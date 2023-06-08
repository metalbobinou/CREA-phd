import os
import sys

## Lib pour lecture données
import pandas

## Lib usages multiples...
import numpy

## Lib pour MDS
from sklearn import manifold
from sklearn.metrics import euclidean_distances

## Lib pour K-Means
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score

## Lib plotting
import matplotlib.pyplot as plt
from matplotlib.collections import LineCollection


def BuildOutputName(filename):
    InBaseName = os.path.basename(filename)
    OutName = InBaseName
    return OutName


def GenerateMDS(filename, outfile="NULL", separator=";",
                XSize=10, YSize=9, dpi=300):
    if (outfile == "NULL"):
        outfile = BuildOutputName(filename)

    ## Charger les données
    # data = pandas.read_excel(filename, sheet_name=0, header=0, index_col=0)
    # data = pd.read_csv(filename, index_col='Terms')
    data = pandas.read_table(filename, ";", header=0, index_col=0)

    ## Vérifications des colonnes
    #print(data.info())
    ## Index des lignes
    #print(data.index)

    #######
    # MDS #
    #######
    print("#######")
    print("# MDS #")
    print("#######")
    print("")

    ##  Nous indiquons le nombre de composantes (n_components = 2), (2D)
    ##  le type de matrice en entrée (dissimilarity = ‘precomputed’ ;
    ##   nous présentons à l’algorithme une matrice de distances ou de
    ##   dissimilarités), ('precomputed' : distances déjà calculées)
    ##  (random_state = 1) rend l’expérimentation reproductible
    mds = manifold.MDS(n_components=2, random_state=1, dissimilarity="precomputed")
    #mds = manifold.MDS(n_components=2, random_state=1, dissimilarity="euclidean")

    ## Apprentissage
    mds.fit(data)

    ## Coordonnées des points dans le plan puisque (n_components = 2)
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
    stress = 0.5 * numpy.sum((DE - data.values)**2)
    print(stress)
    print("")

    ## Kruskal stress (ou stress formula 1)
    print("Stress de Kruskal :")
    print("[Mauvais > 0.2 > Correct > 0.1 > Bon > 0.05 > Excellent > 0.025 > Parfait > 0.0]")
    stress1 = numpy.sqrt(stress / (0.5 * numpy.sum(data.values**2)))
    print(stress1)
    print("")


    ###########
    # K-Means #
    ###########
    print("###########")
    print("# K-Means #")
    print("###########")


    ## Optimisation du nombre de clusters : maximisatin du coefficient silhouette
    print("## Optimisation du nombre de clusters : maximisatin du coefficient silhouette")
    print("")

    ## Calcul du coefficient silhouette (optimisation du nombre de clusters)

    ## Balayage des différentes valeurs de K
    # Nb minimum de clusters : 2
    min = 2
    # Nb maximum de clusters : nombre de valeurs
    #max = len(data.index) # Compte les NaN
    #max = data.shape[0] # Compte les NaN en lignes
    #max = data.shape[1] # Compte les NaN en colonnes
    #max = data[0].count() # Ne compte PAS les NaN
    max = len(data.columns) # Nb colonnes
    #max = len(data) # Nb lignes
    min = int(min)
    max = int(max)
    sil = numpy.zeros(max - 2) # max # 5
    for K in range(min, max): # max + 2 # 2 et 7 # min et max +2 (mais marche pas :( )
        kms = KMeans(n_clusters=K, random_state=1).fit(points)
        sil[K - 2] = silhouette_score(points, kms.labels_, metric='euclidean')
    #valeurs des silhouettes
    print(sil)

    ## Choix du meilleur coefficient silhouette
    print("Recherche du coefficient silhouette maximal / nombre de clusters optimal")
    #choix_sil = sil.deepcopy() # Copie liste
    choix_sil = list(sil)
    # choix_sil.sort(reverse=True) # Tri par ordre décroissant => SURTOUT PAS
    ## On cherche le plus gros coefficient silhouette, et le nombre de clusters associé
    tmp_nb_clusters = min
    biggest_nb_clusters = min
    biggest_coeff_sil = 0
    for i in choix_sil:
        if (i > biggest_coeff_sil):
            biggest_coeff_sil = i
            biggest_nb_clusters = tmp_nb_clusters
        tmp_nb_clusters += 1
    print("Nombre optimal de clusters : " + str(biggest_nb_clusters) +
          " [coeff. sil. : " + str(biggest_coeff_sil) + "]")
    print("")


    ## K-Means
    nb_clusters = biggest_nb_clusters
    print("K-Means : [nb_clusters = " + str(nb_clusters) + "]")
    km = KMeans(n_clusters=nb_clusters, random_state=1)

    ## Modélisation
    km.fit(points)
    print("")

    ## Barycentres
    print("K-Means : Barycentres")
    print(km.cluster_centers_)
    print("")


    ## Groupe d'appartenance
    print("K-Means : Groupes d'appartenance")
    print(km.labels_)
    print("")

    print("K-Means : Mes groupes d'appartenance (Pretty Print)")

    ## AWEFUL PRINT
    #print("K-Means : Mes groupes d'appartenance (1)")
    #columns_list = data.columns.values.tolist()
    #clusters_list = km.labels_
    #for i in range(0, (nb_clusters - 1)):
    #    cur_column = columns_list[i] # Label
    #    cur_cluster = clusters_list[i] # Cluster
    #    print(str(i) + " : " + str(km.labels_[i]) + " [" + columns_list[i] + "]")
    #print("")

    ## Groupe d'appartenance OK pour CSV
    #print("K-Means : Mes groupes d'appartenance (2)")
    pred_classes = km.predict(points)
    labels = numpy.array(data.columns.values.tolist())
    for cluster in range(nb_clusters):
        print('cluster: ', cluster)
        print(labels[numpy.where(pred_classes == cluster)])
    print("")

    print("K-Means : Mes groupes d'appartenance (CSV)")
    CSV_OUT_filename = 'Clusters-MDS+K-Means-' + outfile + '.csv'
    print("File : " + CSV_OUT_filename)
    CSV_OUT = open(CSV_OUT_filename, "w")
    OFS = ";"
    pred_classes = km.predict(points)
    labels = numpy.array(data.columns.values.tolist())
    for cluster in range(nb_clusters):
        line = str(cluster)
        #print(str(cluster))
        for Value in labels[numpy.where(pred_classes == cluster)]:
            EachLabel = str.strip(Value)
            line = line + OFS + EachLabel
            #print(OFS + EachLabel)
        line = line + "\n"
        #print("\n")
        #print(line)
        CSV_OUT.write(line)
    CSV_OUT.close()
    print("")


    ## Individus proches (dissimilarité nulle) parfois dans communautés distinctes...
    ## Vérification du nombre !
    print("K-Means : Détection individus proches/liens amis")

    ## Lien entre amis
    segments = []

    ## Travailler sur la partie traingulaire de la matrice de dissimilarités
    for i in range(0, data.shape[0] - 1):
        for j in range(i + 1, data.shape[0]):
            ## uniquement si la distance est nulle
            if (data.iloc[i,j] == 0):
                segments.append([points[i,:], points[j,:]])

    ## Nombre de segments concernés
    print("Liens 'amis', nb segments concernés : ")
    print(len(segments))
    print("")

    ## 1er segment concerné
    if (len(segments) > 0):
        print("1er segment 'ami'")
        print(segments[0])
        print("")

    ## Collection de lignes
    lc = LineCollection(segments, color='lightgray')


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
    GenerateMDS(sys.argv[1])
def ThreeArgs():
    GenerateMDS(sys.argv[1], sys.argv[2])
def FourArgs():
    GenerateMDS(sys.argv[1], sys.argv[2], sys.argv[3])
def FiveArgs():
    GenerateMDS(sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]))
def SixArgs():
    GenerateMDS(sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]),
                int(sys.argv[5]))
def SevenArgs():
    GenerateMDS(sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]),
                int(sys.argv[5]), int(sys.argv[6]))

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



###########################

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
