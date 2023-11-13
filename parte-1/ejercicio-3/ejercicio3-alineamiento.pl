#!/usr/bin/perl

use strict;
use warnings;
use Bio::AlignIO;
use Bio::SimpleAlign;
use Bio::Tools::Run::Alignment::Clustalw;

sub run_clustal_omega {
    my ($sequences, $output_fasta) = @_;

    my $align_factory = Bio::Tools::Run::Alignment::Clustalw->new;
    my $alignment = $align_factory->align($sequences);

    my $out = Bio::AlignIO->new(-file => ">$output_fasta", -format => 'fasta');
    $out->write_aln($alignment);

    print "Multi-Sequence Alignment completed successfully.\n";
}

sub add_unique_identifiers {
    my $sequences = shift;

    my $counter = 1;
    foreach my $seq (@$sequences) {
        my $id = "sequence_$counter";
        $seq->id($id);
        $seq->display_id($id);
        $counter++;
    }

    return $sequences;
}

my @sequences;

# Load sequences from input FASTA files
push @sequences, Bio::SeqIO->new(-file => "MYBPC3-homo-sapiens.fasta", -format => 'fasta')->next_seq;
push @sequences, Bio::SeqIO->new(-file => "gallus-gallus-sequence.fasta", -format => 'fasta')->next_seq;
push @sequences, Bio::SeqIO->new(-file => "mus-musculus-sequence.fasta", -format => 'fasta')->next_seq;
push @sequences, Bio::SeqIO->new(-file => "rattus-norvegicus-sequence.fasta", -format => 'fasta')->next_seq;

# Add unique identifiers to the sequences
@sequences = @{add_unique_identifiers(\@sequences)};

# Run Clustal Omega to perform the Multi-Sequence Alignment
run_clustal_omega(\@sequences, "output_alignment.fasta");
