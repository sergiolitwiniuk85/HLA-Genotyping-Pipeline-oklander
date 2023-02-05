process distSeqsDqa{
publishDir("outdir_distSeqs/${dqa}_dqa", mode:"copy", overwrite:false)

input:
path(dqa)

output:
path "${dqa}*.dist", emit: distDqa

script:
"""
mothur "#dist.seqs(fasta=${dqa}, cutoff=0.40)"
"""
}



process distSeqsDqb{
publishDir("outdir_distSeqs/${dqb}_dqb", mode:"copy", overwrite:false)

input:
path(dqb)

output:
path "${dqb}*.dist", emit: distDqb

script:
"""
dist.seqs(fasta=${dqb}, cutoff=0.40)
"""
}



process distSeqsDrb{
publishDir("outdir_distSeqs/${drb}_drb", mode:"copy", overwrite:false)

input:
path(drb)

output:
path "${drb}*.dist", emit: distDrb

script:
"""
dist.seqs(fasta=${drb}, cutoff=0.40)
"""
}