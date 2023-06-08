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


def GenerateDBSCAN(filename, outfile="NULL", separator=";", XSize=10, YSize=9, dpi=300):
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

    labels_true = in_labels
    data = in_values

    ## Dimension des donnees
    #print("Data.Shape : " + str(data.shape) + "\n")

    ## Statistiques descriptives
    ##print("Data.Describe : " + str(data.describe) + "\n")
    print("Data.Describe() : ")
    print(in_data.describe())
    print("\n")


    ## PARAMETRES CLUSTERING DBSCAN :
    param_k = 19                     # (dimension * 2) - 1
    param_min_samples = param_k + 1  # k + 1 || Best to use is 4 for 2D
    param_eps = 0.45                 # 1st valley || Max curvature of NearestNeighbors

    ## k = (dimension * 2) - 1
    ## MinPts = k + 1
    ## eps = X du : 1ere vallee NearestNeighbors || point ou s'arrete le bruit
    ## Dissimilarity Simple :
    ## Nb Dimensions = Nb Cours en entree = 10 (fixe pour tous)
    ## Directe : param_k = 19  min_samples = 20  eps = 0.45
    ## S=M : param_k = 19  min_samples = 20  eps = 0.5
    ## S=B : param_k = 19  min_samples = 20  eps = 0.3
    ## S=H : param_k = 19  min_samples = 20  eps = 0.45

    ## Nb Dimensions = Nb Concepts Treillis (variable)
    ## Directe (203) : param_k = 405  min_samples = 404  eps =
    ## S=M (156) : param_k =   min_samples =   eps =
    ## S=B (91) : param_k =   min_samples =   eps =
    ## S=H (33) : param_k =   min_samples =   eps =

    ## Nb Dimensions = Nb Termes (variable)
    ## Directe (245) : param_k = 489  min_samples = 490  eps =
    ## S=M (244) : param_k =   min_samples =   eps =
    ## S=B (61) : param_k =   min_samples =   eps =
    ## S=H (61) : param_k =   min_samples =   eps =


    ## THEY WERE NOT USING METRIC="PRECOMPUTED" !!!
    ## METRIC="PRECOMPUTED" => INPUT MATRIX CONTAINS DISTANCES !!! AND NOT COORDINATES !!!
    ## Dissimilarity Simple [OBSOLETE] : min_samples=4
    ## Directe : eps=1.05 (1.5 ?)   S=M : eps=1.00
    ## S=B : eps=0.9    S=H : eps=1.00

    ## Dissimilarity Complex [OBSOLETE] : min_samples=4
    ## Directe : eps=1.4    S=M : eps=1.6 (1.7 ?)
    ## S=B : eps=1.12 (1.4 ?)    S=H : eps=1.45

    ## Similarity [OBSOLETE] : min_samples=4
    ## Directe : eps=1.25 (0.75 ?)     S=M : eps=1.0
    ## S=B : eps=0.9 (0.5 ? 0.4 ?)   S=H : eps=1.0 (0.8 ?)

    print("")
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    print("!!! PARAMETRE : K = " + str(param_k) + " !!!!!!")
    print("!!! PARAMETRE : EPS = " + str(param_eps) + " !!!!!!")
    print("!!! PARAMETRE : MIN_SAMPLES = " + str(param_min_samples) + " !!!!!!")
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    print("")



    ###### DBSCAN
    ## The DBSCAN algorithm views clusters as areas of high density separated by areas of
    ## low density. Due to this rather generic view, clusters found by DBSCAN can be any
    ## shape, as opposed to k-means which assumes that clusters are convex shaped.

    ## Search the optimal Epsilon (eps) :
    ##   best eps = 1st valley in NearestNeighbors ? Or point of max curvature ? (same ?)
    ##   metric="precomputed" => the matrix in input is already a distance matrix
    ## First, list the nearest neighbors
    neigh = NearestNeighbors(n_neighbors=param_k, metric="precomputed")
    nbrs = neigh.fit(data)
    distances, indices = nbrs.kneighbors(data)
    ## Sort and plot results
    distances = np.sort(distances, axis=0)
    distances = distances[:,1]

    ## New matplotlib figure
    plt.figure(1)
    ## Show the grid lines as dark grey lines
    plt.grid(b=True, which='major', color='#666666', linestyle='-')
    ## Plot the curves of distances
    plt.plot(distances)
    ## Save into a PNG
    plt.savefig('NearestNeighbors-DBSCAN-' + outfile + '.png', format='png', bbox_inches='tight') # PNG

    #data_test = StandardScaler().fit_transform(in_data)

    ### Compute DBSCAN
    ## eps = The maximum distance between 2 samples for one to be considered as in the
    ##       neighborhood of the other.
    ## min_samples = The number of samples (or total weight) in a neighborhood for a point
    ##               to be considered as a core point. This includes the point itself.
    ##         minPts must be chosen at least 3
    ##         Generally, MinPts should be greater than or equal to the dimensionality of
    ##         the data set
    ##         For 2-dimensional data, use DBSCAN’s default value of MinPts = 4 (Ester et
    ##         al., 1996).
    ##         As a rule of thumb, minPts = 2 * dim can be used, where dim = the
    ##         dimensions of your data set (Sander et al., 1998)
    ##         but it may be necessary to choose larger values for very large data,
    ##         noisy data, ...
    ## metric = "precomputed" : distances are already calculated (distance matrix in input)
    ## Higher min_samples or lower eps indicate higher density necessary to form a cluster
    db = DBSCAN(eps=param_eps, min_samples=param_min_samples, metric="precomputed")

    ## Apprentissage
    out_data = db.fit(data)

    ## Get DBSCAN data
    core_samples_mask = np.zeros_like(db.labels_, dtype=bool)
    core_samples_mask[db.core_sample_indices_] = True
    labels = db.labels_

    ## Number of clusters in labels, ignoring noise if present.
    n_clusters_ = len(set(labels)) - (1 if -1 in labels else 0)
    n_noise_ = list(labels).count(-1)

    print('Estimated number of clusters: %d' % n_clusters_)
    print('Estimated number of noise points: %d' % n_noise_)
    print("Homogeneity: %0.3f" % metrics.homogeneity_score(labels_true, labels))
    print("Completeness: %0.3f" % metrics.completeness_score(labels_true, labels))
    print("V-measure: %0.3f" % metrics.v_measure_score(labels_true, labels))
    print("Adjusted Rand Index: %0.3f"
          % metrics.adjusted_rand_score(labels_true, labels))
    print("Adjusted Mutual Information: %0.3f"
          % metrics.adjusted_mutual_info_score(labels_true, labels))
    #print("Silhouette Coefficient: %0.3f"
    #      % metrics.silhouette_score(data, labels))
    #### BUUUUG HEEEERE : ValueError: Number of labels is 1. Valid values are 2 to n_samples - 1 (inclusive)


    # #############################################################################
    # Print result

    ## Prepare structures
    nb_clusters = n_clusters_ + 1
    cluster_list = []
    for i in range(nb_clusters):
        cluster_list.append([])

    ## List of values : each point (index/labels_true[index]) is in a cluster (value)
    ## value "-1" means it's noise, other is a cluster
    print("## Liste d'appartenance des valeurs aux clusters (-1 = noise)")
    for index, value in enumerate(labels):
        print("[" + str(index) + " " + in_labels[index] + "] : " + str(value))
        ## Avoid "-1" as key, as in python it makes it go to the last cell...
        cluster_list[value + 1].append(index)
    print("")

    ## Gather clusters
    print("## Clusters (0 = noise)")
    for cluster in range(len(cluster_list)):
        if (cluster == 0):
            print('cluster: ', cluster, " (noise)")
        else:
            print('cluster: ', cluster)
        ## Cluster "0" is noise ("-1" in DBSCAN)
        for elt in range(len(cluster_list[cluster])):
            index = cluster_list[cluster][elt]
            print("-- ", in_labels[index])
    print("")

    ## Print in a file
    print("## Clusters CSV (0 = noise)")
    CSV_OUT_filename = 'Clusters-DBSCAN-' + outfile + '.csv'
    print("File : " + CSV_OUT_filename)
    CSV_OUT = open(CSV_OUT_filename, "w")
    OFS = ";"
    for cluster in range(len(cluster_list)):
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


    # #############################################################################
    # Plot result
    plt.figure(2)

    # Black removed and is used for noise instead:
    unique_labels = set(labels)
    colors = [plt.cm.Spectral(each)
              for each in np.linspace(0, 1, len(unique_labels))]
    for k, col in zip(unique_labels, colors):
        if k == -1:
            # Black used for noise.
            col = [0, 0, 0, 1]

        class_member_mask = (labels == k)

        xy = data[class_member_mask & core_samples_mask]
        plt.plot(xy[:, 0], xy[:, 1], 'o', markerfacecolor=tuple(col),
                 markeredgecolor='k', markersize=14)

        xy = data[class_member_mask & ~core_samples_mask]
        plt.plot(xy[:, 0], xy[:, 1], 'o', markerfacecolor=tuple(col),
                 markeredgecolor='k', markersize=6)

    plt.title("DBSCAN (Automatic Clustering)\n"
              + "Epsilon [" + str(param_eps)
              + "]  Min_samples [" + str(param_min_samples)
              + "]\nNb Clusters : " + str(n_clusters_)
              + "  Noise : " + str(n_noise_)
              )
    #plt.show()
    plt.savefig('DBSCAN-' + outfile + '.png', format='png', bbox_inches='tight') # PNG
    #plt.savefig(outfile + '.jpg', format='jpg', bbox_inches='tight') # JPG


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
    GenerateDBSCAN(sys.argv[1])
def ThreeArgs():
    GenerateDBSCAN(sys.argv[1], sys.argv[2])
def FourArgs():
    GenerateDBSCAN(sys.argv[1], sys.argv[2], sys.argv[3])
def FiveArgs():
    GenerateDBSCAN(sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]))
def SixArgs():
    GenerateDBSCAN(sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]), int(sys.argv[5]))
def SevenArgs():
    GenerateDBSCAN(sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]), int(sys.argv[5]), int(sys.argv[6]))

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
