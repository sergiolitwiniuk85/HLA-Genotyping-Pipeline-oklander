process uniqueSeqs{
publishDir("outdir_uniqueSeqsfp/${reads}", mode:"copy", overwrite:false)

input:
path(reads)

output:
path "*.fastq", emit: uniqueTesting
path "*table", emit: countTesting

script:
"""
mothur "#unique.seqs(fasta=${reads}, format=count)"
"""
}