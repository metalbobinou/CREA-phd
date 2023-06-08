#! /bin/sh

INPUT_DIR=FichiersStrategies-Etudiants-Init
OUTPUT_DIR=FichiersStrategies-lol

PIVOT=,

PREFIX="${PIVOT}*"
SUFFIX="*${PIVOT}"

# Required function for later
myrealpath()
{
    echo $(cd $(dirname "$1") && pwd -P)/$(basename "$1")
}

INPUT_DIR=`myrealpath ${INPUT_DIR}`
OUTPUT_DIR=`myrealpath ${OUTPUT_DIR}`

if [ ! -d ${OUTPUT_DIR} ]; then
    mkdir -p ${OUTPUT_DIR}
fi

for EACHFILE in ${INPUT_DIR}/*
do
    BASENAME=`basename ${EACHFILE}`
    PREFIX_NAME=${BASENAME%%${PREFIX}}
    SUFFIX_NAME=${BASENAME##${SUFFIX}}
    NEWNAME=${PREFIX_NAME}.${SUFFIX_NAME}
    echo "${BASENAME} : ${NEWNAME} : ${PREFIX_NAME}  -  ${SUFFIX_NAME}"
#    if [ "${BASENAME}" != "${PREFIX_NAME}" ]; then
#	mv ${EACHFILE} ${OUTPUT_DIR}/${NEWNAME}
#    fi
done
