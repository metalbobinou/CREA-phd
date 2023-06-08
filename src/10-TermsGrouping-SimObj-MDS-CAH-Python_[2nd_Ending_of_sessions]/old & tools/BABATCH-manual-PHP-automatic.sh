#! /bin/sh


################ NO-BN
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
