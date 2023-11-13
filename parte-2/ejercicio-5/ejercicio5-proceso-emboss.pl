#!/usr/bin/perl

use strict;
use warnings;

# Archivo de entrada de nucléotidos
my $input_fasta_file = "MYBPC3-mNRA-sequence.fasta";

# Ruta de la base de datos de dominios y funcionalidades
my $prosite_db_path = "prosite.dat";

# Programa para obtener los ORF's
my $orf_output = `getorf -sequence $input_fasta_file -outseq orfs.fasta`;

if ($? == 0) {
    print "ORFs identificado correctamente .\n";

    # Ejecuta el análisis de dominios / funcionalidad por cada ORF
    my $orf_sequence = '';
    open(my $orf_file, '<', 'orfs.fasta') or die "Could not open ORF file: $!";
    while (<$orf_file>) {
        if (/^>ORF_(\d+)/) {
            my $orf_num = $1;
            if ($orf_sequence ne '') {
                # Run patmatmotifs on the ORF sequence
                my $output = `patmatmotifs -sequence -outfile motifs_orf_$orf_num.txt -d $prosite_db_path`;

                # Validación de análisis de ORF
                if ($? == 0) {
                    print "Análisis de ORF $orf_num completado satisfactoriamente.\n";

                    # Process the results for this ORF (you can modify this part according to your needs)
                    open(my $motif_file, '<', "motifs_orf_$orf_num.txt") or die "No pudo abrir el archivo de análisis para ORF $orf_num: $!";
                    while (<$motif_file>) {
                        if (/^(query\s+.+)$/) {
                            print "ORF $orf_num Motif: $1\n";
                        }
                    }
                    close $motif_file;
                } else {
                    print "Error ejecutando patmatmotifs para el ORF $orf_num: $!\n";
                }
            }

            # Resete de secuencia de ORF sequence
            $orf_sequence = '';
        } else {
            $orf_sequence .= $_;
        }
    }
    close $orf_file;
} else {
    print "Error ejecutando getorf: $!\n";
}
