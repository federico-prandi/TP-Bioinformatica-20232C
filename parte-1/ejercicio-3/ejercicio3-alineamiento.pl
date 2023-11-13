#!/usr/bin/perl
use strict;
use warnings;
use Bio::SeqIO;
use Bio::Tools::Run::Alignment::Clustalw;

# Archivos FASTA de secuencias de entrada
my @input_files = ("gallus-gallus-sequence.fasta", "mus-musculus-sequence.fasta", "rattus-norvegicus-sequence.fasta","MYBPC3-homo-sapiens.fasta" );

# Crear un objeto de alineamiento ClustalW
my $clustalw = Bio::Tools::Run::Alignment::Clustalw->new();

# Leer las secuencias de entrada
my @sequences;
foreach my $input_file (@input_files) {
    my $seqio = Bio::SeqIO->new(-file => $input_file, -format => 'fasta', -alphabet => 'protein');
    my $seq = $seqio->next_seq;
    push @sequences, $seq;
}


print "Secuencia de entrada 1: ", $sequences[0]->seq, "\n";
print "Secuencia de entrada 2: ", $sequences[1]->seq, "\n";
print "Secuencia de entrada 3: ", $sequences[2]->seq, "\n";
print "Secuencia de entrada 4: ", $sequences[3]->seq, "\n";

# Ejecutar el alineamiento múltiple
my $aln = $clustalw->profile_align(\@sequences);

print "Resultado del alineamiento: ", $aln->display_id, "\n";

# Imprimir el resultado
my $aln_out = Bio::AlignIO->new(-file => ">multiple_alignment.fasta", -format => 'fasta');
$aln_out->write_aln($aln);

print "Alineamiento múltiple completado. Resultados guardados en 'multiple_alignment.fasta'\n";