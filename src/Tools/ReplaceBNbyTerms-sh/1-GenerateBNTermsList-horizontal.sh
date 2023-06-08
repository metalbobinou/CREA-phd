#! /bin/sh

OUTPUT_PREFIX=reference_

if [ "$#" == "0" ]; then
    echo "Missing arguments"
    echo "$0 matrix.csv [...]"
    echo ""
    echo "Format of matrix.csv :"
    echo 'X ; "bn:ID Term" ; "bn:ID Term" ; ...'
    echo "file1.csv ; 0 ; 1 ; ..."
    echo "... ; ... ; ... ; ..."
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

	cp -f "${IN_NAME}" ${TMP1_IN}

	# Horizontal
	# Read the 1st line of the matrix in order to extract the bn:ID and terms
	${AWK} -F ";" -v OFS=";" \
	       -f extract-bn-terms-horizontal.awk \
	       ${TMP1_IN} > ${TMP2_OUT}

	cp -f ${TMP2_OUT} "${OUTPUT_NAME}"

	rm -f ${TMP1_IN}
	rm -f ${TMP2_OUT}
    fi
done
