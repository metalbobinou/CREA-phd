#! /bin/sh

INPUT_DIR=FichiersStrategies-lol
OUTPUT_DIR=FichiersStrategies-OK

PIVOT=-

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
    BASENAME_LEN=`echo "${BASENAME}" | wc -m`
    BASENAME_LEN=`expr ${BASENAME_LEN} - 1`
    PREFIX_NAME=${BASENAME%%${PREFIX}}
    SUFFIX_NAME=${BASENAME##${SUFFIX}}
    PREFIX_LEN=`echo "${PREFIX_NAME}" | wc -m`
    PREFIX_LEN=`expr ${PREFIX_LEN} - 1`
    SUFFIX_LEN=`echo "${SUFFIX_NAME}" | wc -m`
    SUFFIX_LEN=`expr ${SUFFIX_LEN} - 1`
    PREFIX_NEXT=`echo "${PREFIX_NAME}" | wc -m`
    PREFIX_NAME=`echo ${BASENAME} | cut -c 1-${PREFIX_LEN}`
    SUFFIX_NAME=`echo ${BASENAME} | cut -c ${PREFIX_NEXT}-${BASENAME_LEN}`
    NEWNAME=${PREFIX_NAME}.csv${SUFFIX_NAME}
    echo "${BASENAME} : ${NEWNAME} : ${PREFIX_NAME}  -  ${SUFFIX_NAME}"
#    if [ "${BASENAME}" != "${PREFIX_NAME}" ]; then
#	mv ${EACHFILE} ${OUTPUT_DIR}/${NEWNAME}
#    fi
done
