
process fastqc2{

memory '2 GB'
tag "FastQC_after $reads"
publishDir("outdir_1_fastqc/${reads}_afterQc", mode:'copy')

input:
path(reads)

output:
path "fastqc2_${reads}_logs"

script:
"""
mkdir fastqc2_${reads}_logs
fastqc -o fastqc2_${reads}_logs -t 4 ${reads}
"""
}
