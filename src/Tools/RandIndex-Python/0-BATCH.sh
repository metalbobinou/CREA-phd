#! /bin/sh

./1-Build-Partitions.sh  \
	input-data/clusters-S=H-B=1.00-CAH-maxclusters-8.csv  \
	input-data/clusters-1-Non-Expert.csv  \
	input-data/clusters-2-Non-Expert.csv  \
	input-data/clusters-3-Expert.csv  \
	input-data/clusters-4-Expert.csv  \
	input-data/clusters-5-Expert.csv

./2-Calculate-RandIndex.sh  \
	partition_mono-excl_clusters-S=H-B=1.00-CAH-maxclusters-8.csv  \
	partition_mono-excl_clusters-1-Non-Expert.csv  \
	partition_mono-excl_clusters-2-Non-Expert.csv  \
	partition_mono-excl_clusters-3-Expert.csv  \
	partition_mono-excl_clusters-4-Expert.csv  \
	partition_mono-excl_clusters-5-Expert.csv    > Output_mono.txt

./2-Calculate-RandIndex.sh  \
	partition_multi-excl_clusters-S=H-B=1.00-CAH-maxclusters-8.csv  \
	partition_multi-excl_clusters-1-Non-Expert.csv  \
	partition_multi-excl_clusters-2-Non-Expert.csv  \
	partition_multi-excl_clusters-3-Expert.csv  \
	partition_multi-excl_clusters-4-Expert.csv  \
	partition_multi-excl_clusters-5-Expert.csv    > Output_multi.txt
