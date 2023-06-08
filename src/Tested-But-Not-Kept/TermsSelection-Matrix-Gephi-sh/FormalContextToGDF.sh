#! /bin/sh

OUTPUT_PREFIX=GDF-matrix_
OUTPUT_SUFFIX=.gdf

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

        OUTPUT_NAME="${OUTPUT_PREFIX}${INPUT_BASENAME}${OUTPUT_SUFFIX}"

	MATRIX_FILE="${INPUT_NAME}"
	TMP1_OUT=`mktemp tmp1.XXXXX`
	TMP2_OUT=`mktemp tmp2.XXXXX`
	TMP3_OUT=`mktemp tmp3.XXXXX`
	TMP4_OUT=`mktemp tmp4.XXXXX`
	TMP5_OUT=`mktemp tmp5.XXXXX`

	# Input :
	# [line1] X ; Document 1 ; Document 2 ; ...
	# [line2+] Term ; 0 ; 1 ; ...

	# Transform the first line of matrix into a list in column
	${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," \
	       -f matrix-1st-line-to-col.awk \
	       ${MATRIX_FILE} > ${TMP1_OUT}

	# Transform the first col of each line of matrix into a list in column
	${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," \
	       -f matrix-1st-col-to-col.awk \
	       ${MATRIX_FILE} > ${TMP2_OUT}

	# Merge Documents, then Terms, into a list (Nodes)
	${CAT} ${TMP1_OUT} ${TMP2_OUT} > ${TMP3_OUT}

	# Output :
	# Doc/Term 1 , Description
	# Doc/Term 2 , Description
	# ...

	# Transform the content of the matrix into a list of edges (Edges)
	${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," \
	       -f matrix-content-to-GDF-edges.awk \
	       ${MATRIX_FILE} > ${TMP4_OUT}

	# Output :
	# Term 1 , Doc X
	# Term 1 , Doc Y
	# Term 2 , Doc Z
	# ...

	# Merge Nodes and Edges in one file in GDF format
	echo "nodedef>name VARCHAR,label VARCHAR" > ${TMP5_OUT}
	${CAT} ${TMP3_OUT} >> ${TMP5_OUT}
	echo "edgedef>node1 VARCHAR,node2 VARCHAR" >> ${TMP5_OUT}
	${CAT} ${TMP4_OUT} >> ${TMP5_OUT}

	# Output :
	# nodedef>name VARCHAR, label VARCHAR
	# Doc X , Description
	# ...
	# Term 1, Description
	# ...
	# edgedef>node1 VARCHAR, node2 VARCHAR
	# Term 1 , Doc X
	# Term 1 , Doc Y
	# ...

	cp -f ${TMP5_OUT} "${OUTPUT_NAME}"

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
