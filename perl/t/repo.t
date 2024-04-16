#!/usr/bin/env perl
use strict;
use warnings;
use v5.20;
use Test::More;

# Check if module can be imported
require_ok "AUR::Repo";

use AUR::Repo qw(list_attr check_attr check_type parse_db parse_db_file);

done_testing();
