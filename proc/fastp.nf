process fastp{
       memory '4 GB'
       cpus 8

       tag "Fastp_$reads"
       publishDir("outdir_fastp/${sample_id}_fastp")

       params.quality = 30 //the quality value that a base is qualified. Default 15 means phred quality >=Q15 is qualified. (Default 15)
       params.thread = 8 
       params.percent = 3 // unqualified_percent_limit   how many percents of bases are allowed to be unqualified (0~100). Default 40 means 40%
 
       input:

       tuple val(sample_id), path(reads)

       output:
       tuple val(sample_id), path("fastp_${sample_id}_R1.fastq"), emit: fastp_1 
       tuple val(sample_id), path("fastp_${sample_id}_R2.fastq"), emit: fastp_2

       script:

       """
       fastp -i ${reads[0]} -o fastp_${sample_id}_R1.fastq -I ${reads[1]} -O fastp_${sample_id}_R2.fastq -q ${params.quality} -w ${params.thread} -u ${params.percent}
       """

}
