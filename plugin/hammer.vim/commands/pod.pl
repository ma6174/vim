#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';
use Pod::Simple::HTML;

my $parser = Pod::Simple::HTML->new;

$parser->output_string(\my $html);

my $fh = *STDIN;
$parser->parse_file( $fh );

print $html;
