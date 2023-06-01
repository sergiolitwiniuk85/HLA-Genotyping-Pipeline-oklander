process trueAllelesDQA{
tag "DQAr"
publishDir("outdir_taFiltered/DQAr/", mode:'copy')

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
tag "DQBr"
publishDir("outdir_taFiltered/DQBr/", mode:'copy')

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
tag "DRBr"
publishDir("outdir_taFiltered/DRBr/", mode:'copy')

input:
tuple val(seqid), path(reads)


output:
path "${seqid}", emit: tAlleles


script:
"""
cat ${reads[0]} ${reads[1]} | fastx_collapser -o ${seqid}
"""

}





