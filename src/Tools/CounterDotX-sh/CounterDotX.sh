#! /bin/sh

if [ $# -lt 1 ]; then
    echo "One argument is required"
    echo "$0 test_file"
    exit -1
fi

source ./functions.sh

#########################  

FILE=$1

NB_DOT=`${GREP} -o '\.' ${FILE} | ${WC} -l`
NB_X=`${GREP} -o 'X' ${FILE} | ${WC} -l`

NB_DOT=$(( NB_DOT ))
NB_X=$(( NB_X ))

TOTAL=$(( NB_DOT + NB_X ))
DOT_PROPORTION=`echo "scale=2;${NB_DOT}*100/${TOTAL}" | bc`
X_PROPORTION=`echo "scale=2;${NB_X}*100/${TOTAL}" | bc`

echo "${NB_X} X + ${NB_DOT} dot = ${TOTAL} (${X_PROPORTION}%)"
