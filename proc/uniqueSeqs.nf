process uniqueSeqs{
publishDir("outdir_uniqueSeqs/${contigs}", mode:"copy", overwrite:false)

input:
path(contigs)

output:
path "*.good.unique.fasta*", emit: unique
path "*.count_table", emit: count

script:
"""
mothur "#unique.seqs(fasta=${contigs}, format=count)"
"""
}
