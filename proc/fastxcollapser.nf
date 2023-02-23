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
path "collapsed_${dqaf}", emit: collapsed_dqaf
path "collapsed_${dqbf}", emit: collapsed_dqbf
path "collapsed_${drbf}", emit: collapsed_drbf
path "collapsed_${dqar}", emit: collapsed_dqar
path "collapsed_${dqbr}", emit: collapsed_dqbr
path "collapsed_${drbr}", emit: collapsed_drbr


script:
"""
fastx_collapser -i ${dqaf} -o collapsed_${dqaf}
sleep 1
fastx_collapser -i ${dqbf} -o collapsed_${dqbf}
sleep 1
fastx_collapser -i ${drbf} -o collapsed_${drbf}
sleep 1
fastx_collapser -i ${dqar} -o collapsed_${dqar}
sleep 1
fastx_collapser -i ${dqbr} -o collapsed_${dqbr}
sleep 1
fastx_collapser -i ${drbr} -o collapsed_${drbr}
sleep 1
"""

}






