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
include { filesForCount; collapseFilesForCount; count_sequences as countDRB; count_sequences as countDQA; count_sequences as countDQB } from './proc/trueAllelesCountTable.nf'
include { pandaSeq ; barcodeSplit } from './proc/pandaseq.nf'


params.reads = './Data/*/*{R1,R2}.fastq'
params.countdqa = './outdir_filteredFastaFromId/*DQAf.fasta.fa'
params.countdqb = './outdir_filteredFastaFromId/*DQBf.fasta.fa'
params.countdrb = './outdir_filteredFastaFromId/*DRBf.fasta.fa'
params.outdir = "output"
params.thread = 2
params.quality = 30
params.barcodeFile1 = './Data/barcode/barcode_file.txt'
params.barcodeFile2 = './Data/barcode/barcode_file2.txt'
params.cleanfolder = './outdir_barcodeSplit/*'

reads_ch = Channel.fromFilePairs(params.reads)   
              
barcode_f = Channel.fromPath(params.barcodeFile1)

barcode_r = Channel.fromPath(params.barcodeFile2)


workflow PROCESS{

//--------------First_step-------------------------------------
       fastqc(reads_ch)

       fastp(reads_ch)

       
       pandaSeq(fastp.out.fastpOut.view())
              
       
       fastxcollapser(pandaSeq.out.pandaOut)
       
       barcodeSplit_f(fastxcollapser.out.seqCollapsed, barcode_f)


       barcodeSplit_f.out.dqaf.concat(barcodeSplit_f.out.dqbf,barcodeSplit_f.out.drbf).set{toCollapse}

       collapseFilter(toCollapse)

       idsToFasta(collapseFilter.out.idReads,collapseFilter.out.idFile)
       


}




workflow COUNT{   

      //Setting input ch. for trueAlleles

    dqafile = Channel.fromFilePairs(params.countdqa, size: -1, checkIfExists:true).view()
    dqbfile = Channel.fromFilePairs(params.countdqb, size: -1, checkIfExists:true).view()
    drbfile = Channel.fromFilePairs(params.countdrb, size: -1, checkIfExists:true).view()

    trueAllelesDQA(dqafile)
    trueAllelesDQB(dqbfile)
    trueAllelesDRB(drbfile)

      filesForCount()


       collapseFilesForCount(filesForCount.out.dqaCount,filesForCount.out.dqbCount,filesForCount.out.drbCount)

       //........................CountTable...............................

        //input_fasta_files
        Channel.fromPath('./outdir_taFiltered/DRB/*').collect().set{fastafiles}
        Channel.fromPath('./outdir_taFiltered/collapsedCountGenes/DRB.collapsed.full').set{querydrb}

        Channel.fromPath('./outdir_taFiltered/DQA/*').collect().set{fastadqa}
        Channel.fromPath('./outdir_taFiltered/collapsedCountGenes/DQA.collapsed.full').set{querydqa}

        Channel.fromPath('./outdir_taFiltered/DQB/*').collect().set{fastadqb}
        Channel.fromPath('./outdir_taFiltered/collapsedCountGenes/DQB.collapsed.full').set{querydqb}



        //run module
        countDRB(querydrb)//,fastafiles.view())
        countDQA(querydqa)
        countDQB(querydqb)
}


workflow{
    //PROCESS()


    COUNT()
}    









