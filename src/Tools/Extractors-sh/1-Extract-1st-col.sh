#! /bin/sh

OUTPUT_PREFIX=out_
OUTPUT_PREFIX_LINES=lines_
OUTPUT_PREFIX_COLUMNS=cols_
OUTPUT_PREFIX_COLSTRANS=colstrans_
OUTPUT_PREFIX_ENHANCED=enhanced_
OUTPUT_PREFIX_NUMBERED=numbered_


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
	OUTPUT_LINES="${OUTPUT_PREFIX_LINES}${INPUT_BASENAME}"
	OUTPUT_COLUMNS="${OUTPUT_PREFIX_COLUMNS}${INPUT_BASENAME}"
	OUTPUT_COLSTRANS="${OUTPUT_PREFIX_COLSTRANS}${INPUT_BASENAME}"
	OUTPUT_ENHANCED="${OUTPUT_PREFIX_ENHANCED}${INPUT_BASENAME}"
	OUTPUT_NUMBERED="${OUTPUT_PREFIX_NUMBERED}${INPUT_BASENAME}"

        TMP1_OUT=`mktemp tmp1.XXXXX`
        TMP2_OUT=`mktemp tmp2.XXXXX`
        TMP3_OUT=`mktemp tmp3.XXXXX`
        TMP4_OUT=`mktemp tmp4.XXXXX`
        TMP5_OUT=`mktemp tmp5.XXXXX`

	### LINES
	# Print only the first column
	#${AWK} -F ";" '{ print $1 }'    \
	#    "${INPUT_NAME}" > ${TMP1_OUT}

	# Print line number and first column
	#${AWK} -F ";" -v SEP=";"     \
	#    '{ print NR SEP $1 }'    \
        #    "${INPUT_NAME}" > ${TMP1_OUT}

	# Print line number and first column (shift by 1 line)
	${AWK} -F ";" -v SEP=";"        \
	    -f print-lines-number.awk   \
	    "${INPUT_NAME}" > ${TMP1_OUT}

	cp -f ${TMP1_OUT} "${OUTPUT_LINES}"

	### COLUMNS
	# Print only the first line
	#${HEAD} -n 1
	# Print the 1st line of N files
	#${AWK} 'FNR <= 1' file_*.txt

	# Print a line with column number, then a line with column content
	${AWK} -F ";" -v SEP=";"      \
	    -f print-cols-number.awk  \
	    "${INPUT_NAME}" > ${TMP2_OUT}

	cp -f ${TMP2_OUT} "${OUTPUT_COLUMNS}"

	# Print each column name with 
	${AWK} -F ";" -v SEP=";"          \
	    -f print-cols-transposed.awk  \
	    ${TMP2_OUT} > ${TMP3_OUT}

	cp -f ${TMP3_OUT} "${OUTPUT_COLSTRANS}"

	### ENHANCED MATRIX
	# Print the matrix with one line of numbers and one column of numbers
	${AWK} -F ";" -v SEP=";"          \
	    -f print-enhanced-matrix.awk  \
	    "${INPUT_NAME}" > ${TMP4_OUT}

	cp -f ${TMP4_OUT} "${OUTPUT_ENHANCED}"

	### NUMBERED MATRIX
	# Print a matrix where sources and terms are replaced by numbers
	${AWK} -F ";" -v SEP=";"          \
	    -f print-numbered-matrix.awk  \
	    "${INPUT_NAME}" > ${TMP5_OUT}

	cp -f ${TMP5_OUT} "${OUTPUT_NUMBERED}"
	
	rm -f ${TMP1_OUT}
	rm -f ${TMP2_OUT}
	rm -f ${TMP3_OUT}
	rm -f ${TMP4_OUT}
	rm -f ${TMP5_OUT}
    fi
    NUM_FILE=$(( NUM_FILE + 1 ))
done
