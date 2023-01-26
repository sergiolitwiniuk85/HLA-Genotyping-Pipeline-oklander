process fastqc{
tag "FastQC_after $reads"
publishDir 'outdir_0_fastqc', mode:'copy'


input:
tuple val(sample_id), path(reads)

output:
path "fastqc_${sample_id}_logs"

script:
"""
mkdir fastqc_${sample_id}_logs
fastqc -o fastqc_${sample_id}_logs -t 4 ${reads}
"""
}
