package AUR::Depends;
use strict;
use warnings;
use v5.20;

use List::Util qw(first);
use Carp;
use Exporter qw(import);
our @EXPORT_OK = qw(vercmp extract depends prune graph);
our $VERSION = 'unstable';

=head1 NAME

AUR::Depends - Resolve dependencies from AUR package information

=head1 SYNOPSIS

  use AUR::Depends qw(vercmp extract depends prune graph);

=head1 DESCRIPTION

=head1 AUTHORS

Alad Wenter <https://github.com/AladW/aurutils>

=cut

sub vercmp_run {
    say STDERR __PACKAGE__ . ': vercmp ' . join(" ", @_)
	if defined $ENV{'AUR_DEBUG'};

    my @command = ('vercmp', @_);
    my $child_pid = open(my $fh, "-|", @command) or die $!;
    my $num;

    if ($child_pid) {
        $num = <$fh>;
        waitpid($child_pid, 0);
    }
    die __PACKAGE__ . ": vercmp failure" if $?;
    return $num;
}

sub vercmp_ops {
    my %ops = (
        '<'  => sub { $_[0] <  $_[1] },
        '>'  => sub { $_[0] >  $_[1] },
        '<=' => sub { $_[0] <= $_[1] },
        '>=' => sub { $_[0] >= $_[1] },
        );
    return %ops;
}

=item vercmp

This function provides a simple way to call C<vercmp(8)> from perl code.
Instead of ordering versions on the command-line, this function takes
an explicit comparison operator (<, >, =, <= or >=) as argument.

Under the hood, this function calls the C<vercmp> binary explicitly.
This avoids any rebuilds for C<libalpm.so> soname bumps. To keep the approach
performant, C<vercmp> is only called when input versions differ.

=cut

sub vercmp {
    my ($ver1, $ver2, $op) = @_;
    my %cmp = vercmp_ops();

    if (not defined $ver2 or not defined $op) {
        return "true";  # unversioned dependency
    }
    elsif ($op eq '=') {
        return $ver1 eq $ver2;
    }
    elsif (defined $cmp{$op}) {
        # check if cmp(ver1, ver2) holds        
        return $cmp{$op}->(vercmp_run($ver1, $ver2), 0);
    }
    else {
        croak __PACKAGE__ . "invalid vercmp operation";
    }
}

=item extract()

Extracts dependency (C<$pkgdeps>) and provider (C<$pkgmap>)
information from an array of package information hashes, such as
those from C<Srcinfo.pm> or C<Query.pm>.

Any I<new> dependencies are added to the returned array value. A
dependency is considered I<new> if it has no existing entry in the
C<$results> hash ref. This makes it efficient to use this function
iteratively for retrieving the dependency graph of a set of targets.

Verifying if any versioned dependencies can be fulfilled can be done
subsequently with the C<graph> function.

=cut

