#!/usr/bin/perl

use strict;
use warnings;
# Input nucleotide sequence file
my $input_fasta_file = "MYBPC3-mNRA-sequence.fasta";

# Path to the Prosite domain and functionality database
my $prosite_db_path = "prosite.dat";

# Run getorf to obtain ORFs from the input sequence
my $orf_output = `getorf -sequence $input_fasta_file -outseq orfs.fasta`;

if ($? == 0) {
    print "ORFs identified successfully.\n";

    # Execute domain/functional analysis for each ORF
open(my $orf_file, '<', 'orfs.fasta') or die "Could not open ORF file: $!";
my $orf_num;
my $orf_sequence = '';

while (<$orf_file>) {
    if (/^>(NM_\d+\.\d+_cds_NP_\d+\.\d+_\d+_\d+)/) {
        $orf_num = $1;
        if ($orf_sequence ne '') {
            # Create a temporary file to store the ORF sequence
            my $tmp_sequence_file = "tmp_sequence_$orf_num.fasta";
            open(my $tmp_sequence_fh, '>', $tmp_sequence_file) or die "Could not open temporary sequence file: $!";
            print $tmp_sequence_fh ">$orf_num\n$orf_sequence";
            close $tmp_sequence_fh;

            # Run patmatmotifs on the temporary sequence file
            my $output = `patmatmotifs -sequence $tmp_sequence_file -outfile motifs_$orf_num.txt`;


            # Remove the temporary sequence file
            unlink $tmp_sequence_file;

            # Validation of ORF analysis
            if ($? == 0) {
                print "Analysis for ORF $orf_num completed successfully.\n";

                # Process the results for this ORF (modify according to your needs)
                open(my $motif_file, '<', "motifs_$orf_num.txt") or die "Could not open analysis file for ORF $orf_num: $!";
                while (<$motif_file>) {
                    if (/^(query\s+.+)$/) {
                        print "ORF $orf_num Motif: $1\n";
                    }
                }
                close $motif_file;
            } else {
                print "Error executing patmatmotifs for ORF $orf_num: $!\n";
            }
        }

        # Reset ORF sequence
        $orf_sequence = '';
    } else {
        $orf_sequence .= $_;
    }
}
close $orf_file;
} else {
    print "Error executing getorf: $!\n";
}
