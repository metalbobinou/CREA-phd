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
    OutName = "CAH-" + InBaseName
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
    data = in_values

    ## Dimension des donnees
    #print("Data.Shape : " + str(data.shape) + "\n")

    ## Statistiques descriptives
    ##print("Data.Describe : " + str(data.describe) + "\n")
    print("Data.Describe() : ")
    print(data.describe())
    print("\n")

    ## Description donnees
    #print("Data.Index : " + str(data.index) + "\n")
    ##print("Data.Index VALUES :")
    ##print(data.index.values)
    ##print("\n")

    ## Graphique - croisement deux a deux des variables ### DISPLAY
    ### TRES TRES LENT CAR TOUTES LES MATRICES SONT COMPAREES ###
    ##scatter_matrix(data, figsize=(9,9))
    print("\n--\n")

    ## Copy the data array (may modify it)
    ##my_array = []
    ##for i in range(0, len(data.index.values)):
    ##    my_array.insert(i, data.index.values[i])
    ##print("Data.Index VALUES SECOND :")
    ##print(my_array)
    ##print("\n")

    ## Centrage-reduction des variables
    data_cr = preprocessing.scale(data)

    ## Generer la matrice de liens
    LinkMatrix = linkage(data_cr, method='ward', metric='euclidean')

    ## Affichage du dendrogramme ### DISPLAY
    ##plt.title("CAH")
    ####                   orientation='left' color_threshold=0
    ##dendrogram(LinkMatrix, orientation='top', color_threshold=0)
    ##plt.show()

    ###### DENDROGRAMME / CAH #####
    plt.figure(figsize=(XSize,YSize), dpi=dpi) # Size of the figure [x,y]
    ##plt.figure(dpi=200)
    plt.title("CAH avec materialisation des classes (threshold = 7)")
    #### Materialisation des N classes (hauteur t = 7)
    threshold_height = 7
    #### BASIC DENDROGRAM
    ##dendrogram(LinkMatrix, labels=data.index.values.tolist(), orientation='top', color_threshold=threshold_height)
    ##plt.show()
    #### MY PLOTTER
    den = dendrogram(LinkMatrix, # Return a dictionnary representing the tree
                     labels=data.index.values.tolist(),
                     orientation='left',
                     color_threshold=threshold_height,
                     above_threshold_color='grey')
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
    plt.savefig(outfile + '.png', format='png', bbox_inches='tight') # PNG
    ##plt.savefig(outfile + '.jpg', format='jpg', bbox_inches='tight') # JPG
    ##### TRUNCATE
    ## method 1: lastp
    dendrogram(LinkMatrix, # You will have 4 leaf at the bottom of the plot
               truncate_mode = 'lastp',
               p=4)
    ## method 2: level
    dendrogram(LinkMatrix, # No more than p levels of dendrogram tree displayed
               truncate_mode = 'level',
               p=2)


    ## Decoupage a la hauteur t = 7 ==> identifiants de N groupes obtenus
    groupes_cah = fcluster(LinkMatrix, t=7, criterion='distance')
    #print(groupes_cah)

    ## Index tries des groupes
    idg = np.argsort(groupes_cah)

    ## Affichage des observations et leurs groupes
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
