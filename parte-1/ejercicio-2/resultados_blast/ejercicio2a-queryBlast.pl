#!/usr/bin/perl -w

use strict;
use warnings;

my $blast_db = "~/blast/db/swissprot";  # Ruta a tu base de datos BLAST
my $input_file = "proteinas_traducidas.fasta";  # Ruta a tu archivo con los 6 marcos
my $output_dir = "resultados_blast";  # Directorio para guardar los resultados

# Crea el directorio de resultados si no existe
unless (-e $output_dir && -d $output_dir) {
    mkdir $output_dir or die "No se pudo crear el directorio de resultados: $!";
}

# Leer el archivo con los 6 marcos y ejecutar BLAST para cada marco
open my $input_fh, "<", $input_file or die "No se pudo abrir el archivo de entrada: $!";
while (my $line = <$input_fh>) {
    chomp $line;
    if ($line =~ /^>(\S+)/) {
        my $frame = $1;  # Extrae el nombre del marco a partir del encabezado
        my $output_file = "$output_dir/resultados_$frame.out";  # Cambiar la extensión a .out
        my $blast_command = "blastp -query $input_file -db $blast_db -out $output_file";  # Cambiar la extensión a .out
        system($blast_command);
    }
}
close $input_fh;

print "Búsqueda BLAST en los seis marcos de lectura completa. Los resultados se han guardado en el directorio $output_dir.\n";
