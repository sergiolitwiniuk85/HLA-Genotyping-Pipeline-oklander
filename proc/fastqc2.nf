

process fastqc2{


tag "FastQC_after $reads"
publishDir 'outdir_1_fastqc', mode:'copy'

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
