#! /bin/sh


################ NO-BN
# Automatiques
python3.6 \
    src/MDS-MultiDimensionalScaling-Dissimilarities.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-NO-BN.csv

python3.6 \
    src/MDS-MultiDimensionalScaling-Dissimilarities.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.25_SimObj-NO-BN.csv

python3.6 \
    src/MDS-MultiDimensionalScaling-Dissimilarities.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.50_SimObj-NO-BN.csv

python3.6 \
    src/MDS-MultiDimensionalScaling-Dissimilarities.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.75_SimObj-NO-BN.csv

python3.6 \
    src/MDS-MultiDimensionalScaling-Dissimilarities.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=1.00_SimObj-NO-BN.csv



python3.6 \
    src/CAH-Dendrogramme-maxclust.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-NO-BN.csv

python3.6 \
    src/CAH-Dendrogramme-maxclust.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.25_SimObj-NO-BN.csv

python3.6 \
    src/CAH-Dendrogramme-maxclust.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.50_SimObj-NO-BN.csv

python3.6 \
    src/CAH-Dendrogramme-maxclust.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.75_SimObj-NO-BN.csv

python3.6 \
    src/CAH-Dendrogramme-maxclust.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=1.00_SimObj-NO-BN.csv



python3.6 \
    src/CAH-Dendrogramme-maxclust-param.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-NO-BN.csv 8

python3.6 \
    src/CAH-Dendrogramme-maxclust-param.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.25_SimObj-NO-BN.csv 8

python3.6 \
    src/CAH-Dendrogramme-maxclust-param.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.50_SimObj-NO-BN.csv 8

python3.6 \
    src/CAH-Dendrogramme-maxclust-param.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.75_SimObj-NO-BN.csv 8

python3.6 \
    src/CAH-Dendrogramme-maxclust-param.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=1.00_SimObj-NO-BN.csv 8



python3.6 \
    src/MDS+K-Means-param.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-NO-BN.csv 8

python3.6 \
    src/MDS+K-Means-param.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.25_SimObj-NO-BN.csv 8

python3.6 \
    src/MDS+K-Means-param.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.50_SimObj-NO-BN.csv 8

python3.6 \
    src/MDS+K-Means-param.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.75_SimObj-NO-BN.csv 8

python3.6 \
    src/MDS+K-Means-param.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=1.00_SimObj-NO-BN.csv 8



################ BN
# Automatiques
python3.6 \
    src/MDS-MultiDimensionalScaling-Dissimilarities.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-BN.csv

python3.6 \
    src/MDS-MultiDimensionalScaling-Dissimilarities.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.25_SimObj-BN.csv

python3.6 \
    src/MDS-MultiDimensionalScaling-Dissimilarities.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.50_SimObj-BN.csv

python3.6 \
    src/MDS-MultiDimensionalScaling-Dissimilarities.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.75_SimObj-BN.csv

python3.6 \
    src/MDS-MultiDimensionalScaling-Dissimilarities.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=1.00_SimObj-BN.csv



python3.6 \
    src/CAH-Dendrogramme-maxclust.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-BN.csv

python3.6 \
    src/CAH-Dendrogramme-maxclust.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.25_SimObj-BN.csv

python3.6 \
    src/CAH-Dendrogramme-maxclust.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.50_SimObj-BN.csv

python3.6 \
    src/CAH-Dendrogramme-maxclust.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.75_SimObj-BN.csv

python3.6 \
    src/CAH-Dendrogramme-maxclust.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=1.00_SimObj-BN.csv



python3.6 \
    src/CAH-Dendrogramme-maxclust-param.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-BN.csv 8

python3.6 \
    src/CAH-Dendrogramme-maxclust-param.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.25_SimObj-BN.csv 8

python3.6 \
    src/CAH-Dendrogramme-maxclust-param.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.50_SimObj-BN.csv 8

python3.6 \
    src/CAH-Dendrogramme-maxclust-param.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.75_SimObj-BN.csv 8

python3.6 \
    src/CAH-Dendrogramme-maxclust-param.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=1.00_SimObj-BN.csv 8



python3.6 \
    src/MDS+K-Means-param.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-BN.csv 8

python3.6 \
    src/MDS+K-Means-param.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.25_SimObj-BN.csv 8

python3.6 \
    src/MDS+K-Means-param.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.50_SimObj-BN.csv 8

python3.6 \
    src/MDS+K-Means-param.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.75_SimObj-BN.csv 8

python3.6 \
    src/MDS+K-Means-param.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=1.00_SimObj-BN.csv 8
