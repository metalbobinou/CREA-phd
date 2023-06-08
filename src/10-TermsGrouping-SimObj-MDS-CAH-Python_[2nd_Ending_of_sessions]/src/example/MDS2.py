import numpy as np
from sklearn.datasets import load_iris
import matplotlib.pyplot as plt
from sklearn.manifold import MDS
from sklearn.preprocessing import MinMaxScaler

# Load Iris dataset
data = load_iris()
X = data.data

# 0-1 scaler
scaler = MinMaxScaler()
X_scaled = scaler.fit_transform(X)

# MDS for a 2-dimensional dataset
# (The random_state is set in order to make every plot reproducible)
mds = MDS(2,random_state=0)
X_2d = mds.fit_transform(X_scaled)

# Graphical plot
colors = ['red','green','blue']
plt.rcParams['figure.figsize'] = [7, 7]
plt.rc('font', size=14)
for i in np.unique(data.target):
  subset = X_2d[data.target == i]

  x = [row[0] for row in subset]
  y = [row[1] for row in subset]
plt.scatter(x,y,c=colors[i],label=data.target_names[i])
plt.legend()
plt.show()
