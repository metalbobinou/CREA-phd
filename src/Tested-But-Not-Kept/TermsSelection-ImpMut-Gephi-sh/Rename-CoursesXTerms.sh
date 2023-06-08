#! /bin/sh

OUTPUT_PREFIX=clean_
OUTPUT_SUFFIX=

function MyUsage()
{
    echo "Usage:"
    echo "$0 ImpMutMatrixFile.csv [...] "
    echo ""
    echo "Format of ImpMutMarixFile.csv :"
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

        OUTPUT_NAME="${OUTPUT_PREFIX}${INPUT_BASENAME}${OUTPUT_SUFFIX}"

	TMP1_OUT=`mktemp tmp1.XXXXX`
	TMP2_OUT=`mktemp tmp2.XXXXX`

	# Input :
	# [line1] X ; Document 1 ; Document 2 ; ...
	# [line2+] Term ; 0 ; 1 ; ...

	# Transforms the 1st line (each cols) for putting correct documents names
	#${SED} -E 's/;[^;]*(C[0-9]+)\.csv/;\1/g' "${INPUT_NAME}" > ${TMP1_OUT}
	${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," \
	       -f rename-cols-courses.awk \
	       "${INPUT_NAME}" > ${TMP1_OUT}

	# Transforms each line (1st col) for putting correct terms (removes bn:ID)
	${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," \
	       -f rename-lines-bnID.awk \
	       ${TMP1_OUT} > ${TMP2_OUT}

	cp -f ${TMP2_OUT} "${OUTPUT_NAME}"

	rm -f ${TMP1_OUT}
	rm -f ${TMP2_OUT}
    else
        echo "File ${ARG} not found (skipping it)"
    fi
    NUM_FILE=$(( NUM_FILE + 1 ))
done
