#! /bin/sh

OUTPUT_KEPT_PREFIX=kept_
OUTPUT_REMOVED_PREFIX=removed_

function MyUsage()
{
    echo "Usage:"
    echo "$0 List-of-Terms.csv Clusters1.csv [...] "
    echo ""
    echo "List-of-Terms : a CSV file containing the old terms to remove from clusters (1 term per line)."
    echo "ClustersX : CSV file(s) containing clusters of terms."
    echo ""
    echo "Clusters format : term1 , term2 , ..."
}

if [ $# -lt 2 ]; then
    echo "Missing arguments"
    echo ""
    MyUsage
    exit -1
fi

source ./functions.sh

########################################

REF_TERMS="$1"
REF_BASENAME=`basename "${REF_TERMS}"`

if [ ! -f $1 ]; then
    echo "List-of-Terms must exist"
    echo ""
    MyUsage
    exit -1
fi

# Let's skip the number of parts, now
shift

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

        #OUTPUT_KEPT_NAME="${OUTPUT_KEPT_PREFIX}${INPUT_BASENAME}"
	#OUTPUT_KEPT_NAME="${OUTPUT_KEPT_PREFIX}${INPUT_BASENAME_NO_EXTENSION}_${REF_BASENAME}.${INPUT_EXTENSION}"
	OUTPUT_KEPT_NAME="${OUTPUT_KEPT_PREFIX}${INPUT_BASENAME_NO_EXTENSION}_${REF_BASENAME}"
	#OUTPUT_REMOVED_NAME="${OUTPUT_REMOVED_PREFIX}${INPUT_BASENAME}"
	#OUTPUT_REMOVED_NAME="${OUTPUT_REMOVED_PREFIX}${INPUT_BASENAME_NO_EXTENSION}_${REF_BASENAME}.${INPUT_EXTENSION}"
	OUTPUT_REMOVED_NAME="${OUTPUT_REMOVED_PREFIX}${INPUT_BASENAME_NO_EXTENSION}_${REF_BASENAME}"
	# Last file is already a CSV too :)

	CLUSTERS_FILE="${INPUT_NAME}"
	TMP1_OUT=`mktemp tmp1.XXXXX`
	TMP2_OUT=`mktemp tmp2.XXXXX`


	# Input :
	# Term1 , Term2 , ...

	# Extract only the terms to keep
	${AWK} -v FS="," -v OFS="," -v SUB_OFS="," \
	       -f extract-kept-terms.awk \
	       ${REF_TERMS} ${CLUSTERS_FILE} > ${TMP1_OUT}

	# Extract only the terms to remove
	${AWK} -v FS="," -v OFS="," -v SUB_OFS="," \
	       -f extract-removed-terms.awk \
	       ${REF_TERMS} ${CLUSTERS_FILE} > ${TMP2_OUT}

	cp -f ${TMP1_OUT} "${OUTPUT_KEPT_NAME}"
	cp -f ${TMP2_OUT} "${OUTPUT_REMOVED_NAME}"

	rm -f ${TMP1_OUT}
	rm -f ${TMP2_OUT}
    else
        echo "File ${ARG} not found (skipping it)"
    fi
    NUM_FILE=$(( NUM_FILE + 1 ))
done
