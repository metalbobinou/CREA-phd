#! /bin/sh

DIR=PHP-automatic

## generic

## BN dirs
mkdir -p "./${DIR}/CAH-distance-BN"
mkdir -p "./${DIR}/CAH-maxclust-BN"
mkdir -p "./${DIR}/MDS+DBSCAN-BN"
mkdir -p "./${DIR}/MDS+OPTICS-BN"
mkdir -p "./${DIR}/MDS+K-Means-BN"
mkdir -p "./${DIR}/Similarity-BN"

## NO-BN dirs
mkdir -p "./${DIR}/CAH-distance-NO-BN"
mkdir -p "./${DIR}/CAH-maxclust-NO-BN"
mkdir -p "./${DIR}/MDS+DBSCAN-NO-BN"
mkdir -p "./${DIR}/MDS+OPTICS-NO-BN"
mkdir -p "./${DIR}/MDS+K-Means-NO-BN"
mkdir -p "./${DIR}/Similarity-NO-BN"

## Generic
mkdir -p "./${DIR}/MDS"
mkdir -p "./${DIR}/Clusters-DB"
touch "./${DIR}/Parametres.txt"
