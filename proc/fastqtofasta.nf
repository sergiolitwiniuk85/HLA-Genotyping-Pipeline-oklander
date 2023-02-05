process fastqtofasta{

publishDir("outdir_fastqtofasta/${reads}", mode:'copy')

input:
tuple val(sample_id), path(reads)


output:
path "tofasta_${reads}", emit: fastq_to_fasta2


script:
"""
fastq_to_fasta -i ${reads} -o tofasta_${reads}
"""

}
