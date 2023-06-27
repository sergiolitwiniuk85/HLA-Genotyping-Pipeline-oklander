process fastxcollapser{

publishDir("outdir_fastxcollapser/", mode:'copy')

input:
path(seq)


output:
path("c_${seq}"), emit: seqCollapsed


script:

"""
fastx_collapser -i ${seq} -o c_${seq}
"""

}






