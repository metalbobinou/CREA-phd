#! /bin/sh

FILE1=refs/IT-Students-bn.txt
FILE2=refs/Non-Experts-bn.txt

FILE1STRINGLIST=`cat ${FILE1}`
FILE2STRINGLIST=`cat ${FILE2}`

MATCHING=0
WORDS1=0
# Comma is used as a separator
OLD_IFS=${IFS}
IFS=','
for WORD1 in ${FILE1STRINGLIST}
do
    WORDS2=0
    for WORD2 in ${FILE2STRINGLIST}
    do
	if [ "${WORD1}" == "${WORD2}" ]; then
	    MATCHING=$(( MATCHING + 1 ))
	    echo "${WORD2}"
	fi
	WORDS2=$(( WORDS2 + 1))
    done
    WORDS1=$(( WORDS1 + 1 ))
done

# Context back
IFS=${OLD_IFS}

echo ""
echo "--"
echo ""

#PERCENTAGE=`echo "scale=2;${NB_WORDS}*100/${TOTAL_WORDS}" | bc`
#echo "Total : ${NB_WORDS} / ${TOTAL_WORDS} (${PERCENTAGE}%)

echo "File 1 (${FILE1}) : ${WORDS1}"
echo "File 2 (${FILE2}) : ${WORDS2}"
echo "Matching : ${MATCHING}"
