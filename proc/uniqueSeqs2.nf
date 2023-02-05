process uniqueSeqs2{
publishDir("outdir_uniqueSeqs2/${reads}", mode:"copy", overwrite:false)

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
