
process pandaSeq{
tag "pandaSeq_$file"
publishDir 'outdir_screenSeqs', mode:'copy'

input:
tuple val(sample_id), path(reads)

output:
path(contigs)

script:

pandaseq -f ${reads[0]} -r ${reads[0]} -g log_${sample_id}.txt -w ${sample_id}.fasta


}


process barcodeSplit{
publishDir("outdir_bcSplit/${reads}.fasta", mode:"copy", overwrite:false)

input:
each path(reads)
path(barcodeFile)

output:
path "${reads}_DQA.fasta", emit: dqa, optional: true
path "${reads}_DQB.fasta", emit: dqb, optional: true
path "${reads}_DRB.fasta", emit: drb, optional: true
path "${reads}_log"


script:
"""
cat ${reads} | fastx_barcode_splitter.pl --bcfile ${barcodeFile} --prefix ${reads}_ --suffix ".fasta" --bol --mismatches 1 > ${reads}_log
"""
}


fastx_collapser -i 52_DQAf.fasta -o 52_DQAf.collapsed.fasta

//then make collapserFrecFilter.py