sub extract {
    # hash refs modified in place
    my ($results, $pkgdeps, $pkgmap, $types, @level) = @_;
    my @depends = ();

    for my $node (@level) {
        my $name    = $node->{'Name'};
        my $version = $node->{'Version'};
        $results->{$name} = $node;

        # Iterate over explicit provides
        for my $spec (@{$node->{'Provides'} // []}) {
            my ($prov, $prov_version) = split(/=/, $spec);
            
            # XXX: the first provider takes precedence
            #      keep multiple providers and warn on ambiguity instead
            if (not defined $pkgmap->{$prov} and $prov ne $name) {
                $pkgmap->{$prov} = [$name, $prov_version];
            }
        }
        # Filter out dependency types early (#882)
        for my $deptype (@{$types}) {
            next if (not defined($node->{$deptype}));  # no dependency of this type

            for my $spec (@{$node->{$deptype}}) {
                # Push versioned dependency to global depends
                push(@{$pkgdeps->{$name}}, [$spec, $deptype]);

                # Valid operators (important: <= before <)
                my ($dep, $op, $ver) = split(/(<=|>=|<|=|>)/, $spec);

                # Avoid querying duplicate packages (#4)
                next if defined $results->{$dep};
                push(@depends, $dep);

                # Mark as incomplete (retrieved in next step or repo package)
                # XXX: do not write directly into <results>, but some other
                # dict shared between <extract> calls
                $results->{$dep} = 'None';
            }
        }
    }
    return @depends;
}

=item depends()

Iteratively call C<extract()> with a callback function. The
number of times the callback function may be called is specified as a
separate parameter.

=cut

sub depends {
    my ($targets, $types, $callback, $callback_max_a) = @_;
    my @depends = @{$targets};

    my (%results, %pkgdeps, %pkgmap);

    # XXX: return $a for testing number of requests, e.g. 7 for ros-noetic-desktop
    for my $a (1..$callback_max_a) {
        say STDERR join(" ", "callback: [$a]", @depends) if defined $ENV{'AUR_DEBUG'};

        # Check if request limits have been exceeded
        if ($a == $callback_max_a) {
            say STDERR __PACKAGE__ . ": total requests: $a (out of range)";
            exit(34);
        }

        # Use callback to retrieve new hash of results
        my @level = $callback->(\@depends);

        if (not scalar(@level) and $a == 1) {
            say STDERR __PACKAGE__ . ": no packages found";
            exit(1);
        }

        # Retrieve next level of dependencies from results
        @depends = extract(\%results, \%pkgdeps, \%pkgmap, $types, @level);

        if (not scalar(@depends)) {
            last;  # no further results
        }
    }
    # XXX: workaround for extract() tallying packages in <results> dict
    for my $pkg (keys %results) {
        delete $results{$pkg} if $results{$pkg} eq 'None';
    }
    return \%results, \%pkgdeps, \%pkgmap;
}

=item graph()

For a set of package-dependency relations (C<$pkgdeps>) and providers
(C<$pkgmap>), verify if all dependencies and their versions can be
fulfilled by the available set of packages. Version relations are
checked with C<vercmp>.

Two hashes are kept: one for packages in the set (C<$dag>), and
another for packages outside it (C<$dag_foreign>). Only relations in
the former are checked.

=cut

# XXX: <results> only used for versions and checking if AUR target
sub graph {
    my ($results, $pkgdeps, $pkgmap, $verify, $provides) = @_;
    my (%dag, %dag_foreign);

    my $dag_valid = 1;
    $verify //= 1;  # run vercmp by default

    # Iterate over packages
    for my $name (keys %{$pkgdeps}) {
        # Add a loop to isolated nodes (#402, #1065)
        # XXX: distinguish between explicit (command-line) and
        # implicit (dependencies) targets
        $dag{$name}{$name} = 'Self';

        # Iterate over dependencies
        for my $dep (@{$pkgdeps->{$name}}) {
            my ($dep_spec, $dep_type) = @{$dep};  # ['foo>=1.0', 'Depends']

            # Retrieve dependency requirements
            my ($dep_name, $dep_op, $dep_req) = split(/(<=|>=|<|=|>)/, $dep_spec);

            if (defined $results->{$dep_name}) {
                # Split results version to pkgver and pkgrel
                my @dep_ver = split("-", $results->{$dep_name}->{'Version'}, 2);

                # Provides take precedence over regular packages,
                # unless $provides is false.
                my  ($prov_name, $prov_ver) = ($dep_name, $dep_ver[0]);

                if ($provides and defined $pkgmap->{$dep_name}) {
                    ($prov_name, $prov_ver) = @{$pkgmap->{$dep_name}};
                }

                # Run vercmp with provider and versioned dependency
                # XXX: a dependency can be both fulfilled by a package
                # and a different package (provides). In this case an
                # error should only be returned if neither fulfill the
                # version requirement.
                if (not $verify or vercmp($prov_ver, $dep_req, $dep_op)) {
                    $dag{$prov_name}{$name} = $dep_type;
                }
                else {
                    say STDERR "invalid node: $prov_name=$prov_ver (required: $dep_op$dep_req by: $name)";
                    $dag_valid = 0;
                }
            }
            # Dependency is foreign
            else {
                $dag_foreign{$dep_name}{$name} = $dep_type;
            }
        }
    }
    if (not $dag_valid) {
        exit(1);
    }
    return \%dag, \%dag_foreign;
}

=item prune()

Remove specified nodes from a dependency graph. Every dependency is
checked against every pkgname provided (quadratic complexity).

The keys of removed nodes are returned in an array.

=cut

# XXX: return complement dict instead of array
sub prune {
    my ($dag, $installed) = @_;
    my @removals;

    # Remove reverse dependencies for installed targets
    for my $dep (keys %{$dag}) {  # list returned by `keys` is a copy
        for my $name (keys %{$dag->{$dep}}) {
            my $found = first { $name eq $_ } @{$installed};

            if (defined $found) {
                delete $dag->{$dep}->{$found};
            }
        }
    }

    for my $dep (keys %{$dag}) {
        if (not scalar keys %{$dag->{$dep}}) {
            delete $dag->{$dep};  # remove targets that are no longer required
            push(@removals, $dep);
        }
        my $found = first { $dep eq $_ } @{$installed};

        if (defined $found) {
            delete $dag->{$dep};  # remove targets that are installed
            push(@removals, $dep);
        }
    }
    return \@removals;
}

=item levels()

=cut

# TODO: compute dependency levels (bfs)
# sub levels {

# }

# vim: set et sw=4 sts=4 ft=perl:
