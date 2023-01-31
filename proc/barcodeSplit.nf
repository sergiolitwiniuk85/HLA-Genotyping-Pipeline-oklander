process barcodeSplit{
publishDir("outdir_barcodeSplit/${contigs}", mode:"copy", overwrite:false)

input:
each path(contigs)
path(barcodeFile)

output:
path "${contigs}_DQA", emit: dqa
path "${contigs}_DQB", emit: dqb
path "${contigs}_DRB", emit: drb
path "${contigs}_log"

script:
"""
cat ${contigs} | fastx_barcode_splitter.pl --bcfile ${barcodeFile} --prefix ${contigs}_ --bol --mismatches 1 > ${contigs}_log
"""
}