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

# CAH import
from scipy.cluster.hierarchy import dendrogram, linkage, fcluster

# index tries
import numpy as np


def BuildOutputName(filename):
    InBaseName = os.path.basename(filename)
    OutName = InBaseName
    return OutName


def GenerateCAH(filename, outfile="NULL", separator=";", XSize=10, YSize=9, dpi=300):
    if (outfile == "NULL"):
        outfile = BuildOutputName(filename)

    in_data = pandas.read_table(filename, separator, header=0, index_col=0)
    in_labels = np.array(in_data.columns.values.tolist())
    in_values = in_data.to_numpy()
    in_nb_values = len(in_values)

    ## in_data : <class 'pandas.core.frame.DataFrame'> (Matrix values + labels)
    ## in_values : <class 'numpy.ndarray'> (Matrix values)
    ## in_labels : <class 'numpy.ndarray'> (Labels)

    labels_true = in_labels
    data = in_data

    ## Dimension des donnees
    #print("Data.Shape : " + str(data.shape) + "\n")

    ## Statistiques descriptives
    ##print("Data.Describe : " + str(data.describe) + "\n")
    print("Data.Describe() : ")
    print(in_data.describe())
    print("\n")

    ## Description donnees
    #print("Data.Index : " + str(data.index) + "\n")
    ##print("Data.Index VALUES :")
    ##print(data.index.values)
    ##print("\n")

    ## Choix de la taille à indiquer : 7
    threshold_height = 7

    ###### DENDROGRAMME / CAH #####
    ## 0) Centrage-reduction des variables (calcul des centroides)
    ## 1) Creation de matrice de liens
    ## 2) Affichage du dendrogramme (directement dans matplotlib)

    ## 0) Centrage-reduction des variables (calcul des centroides)
    data_CR = preprocessing.scale(data)

    ## 1) Creation de matrice de liens
    data_LinkMatrix = linkage(data_CR, method='ward', metric='euclidean')

    ## 2) Affichage du dendrogramme (directement dans matplotlib)

    ## 2.1) Preparation matplotlib
    plt.figure(1)
    plt.figure(figsize=(XSize,YSize), dpi=dpi) # Size of the figure [x,y]
    ##plt.figure(dpi=200)
    plt.title("CAH avec materialisation des classes (decoupage à "
              + str(threshold_height)
              + ")")

    ## 2.2) Affichage dendrogramme dans matplotlib (index des donnees d'origine)
    dendrogram(data_LinkMatrix,
               labels=data.index,
               orientation='left',
               color_threshold=0)

    ## 2.3) Sauvegarde de la sortie

    ## Bigger fonts
    ax = plt.gca()
    ax.tick_params(axis='x', which='major', labelsize=15)
    ax.tick_params(axis='y', which='major', labelsize=16)

    ## Print lines
    ##plt.axhline(y=threshold_height, # print an horizontal line for threshold
    plt.axvline(x=threshold_height, # print a vertical line for threshold
                c='grey',
                lw=1,
                linestyle='dashed')
    ##plt.show() # Open display and show at screen
    plt.savefig('CAH-' + outfile + '.png', format='png', bbox_inches='tight') # PNG
    ##plt.savefig('CAH-' + outfile + '.jpg', format='jpg', bbox_inches='tight') # JPG


    ## Découpage à la hauteur t = 7 ==> identifiants de 4 groupes obtenus
    print("Groupes CAH")
    groupes_cah = fcluster(data_LinkMatrix, t=threshold_height, criterion='distance')
    print(groupes_cah)
    print("\n")

    ## Prepare structures
    cluster_list = []
    ## Biggest value in array
    nb_clusters = 0
    for val in groupes_cah:
        if (nb_clusters < val):
            nb_clusters = val
    for i in range(nb_clusters + 1):
        cluster_list.append([])

    ## List of values : each point (index/labels_true[index]) is in a cluster (value)
    print("## Liste d'appartenance des valeurs aux clusters")
    for index, value in enumerate(groupes_cah):
        print("[" + str(index) + " " + in_labels[index] + "] : " + str(value))
        cluster_list[value].append(index)
    print("")

    ## Gather clusters
    print("## Clusters")
    for cluster in range(1, len(cluster_list)):
        print('cluster: ', cluster)
        ## Cluster "0" does not exist
        for elt in range(len(cluster_list[cluster])):
            index = cluster_list[cluster][elt]
            print("-- ", in_labels[index])
    print("")


    ## Print in a file
    print("## Clusters CSV")
    CSV_OUT_filename = 'Clusters-CAH-' + outfile + '.csv'
    print("File : " + CSV_OUT_filename)
    CSV_OUT = open(CSV_OUT_filename, "w")
    OFS = ";"
    for cluster in range(1, len(cluster_list)):
        line = str(cluster)
        #print(str(cluster))
        for elt in range(len(cluster_list[cluster])):
            index = cluster_list[cluster][elt]
            out_label = in_labels[index]
            EachLabel = str.strip(out_label)
            line = line + OFS + EachLabel
            #print(OFS + EachLabel)
        line = line + "\n"
        #print("\n")
        #print(line)
        CSV_OUT.write(line)
    CSV_OUT.close()
    print("")


    ## Index triés des groupes
    #idg = np.argsort(groupes_cah)

    ## Affichage des observations et leurs groupes
    #print("Observations & groupes")
    #print(pandas.DataFrame(data.index[idg], groupes_cah[idg]))


###### SWITCH CASE FOR ARGS
####
# METHOD 1 : (do not manage "default")
# PREPARE CASES FIRST :
def ZeroArg():
    printHelp()
def OneArg():
    ZeroArg()
def TwoArgs():
    GenerateCAH(sys.argv[1])
def ThreeArgs():
    GenerateCAH(sys.argv[1], sys.argv[2])
def FourArgs():
    GenerateCAH(sys.argv[1], sys.argv[2], sys.argv[3])
def FiveArgs():
    GenerateCAH(sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]))
def SixArgs():
    GenerateCAH(sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]), int(sys.argv[5]))
def SevenArgs():
    GenerateCAH(sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]), int(sys.argv[5]), int(sys.argv[6]))

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
