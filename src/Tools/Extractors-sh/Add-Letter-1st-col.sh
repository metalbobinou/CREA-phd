#! /bin/sh

### Add 1 letter in the first column (to each line)
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
        # Add a letter in front of each 1st column
        ${AWK} -F ";" -v OFS=";" -v LETTER="N" \
               ' { if (length($1) != 0)
	       	   { printf("%s%s", LETTER, $1);
	       	     for (i = 2; i <= NF; i++)
     	       	     { printf("%s%s", OFS, $i) }
		     printf("%s", "\n");
		   }
		   else { print $0 } } ' \
               ${TMP1_OUT} > ${TMP2_OUT}

        cp -f ${TMP2_OUT} "${OUTPUT_NAME}"

        rm -f ${TMP1_OUT}
        rm -f ${TMP2_OUT}
    fi
    NUM_FILE=$(( NUM_FILE + 1 ))
done
