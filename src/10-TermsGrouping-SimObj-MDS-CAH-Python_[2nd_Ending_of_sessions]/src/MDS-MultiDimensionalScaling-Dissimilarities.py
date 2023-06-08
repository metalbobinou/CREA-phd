import os
import sys

## Lib pour lecture données
import pandas

## Lib usages multiples...
import numpy

## Lib pour MDS
from sklearn import manifold
from sklearn.metrics import euclidean_distances

## Lib plotting
import matplotlib.pyplot as plt


def BuildOutputName(filename):
    InBaseName = os.path.basename(filename)
    OutName = "MDS-" + InBaseName
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

    ##  Nous indiquons le nombre de composantes (n_components = 2), (2D)
    ##  le type de matrice en entrée (dissimilarity = ‘precomputed’ ;
    ##   nous présentons à l’algorithme une matrice de distances ou de
    ##   dissimilarités), ('precomputed' : distances déjà calculées)
    ##  (random_state = 1) rend l’expérimentation reproductible
    mds = manifold.MDS(n_components=2, random_state=1, dissimilarity="precomputed")
    #mds = manifold.MDS(n_components=2, random_state=1, dissimilarity="euclidean")
    #mds = manifold.MDS(random_state=1, dissimilarity="precomputed")

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


    ## Définir la taille du graphique
    ax = plt.axes([0,0,2,2])
    ## Ajuster le ratio abscisse - ordonnée
    ax.set_aspect(aspect='equal')
    ## Placer les points dans le plan (abscisse, ordonnée)
    plt.scatter(points[:,0], points[:,1], color='silver', s=150)
    ## Ajouter les étiquettes dans le graphique
    for i in range(data.shape[0]):
        ax.annotate(data.index[i], (points[i,0], points[i,1]), color='blue')

    #plt.show() # Open display and show at screen
    plt.savefig(outfile + '.png', format='png', bbox_inches='tight') # PNG
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
