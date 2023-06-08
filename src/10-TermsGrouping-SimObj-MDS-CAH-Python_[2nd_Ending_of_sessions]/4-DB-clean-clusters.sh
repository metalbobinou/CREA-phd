#! /bin/sh

OUTPUT_PREFIX=sorted_

if [ $# -lt 1 ]; then
    echo "Missing arguments"
    echo "$0 Reference_Clusters.csv [...]"
    echo ""
    echo "Reference_Clusters.csv : "
    echo "ID_Cluster ; Qty Occurrences Cluster ; Word1 ; Word2 ; ..."
    echo "[identifier ; nb of times a cluster appeared ; term 1 ; term 2 ; ...]"
    echo ""
    exit -1
fi

source ./functions.sh

########################################

for ARG in "$@"
do
    if [ -f "${ARG}" ]; then
        IN_NAME="${ARG}"
        BASENAME=`basename "${IN_NAME}"`

	echo "-- ${BASENAME} --"

	OUTPUT_NAME="${OUTPUT_PREFIX}${BASENAME}"

	TMP1_IN=`mktemp tmp1.XXXXX`
	TMP2_OUT=`mktemp tmp2.XXXXX`

	# Sort by number of occurrences of cluster
	${SORT} -r -n -k2 -t";" "${IN_NAME}" > ${TMP1_IN}

	# Update the DB. BEWARE: IT ALWAYS TAKE INTO ACCOUNT THE FIRST LINE
        ${AWK} -F ";" -v OFS=";" \
	       '{ printf("%s", NR);
	       	  for (i = 2; i <= NF; i++)
	       	  { printf("%s%s", OFS, $i); }
		  printf("\n"); }' \
               ${TMP1_IN} > ${TMP2_OUT}

	cp -f ${TMP2_OUT} "${OUTPUT_NAME}"

	rm -f ${TMP1_IN}
	rm -f ${TMP2_OUT}
    else
	echo "#### Missing file: ${ARG}"
    fi
done
