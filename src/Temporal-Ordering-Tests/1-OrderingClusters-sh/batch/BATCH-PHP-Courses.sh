#! /bin/sh

./1bis-OrderingClusters-plus-infos.sh \
    input-clusters/Clusters-DB/Dissimilarity\ Simple/BN/sorted_DB-clusters-Directe-Dissimilarity-Simple.csv \
    input-parts/PHP-Courses/clean_stats_terms-8-count.csv

./1bis-OrderingClusters-plus-infos.sh \
    input-clusters/Clusters-DB/Dissimilarity\ Simple/BN/sorted_DB-clusters-S\=H-Dissimilarity-Simple.csv \
    input-parts/PHP-Courses/clean_stats_terms-8-count.csv

./1bis-OrderingClusters-plus-infos.sh \
    input-clusters/Clusters-DB/Dissimilarity\ Simple/BN/sorted_DB-clusters-S\=M-Dissimilarity-Simple.csv \
    input-parts/PHP-Courses/clean_stats_terms-8-count.csv

./1bis-OrderingClusters-plus-infos.sh \
    input-clusters/Clusters-DB/Dissimilarity\ Simple/BN/sorted_DB-clusters-S\=B-Dissimilarity-Simple.csv \
    input-parts/PHP-Courses/clean_stats_terms-8-count.csv
