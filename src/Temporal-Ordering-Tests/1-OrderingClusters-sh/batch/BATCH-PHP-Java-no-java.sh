#! /bin/sh

./1bis-OrderingClusters-plus-infos.sh \
    input-clusters/Clusters-DB/PHP-no-java/sorted_DB-clusters-Directe-PHP-no-java.csv \
    input-parts/PHP-Java/clean_stats_terms-8-count.csv

./1bis-OrderingClusters-plus-infos.sh \
    input-clusters/Clusters-DB/PHP-no-java/sorted_DB-clusters-S\=B-PHP-no-java.csv \
    input-parts/PHP-Java/clean_stats_terms-8-count.csv

./1bis-OrderingClusters-plus-infos.sh \
    input-clusters/Clusters-DB/PHP-no-java/sorted_DB-clusters-S\=H-PHP-no-java.csv \
    input-parts/PHP-Java/clean_stats_terms-8-count.csv

./1bis-OrderingClusters-plus-infos.sh \
    input-clusters/Clusters-DB/PHP-no-java/sorted_DB-clusters-S\=M-PHP-no-java.csv \
    input-parts/PHP-Java/clean_stats_terms-8-count.csv
