#! /bin/sh

if [ $# -lt 2 ]; then
    echo "Two arguments are required"
    echo "$0 Reference-Words-list test-file"
    exit -1
fi

source ./functions.sh

#########################

# Input data to check
INPUT_FILE=$2

# Reference file
REFERENCE_FILE=$1
STRINGLIST=`${CAT} ${REFERENCE_FILE}`

# Hard coded max nb of words
MAX_WORDS=333
# Counters
NB_WORDS=0
TOTAL_WORDS=0

# Comma is used as a separator
OLD_IFS=${IFS}
IFS=','
for WORD in ${STRINGLIST}
do
    # Trim the word to search for
    SEARCH=`echo "${WORD}" | ${AWK} '{$1=$1};1'`

    # Search within the file (-o : occurences, -w : exact word match)
    NB_WORDS_DOC=`${CAT} ${INPUT_FILE} | \
	${GREP} -ow "${SEARCH}" | \
	${WC} -l`

    # Let's realign the number
    NB_WORDS_DOC=$(( NB_WORDS_DOC ))

    # Print the result :)
    echo "${SEARCH} : ${NB_WORDS_DOC}"
    NB_WORDS=$(( NB_WORDS + NB_WORDS_DOC ))
    TOTAL_WORDS=$(( TOTAL_WORDS + 1 ))
done

# Context back
IFS=${OLD_IFS}

echo ""
echo "--"
echo ""
echo "${REFERENCE_FILE}"
echo "${INPUT_FILE}"
echo ""

PERCENTAGE=`echo "scale=2;${NB_WORDS}*100/${TOTAL_WORDS}" | bc`
echo "Total : ${NB_WORDS} / ${TOTAL_WORDS} (${PERCENTAGE}%)"
