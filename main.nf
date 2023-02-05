//#! usr/bin/env nextflow
//process zero loadfiles

include { fastqc } from './proc/fastqc.nf'
include { fastp } from './proc/fastp.nf'
include { fastqc2 } from './proc/fastqc2.nf'
include { makeContigs } from './proc/makeContigs.nf'
include { screenSeqs } from './proc/screenSeqs.nf'
include { summarySeqs } from './proc/summarySeqs.nf'
include { barcodeSplit } from './proc/barcodeSplit.nf'
include { uniqueSeqs } from './proc/uniqueSeqs.nf'
include { distSeqsDqa; distSeqsDqb; distSeqsDrb } from './proc/distSeqs.nf'
include { fastqtofasta } from './proc/fastqtofasta.nf'
include { uniqueSeqs2 } from './proc/uniqueSeqs2.nf'




//Channel.fromPath('./Data/LGE*')
  //     .view()
params.reads = './Data/*/*{R1,R2}.fastq'
params.outdir = "output"
params.thread = 4
params.quality = 30
params.barcodeFile = './Data/barcode/barcode_file.txt'

ifile = Channel.fromFilePairs(params.reads)
       .set {reads_ch}   
              
barcodeChannel = Channel.fromPath(params.barcodeFile)
       //.view()
       .set {barcode_ch}



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





workflow{

//--------------First_step-------------------------------------

//fastqc (QC)

//fastp

//fastqc

//Make.contigs (ensamble de contigs) del mismo individuo.

//Screen.seqs (filtrado de secuencias indeseadas, por longitud 200-350, bases ambiguas, max homopolymer=8)

//Summary.seqs (información estadística del proceso)

       fastqc(reads_ch)

       fastp_ch = fastp(reads_ch)

       fastpOut = fastp.out[0].join(fastp.out[1])

       fastqc2(fastp.out.fastp_1.concat(fastp.out.fastp_2).view())



       fastpOut.view()

       makeContigs(fastpOut)

       toScreen = makeContigs.out.trimContigs.toSortedList().flatten()
       
       summarySeqs(screenSeqs(toScreen).buffer( size: 1 ))

       
//---------------Second_step--------------------------------------

//Barcode Splitter (split into 3 genes DQA, DQB, DRB)
//       fastx_barcode_splitter.pl
//	Barcode Splitter, by Assaf Gordon (gordon@cshl.edu), 11sep2008

//Unique.seqs (names: grupos de nombres según secuencias únicas)

//Count.seqs (conteo de seqs, mothur instalado localmente)
//      Conteo final de genes en grupos (GH2,DQB,DRB)
//      mothur > count.seqs(name=file.mothur.names, group=file.mothur.groups, compress=f)

       barcodeSplit(screenSeqs.out.screenedContig, barcode_ch)

//experimental --> dist.seqs(fasta=) ; read.dist(phylip=file.phylip.dist) ; cluster(method=average)
       dqaData = barcodeSplit.out.dqa//.view()
       
       uniqueSeqs(dqaData.buffer( size: 1 ))
       
       tofa = fastqtofasta(fastp.out.fastp_1.concat(fastp.out.fastp_2).view())

       uniqueSeqs2(tofa.buffer( size: 1 ))

       }









