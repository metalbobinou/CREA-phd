#! /bin/sh

if [ -z "$1" ]; then
    echo "A directory must be provided in argument"
    echo "Example:"
    echo "$0 directory"
    exit 255
fi

DIR=$1

EXT=xlsx

# Obtain the real physical path of an object (file or directory)
myrealpath()
{
    echo $(cd $(dirname "$1") && pwd -P)/$(basename "$1")
}

DIR=`realpath ${DIR}`

if [ ! -d "${DIR}" ]; then
    echo "Directory ${DIR} does not exist"
    exit 254
fi

for EACHFILE in ${DIR}/*.${EXT}
do
    INFILE=${EACHFILE}
#   OUTFILE=${INFILE#*.}  # Get extension only
#   OUTFILE=${INFILE%.*}  # Get full name except extension
    OUTFILE=${INFILE%.*}.csv

    INFILE=`realpath ${INFILE}`
    OUTFILE=`realpath ${OUTFILE}`

    xlsx2csv -i -d ";" ${INFILE} ${OUTFILE}
done
