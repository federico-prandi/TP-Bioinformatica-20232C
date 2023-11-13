#!/usr/bin/perl -w

use Bio::SeqIO;

# Nombre del archivo GenBank que contiene la secuencia mRNA
my $genbank_file = "MYBPC3.gb";

# Nombre del archivo FASTA de salida
my $fasta_output_file = "proteinas_traducidas.fasta";

# Crea un objeto Bio::SeqIO para leer el archivo GenBank
my $seqio = Bio::SeqIO->new(-file => $genbank_file, -format => "genbank");

# Abre el archivo de salida FASTA
open my $fasta_out, '>', $fasta_output_file or die "No se puede abrir el archivo $fasta_output_file: $!";

while (my $seq_obj = $seqio->next_seq) {
    # Verifica si la secuencia es un mRNA
    $seq_obj->alphabet('rna') unless $seq_obj->alphabet eq 'rna';

    if ($seq_obj->alphabet eq 'rna') {
        my $mRNA_sequence = $seq_obj->seq;
        # Recorre los seis marcos de lectura (tres en sentido directo y tres en sentido inverso)
        for my $frame (0, 1, 2) {
            my $translated_seq = $seq_obj->translate(-frame => $frame);
            

            # Imprime el marco de lectura actual en formato FASTA
            print $fasta_out ">$frame\n";
            print $fasta_out $translated_seq->seq . "\n";
        }
        my $reverse_complement = $seq_obj->revcom;
         for my $frame (0, 1, 2) {
            my $translated_seq = $reverse_complement->translate(-frame => $frame);
            

            # Imprime el marco de lectura actual en formato FASTA
            print $fasta_out ">-$frame\n";
            print $fasta_out $translated_seq->seq . "\n";
        }

    }
}

close $fasta_out;
print "Las secuencias traducidas se han guardado en $fasta_output_file.\n";
