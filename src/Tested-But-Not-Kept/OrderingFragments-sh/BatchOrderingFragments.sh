#! /bin/sh

NB_PARTS=8
PARTS_FILE=clean_stats_terms-8-count.csv
OUT_DIR=out-8-parts

FRAGMENTS_DIR=data-in-fragments
PARTS_DIR=data-in-parts

#SCRIPT_EXEC=OrderingFragments-union.sh
#OUTPUT_PREFIX=ordered-union_
SCRIPT_EXEC=OrderingFragments-intersection.sh
OUTPUT_PREFIX=ordered-intersection_


source ./functions.sh

########################################

PARTS_FILENAME="${PARTS_DIR}/${PARTS_FILE}"

FOR_DIR="./${FRAGMENTS_DIR}/*"

if [ ! -d "${OUT_DIR}" ]; then
    mkdir -p "${OUT_DIR}"
fi

echo "-- PARTS : ${NB_PARTS} --"

NUM_FILE=0
for FRAGMENTS_FILENAME in ${FOR_DIR}
do
    echo "${FRAGMENTS_FILENAME}"
    FRAGMENTS_BASENAME=`basename "${FRAGMENTS_FILENAME}"`
    OUTPUT_SCRIPT_NAME="${OUTPUT_PREFIX}${FRAGMENTS_BASENAME}"

    #SUB_NAME=`echo "${FRAGMENTS_BASENAME}" | sed -E 's/.*(O=[^ ]*).*/\1/g'`
    SUB_NAME=`echo "${FRAGMENTS_BASENAME}" | sed -E 's/.*(O=[^ ]*|Directe|Inverse).*/\1/g'`
    FINAL_OUTPUT_NAME="${OUTPUT_PREFIX}${NB_PARTS}-parts-${SUB_NAME}.csv"

    sh ${SCRIPT_EXEC} ${NB_PARTS} "${FRAGMENTS_FILENAME}" "${PARTS_FILENAME}"

    mv "${OUTPUT_SCRIPT_NAME}" "${OUT_DIR}/${FINAL_OUTPUT_NAME}"
    NUM_FILE=$(( NUM_FILE + 1 ))
done
