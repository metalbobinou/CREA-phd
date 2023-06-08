#! /bin/sh

DIR1_1=InterTreillis
DIR1_2=Intertreillis-Etudiants-OK

REF_DIR1=${DIR1_1}
DIFF_DIR1=${DIR1_2}

RETURN_VALUE=0

# Required function for later
myrealpath()
{
    echo $(cd $(dirname "$1") && pwd -P)/$(basename "$1")
}

REF_DIR1=`myrealpath ${REF_DIR1}`
DIFF_DIR1=`myrealpath ${DIFF_DIR1}`

for EACHFILE in ${REF_DIR1}/*
do
    FILENAME=`basename ${EACHFILE}`
    echo "- Processing: ${FILENAME}"
    diff ${REF_DIR1}/${FILENAME} ${DIFF_DIR1}/${FILENAME}
    RETURN_VALUE=`expr ${RETURN_VALUE} + $?`
    echo "#########################"
done

if [ "${RETURN_VALUE}" != "0" ]; then
    echo "ERROR ! Files are different in dir: ${DIR1_1}"
else
    echo "CHECK PASSED SUCCESFULLY FOR DIR: ${DIR1_1} !"
fi

exit ${RETURN_VALUE}
