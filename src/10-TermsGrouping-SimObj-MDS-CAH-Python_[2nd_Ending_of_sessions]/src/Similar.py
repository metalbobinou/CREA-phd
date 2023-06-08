import os
import sys

import csv
#from itertools import izip

# Graphics
import pandas
# - scatter matrix
from pandas.plotting import scatter_matrix
# - general plotting
from matplotlib import pyplot as plt

# Centrage-Reduction des variables
from sklearn import preprocessing

# Stats
from sklearn import metrics

# DBSCAN
from sklearn.cluster import DBSCAN

# DBSCAN preprocessing
from sklearn.neighbors import NearestNeighbors
from sklearn.preprocessing import StandardScaler

# index tries
import numpy as np


## MANUAL SETTING OF EPS !!!
## You must choose the best EPS by reading the first graphic !
## The best EPS is at the elbow of the curve ! (take the Y axis value)
## Then, modify the EPS in the DBSCAN and relaunch the code


def BuildOutputName(filename):
    InBaseName = os.path.basename(filename)
    OutName = InBaseName
    return OutName


def GetSimilar(filename, outfile="NULL", separator=";", XSize=10, YSize=9, dpi=300):
    if (outfile == "NULL"):
        outfile = BuildOutputName(filename)

    ## Load CSV file in memory
    in_data = pandas.read_table(filename, separator, header=0, index_col=0)
    in_labels = np.array(in_data.columns.values.tolist())
    in_values = in_data.to_numpy()
    in_nb_values = len(in_values)

    ## in_data : <class 'pandas.core.frame.DataFrame'> (Matrix values + labels)
    ## in_values : <class 'numpy.ndarray'> (Matrix values)
    ## in_labels : <class 'numpy.ndarray'> (Labels)

    ## Dimension des donnees
    #print("Data.Shape : " + str(data.shape) + "\n")

    ## Statistiques descriptives
    ##print("Data.Describe : " + str(data.describe) + "\n")
    print("Data.Describe() : ")
    print(in_data.describe())
    print("\n")

    print("in_data :")
    cluster_list = []
    for i in range(len(in_labels)):
        label_col = in_labels[i]
        cur_column = in_data[label_col]
        #print(label_col)
        local_cluster = { label_col.strip() }
        for label_row in in_data[label_col].index:
            #if (label_col.strip() == label_row.strip()):
                # print("!!! DIAGONALE !!!")
            value = in_data[label_col][label_row]
            if (type(value) != type(np.float64(0.0))):
                print("probleme type")
                value = np.float64(value)
                if (type(value) == type(np.array([0.,0.], dtype=np.float64))):
                    value = np.float64(value[0])
            out = str(label_row) + " : (" +str(type(value))+ ") " + str(value)
            print(out)
            # Si n'est PAS diagonale, mais est a 0, alors on affiche
            if ((label_col.strip() != label_row.strip()) and (value == 0)):
                local_cluster.add(label_row.strip())
                #out = str(label_row) + " : " + str(value)
                #print(out)
        # Now, let's create a cluster "if" there is more than the initial term
        if (len(local_cluster) > 1):
            #local_cluster.sort()
            local_cluster_l = sorted(local_cluster)
            cluster_list.append(local_cluster_l) if local_cluster_l not in cluster_list else cluster_list
        #print("--")

    for i in range(len(cluster_list)):
        #print(i)
        out = ""
        cluster = cluster_list[i]
        for j in range(len(cluster)):
            #print(j)
            #print(cluster[j])
            out = "'" + str(cluster[j]) + "' " + out
        print(str(i) + " : " + out)

    ## Print in a file
    print("## Clusters CSV")
    CSV_OUT_filename = 'Clusters-Similar-' + outfile + '.csv'
    print("File : " + CSV_OUT_filename)
    CSV_OUT = open(CSV_OUT_filename, "w")
    OFS = ";"
    for i in range(len(cluster_list)):
        line = str(i)
        #print(str(i))
        cluster = cluster_list[i]
        for elt in range(len(cluster)):
            index = cluster_list[i][elt]
            out_label = cluster[elt]
            EachLabel = str.strip(out_label)
            line = line + OFS + EachLabel
            #print(OFS + EachLabel)
        line = line + "\n"
        #print("\n")
        #print(line)
        CSV_OUT.write(line)
    CSV_OUT.close()
    print("")


###########################

###### SWITCH CASE FOR ARGS
####
# METHOD 1 : (do not manage "default")
# PREPARE CASES FIRST :
def ZeroArg():
    printHelp()
def OneArg():
    ZeroArg()
def TwoArgs():
    GetSimilar(sys.argv[1])
def ThreeArgs():
    GetSimilar(sys.argv[1], sys.argv[2])
def FourArgs():
    GetSimilar(sys.argv[1], sys.argv[2], sys.argv[3])
def FiveArgs():
    GetSimilar(sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]))
def SixArgs():
    GetSimilar(sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]), int(sys.argv[5]))
def SevenArgs():
    GetSimilar(sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]), int(sys.argv[5]), int(sys.argv[6]))

# PREPARE SWITCH
ArgsMgmt = { 0 : ZeroArg,
             1 : OneArg,
             2 : TwoArgs,
             3 : ThreeArgs,
             4 : FourArgs,
             5 : FiveArgs,
             6 : SixArgs,
             7 : SevenArgs,
}

# CALL SWITCH/CASE :
#NBArgs = len(sys.argv);
#ArgsMgmt[NBArgs]()

####
# METHOD 2 : if/elseif/else (manage "default")
#if (NBArgs == 1):
#    OneArg()
#else if (NBArgs == 2):
#    TwoArgs()
#else:
#    default()

def printHelp():
    print("Error: No parameters given")
    print("Format of parameter : ")
    print(sys.argv[0] + " filename outfile separator XSize YSize dpi")

def main():
    NBArgs = len(sys.argv);
#    print("NB Args : " + str(NBArgs))
#    for arg in sys.argv:
#        print(arg)
#        TransposeCSV(arg)

    if (NBArgs > 0):
        ArgsMgmt[NBArgs]()
    else:
        printHelp()
        exit(-1)
    exit(0)

main()
