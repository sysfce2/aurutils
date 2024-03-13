#!/usr/bin/env perl
use strict;
use warnings;
use v5.20;
use Test::More;

# Check if module can be imported
require_ok "AUR::Query";

use AUR::Query qw(urlencode query query_multi);

done_testing();
