
process pandaSeq {
    tag "pandaSeq_$file"
    publishDir 'outdir_screenSeqs', mode: 'copy'

    input:
    tuple val(sample), path(f), path(r)

    output:
    path("ps_${sample}*.assembled.fastq"), emit:pandaOut

    script:
    """
    pear -j 8 -f ${f} -r ${r} -o ps_${sample}
    """
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


//fastx_collapser -i 52_DQAf.fasta -o 52_DQAf.collapsed.fasta

//then make collapserFrecFilter.py




