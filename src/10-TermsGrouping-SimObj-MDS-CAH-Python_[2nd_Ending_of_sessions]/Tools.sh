#! /bin/sh

OUTPUT_PREFIX=COMMA-

SCRIPT1_SIMILARITY_TO_DISSIMILARITY=similarity-to-dissimilarity-simple.awk
SCRIPT2_SIMILARITY_TO_DISSIMILARITY=similarity-to-dissimilarity-complex.awk

SIMILARITY_TO_DISSIMILARITY=${SCRIPT2_SIMILARITY_TO_DISSIMILARITY}


if [ "$#" == "0" ]; then
    echo "Missing arguments"
    echo "$0 input_file1.csv [...]"
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
	TMP3_OUT=`mktemp tmp3.XXXXX`
	TMP4_OUT=`mktemp tmp4.XXXXX`

	cp -f "${IN_NAME}" ${TMP1_IN}

	# Remove the bn:ID in the terms : just keep the word
	${AWK} -F ";" -v OFS=";" \
	       -f clean-terms-from-bn.awk \
	       ${TMP1_IN} > ${TMP2_OUT}

	# Put "0" in the diagonal
	#${AWK} -F ";" -v OFS=";" -v DIAGONAL="0" \
	#       -f replace-diagonal.awk \
	#       ${TMP1_NO_BN} > ${TMP1_DIAG}

	# Replace "1" by "0"
	#${AWK} -F ";" -v OFS=";" -v VAL_SEARCHED="1" -v VAL_REPLACED="0" \
	#       -f replace-values.awk \
	#       ${TMP1_DIAG} > ${TMP1_VAL}

	#############################
        # Transformations of matrix #
        #############################
        # Matrix of similarity : diagonal at 1 or 100% (object is 100% equal to itself)
        # Matrix of dissimilarity : diagonal at 0 or 0% (object is 0% equal to itself)
        #
        # MDS : requires a dissimalrity matrix (with 0 at diagonal)
        # Similarity to Dissimilarity :
	# SimToDiss Simple : apply (1 - value) on each cell [value between -1 & 1]
	# SimToDiss Complex : (sii + si'i' - 2 * sii')^1/2

	# Skip a step
	#cp -f ${TMP2_OUT} ${TMP3_OUT}

        # Apply the similarity to dissimilarity transformation to each cell of the matrix
        ${AWK} -F ";" -v OFS=";" \
               -f ${SIMILARITY_TO_DISSIMILARITY} \
               ${TMP2_OUT} > ${TMP3_OUT}

	# Replace the dot "." in the number by a comma ","
	${SED}  's/\([[:digit:]]\)\.\([[:digit:]]\)/\1,\2/g' \
		 ${TMP3_OUT} > ${TMP4_OUT}

	cp -f ${TMP4_OUT} "${OUTPUT_NAME}"

	rm -f ${TMP1_IN}
	rm -f ${TMP2_OUT}
	rm -f ${TMP3_OUT}
	rm -f ${TMP4_OUT}
    fi
done
