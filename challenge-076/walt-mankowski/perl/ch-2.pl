#!/usr/bin/env perl
use strict;
use warnings;
use feature qw(:5.32);
use experimental qw(signatures);
use autodie;

# TASK #2 › Word Search
# Submitted by: Neil Bowers
# Reviewed by: Ryan Thompson
#
# Write a script that takes two file names. The first file would
# contain word search grid as shown below. The second file contains
# list of words, one word per line. You could even use local
# dictionary file.
#
# Print out a list of all words seen on the grid, looking both
# orthogonally and diagonally, backwards as well as forwards.
#
# Output
# Found 54 words of length 5 or more when checked against the local
# dictionary. You may or may not get the same result but that is fine.

my $MIN_LEN = 5;
my ($grid_name, $dict_name) = @ARGV;
my $grid = read_grid($grid_name);
for my $row ($grid->@*) {
    $, = ", ";
    say $row->@*;
}

my ($words, $prefixes) = parse_dict($dict_name, $MIN_LEN);
for my $k (sort keys %$prefixes) {
    say $k;
}


sub read_grid($grid_name) {
    my @grid;
    open my $fh, '<', $grid_name;
    my $width = 0;
    my $row = 0;
    while (my $line = <$fh>) {
        chomp $line;
        if ($width == 0) {
            # make top line
            $width = 2 + length($line);
            for my $col (0..$width-1) {
                $grid[$row][$col] = ' ';
            }
            $row = 1;
        }
        my @c = split //, $line;
        $grid[$row][0] = ' ';
        for my $i (0..$#c) {
            $grid[$row][$i+1] = $c[$i];
        }
        $grid[$row][$width-1] = ' ';
        $row++;
    }
    # make bottom line
    for my $col (0..$width-1) {
        $grid[$row][$col] = ' ';
    }

    return \@grid;
}

sub parse_dict($dict_name, $min_len) {
    my %words;
    my %prefixes;

    open my $fh, '<', $dict_name;
    while (my $word = <$fh>) {
        chomp $word;
        next unless length($word) >= $min_len;
        next unless $word =~ /^[a-z]+$/;

        $words{$word} = 1;
        for my $len (1..length($word)) {
            $prefixes{substr($word, 0, $len)} = 1;
        }
    }
    return (\%words, \%prefixes);
}
