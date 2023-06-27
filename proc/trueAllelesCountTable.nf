process filesForCount{
publishDir("outdir_taFiltered/", mode:'copy')

output:
path "DQA.full", emit: dqaCount
path "DQB.full", emit: dqbCount
path "DRB.full", emit: drbCount


script:
"""
ls $baseDir/outdir_taFiltered/DQA/* | xargs cat >> "DQA.full"
ls $baseDir/outdir_taFiltered/DQB/* | xargs cat >> "DQB.full" 
ls $baseDir/outdir_taFiltered/DRB/* | xargs cat >> "DRB.full"
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
fastx_collapser -i ${read0} -o x_${read0}
fastx_collapser -i ${read1} -o x_${read1}
fastx_collapser -i ${read2} -o x_${read2}
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
path "drbCounts.tsv" , optional:true

script:
"""
cd /home/sergiolitwiniuk/Documents/nextFlowFiles/nf-lula-2/outdir_taFiltered/DRB
${params.env} $PWD/proc/count.pl ../collapsedCountGenes/${query_file} > ../drbCounts.tsv
"""
}