process compareseq {
    publishDir("outdir_fr_true/${sample_id}.fasta")


    input:
    tuple val(sample_id), path('seqFile?')

    output:
    file "${sample_id}.fasta"

    script:
    """
#!/home/sergiolitwiniuk/anaconda3/envs/bio/bin/python
from Bio import SeqIO
import sys
    # Carga los archivos FASTA en diccionarios de Biopython SeqIO
seq_dict1 = SeqIO.to_dict(SeqIO.parse("seqFile1", "fasta"))
seq_dict2 = SeqIO.to_dict(SeqIO.parse("seqFile2", "fasta"))
print(seq_dict1)
print(seq_dict2)

        # Encuentra las secuencias que se encuentran en ambos archivos
common_seqs = [seq_dict1[key] for key in seq_dict1 if key in seq_dict2]

        # Escribe el archivo FASTA de salida que contiene solo las secuencias comunes
with open("${sample_id}.fasta", "w") as out_handle:
    SeqIO.write(common_seqs, out_handle, "fasta")
    """
}