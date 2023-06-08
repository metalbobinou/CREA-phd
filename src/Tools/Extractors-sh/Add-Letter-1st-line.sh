#! /bin/sh

### Add 1 letter in the first line (to each column)
## useful after Extract-1st-col.sh

OUTPUT_PREFIX=new_


if [ $# -lt 1 ]; then
    echo "Missing arguments"
    echo ""
    echo "Usage:"
    echo "$0 file1 [files] ..."
    exit -1
fi

source ./functions.sh

#########################

NUM_FILE=0
for ARG in "$@"
do
    if [ -f "${ARG}" ]; then
        INPUT_NAME="${ARG}"
        INPUT_BASENAME=`basename "${INPUT_NAME}"`
        echo "${INPUT_BASENAME}"

        OUTPUT_NAME="${OUTPUT_PREFIX}${INPUT_BASENAME}"

	TMP1_OUT=`mktemp tmp1.XXXXX`
        TMP2_OUT=`mktemp tmp2.XXXXX`

	cp -f "${INPUT_NAME}" ${TMP1_OUT}

        ### ENHANCED MATRIX
        # Add a letter in front of each field in 1st line
        ${AWK} -F ";" -v OFS=";" -v LETTER="N" \
               ' NR == 1 { for (i = 1; i <= NF; i++)
	       	 { if (length($i) != 0)
		   { printf("%s%s", LETTER, $i) }
		   else { printf("%s", $i) }
		   if (i != NF)
		   { printf("%s", OFS) }
		 }
		 printf("%s", "\n"); }

		 NR != 1 { print $0 }' \
               ${TMP1_OUT} > ${TMP2_OUT}

        cp -f ${TMP2_OUT} "${OUTPUT_NAME}"

        rm -f ${TMP1_OUT}
        rm -f ${TMP2_OUT}
    fi
    NUM_FILE=$(( NUM_FILE + 1 ))
done
