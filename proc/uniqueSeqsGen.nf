process uniquedqa{
publishDir("outdir_uniquedqa/${reads}", mode:"copy", overwrite:false)

input:
path(reads)

output:
path "*_DQA", emit: uniquedqa
path "*table", emit: countdqa

script:
"""
sleep 10
mothur "#unique.seqs(fasta=${reads}, format=count)"
"""
}

process uniquedqb{
publishDir("outdir_uniquedqb/${reads}", mode:"copy", overwrite:false)

input:
path(reads)

output:
path "*_DQB", emit: uniquedqb
path "*table", emit: countdqb

script:
"""
mothur "#unique.seqs(fasta=${reads}, format=count)"
"""
}

process uniquedrb{
publishDir("outdir_uniquedrb/${reads}", mode:"copy", overwrite:false)

input:
path(reads)

output:
path "*_DRB", emit: uniquedrb
path "*table", emit: countdrb

script:
"""
sleep 15
mothur "#unique.seqs(fasta=${reads}, format=count)"
"""
}