process fastxcollapser{

publishDir("outdir_fastxcollapser/", mode:'copy')

input:
path(dqaf)
path(dqbf)
path(drbf)
path(dqar)
path(dqbr)
path(drbr)


output:
path("c_${dqaf}"), emit: collapsed_dqaf
path("c_${dqbf}"), emit: collapsed_dqbf
path("c_${drbf}"), emit: collapsed_drbf
path("c_${dqar}"), emit: collapsed_dqar
path("c_${dqbr}"), emit: collapsed_dqbr
path("c_${drbr}"), emit: collapsed_drbr


script:

"""
fastx_collapser -i ${dqaf} -o c_${dqaf}
fastx_collapser -i ${dqbf} -o c_${dqbf}
fastx_collapser -i ${drbf} -o c_${drbf}
seqtk seq -r ${dqar} | fastx_collapser -o c_${dqar}
seqtk seq -r ${dqbr} | fastx_collapser -o c_${dqbr}
seqtk seq -r ${drbr} | fastx_collapser -o c_${drbr}
"""

}






