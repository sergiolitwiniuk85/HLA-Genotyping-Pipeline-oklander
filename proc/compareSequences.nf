process compare_sequences{
    publishDir("outdir_fr_true/${sample_id}.fasta")

    input:
    tuple val(sample_id), path('seqFile?.fa')

    output:
    file "${sample_id}.fasta"

    """
    # Concatena los archivos FASTA en un solo archivo temporal
    cat seqFile1.fa seqFile2.fa > temp.fasta 
    cat temp.fasta | cowsay

    # Encuentra las secuencias comunes en ambos archivos
    #grep -F -f <(awk '/^>/ {print \$0 "\\t" getline} {print}' temp.fasta | tr '\\n' ' ') temp.fasta > ${sample_id}.fasta

    # Elimina el archivo temporal
    #rm temp.fasta

    """
}