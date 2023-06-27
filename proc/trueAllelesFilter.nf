process trueAllelesDQA{
tag "DQA"
publishDir("outdir_taFiltered/DQA/", mode:'copy')

input:
tuple val(seqid), path(reads)


output:
path "${seqid}", emit: tAlleles


script:
"""
cat ${reads[0]} ${reads[1]} | fastx_collapser -v -o ${seqid}
"""

}

process trueAllelesDQB{
tag "DQB"
publishDir("outdir_taFiltered/DQB/", mode:'copy')

input:
tuple val(seqid), path(reads)


output:
path "${seqid}", emit: tAlleles


script:
"""
cat ${reads[0]} ${reads[1]} | fastx_collapser -v -o ${seqid}
"""

}

process trueAllelesDRB{
tag "DRB"
publishDir("outdir_taFiltered/DRB/", mode:'copy')

input:
tuple val(seqid), path(reads)


output:
path "${seqid}", emit: tAlleles


script:
"""
cat ${reads[0]} ${reads[1]} | fastx_collapser -o ${seqid}
"""

}





