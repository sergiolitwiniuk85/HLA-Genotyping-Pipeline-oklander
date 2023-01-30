process screenSeqs{
tag "screenSeqs_$contigs"
publishDir 'outdir_screenSeqs', mode:'copy'

input:
path(contigs)

output:
path "*trim.contigs.good.fasta", emit: screenedContig
//path "*.scrap.contigs.fasta", emit: scrapContigs
//path "*.contigs_report", emit: reportContigs

shell:
'''

mothur "#screen.seqs(fasta=!{contigs}, maxlength=370)" 

'''
}