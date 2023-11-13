#!/usr/bin/perl

use strict;
use warnings;

if (@ARGV != 3) {
    die "Usage: $0 <BLAST Report> <Pattern> <Output File>\n";
}

my ($blast_report, $pattern, $output_file) = @ARGV;

open my $blast_fh, '<', $blast_report or die "Cannot open $blast_report: $!";
open my $output_fh, '>', $output_file or die "Cannot open $output_file: $!";

while (<$blast_fh>) {
    chomp;

    # Skip comment lines
    next if /^\s*#/;

    # Check if the line contains a record in the "sequence producing significant alignments" section
    if (/^\S+\s+RecName:.*?\s+(\d+)\s+([\d.]+)\s*$/) {
        my $alignment_length = $1;
        my $e_value = $2;

        # If the alignment length is greater than 0 and the E-value is less than or equal to 0.05 (you can adjust this threshold)
        if ($alignment_length > 0 && $e_value <= 0.05) {
            # Save the entire line to the output file
            print $output_fh "$_\n";
        }
    }
}

close $blast_fh;
close $output_fh;

print "Hits meeting the criteria saved in $output_file.\n";
