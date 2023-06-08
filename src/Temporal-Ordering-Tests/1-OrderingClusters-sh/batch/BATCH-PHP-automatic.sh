#! /bin/sh

./1bis-OrderingClusters-plus-infos.sh \
    input-clusters/Clusters-DB/PHP-automatic/sorted_DB-clusters-Directe-PHP-automatic.csv \
    input-parts/PHP-automatic/clean_stats_terms-8-count.csv

./1bis-OrderingClusters-plus-infos.sh \
    input-clusters/Clusters-DB/PHP-automatic/sorted_DB-clusters-S=B-PHP-automatic.csv \
    input-parts/PHP-automatic/clean_stats_terms-8-count.csv

./1bis-OrderingClusters-plus-infos.sh \
    input-clusters/Clusters-DB/PHP-automatic/sorted_DB-clusters-S=H-PHP-automatic.csv \
    input-parts/PHP-automatic/clean_stats_terms-8-count.csv

./1bis-OrderingClusters-plus-infos.sh \
    input-clusters/Clusters-DB/PHP-automatic/sorted_DB-clusters-S=M-PHP-automatic.csv \
    input-parts/PHP-automatic/clean_stats_terms-8-count.csv
