#! /bin/sh

OUTPUT_PREFIX=listOfTermsDocuments_
OUTPUT_BRUT_PREFIX=list_

function MyUsage()
{
    echo "Usage:"
    echo "$0 StrategyMatrixFile.csv [...] "
    echo ""
    echo "Format of StrategyMarixFile.csv :"
    echo "[line1] X ; Document 1 ; Document 2 ; ..."
    echo "[line2+] Term ; 0 ; 1 ; ..."
    echo ""
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
        echo "${INPUT_BASENAME}"

        OUTPUT_NAME="${OUTPUT_PREFIX}${INPUT_BASENAME}"
	OUTPUT_BRUT_NAME="${OUTPUT_BRUT_PREFIX}${INPUT_BASENAME}"

	MATRIX_FILE="${INPUT_NAME}"
	TMP1_OUT=`mktemp tmp1.XXXXX`
	TMP2_OUT=`mktemp tmp2.XXXXX`
	TMP3_OUT=`mktemp tmp3.XXXXX`
	TMP4_OUT=`mktemp tmp4.XXXXX`
	TMP5_OUT=`mktemp tmp5.XXXXX`

	# Input :
	# [line1] X ; Document 1 ; Document 2 ; ...
	# [line2+] Term ; 0 ; 1 ; ...

	# Transform the matrix into a simple list
	${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," \
	       -f terms-matrix-to-list.awk \
	       ${MATRIX_FILE} > ${TMP1_OUT}

	# Output :
	# Term ; 2 ; C1 ; C2

	# Get the maximum number of documents
	${AWK} -v FS=";" \
	       'BEGIN { MAX = 0 }
	       	      { if (MAX < $2) { MAX = $2 } }
	       END { print MAX }'            \
	       ${TMP1_OUT} > ${TMP2_OUT}
	MAX_DOCUMENTS=`${CAT} ${TMP2_OUT}`

	# Sort by number of appearances (then by name)
	${SORT} -b -r -k 2,2 -k 1,1 -t ";" ${TMP1_OUT} > ${TMP3_OUT}

	# Add header
	echo "Terms ; NbCourses ; Documents" > ${TMP4_OUT}
	${CAT} ${TMP4_OUT} ${TMP3_OUT} > ${TMP5_OUT}

	# Output :
	# [line1] Terms ; NbCourses ; Course 1 ; [ Course 2 ; ... ]
	# [line2+] Term ; 2 ; C1 ; C2

	cp -f ${TMP5_OUT} "${OUTPUT_NAME}"


	# Get the brut output
	${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," \
	       '{ printf("%s", $1); for (i = 3; i <= NF; i++) { printf("%s%s", OFS, $i) }
	       printf("\n") }' \
		   ${TMP3_OUT} > ${TMP5_OUT}

	# Output :
	# Term ; C1 ; C2

	cp -f ${TMP5_OUT} "${OUTPUT_BRUT_NAME}"

	rm -f ${TMP1_OUT}
	rm -f ${TMP2_OUT}
	rm -f ${TMP3_OUT}
	rm -f ${TMP4_OUT}
	rm -f ${TMP5_OUT}

    else
        echo "File ${ARG} not found (skipping it)"
    fi
    NUM_FILE=$(( NUM_FILE + 1 ))
done
