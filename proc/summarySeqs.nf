process summarySeqs{
publishDir("outdir_summarySeqs/${contigs}", mode:"copy", overwrite:false)

input:
path(contigs)

output:
path "fastp*.summary", emit: summary
path "mothur*.logfile", emit: logfile

script:
"""
mothur "#contigs=${contigs};summary.seqs(fasta=$contigs)"
"""
}