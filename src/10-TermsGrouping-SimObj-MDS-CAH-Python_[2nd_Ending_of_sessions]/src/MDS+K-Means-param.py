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


def GenerateMDSandKMeansparameter(filename, NBClusters):
    outfile="NULL"
    separator=";"
    XSize=10
    YSize=9
    dpi=300

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


    ## NB CLUSTERS FIXE A 8 EN DUR

    ## K-Means
    nb_clusters = NBClusters
    print("K-Means : [nb_clusters = " + str(nb_clusters) + "]")
    km = KMeans(n_clusters=nb_clusters, random_state=1)

    ## Modélisation
    km.fit(points)
    print("")

    ## Barycentres
    print("K-Means : Barycentres")
    print(km.cluster_centers_)
    print("")

    #graphique avec les barycentres
    plt.figure(1)
    ax = plt.axes([0,0,2,2])
    ax.set_aspect(aspect='equal')
    plt.scatter(points[:,0], points[:,1], color='silver',s=100)
    plt.scatter(km.cluster_centers_[:,0], km.cluster_centers_[:,1], color='blue', s=150)
    ## Ajouter les étiquettes dans le graphique
    #for i in range(data.shape[0]):
    #    ax.annotate(data.index[i], (points[i,0], points[i,1]), color='blue')
    #plt.show()
    plt.savefig('Barycentres-MDS+K-Means-' + str(NBClusters) + '-' + outfile + '.png', format='png', bbox_inches='tight') # PNG
    #plt.savefig(outfile + '.jpg', format='jpg', bbox_inches='tight') # JPG


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
    CSV_OUT_filename = 'Clusters-MDS+K-Means-' + str(NBClusters) + '-' + outfile + '.csv'
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


    ## Couleurs pour groupes d'appartenance
    cnames = { 'aliceblue':            '#F0F8FF',
    'antiquewhite':         '#FAEBD7', 'aqua':                 '#00FFFF',
    'aquamarine':           '#7FFFD4', 'azure':                '#F0FFFF',
    'beige':                '#F5F5DC', 'bisque':               '#FFE4C4',
    'black':                '#000000', 'blanchedalmond':       '#FFEBCD',
    'blue':                 '#0000FF', 'blueviolet':           '#8A2BE2',
    'brown':                '#A52A2A', 'burlywood':            '#DEB887',
    'cadetblue':            '#5F9EA0', 'chartreuse':           '#7FFF00',
    'chocolate':            '#D2691E', 'coral':                '#FF7F50',
    'cornflowerblue':       '#6495ED', 'cornsilk':             '#FFF8DC',
'crimson':              '#DC143C', 'cyan':                 '#00FFFF',
'darkblue':             '#00008B', 'darkcyan':             '#008B8B',
'darkgoldenrod':        '#B8860B', 'darkgray':             '#A9A9A9',
'darkgreen':            '#006400', 'darkkhaki':            '#BDB76B',
'darkmagenta':          '#8B008B', 'darkolivegreen':       '#556B2F',
'darkorange':           '#FF8C00', 'darkorchid':           '#9932CC',
'darkred':              '#8B0000', 'darksalmon':           '#E9967A',
'darkseagreen':         '#8FBC8F', 'darkslateblue':        '#483D8B',
'darkslategray':        '#2F4F4F', 'darkturquoise':        '#00CED1',
'darkviolet':           '#9400D3', 'deeppink':             '#FF1493',
'deepskyblue':          '#00BFFF', 'dimgray':              '#696969',
'dodgerblue':           '#1E90FF', 'firebrick':            '#B22222',
'floralwhite':          '#FFFAF0', 'forestgreen':          '#228B22',
'fuchsia':              '#FF00FF', 'gainsboro':            '#DCDCDC',
'ghostwhite':           '#F8F8FF', 'gold':                 '#FFD700',
'goldenrod':            '#DAA520', 'gray':                 '#808080',
'green':                '#008000', 'greenyellow':          '#ADFF2F',
'honeydew':             '#F0FFF0', 'hotpink':              '#FF69B4',
'indianred':            '#CD5C5C', 'indigo':               '#4B0082',
'ivory':                '#FFFFF0', 'khaki':                '#F0E68C',
'lavender':             '#E6E6FA', 'lavenderblush':        '#FFF0F5',
'lawngreen':            '#7CFC00', 'lemonchiffon':         '#FFFACD',
'lightblue':            '#ADD8E6', 'lightcoral':           '#F08080',
'lightcyan':            '#E0FFFF', 'lightgoldenrodyellow': '#FAFAD2',
'lightgreen':           '#90EE90', 'lightgray':            '#D3D3D3',
'lightpink':            '#FFB6C1', 'lightsalmon':          '#FFA07A',
'lightseagreen':        '#20B2AA', 'lightskyblue':         '#87CEFA',
'lightslategray':       '#778899', 'lightsteelblue':       '#B0C4DE',
'lightyellow':          '#FFFFE0', 'lime':                 '#00FF00',
'limegreen':            '#32CD32', 'linen':                '#FAF0E6',
'magenta':              '#FF00FF', 'maroon':               '#800000',
'mediumaquamarine':     '#66CDAA', 'mediumblue':           '#0000CD',
'mediumorchid':         '#BA55D3', 'mediumpurple':         '#9370DB',
'mediumseagreen':       '#3CB371', 'mediumslateblue':      '#7B68EE',
'mediumspringgreen':    '#00FA9A', 'mediumturquoise':      '#48D1CC',
'mediumvioletred':      '#C71585', 'midnightblue':         '#191970',
'mintcream':            '#F5FFFA', 'mistyrose':            '#FFE4E1',
'moccasin':             '#FFE4B5', 'navajowhite':          '#FFDEAD',
'navy':                 '#000080', 'oldlace':              '#FDF5E6',
'olive':                '#808000', 'olivedrab':            '#6B8E23',
'orange':               '#FFA500', 'orangered':            '#FF4500',
'orchid':               '#DA70D6', 'palegoldenrod':        '#EEE8AA',
'palegreen':            '#98FB98', 'paleturquoise':        '#AFEEEE',
'palevioletred':        '#DB7093', 'papayawhip':           '#FFEFD5',
'peachpuff':            '#FFDAB9', 'peru':                 '#CD853F',
'pink':                 '#FFC0CB', 'plum':                 '#DDA0DD',
'powderblue':           '#B0E0E6', 'purple':               '#800080',
'red':                  '#FF0000', 'rosybrown':            '#BC8F8F',
'royalblue':            '#4169E1', 'saddlebrown':          '#8B4513',
'salmon':               '#FA8072', 'sandybrown':           '#FAA460',
'seagreen':             '#2E8B57', 'seashell':             '#FFF5EE',
'sienna':               '#A0522D', 'silver':               '#C0C0C0',
'skyblue':              '#87CEEB', 'slateblue':            '#6A5ACD',
'slategray':            '#708090', 'snow':                 '#FFFAFA',
'springgreen':          '#00FF7F', 'steelblue':            '#4682B4',
'tan':                  '#D2B48C', 'teal':                 '#008080',
'thistle':              '#D8BFD8', 'tomato':               '#FF6347',
'turquoise':            '#40E0D0', 'violet':               '#EE82EE',
'wheat':                '#F5DEB3', 'white':                '#FFFFFF',
'whitesmoke':           '#F5F5F5', 'yellow':               '#FFFF00',
    'yellowgreen':          '#9ACD32' }

    #couleurs_toutes = list(cnames.values()) # #9ACD32
    couleurs_toutes = list(cnames) # yellowgreen

    #couleurs_groupes = numpy.array(
    #    ['turquoise','violet','goldenrod','lightsalmon'])[km.labels_]

    couleurs_groupes = numpy.array(list(couleurs_toutes[:nb_clusters]))[km.labels_]

    #graphique avec les couleurs pour les groupes
    plt.figure(2)
    ax = plt.axes([0,0,2,2])
    ax.set_aspect(aspect='equal')
    plt.scatter(points[:,0],points[:,1], color=couleurs_groupes, s=150)
    for i in range(data.shape[0]):
        ax.annotate(data.index[i], (points[i,0], points[i,1]), color='black')
    #plt.show()
    plt.savefig('Clusters-MDS+K-Means-' + str(NBClusters) + '-' + outfile + '.png', format='png', bbox_inches='tight')
    #plt.savefig(outfile + '.jpg', format='jpg', bbox_inches='tight') # JPG


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

    ## Graphique avec les couleurs pour les groupes et les segments des amis
    plt.figure(4)
    ax = plt.axes([0,0,2,2])
    ax.set_aspect(aspect='equal')
    plt.scatter(points[:,0], points[:,1], color=couleurs_groupes, s=150)
    for i in range(data.shape[0]):
        ax.annotate(data.index[i], (points[i,0], points[i,1]), color='black')
        ax.add_collection(lc)
    #plt.show()
    plt.savefig('Liens-Amis-MDS+K-Means-' + str(NBClusters) + '-' + outfile + '.png', format='png', bbox_inches='tight') # PNG
    #plt.savefig(outfile + '.jpg', format='jpg', bbox_inches='tight') # JPG


###########################

###### SWITCH CASE FOR ARGS
####
# METHOD 1 : (do not manage "default")
# PREPARE CASES FIRST :
def ZeroArg():
    printHelp()
def OneArg():
    printHelp()
def TwoArgs():
    printHelp()
def ThreeArgs():
    GenerateMDSandKMeansparameter(sys.argv[1], int(sys.argv[2]))

# PREPARE SWITCH
ArgsMgmt = { 0 : ZeroArg,
             1 : OneArg,
             2 : TwoArgs,
             3 : ThreeArgs,
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
    print("Error: Too few or too much parameters given (expected 2)")
    print("Format of parameter : ")
    print(sys.argv[0] + " filename NbClusters")

# sys.argv[0] : python script name
# sys.argv[1] : 1st arg
# sys.argv[2] : 2nd arg

def main():
    NBArgs = len(sys.argv);
#    print("NB Args : " + str(NBArgs))
#    for arg in sys.argv:
#        print(arg)
#        TransposeCSV(arg)

    if ((NBArgs > 0) and (NBArgs <= max(ArgsMgmt))):
        ArgsMgmt[NBArgs]()
    else:
        printHelp()
        exit(-1)
    exit(0)

main()
