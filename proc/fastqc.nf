process fastqc{
tag "FastQC_before $reads"
publishDir("outdir_0_fastqc/${sample_id}_beforeQc", mode:'copy')

input:
tuple val(sample_id), path(reads)

output:
path "fastqc_${sample_id}_logs"

script:
"""
mkdir fastqc_${sample_id}_logs
fastqc -o fastqc_${sample_id}_logs -t 2 ${reads}
"""
}
