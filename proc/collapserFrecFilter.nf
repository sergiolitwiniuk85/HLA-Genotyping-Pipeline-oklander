process collapseFilter{ 
publishDir("outdir_filteredFastaIds/", mode:"copy", overwrite:false)

params.frec = 1 //frequency percentage
params.env = "/home/sergiolitwiniuk/anaconda3/envs/bio/bin/python"

input:

path(reads)

output:

path "${reads}.id.fasta", emit: idFile
path "${reads}" , emit: idReads

script:

"""
${params.env} $PWD/proc/collapserFrecFilter.py $reads ${params.frec} > ${reads}.id.fasta
"""

}

process idsToFasta{
publishDir("outdir_filteredFastaFromId/", mode:"copy", overwrite:true)

input:
path(reads)
path(idFile)

output:
path "${reads}.fa"


script:

"""
seqtk subseq ${reads} ${idFile} > ${reads}.fa
"""

}
