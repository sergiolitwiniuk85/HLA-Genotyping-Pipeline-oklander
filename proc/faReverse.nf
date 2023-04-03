process fareverse{
publishDir("outdir_fasta_for_comparison/${reads}", mode:"copy", overwrite:false)
params.env = "/home/sergiolitwiniuk/anaconda3/envs/bio/bin/python"

input:
path(reads)

output:
path "*_DQA", emit: uniquedqa
path "*table", emit: countdqa

script:

"""
${params.env} $PWD/proc/collapserFrecFilter.py $reads ${params.frec} > ${reads}.id.fasta
"""

}