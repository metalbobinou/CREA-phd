## Lib pour lecture données
import pandas

## Lib pour MDS
from sklearn import manifold

## Lib plotting
import matplotlib.pyplot as plt


filename = "SimTest3.csv"

## Charger les données
# D = pandas.read_excel(filename, sheet_name=0, header=0, index_col=0)
D = pandas.read_table(filename, ";", header=0, index_col=0)

## Vérifications des colonnes
print(D.info())

## Index des lignes
print(D.index)

## MDS
##  Nous indiquons le nombre de composantes (n_components = 2),
##  le type de matrice en entrée (dissimilarity = ‘precomputed’ ; nous
##   présentons à l’algorithme une matrice de distances ou de dissimilarités),
##  (random_state = 1) rend l’expérimentation reproductible
mds = manifold.MDS(n_components=2,random_state=1,dissimilarity="precomputed")

## Apprentissage
mds.fit(D)


## Coordonnées des points dans le plan puisque (n_components = 2)
points = mds.embedding_
print(points)

## Définir la taille du graphique
ax = plt.axes([0,0,2,2])
## Ajuster le ratio abscisse - ordonnée
ax.set_aspect(aspect='equal')
## Placer les points dans le plan (abscisse, ordonnée)
plt.scatter(points[:,0],points[:,1],color='silver',s=150)
## Ajouter les étiquettes dans le graphique
for i in range(D.shape[0]):
    ax.annotate(D.index[i], (points[i,0], points[i,1]), color='black')



## Affichage OU Sauvegarde image
outfile = "out"
#plt.show() # Open display and show at screen
plt.savefig(outfile + '.png', format='png', bbox_inches='tight') # PNG
#plt.savefig(outfile + '.jpg', format='jpg', bbox_inches='tight') # JPG
