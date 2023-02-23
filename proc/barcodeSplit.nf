process barcodeSplit_f{
publishDir("outdir_barcodeSplit/${reads}.fasta", mode:"copy", overwrite:false)

input:
each path(reads)
path(barcodeFile)

output:
path "${reads}_DQAf.fasta", emit: dqaf, optional: true
path "${reads}_DQBf.fasta", emit: dqbf, optional: true
path "${reads}_DRBf.fasta", emit: drbf, optional: true
path "${reads}_log"


script:
"""
sleep 1
cat ${reads} | fastx_barcode_splitter.pl --bcfile ${barcodeFile} --prefix ${reads}_ --suffix ".fasta" --bol --mismatches 1 > ${reads}_log
"""
}

process barcodeSplit_r{
publishDir("outdir_barcodeSplit/${reads}.fasta", mode:"copy", overwrite:false)

input:
each path(reads)
path(barcodeFile)

output:
path "${reads}_DQAr.fasta", emit: dqar, optional: true
path "${reads}_DQBr.fasta", emit: dqbr, optional: true
path "${reads}_DRBr.fasta", emit: drbr, optional: true
path "${reads}_log"


script:
"""
sleep 1
cat ${reads} | fastx_barcode_splitter.pl --bcfile ${barcodeFile} --prefix ${reads}_ --suffix ".fasta" --bol --mismatches 1 > ${reads}_log
"""
}