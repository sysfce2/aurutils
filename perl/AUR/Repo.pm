package AUR::Repo;
use strict;
use warnings;
use v5.20;
use open ":std", ":encoding(UTF-8)";

use Carp;
use Exporter qw(import);
our @EXPORT_OK = qw(list_attr check_attr check_type parse_db parse_db_file);
our $VERSION = 'unstable';

=head1 NAME

AUR::Repo - Parse contents of a local repository

=head1 SYNOPSIS

  use AUR::Repo qw(parse_db);

=head1 DESCRIPTION

=head1 AUTHORS

Alad Wenter <https://github.com/AladW/aurutils>

=cut

# Attributes which (where applicable) match AurJson, such that `aur-repo-parse --json`
# can be piped to `aur-format`.
our %repo_add_attributes = (
    'ARCH'         => ['string',  'Arch'         ],
    'BASE'         => ['string',  'PackageBase'  ],
    'DESC'         => ['string',  'Description'  ],
    'FILENAME'     => ['string',  'FileName'     ],
    'MD5SUM'       => ['string',  'Md5Sum'       ],  # too large for int32/int64
    'NAME'         => ['string',  'Name'         ],
    'PACKAGER'     => ['string',  'Packager'     ],
    'SHA256SUM'    => ['string',  'Sha256Sum'    ],  # too large for int32/int64
    'URL'          => ['string',  'URL'          ],
    'VERSION'      => ['string',  'Version'      ],
    'PGPSIG'       => ['string',  'PgpSig'       ],
    'CONFLICTS'    => ['array',   'Conflicts'    ],
    'CHECKDEPENDS' => ['array',   'CheckDepends' ],
    'DEPENDS'      => ['array',   'Depends'      ],
    'LICENSE'      => ['array',   'License'      ],
    'MAKEDEPENDS'  => ['array',   'MakeDepends'  ],
    'OPTDEPENDS'   => ['array',   'OptDepends'   ],
    'PROVIDES'     => ['array',   'Provides'     ],
    'REPLACES'     => ['array',   'Replaces'     ],
    'GROUPS'       => ['array',   'Groups'       ],
    'FILES'        => ['array',   'Files'        ],
    'BUILDDATE'    => ['numeric', 'BuildDate'    ],
    'CSIZE'        => ['numeric', 'CSize'        ],
    'ISIZE'        => ['numeric', 'ISize'        ]
);

=head2 list_attr()

List all defined attributes for a pacman database file, in sorted order.

=cut

sub list_attr {
    return sort(keys %repo_add_attributes);
}

=head2 check_attr()

=cut

sub check_attr {
    my ($attr) = @_;
    return $repo_add_attributes{$attr}->[1];
}

=head2 check_type()

=cut

sub check_type {
    my ($attr) = @_;
    return $repo_add_attributes{$attr}->[0];
}

=head2 parse_db()

Iterate over a pacman database file, and run a C<handler> function on each
entry. C<handler> should accept a hash representing a package in the database,
the current package count, and whether any packages follow the current one.

Parameters:

=over

=item C<$fh>

=item C<$header>

=item C<$handler>

=item C<@varargs>

=back

=cut

sub parse_db {
    my ($fh, $header, $handler, @varargs) = @_;
    my $count = 0;
    my ($entry, $filename, $attr, $attr_label);

    while (my $row = <$fh>) {
        chomp($row);

        if ($row =~ /^%\Q$header\E%$/) {
            $filename = readline($fh);
            chomp($filename);

            # Evaluate condition on previous entry and run handler
            if ($count > 0) {
                $count++ if $handler->($entry, $count, 0, @varargs);
            } else {
                $count++;
            }

            # New entry in the database (hashref)
            %{$entry} = ();
            $entry->{$repo_add_attributes{$header}->[1]} = $filename;
        }
        elsif ($row =~ /^%.+%$/) {
            if (not length($filename)) {
                die __PACKAGE__ . ": attribute '$header' not set";
            }
            $attr = substr($row, 1, -1);
            $attr_label = $repo_add_attributes{$attr}->[1];

            if (not defined $attr_label) {
                warn __PACKAGE__ . ": unknown attribute '$attr'";
                $attr_label = ucfirst(lc($attr));
            }
        }
        elsif ($row eq "") {
            next;
        }
        else {
            die unless length($attr) and length($attr_label);

            if ($repo_add_attributes{$attr}->[0] eq 'numeric') {
                $entry->{$attr_label} = $row + 0;
            }
            elsif ($repo_add_attributes{$attr}->[0] eq 'array') {
                push(@{$entry->{$attr_label}}, $row);
            }
            else {  # Unknown attributes are assumed to have string data
                $entry->{$attr_label} = $row;
            }
        }
    }
    # Process last entry
    if ($count > 0) {
        $handler->($entry, $count, 1, @varargs);
    }
    return $count;
}

=head2 parse_db_file()

Parameters:

=over

=item C<$db_path>

=item C<$header>

=item C<$handler>

=item C<@varargs>

=back

=cut

sub parse_db_file {
    my ($db_path, $header, $handler, @varargs) = @_;

    # When parsing the database, do not require a full extraction to either memory or disk
    # by reading `tar` output line-by-line. It is not strictly necessary to depend on
    # attribute order (i.e. %FILENAME% occuring in first place) while doing so; however,
    # the `--verbose` flag printing file names has different behavior for different `tar`
    # versions. Specifically, `bsdtar -xv` does not add a newline after the file path,
    # while `tar -xv` does.
    my $child_pid = open(my $fh, "-|", 'bsdtar', '-Oxf', $db_path) or die $!;
    my $count;

    if ($child_pid) { # parent process
        $count = parse_db($fh, $header, $handler, @varargs);

        waitpid($child_pid, 0);
    }
    exit(2) if $?;

    return $count;
}
