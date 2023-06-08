#! /bin/sh

NB_PARTS=8
OUT_DIR=out-8-parts

FRAGMENTS_DIR=data-in
PARTS_SUBDIR=8-Parts/PHP-automatic

SCRIPT_EXEC=1-ScenarioBuilding-From-Clustering.sh
OUTPUT_PREFIX=scenario_


source ./functions.sh

########################################

FOR_DIR="./${FRAGMENTS_DIR}/${PARTS_SUBDIR}/*"

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
    #FINAL_OUTPUT_NAME="${OUTPUT_PREFIX}${SUB_NAME}.csv"

    sh ${SCRIPT_EXEC} ${NB_PARTS} "${FRAGMENTS_FILENAME}"

    mv "${OUTPUT_SCRIPT_NAME}" "${OUT_DIR}/${FINAL_OUTPUT_NAME}"

    NUM_FILE=$(( NUM_FILE + 1 ))
done
