package AUR::Json;
use strict;
use warnings;
use v5.20;

use Exporter qw(import);
our @EXPORT = qw(parse_json parse_json_aur write_json);
our $VERSION = 'unstable';

=head1 NAME

AUR::Json - Perl interface to AurJson

=head1 SYNOPSIS

  use AUR::Json qw(parse_json_aur write_json);

  my $json;
  my @results = parse_json_aur($json);
  my $object  = parse_json($json);
  my $str     = write_json($object);

=head1 DESCRIPTION

This module provides Perl aur(1) scripts a coherent way to deal with
AurJson responses. In particular, parse_json_aur() returns an array of
package results for variable AUR inputs (both from AurJson and
metadata archives.

If JSON::XS is available, this module will use it for JSON
parsing. JSON::PP shipped with Perl is used as a fallback.

TODO: The interface is in its early stages and is prone to change in
later versions. Possible additions include AUR types for common use
with aur-format(1) and aur-search(1).

=head1 AUTHORS

Alad Wenter <https://github.com/AladW/aurutils>

=cut

our $aur_json;

# Fallback to slower perl-based JSON parsing
if (eval { require JSON::XS; 1 }) {
    $aur_json = JSON::XS->new;
}
else {
    require JSON::PP;
    $aur_json = JSON::PP->new;
}

=item parse_json()

=cut

sub parse_json {
    my $str = shift;
    my $obj = $aur_json->incr_parse($str)
        or die __PACKAGE__ . ": expected JSON object or array at beginning of string";
    $aur_json->incr_reset();

    return $obj;
}

=item parse_json_aur()

=cut

sub parse_json_aur {
    my $str = shift;
    my $obj = parse_json($str);

    # Possible AUR responses:
    # - JSON arrays: REST (suggests), metadata archives (packages-meta-v1.json)
    # - JSON hashes, `results` array: REST (info, search)
    # - JSON hashes: `repo-parse` (JSONL)
    if (ref($obj) eq 'HASH' and defined($obj->{'results'})) {
        my $error = $obj->{'error'};

        if (defined($error)) {
            say STDERR __PACKAGE__ . ': response error (' . $error . ')';
            exit(4);
        }
        return @{$obj->{'results'}};
    }
    elsif (ref($obj) eq 'HASH') {
        return ($obj);
    }
    elsif (ref($obj) eq 'ARRAY') {
        return @{$obj};
    }
    else {
        say STDERR __PACKAGE__ . ": not an array or hash";
        exit(4);
    }
}

=item write_json()

=cut

sub write_json {
    my $obj = shift;
    my $str = $aur_json->canonical()->encode($obj);
    return $str;
}

# vim: set et sw=4 sts=4 ft=perl:
