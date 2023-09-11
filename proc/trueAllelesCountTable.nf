

process filesForCount{
publishDir("outdir_taFiltered/collapsedCountGenes/", mode:'copy')

output:
//path "DQA.full"
//path "DQB.full"
//path "DRB.full"
path "DQA.collapsed.full", emit: dqaCount
path "DQB.collapsed.full", emit: dqbCount
path "DRB.collapsed.full", emit: drbCount


shell:
"""
sleep 10s

mkdir -p $baseDir/outdir_taFiltered/collapsedCountGenes

ls $baseDir/outdir_taFiltered/DQA/* | xargs cat >> "$baseDir/outdir_taFiltered/collapsedCountGenes/DQA.full"
fastx_uncollapser -i $baseDir/outdir_taFiltered/collapsedCountGenes/DQA.full | fastx_collapser -v -o DQA.collapsed.full

ls $baseDir/outdir_taFiltered/DQB/* | xargs cat >> "$baseDir/outdir_taFiltered/collapsedCountGenes/DQB.full"
fastx_uncollapser -i $baseDir/outdir_taFiltered/collapsedCountGenes/DQB.full | fastx_collapser -v -o DQB.collapsed.full

ls $baseDir/outdir_taFiltered/DRB/* | xargs cat >> "$baseDir/outdir_taFiltered/collapsedCountGenes/DRB.full"
fastx_uncollapser -i $baseDir/outdir_taFiltered/collapsedCountGenes/DRB.full | fastx_collapser -v -o DRB.collapsed.full


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
sleep 20

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
path "${query_file}_Counts.tsv" , optional:true

script:
"""
sleep 30

f=${query_file}

# Extract a slice of 3 characters using awk
slice=\$(echo "\$f" | awk '{print substr(\$0, 1, 3)}')

# Print the extracted slice
echo "\$slice"

# Change directory to the extracted folder
cd /home/sergiolitwiniuk/Documents/nextFlowFiles/nf-lula-2/outdir_taFiltered/\$slice

# Run script using perl
${params.env} $PWD/proc/count.pl ../collapsedCountGenes/${query_file} > ../${query_file}_Counts.tsv
"""
}