import os
import sys

import csv
#from itertools import izip

# Import Rand Index
from sklearn.metrics.cluster import rand_score
# Import Adjusted Rand Index
from sklearn.metrics.cluster import adjusted_rand_score


def CalculateMetrics(csv1, csv2):
    #RandIndex = rand_score([0, 0, 1, 1], [1, 1, 0, 0])
    #AdjustedRandIndex = adjusted_rand_score([0, 0, 1, 1], [1, 1, 0, 0])

    #    mot1  mot2  mot3 ...       => terme
    # [   C1    C1    C2   ...  ]   => n° du cluster d'appartenance

    RandIndex = rand_score(csv1, csv2)
    AdjustedRandIndex = adjusted_rand_score(csv1, csv2)

    print("Index of Rand : " + str(RandIndex))
    print("Adjusted Index of Rand : " + str(AdjustedRandIndex))
    print("")



def AddFileToList(NbArgs, CSVList):
    for i in range(1, NbArgs):
        filename = sys.argv[i]
        with open(filename) as csvfile:
            reader = csv.reader(csvfile, delimiter=';')
            for row in reader:
                #print(row)  # row contains str
                #ThisTuple = (filename, row)
                TmpList = []
                for n in row:
                    TmpList.append(int(n))
                #print(TmpList)
                ThisTuple = (filename, TmpList)
                CSVList.append(ThisTuple)
                #print(ThisTuple)


def processing(NbArgs):
    print("NB Args : " + str(NbArgs))
    CSVList = []
    AddFileToList(NbArgs, CSVList)

    for csv_i in CSVList:
        for csv_j in CSVList:
            print("Processing '" + str(csv_i[0]) +
                  "' and '" + str(csv_j[0]) + "'")
            CalculateMetrics(csv_i[1], csv_j[1])


def printHelp():
    print("Error: No parameters given")
    print("  Give at least 2 csv files")

def main():
    NBArgs = len(sys.argv);
#    print("NB Args : " + str(NBArgs))
#    for arg in sys.argv:
#        print(arg)
#        TransposeCSV(arg)

    if (NBArgs >= 2):
        processing(NBArgs)
    else:
        printHelp()
        exit(-1)
    exit(0)

main()
