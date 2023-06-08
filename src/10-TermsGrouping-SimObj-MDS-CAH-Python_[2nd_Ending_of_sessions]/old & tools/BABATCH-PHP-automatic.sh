#! /bin/sh


################ NO-BN
# Automatiques
python3.6 \
    src/Similar.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=B-B\=0.00_SimObj-NO-BN.csv

python3.6 \
    src/Similar.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-NO-BN.csv

python3.6 \
    src/Similar.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=M-B\=1.00_SimObj-NO-BN.csv

python3.6 \
    src/CAH-Dendrogramme-maxclust.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=B-B\=0.00_SimObj-NO-BN.csv

python3.6 \
    src/CAH-Dendrogramme-maxclust.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-NO-BN.csv

python3.6 \
    src/CAH-Dendrogramme-maxclust.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=M-B\=1.00_SimObj-NO-BN.csv

python3.6 \
    src/MDS-MultiDimensionalScaling-Dissimilarities.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=B-B\=0.00_SimObj-NO-BN.csv

python3.6 \
    src/MDS-MultiDimensionalScaling-Dissimilarities.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-NO-BN.csv

python3.6 \
    src/MDS-MultiDimensionalScaling-Dissimilarities.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=M-B\=1.00_SimObj-NO-BN.csv

python3.6 \
    src/MDS+K-Means-Dissimiliarities.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=B-B\=0.00_SimObj-NO-BN.csv

python3.6 \
    src/MDS+K-Means-Dissimiliarities.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-NO-BN.csv

python3.6 \
    src/MDS+K-Means-Dissimiliarities.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=M-B\=1.00_SimObj-NO-BN.csv

python3.6 \
    src/MDS+OPTICS.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=B-B\=0.00_SimObj-NO-BN.csv

python3.6 \
    src/MDS+OPTICS.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-NO-BN.csv

python3.6 \
    src/MDS+OPTICS.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=M-B\=1.00_SimObj-NO-BN.csv

# Manuels
python3.6 \
    src/MDS+DBSCAN.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=B-B\=0.00_SimObj-NO-BN.csv

python3.6 \
    src/MDS+DBSCAN.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-NO-BN.csv

python3.6 \
    src/MDS+DBSCAN.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=M-B\=1.00_SimObj-NO-BN.csv

python3.6 \
    src/CAH-Dendrogramme-distance.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=B-B\=0.00_SimObj-NO-BN.csv

python3.6 \
    src/CAH-Dendrogramme-distance.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-NO-BN.csv

python3.6 \
    src/CAH-Dendrogramme-distance.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=M-B\=1.00_SimObj-NO-BN.csv


################ BN
# Automatiques
python3.6 \
    src/Similar.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=B-B\=0.00_SimObj-BN.csv

python3.6 \
    src/Similar.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-BN.csv

python3.6 \
    src/Similar.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=M-B\=1.00_SimObj-BN.csv

python3.6 \
    src/CAH-Dendrogramme-maxclust.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=B-B\=0.00_SimObj-BN.csv

python3.6 \
    src/CAH-Dendrogramme-maxclust.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-BN.csv

python3.6 \
    src/CAH-Dendrogramme-maxclust.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=M-B\=1.00_SimObj-BN.csv

python3.6 \
    src/MDS-MultiDimensionalScaling-Dissimilarities.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=B-B\=0.00_SimObj-BN.csv

python3.6 \
    src/MDS-MultiDimensionalScaling-Dissimilarities.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-BN.csv

python3.6 \
    src/MDS-MultiDimensionalScaling-Dissimilarities.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=M-B\=1.00_SimObj-BN.csv

python3.6 \
    src/MDS+K-Means-Dissimiliarities.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=B-B\=0.00_SimObj-BN.csv

python3.6 \
    src/MDS+K-Means-Dissimiliarities.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-BN.csv

python3.6 \
    src/MDS+K-Means-Dissimiliarities.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=M-B\=1.00_SimObj-BN.csv

python3.6 \
    src/MDS+OPTICS.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=B-B\=0.00_SimObj-BN.csv

python3.6 \
    src/MDS+OPTICS.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-BN.csv

python3.6 \
    src/MDS+OPTICS.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=M-B\=1.00_SimObj-BN.csv

# Manuels
python3.6 \
    src/MDS+DBSCAN.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=B-B\=0.00_SimObj-BN.csv

python3.6 \
    src/MDS+DBSCAN.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-BN.csv

python3.6 \
    src/MDS+DBSCAN.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=M-B\=1.00_SimObj-BN.csv

python3.6 \
    src/CAH-Dendrogramme-distance.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=B-B\=0.00_SimObj-BN.csv

python3.6 \
    src/CAH-Dendrogramme-distance.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-BN.csv

python3.6 \
    src/CAH-Dendrogramme-distance.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=M-B\=1.00_SimObj-BN.csv
