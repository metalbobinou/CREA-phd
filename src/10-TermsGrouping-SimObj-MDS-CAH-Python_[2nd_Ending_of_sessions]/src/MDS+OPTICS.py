import os
import sys

import csv
#from itertools import izip

# Graphics
import pandas
# - scatter matrix
from pandas.plotting import scatter_matrix
# - grid
from matplotlib import gridspec as gridspec
# - general plotting
from matplotlib import pyplot as plt

# OPTICS
from sklearn.cluster import OPTICS, cluster_optics_dbscan

# DBSCAN & OPTICS precompute
from sklearn.neighbors import NearestNeighbors
from sklearn.preprocessing import StandardScaler

# Stats
from sklearn import metrics

## Lib pour MDS
from sklearn import manifold
from sklearn.metrics import euclidean_distances

# index tries
import numpy as np


## MANUAL SETTING OF MIN_SAMPLES (and others) !!!
## You must choose the best values of "min_samples", eventually of "xi" and
## "min_cluster_size"...
## Then, modify the values in the OPTICS and relaunch the code


def BuildOutputName(filename):
    InBaseName = os.path.basename(filename)
    #OutName = "CAH-" + InBaseName
    OutName = InBaseName
    return OutName


def GenerateOPTICS(filename, outfile="NULL", separator=";", XSize=10, YSize=9, dpi=300):
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


    ## PARAMETRES CLUSTERING OPTICS :
    param_k = 3             # (dimension * 2) - 1 || [Default at 2 in example]
    param_min_samples = param_k + 1   # k + 1 || Best to use is 4 for 2D (or 5 ?)
    #param_xi =
    #param_min_cluster_size =


    ## THEY WERE NOT USING METRIC="PRECOMPUTED" !!!
    ## METRIC="PRECOMPUTED" => INPUT MATRIX CONTAINS DISTANCES !!! AND NOT COORDINATES !!!
    ## Dissimilarity Simple [OBSOLETE] :
    ## Directe : min_samples=5    S=M : *
    ## S=B : *    S=H : *

    ## Dissimilarity Complex [OBSOLETE] :
    ## Directe :     S=M :
    ## S=B :     S=H :

    ## Similarity [OBSOLETE] :
    ## Directe : min_samples=5     S=M : *
    ## S=B : *   S=H : *

    print("")
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    print("!!! PARAMETRE : MIN_SAMPLES = " + str(param_min_samples) + " !!!!!!")
    if 'param_xi' in locals():
        print("!!! PARAMETRE : XI = " + str(param_xi) + "  !!!!!!")
    else:
        print("!!! PARAMETRE : XI = [unset]  !!!!!!")
    if 'param_min_cluster_size' in locals():
        print("!!! PARAMETRE : MIN_CLUSTER_SIZE = " + str(param_min_cluster_size) + "  !!!!!!")
    else:
        print("!!! PARAMETRE : MIN_CLUSTER_SIZE = [unset]  !!!!!!")
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    print("")



    #######
    # MDS #
    #######
    print("#######")
    print("# MDS #")
    print("#######")
    print("")

    ##  Nous indiquons le nombre de composantes (n_components = 2), (2D)
    ##  le type de matrice en entrée (dissimilarity = ‘precomputed’ ;
    ##   nous présentons à l’algorithme une matrice de distances ou de
    ##   dissimilarités), ('precomputed' : distances déjà calculées)
    ##  (random_state = 1) rend l’expérimentation reproductible
    mds = manifold.MDS(n_components=2, random_state=1, dissimilarity="precomputed")
    #mds = manifold.MDS(n_components=2, random_state=1, dissimilarity="euclidean")

    ## Apprentissage
    mds.fit(data)

    ## Coordonnées des points dans le plan puisque (n_components = 2)
    points = mds.embedding_
    print(points)
    print("")


    ##########################
    ## Stress : qualité du MDS

    ## Stress MDS de sklearn (inutile)
    print("Stress (sklearn - useless) :")
    print(mds.stress_)
    print("")

    ## Calculer les distances entre paires d'individus dans le plan
    #print("Distance entre individus :")
    DE = euclidean_distances(points)
    #print(DE.shape) # matrice (25, 25)
    ## Distances estimées entre paires d’individus : 5 premières lignes et colonnes
    #print(DE[0:5,0:5])

    ## Vérification du STRESS de MDS
    print("Stress sklearn refait à la main :")
    stress = 0.5 * np.sum((DE - in_data.values)**2)
    print(stress)
    print("")

    ## Kruskal stress (ou stress formula 1)
    print("Stress de Kruskal :")
    print("[Mauvais > 0.2 > Correct > 0.1 > Bon > 0.05 > Excellent > 0.025 > Parfait > 0.0]")
    stress1 = np.sqrt(stress / (0.5 * np.sum(in_data.values**2)))
    print(stress1)
    print("")



    ##########
    # OPTICS #
    ##########
    print("##########")
    print("# OPTICS #")
    print("##########")

    ###### OPTICS

    ## Search the optimal Epsilon (eps) :
    ##   best eps = point of maximum curvature in the k-nearest neighbors
    ## First, list the nearest neighbors
    neigh = NearestNeighbors(n_neighbors=param_k, metric="euclidean") # MDS => euclidean
    nbrs = neigh.fit(points) # data = init data ; points = MDS points
    distances, indices = nbrs.kneighbors(points) # data = init data ; points = MDS points
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
    plt.savefig('NearestNeighbors-MDS+OPTICS-' + outfile + '.png', format='png', bbox_inches='tight') # PNG

    #data_test = StandardScaler().fit_transform(in_data)

    ### Compute OPTICS
    ## Similar to DBSCAN
    ## min_samples: The number of samples in a neighborhood for a point to be considered
    ##    as a core point
    ##    (default = 5)
    ## max_eps: The maximum distance between two samples for one to be considered as in
    ##    the neighborhood of the other.
    ##    (default = np.inf)
    ## min_cluster_size: Minimum number of samples in an OPTICS cluster, expressed as an
    ##    absolute number or a fraction of the number of samples (rounded to be at least
    ##    2). If None, the value of min_samples is used instead.
    ##    !!! Used only when cluster_method='xi' !!!
    ##    (default = None) [int > 1, or float 0 < x < 1]
    ## xi: Determines the minimum steepness on the reachability plot that constitutes a
    ##    cluster boundary.
    ##    (default = 0.05)
    ## metric="precomputed" : the input matrix contains distances
    clust = OPTICS(min_samples=param_min_samples, metric="euclidean") # MDS => euclidean
    #clust = OPTICS(min_samples=param_min_samples, xi=param_xi)
    #clust = OPTICS(min_samples=param_min_samples, xi=param_xi, min_cluster_size=param_min_cluster_size)

    #clust = OPTICS(min_samples=5, xi=0.05, min_cluster_size=0.05)
    #clust = OPTICS(min_samples=50, xi=.05, min_cluster_size=.05)

    ## Run the fit
    clust.fit(points) # data = init data ; points = MDS points

    ## Statistiques & Clusters
    space = np.arange(len(points)) # data = init data ; points = MDS points
    reachability = clust.reachability_[clust.ordering_]
    labels = clust.labels_[clust.ordering_]


    ## DBSCAN (useless/for demo)
    ## EPS = 0.5
    labels_050 = cluster_optics_dbscan(reachability=clust.reachability_,
                                       core_distances=clust.core_distances_,
                                       ordering=clust.ordering_, eps=0.5)
    ## EPS = 2
    labels_200 = cluster_optics_dbscan(reachability=clust.reachability_,
                                       core_distances=clust.core_distances_,
                                       ordering=clust.ordering_, eps=2)

    ## Plot (for demo)

    if (False):
        plt.figure(1)
        plt.figure(figsize=(10, 7))
        G = gridspec.GridSpec(2, 3)
        ax1 = plt.subplot(G[0, :])
        ax2 = plt.subplot(G[1, 0])
        ax3 = plt.subplot(G[1, 1])
        ax4 = plt.subplot(G[1, 2])

        # Reachability plot
        colors = ['g.', 'r.', 'b.', 'y.', 'c.']
        for klass, color in zip(range(0, 5), colors):
            Xk = space[labels == klass]
            Rk = reachability[labels == klass]
            ax1.plot(Xk, Rk, color, alpha=0.3)
        ax1.plot(space[labels == -1], reachability[labels == -1], 'k.', alpha=0.3)
        ax1.plot(space, np.full_like(space, 2., dtype=float), 'k-', alpha=0.5)
        ax1.plot(space, np.full_like(space, 0.5, dtype=float), 'k-.', alpha=0.5)
        ax1.set_ylabel('Reachability (epsilon distance)')
        ax1.set_title('Reachability Plot')

        # OPTICS
        colors = ['g.', 'r.', 'b.', 'y.', 'c.']
        for klass, color in zip(range(0, 5), colors):
            Xk = points[clust.labels_ == klass]
            ax2.plot(Xk[:, 0], Xk[:, 1], color, alpha=0.3)
        ax2.plot(points[clust.labels_ == -1, 0],
                 points[clust.labels_ == -1, 1],
                 'k+', alpha=0.1)
        ax2.set_title('Automatic Clustering\nOPTICS')

        # DBSCAN at 0.5
        colors = ['g', 'greenyellow', 'olive', 'r', 'b', 'c']
        for klass, color in zip(range(0, 6), colors):
            Xk = points[labels_050 == klass]
            ax3.plot(Xk[:, 0], Xk[:, 1], color, alpha=0.3, marker='.')
        ax3.plot(points[labels_050 == -1, 0], points[labels_050 == -1, 1], 'k+', alpha=0.1)
        ax3.set_title('Clustering at 0.5 epsilon cut\nDBSCAN')

        # DBSCAN at 2.
        colors = ['g.', 'm.', 'y.', 'c.']
        for klass, color in zip(range(0, 4), colors):
            Xk = points[labels_200 == klass]
            ax4.plot(Xk[:, 0], Xk[:, 1], color, alpha=0.3)
        ax4.plot(points[labels_200 == -1, 0], points[labels_200 == -1, 1], 'k+', alpha=0.1)
        ax4.set_title('Clustering at 2.0 epsilon cut\nDBSCAN')

        plt.tight_layout()
        plt.savefig('MDS+OPTICS-demo-' + outfile + '.png', format='png', bbox_inches='tight') # PNG
        #plt.savefig('OPTICS-demo-' + outfile + '.jpg', format='jpg', bbox_inches='tight') # JPG

    ## End plot demo

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
    CSV_OUT_filename = 'Clusters-MDS+OPTICS-' + outfile + '.csv'
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

    # Choose colors (no black)
    unique_labels = set(labels)
    colors = [plt.cm.Spectral(each)
              for each in np.linspace(0, 1, len(unique_labels))]

    # OPTICS
    colors = ['g.', 'r.', 'b.', 'y.', 'c.']
    for klass, color in zip(range(0, 5), colors):
        Xk = points[clust.labels_ == klass]
        plt.plot(Xk[:, 0], Xk[:, 1], color, alpha=0.3)
    plt.plot(points[clust.labels_ == -1, 0],
             points[clust.labels_ == -1, 1],
             'k+', alpha=0.1)
    if 'param_xi' not in locals():
        param_xi = "unset"
    if 'param_min_cluster_size' not in locals():
        param_min_cluster_size = "unset"
    plt.title('MDS+OPTICS (Automatic Clustering)\n'
              + "min_samples [" + str(param_min_samples)
              + "]  xi [" + str(param_xi)
              + "]  min_cluster_size [" + str(param_min_cluster_size)
              + "]\n"
              + "Nb Clusters : " + str(n_clusters_)
              + "  Noise : " + str(n_noise_)
              )
    plt.savefig('MDS+OPTICS-' + outfile + '.png', format='png', bbox_inches='tight') # PNG
    #plt.savefig('OPTICS-' + outfile + '.jpg', format='jpg', bbox_inches='tight') # JPG


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
    GenerateOPTICS(sys.argv[1])
def ThreeArgs():
    GenerateOPTICS(sys.argv[1], sys.argv[2])
def FourArgs():
    GenerateOPTICS(sys.argv[1], sys.argv[2], sys.argv[3])
def FiveArgs():
    GenerateOPTICS(sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]))
def SixArgs():
    GenerateOPTICS(sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]), int(sys.argv[5]))
def SevenArgs():
    GenerateOPTICS(sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]), int(sys.argv[5]), int(sys.argv[6]))

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
