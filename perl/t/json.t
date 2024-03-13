#!/usr/bin/env perl
use strict;
use warnings;
use v5.20;
use Test::More;

# Check if module can be imported
require_ok "AUR::Json";

use AUR::Json qw(parse_json parse_json_aur write_json);

done_testing();
