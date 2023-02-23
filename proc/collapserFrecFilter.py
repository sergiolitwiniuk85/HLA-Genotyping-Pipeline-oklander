#!/home/sergiolitwiniuk/anaconda3/envs/bio/bin/python
from Bio import SeqIO
import sys

ids=[]
sumOfCopies = 0
filePath=sys.argv[1]

for record in SeqIO.parse(filePath,"fasta"):
    copies = record.id.split("-")
    sumOfCopies += int(copies[1])

for record in SeqIO.parse(filePath,"fasta"):
    copyNumber = record.id.split("-")
    ids.append(int(copyNumber[1]))

    if ((int(copyNumber[1])/sumOfCopies)*100) > int(sys.argv[2]):
        rowToFile = copyNumber[0] + "-" + copyNumber[1]
        print(rowToFile)



    

