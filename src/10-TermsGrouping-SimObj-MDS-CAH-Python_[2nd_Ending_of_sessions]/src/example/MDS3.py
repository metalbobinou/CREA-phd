import pandas as pd
import numpy as np
from sklearn import manifold
import matplotlib.pyplot as plt

data = pd.read_csv("european_city_distances.csv", index_col='Cities')

mds = manifold.MDS(n_components=2, dissimilarity="precomputed", random_state=6)
results = mds.fit(data.values)

cities = data.columns
coords = results.embedding_

fig = plt.figure(figsize=(12,10))

plt.subplots_adjust(bottom = 0.1)
plt.scatter(coords[:, 0], coords[:, 1])

for label, x, y in zip(cities, coords[:, 0], coords[:, 1]):
    plt.annotate(
        label,
        xy = (x, y),
        xytext = (-20, 20),
        textcoords = 'offset points'
    )
plt.show()
