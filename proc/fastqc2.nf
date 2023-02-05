
process fastqc2{

tag "FastQC_after $reads"
publishDir("outdir_1_fastqc/${sample_id}_afterQc", mode:'copy')

input:
tuple val(sample_id), path(reads)

output:
path "fastqc2_${reads}_logs"

script:
"""
mkdir fastqc2_${reads}_logs
fastqc -o fastqc2_${reads}_logs -t 2 ${reads}
"""
}
