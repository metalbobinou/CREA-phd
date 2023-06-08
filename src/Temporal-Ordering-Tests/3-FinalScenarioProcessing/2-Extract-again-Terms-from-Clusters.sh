#! /bin/sh

OUTPUT_PREFIX=terms_

function MyUsage()
{
    echo "Usage:"
    echo "$0 Clusters1.csv [...] "
    echo ""
    echo "ClustersX : CSV file(s) containing clusters of terms."
    echo ""
    echo "Clusters format : term1 , term2 , ..."
}

if [ $# -lt 1 ]; then
    echo "Missing arguments"
    echo ""
    MyUsage
    exit -1
fi

source ./functions.sh

########################################

NUM_FILE=0
for ARG in "$@"
do
    if [ -f "${ARG}" ]; then
        INPUT_NAME="${ARG}"
        INPUT_BASENAME=`basename "${INPUT_NAME}"`
	INPUT_BASENAME_NO_EXTENSION=$(basename "${INPUT_BASENAME}" |
					  ${REV} | ${CUT} -d'.' -f2- | ${REV})
	INPUT_EXTENSION=$(basename "${INPUT_BASENAME}" |
			      ${REV} | ${CUT} -d'.' -f 1 | ${REV})
        echo "${INPUT_BASENAME}"

        OUTPUT_NAME="${OUTPUT_PREFIX}${INPUT_BASENAME}"

	CLUSTERS_FILE="${INPUT_NAME}"
	TMP1_OUT=`mktemp tmp1.XXXXX`
	TMP2_OUT=`mktemp tmp2.XXXXX`
	TMP3_OUT=`mktemp tmp3.XXXXX`

	# Input :
	# Term1 , Term2 , ...
	# Term2 , Term3 , ...

	# Extract only the terms to keep
	${AWK} -v FS="," -v OFS="," -v SUB_OFS="," \
	       -f extract-terms-from-clusters.awk \
	       ${CLUSTERS_FILE} > ${TMP1_OUT}

	# Sort by name
	${SORT} ${TMP1_OUT} > ${TMP2_OUT}

	# Remove duplicates
	${UNIQ} ${TMP2_OUT} > ${TMP3_OUT}

	cp -f ${TMP3_OUT} "${OUTPUT_NAME}"

	rm -f ${TMP1_OUT}
	rm -f ${TMP2_OUT}
	rm -f ${TMP3_OUT}
    else
        echo "File ${ARG} not found (skipping it)"
    fi
    NUM_FILE=$(( NUM_FILE + 1 ))
done
