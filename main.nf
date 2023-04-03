//#! usr/bin/env nextflow
//load modules

include { fastqc } from './proc/fastqc.nf'
include { fastp } from './proc/fastp.nf'
include { fastxcollapser } from './proc/fastxcollapser.nf'
include { barcodeSplit_f ; barcodeSplit_r } from './proc/barcodeSplit.nf'
include { collapseFilter ; idsToFasta } from './proc/collapserFrecFilter.nf'
include { compare_sequences } from './proc/compareSequences.nf'
include { fareverse } from './proc/faReverse.nf'


params.reads = './datos_completos/*/*{R1,R2}.fastq'
params.outdir = "output"
params.thread = 2
params.quality = 30
params.barcodeFile1 = './Data/barcode/barcode_file.txt'
params.barcodeFile2 = './Data/barcode/barcode_file2.txt'
params.cleanfolder = './outdir_barcodeSplit/*'

ifile = Channel.fromFilePairs(params.reads)
       .set {reads_ch}   
              
barcodeChannel1 = Channel.fromPath(params.barcodeFile1)
       .set {barcode_f}

barcodeChannel2 = Channel.fromPath(params.barcodeFile2)
       .set {barcode_r}


//fastqc (QC)



log.info """\
    Oklander - N F   P I P E L I N E
    ===================================
    File parameters:
    --reads        : ${params.reads}
    --outdir       : ${params.outdir}
    
    Fastp options:
    --thread     : ${params.thread}
    --quality    : ${params.quality}

    """
    .stripIndent()



//fastp

//fastqc

//Barcode Splitter (split into 3 genes)
//       fastx_barcode_splitter.pl
//	Barcode Splitter, by Assaf Gordon (gordon@cshl.edu), 11sep2008


workflow{

//--------------First_step-------------------------------------


       fastqc(reads_ch)

       fastp(reads_ch)
       
       barcodeSplit_f(fastp.out.fastp_1.flatten().buffer( size: 1 ), barcode_f)
       barcodeSplit_r(fastp.out.fastp_2.flatten().buffer( size: 1 ), barcode_r)

       fastxcollapser(barcodeSplit_f.out.dqaf,barcodeSplit_f.out.dqbf,barcodeSplit_f.out.drbf,barcodeSplit_r.out.dqar,barcodeSplit_r.out.dqbr,barcodeSplit_r.out.drbr)
       
       fastxcollapser.out.collapsed_dqaf.concat(fastxcollapser.out.collapsed_dqar,
                                                 fastxcollapser.out.collapsed_dqbf,
                                                 fastxcollapser.out.collapsed_dqbr,
                                                 fastxcollapser.out.collapsed_drbf,
                                                 fastxcollapser.out.collapsed_drbr).set{toCollapse}

       collapseFilter(toCollapse)

       idsToFasta(collapseFilter.out.idReads,collapseFilter.out.idFile)


       //Setting input ch. for trueAlleles

       sequences = Channel.fromFilePairs('outdir_filteredFastaFromId/collapsed_fastp_*Ca*{DQAf,DQAr}.fasta.fa').set{ file_list }
      
       file_list.view()


       }









