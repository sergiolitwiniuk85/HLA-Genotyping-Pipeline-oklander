process filesForCount{
publishDir("outdir_taFiltered/", mode:'copy')

output:
path "DQAr.full", emit: dqarCount
path "DQBr.full", emit: dqbrCount
path "DRBr.full", emit: drbrCount


script:
"""
ls $baseDir/outdir_taFiltered/DQAr/* | xargs cat >> "DQAr.full"
ls $baseDir/outdir_taFiltered/DQBr/* | xargs cat >> "DQBr.full" 
ls $baseDir/outdir_taFiltered/DRBr/* | xargs cat >> "DRBr.full"
"""

}


process collapseFilesForCount{
publishDir("outdir_taFiltered/collapsedCountGenes/", mode:'copy')

input:
path(read0)
path(read1)
path(read2)

output:
path "${read0}", emit: uniqueDQA
path "${read1}", emit: uniqueDQB
path "${read2}", emit: uniqueDRB


script:
"""
fastx_collapser -i ${read0} -o ${read0}
fastx_collapser -i ${read1} -o ${read1}
fastx_collapser -i ${read2} -o ${read2}
"""

}

//calculate-tableCount
/*
* Nextflow module to count the occurrence of sequences in multiple fasta files
* Author: sergiolitwiniuk
* Date: 04-2023
*/

process count_sequences {
publishDir("outdir_taFiltered/count_table/", mode:'copy')
params.env = "/home/sergiolitwiniuk/anaconda3/envs/bio/bin/perl"

input:
path(query_file)
//path(sequences_file)

output:
path "drbfCounts.tsv" , optional:true

script:
"""
cd /home/sergiolitwiniuk/Documents/nextFlowFiles/nf-lula-2/outdir_taFiltered/DRBf
${params.env} $PWD/proc/count.pl ../collapsedCountGenes/${query_file} > ../drbfCounts.tsv
"""
}