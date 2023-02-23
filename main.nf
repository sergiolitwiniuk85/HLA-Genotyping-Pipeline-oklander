//#! usr/bin/env nextflow
//process zero loadfiles

include { fastqc } from './proc/fastqc.nf'
include { fastp } from './proc/fastp.nf'
include { fastqc2 } from './proc/fastqc2.nf'
include { uniqueSeqs } from './proc/uniqueSeqs.nf'
include { fastqtofasta } from './proc/fastqtofasta.nf'
include { fastxcollapser } from './proc/fastxcollapser.nf'
//include { makeContigs } from './proc/makeContigs.nf'
//include { summarySeqs } from './proc/summarySeqs.nf'
include { barcodeSplit_f ; barcodeSplit_r } from './proc/barcodeSplit.nf'
include { uniquedqa; uniquedqb; uniquedrb } from './proc/uniqueSeqsGen.nf'
include { collapseFilter ; idsToFasta } from './proc/collapserFrecFilter.nf'


//Channel.fromPath('./Data/LGE*')
  //     .view()
params.reads = './Data/*/*{R1,R2}.fastq'
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

//Make.contigs (ensamble de contigs) del mismo individuo.

//Summary.seqs (información estadística del proceso)

//Screen.seqs (filtrado de secuencias indeseadas, por longitud 200-350, bases ambiguas, max homopolymer=8)

//Barcode Splitter (split into 3 genes)
//       fastx_barcode_splitter.pl
//	Barcode Splitter, by Assaf Gordon (gordon@cshl.edu), 11sep2008

//Unique.seqs (names: grupos de nombres según secuencias únicas)

//Count.seqs (conteo de seqs, mothur instalado localmente)
//      Conteo final de genes en grupos (GH2,DQB,DRB)
//      mothur > count.seqs(name=file.mothur.names, group=file.mothur.groups, compress=f)


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
                                                 fastxcollapser.out.collapsed_drbr).view().set{toCollapse}

       collapseFilter(toCollapse)

       idsToFasta(collapseFilter.out.idReads,collapseFilter.out.idFile)

       //fastqtofasta(fastp.out.fastp_1.concat(fastp.out.fastp_2))

       //uniqueSeqs(fastqtofasta.out.fastq_to_fasta)

       
       //uniqueSeqs.out.uniqueTesting.view()
      // fastqc2(fastp.out.fastpMerged.view())

      // makeContigs(fastpOut)

      // toScreen = makeContigs.out.trimContigs.toSortedList().flatten()
       
       //summarySeqs(screenSeqs(toScreen).buffer( size: 1 ))

       
//---------------Second_step--------------------------------------

       

       //uniquedqa(barcodeSplit.out.dqa)
       //uniquedqb(barcodeSplit.out.dqb)
       //uniquedrb(barcodeSplit.out.drb)








       }









