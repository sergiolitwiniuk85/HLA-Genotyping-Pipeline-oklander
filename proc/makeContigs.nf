process makeContigs{
tag "makeContigs_$sample_id"
publishDir "outdir_makeContigs/${sample_id}", mode:'copy'

input:
tuple val(sample_id), path(read_1), path(read_2)

output:
path "*.trim.contigs.fasta", emit: trimContigs
path "*.scrap.contigs.fasta", emit: scrapContigs
path "*.contigs_report", emit: reportContigs


script:

"""
mothur "#make.contigs(ffastq=${read_1}, rfastq=${read_2}, processors=2)"
"""

}