#! /bin/sh

# Define the first iteration to do, and the last one
MIN=8
MAX=8

if [ ${MIN} -gt ${MAX} ]; then
	echo "MIN can't be bigger than MAX"
	exit -1
fi

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



ITER=${MIN}
while [ ${ITER} -le ${MAX} ]
do
	echo "Processing for ITER : ${ITER}"

################ NO-BN
# Automatiques
python3.6 \
    src/CAH-Dendrogramme-maxclust-param.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-NO-BN.csv ${ITER}

python3.6 \
    src/CAH-Dendrogramme-maxclust-param.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.25_SimObj-NO-BN.csv ${ITER}

python3.6 \
    src/CAH-Dendrogramme-maxclust-param.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.50_SimObj-NO-BN.csv ${ITER}

python3.6 \
    src/CAH-Dendrogramme-maxclust-param.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.75_SimObj-NO-BN.csv ${ITER}

python3.6 \
    src/CAH-Dendrogramme-maxclust-param.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=1.00_SimObj-NO-BN.csv ${ITER}



python3.6 \
    src/MDS+K-Means-param.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-NO-BN.csv ${ITER}

python3.6 \
    src/MDS+K-Means-param.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.25_SimObj-NO-BN.csv ${ITER}

python3.6 \
    src/MDS+K-Means-param.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.50_SimObj-NO-BN.csv ${ITER}

python3.6 \
    src/MDS+K-Means-param.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=0.75_SimObj-NO-BN.csv ${ITER}

python3.6 \
    src/MDS+K-Means-param.py \
    intermediate-data/PHP-automatic/1-SimObj-SIMPLE+NO-BN/dis_PHP-automatic_S\=H-B\=1.00_SimObj-NO-BN.csv ${ITER}



################ BN
# Automatiques

python3.6 \
    src/CAH-Dendrogramme-maxclust-param.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-BN.csv ${ITER}

python3.6 \
    src/CAH-Dendrogramme-maxclust-param.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.25_SimObj-BN.csv ${ITER}

python3.6 \
    src/CAH-Dendrogramme-maxclust-param.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.50_SimObj-BN.csv ${ITER}

python3.6 \
    src/CAH-Dendrogramme-maxclust-param.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.75_SimObj-BN.csv ${ITER}

python3.6 \
    src/CAH-Dendrogramme-maxclust-param.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=1.00_SimObj-BN.csv ${ITER}



python3.6 \
    src/MDS+K-Means-param.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.00_SimObj-BN.csv ${ITER}

python3.6 \
    src/MDS+K-Means-param.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.25_SimObj-BN.csv ${ITER}

python3.6 \
    src/MDS+K-Means-param.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.50_SimObj-BN.csv ${ITER}

python3.6 \
    src/MDS+K-Means-param.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=0.75_SimObj-BN.csv ${ITER}

python3.6 \
    src/MDS+K-Means-param.py \
    intermediate-data/PHP-automatic/4-SimObj-SIMPLE+BN/dis_PHP-automatic_S\=H-B\=1.00_SimObj-BN.csv ${ITER}



	ITER=$(( ITER + 1 ))
done
