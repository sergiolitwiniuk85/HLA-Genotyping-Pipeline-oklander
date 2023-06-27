//#! usr/bin/env nextflow
//load modules

include { fastqc } from './proc/fastqc.nf'
include { fastp } from './proc/fastp.nf'
include { fastxcollapser } from './proc/fastxcollapser.nf'
include { barcodeSplit_f ; barcodeSplit_r } from './proc/barcodeSplit.nf'
include { collapseFilter ; idsToFasta } from './proc/collapserFrecFilter.nf'
include { compare_sequences } from './proc/compareSequences.nf'
include { fareverse } from './proc/faReverse.nf'
include { trueAllelesDQA; trueAllelesDQB; trueAllelesDRB } from './proc/trueAllelesFilter.nf'
include { filesForCount; collapseFilesForCount; count_sequences } from './proc/trueAllelesCountTable.nf'
include { pandaSeq ; barcodeSplit } from './proc/pandaseq.nf'


params.reads = './Data/*/*{R1,R2}.fastq'
params.outdir = "output"
params.thread = 2
params.quality = 30
params.barcodeFile1 = './Data/barcode/barcode_file.txt'
params.barcodeFile2 = './Data/barcode/barcode_file2.txt'
params.cleanfolder = './outdir_barcodeSplit/*'

reads_ch = Channel.fromFilePairs(params.reads)   
              
barcode_f = Channel.fromPath(params.barcodeFile1)

barcode_r = Channel.fromPath(params.barcodeFile2)


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

       
       pandaSeq(fastp.out.fastpOut.view())
              
       
       fastxcollapser(pandaSeq.out.pandaOut)
       
       barcodeSplit_f(fastxcollapser.out.seqCollapsed, barcode_f)


       barcodeSplit_f.out.dqaf.concat(barcodeSplit_f.out.dqbf,barcodeSplit_f.out.drbf).set{toCollapse}

       collapseFilter(toCollapse)

       idsToFasta(collapseFilter.out.idReads,collapseFilter.out.idFile)

     //Setting input ch. for trueAlleles

       dqafile = Channel.fromFilePairs("./outdir_filteredFastaFromId/c_*{Tis,TIS}*DQAf.fasta.fa")
       dqbfile = Channel.fromFilePairs("./outdir_filteredFastaFromId/c_*{Tis,TIS}*DQBf.fasta.fa")
       drbfile = Channel.fromFilePairs("./outdir_filteredFastaFromId/c_*{Tis,TIS}*DRBf.fasta.fa")


       trueAllelesDQA(dqafile)
       trueAllelesDQB(dqbfile)
       trueAllelesDRB(drbfile)

       filesForCount() 
       
       collapseFilesForCount(filesForCount.out.dqaCount,filesForCount.out.dqbCount,filesForCount.out.drbCount)

       //........................CountTable...............................

        //input_fasta_files
        fastaFiles = Channel.fromPath('./outdir_taFiltered/DRB/*').collect().set{fastafiles}
        query = Channel.fromPath('./outdir_taFiltered/collapsedCountGenes/DRB.full').set{queryfile}

        //run module
        count_sequences(queryfile)//,fastafiles.view())


        /*

       barcodeSplit_r(fastp.out.fastp_2.flatten().buffer( size: 1 ), barcode_r)

       
       fastxcollapser.out.collapsed_dqaf.concat(fastxcollapser.out.collapsed_dqar,
                                                 fastxcollapser.out.collapsed_dqbf,
                                                 fastxcollapser.out.collapsed_dqbr,
                                                 fastxcollapser.out.collapsed_drbf,
                                                 fastxcollapser.out.collapsed_drbr).set{toCollapse}

       collapseFilter(toCollapse)

       idsToFasta(collapseFilter.out.idReads,collapseFilter.out.idFile)


       //Setting input ch. for trueAlleles

       dqafile = Channel.fromFilePairs("./outdir_filteredFastaFromId/c_fastp_*{Tis,TIS}*DQAr.fasta.fa")
       dqbfile = Channel.fromFilePairs("./outdir_filteredFastaFromId/c_fastp_*{Tis,TIS}*DQBr.fasta.fa")
       drbfile = Channel.fromFilePairs("./outdir_filteredFastaFromId/c_fastp_*{Tis,TIS}*DRBr.fasta.fa")


       trueAllelesDQA(dqafile)
       trueAllelesDQB(dqbfile)
       trueAllelesDRB(drbfile)

       filesForCount()

       collapseFilesForCount(filesForCount.out.dqarCount,filesForCount.out.dqbrCount,filesForCount.out.drbrCount)

       //........................CountTable...............................

        //input_fasta_files
        fastaFiles = Channel.fromPath('./outdir_taFiltered/DRBf/*').collect().set{fastafiles}
        query = Channel.fromPath('./outdir_taFiltered/collapsedCountGenes/DRBf.full').set{queryfile}

        //run module
        count_sequences(queryfile)//,fastafiles.view())

    */

}      









