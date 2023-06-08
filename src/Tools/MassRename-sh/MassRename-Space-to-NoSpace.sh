#! /bin/sh

if [ $# -ne 1 ]; then
    echo "At least and at most 1 parameter"
    exit -1
fi

DIR=$1

NEWPREFIX=

##
# INPUT (a directory) : ./MassRename.sh ./data/dir/Transpose-Norm-CSV/
# OUTPUT : description of files renamed (do not forget to uncomment the "cp"
#  when it's okay)


for FILE in "${DIR}"/*
do

    BASENAME=`basename "${FILE}"`
    DIRNAME=`dirname "${FILE}"`
    echo "Basename : ${BASENAME}"
    echo "Dirname : ${DIRNAME}"

    PIVOT=" - T.slf"
    #PREFIX=${BASENAME#"$PIVOT"}
    #SUFFIX=${BASENAME%"$PIVOT"}
    PREFIX=`expr match "${BASENAME}" "\(.*\)$PIVOT.*"`
    SUFFIX=`expr match "${BASENAME}" ".*$PIVOT\(.*\)"`
    echo "Prefix : ${PREFIX}"
    echo "Suffix : ${SUFFIX}"

    NAME=${BASENAME}
    echo "Name : ${NAME}"
    #echo "Name : ${PREFIX}${PIVOT}${SUFFIX}"

    #NEWNAME="${NEWPREFIX}${NAME}"
    #NEWNAME="${NEWPREFIX}${SUFFIX}"
    NEWNAME="${PREFIX}${SUFFIX}"
    echo "New Name : ${NEWNAME}"

    FINALNAME="${DIRNAME}/${NEWNAME}"
    echo "Final Name : ${FINALNAME}"

#    cp "${FILE}" "${FINALNAME}"
    echo ""
done
