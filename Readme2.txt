1) fastqc

2) fastp

Con los fastq filtrados, luego utilizo fastx_collapser para obtener el conteo unico para cada read; me genera un fasta file

3) fastx_collapser -i Data/TIS_SENICULUS/52-Tis_S52_L001_R2.fastq -o collapsed_R2.txt

A partir del fasta file, debo generar los fastq filtrados a partir de los fasta con mayor frecuencia >50 reads; utilizo para ello grep;
        regular_expression para buscar los menores a 50:  -[0-5]\d\n
            grep '>.*-[0-9][0-9][0-9]' -A 1 collapsed.txt

4)grep -F -f collapsed50_R1.only -B 1 -A 2 --no-group-separator  Data/TIS_SENICULUS/52-Tis_S52_L001_R1.fastq > 52-Tis_small_R1.fastq

5) nuevamente fastqc para corroborar;

6) makeContigs

7) screenSeqs

8) summarySeqs

10) barcodeSplit

11) uniqueSeqs