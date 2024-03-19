#!/usr/bin/env perl
use strict;
use warnings;
use v5.20;
use Test::More;

# Check if module can be imported
require_ok "AUR::Options";

use AUR::Options qw(add_from_stdin);

done_testing();
