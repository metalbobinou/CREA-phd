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

# Spatial distance
from scipy.spatial.distance import pdist

# CAH import
from scipy.cluster.hierarchy import dendrogram, linkage, fcluster
# CAH - inconsistent - useless here in maxcluster
from scipy.cluster.hierarchy import inconsistent
# CAH - Cophenetic correlation
from scipy.cluster.hierarchy import cophenet

# index tries
import numpy as np

## Draw a nice dendrogram
## Usage:
##fancy_dendrogram(
##    data_LinkMatrix,
##    truncate_mode='lastp',
##    p=12,
##    leaf_rotation=90.,
##    leaf_font_size=12.,
##    show_contracted=True,
##    annotate_above=10,  # useful in small plots so annotations don't overlap
##)
##plt.show()
##
## OR
##plt.figure(figsize=(10,10))
##fancy_dendrogram(
##    Z2,
##    truncate_mode='lastp',
##    p=30,
##    leaf_rotation=90.,
##    leaf_font_size=12.,
##    show_contracted=True,
##    annotate_above=40,
##    max_d=170, # plot a horizontal cut-off line
##)
##plt.show()
def fancy_dendrogram(*args, **kwargs):
    max_d = kwargs.pop('max_d', None)
    if max_d and 'color_threshold' not in kwargs:
        kwargs['color_threshold'] = max_d
    annotate_above = kwargs.pop('annotate_above', 0)

    ddata = dendrogram(*args, **kwargs)

    if not kwargs.get('no_plot', False):
        plt.title('Hierarchical Clustering Dendrogram (truncated)')
        plt.xlabel('sample index or (cluster size)')
        plt.ylabel('distance')
        for i, d, c in zip(ddata['icoord'], ddata['dcoord'], ddata['color_list']):
            x = 0.5 * sum(i[1:3])
            y = d[1]
            if y > annotate_above:
                plt.plot(x, y, 'o', c=c)
                plt.annotate("%.3g" % y, (x, y), xytext=(0, -5),
                             textcoords='offset points',
                             va='top', ha='center')
        if max_d:
            plt.axhline(y=max_d, c='k')
    return ddata

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

    ## Choix de la taille à indiquer sur le graphique : 7
    threshold_height = 7

    ###### DENDROGRAMME / CAH #####
    ## 0) Centrage-reduction des variables (calcul des centroides)
    ## 1) Creation de matrice de liens
    ## 2) Calcul "Cophenetic correlation"
    ## 3) Détection du nombre idéal de clusters
    ## 4) Affichage du dendrogramme (directement dans matplotlib)

    ## 0) Centrage-reduction des variables (calcul des centroides)
    data_CR = preprocessing.scale(data)

    ## 1) Creation de matrice de liens
    ## Algos possibles : maximum, minimum, mean, centroid, ward (prefered)
    data_LinkMatrix = linkage(data_CR, method='ward', metric='euclidean')

    ## Autre façon de créer une matrice de liens :
    ## data_LinkMatrix = ward(pdist(data))

    ## 2) Calcul "Cophenetic correlation"
    #orign_dists = fc.pdist(data_CR) # Matrix of original distances
    #cophe_dists = cophenet(data_LinkMatrix) # Matrix of cophenetic distances
    #corr_coef = np.corrcoef(in_data, cophe_dists)[0,1]

    corr_coef, coph_dists = cophenet(data_LinkMatrix, pdist(data_CR))

    print("Cophenetic Correlation:")
    print(corr_coef)
    print("")

    ## Choix du nombre de clusters
    nb_clusters = 8

    ## Matrice d'inconsistence & profondeur max
    ## the maximum depth to perform the inconsistency calculation
    depth = threshold_height # 5 ?
    print("Inconsistent Matrix :")
    print("avg, std, count, inconsistency")
    incons = inconsistent(data_LinkMatrix, depth)
    incons[-10:]
    print("")
    ## the threshold to apply when forming flat clusters
    incons_threshold = 8


    ## 4) Affichage du dendrogramme (directement dans matplotlib)

    ## 4.1) Preparation matplotlib
    plt.figure(1)
    plt.figure(figsize=(XSize,YSize), dpi=dpi) # Size of the figure [x,y]
    ##plt.figure(dpi=200)
    plt.title("CAH fcluster 'maxclust' (maxclust ["
              + str(nb_clusters)
              + "] decoupage à "
              + str(threshold_height)
              + ")")

    ## 4.2) Affichage dendrogramme dans matplotlib (index des donnees d'origine)
    dendrogram(data_LinkMatrix,
               labels=data.index,
               orientation='left',
               color_threshold=0)

    ## 4.3) Sauvegarde de la sortie

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
    plt.savefig('CAH-MaxClust-8-' + outfile + '.png', format='png', bbox_inches='tight') # PNG
    ##plt.savefig('CAH-' + outfile + '.jpg', format='jpg', bbox_inches='tight') # JPG


    ## Création des clusters selon le critère
    print("Groupes CAH")

    ## fcluster : flatten the dendrogram, obtaining as a result an assignation of
    ##            the original data points to single clusters

    ## criterion: The criterion to use in forming flat clusters
    ## - inconsistent (default): If a cluster node and all its descendants have an
    ##  inconsistent value less than or equal to t, then all its leaf descendants belong
    ##  to the same flat cluster. When no non-singleton cluster meets this criterion,
    ##  every node is assigned to its own cluster
    ## - distance: Forms flat clusters so that the original observations in each flat
    ##  cluster have no greater a cophenetic distance than t.
    ## - maxclust: Finds a minimum threshold r so that the cophenetic distance between
    ##  any two original observations in the same flat cluster is no more than r and no
    ##  more than t flat clusters are formed.
    ## - monocrit: Forms a flat cluster from a cluster node c with index i when
    ##  monocrit[j] <= t.
    ## - maxclust_monocrit: Forms a flat cluster from a non-singleton cluster node c when
    ##  monocrit[i] <= r for all cluster indices i below and including c. r is minimized
    ##  such that no more than t flat clusters are formed. monocrit must be monotonic.

    ## t + criterion="distance" => découpage lié à hauteur max sans lien dans dendrogramme
    ##    Official doc : distance threshold t - the maximum inter-cluster distance allowed
    #groupes_cah = fcluster(data_LinkMatrix, t=max_distance, criterion='distance')
    ##
    ## t + criterion="maxclust" => découpage pour K clusters max
    #groupes_cah = fcluster(data_LinkMatrix, t=k_nb_clusters, criterion='maxclust')
    ##
    ## t + criterion="inconsistent" => inconsistent threshold require to form a cluster
    #groupes_cah = fcluster(data_LinkMatrix, t=threshold, criterion='inconsistent')

    groupes_cah = fcluster(data_LinkMatrix, t=nb_clusters, criterion='maxclust')
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
    CSV_OUT_filename = 'Clusters-CAH-MaxClust-8-' + outfile + '.csv'
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
