#! /bin/sh

OUTPUT_PREFIX=RandIndex_

SCRIPT1_PYTHON=./src/RandIndex.py

if [ $# -lt 2 ]; then
    echo "Missing arguments"
    echo "$0 partition_1.csv partition_2.csv [...]"
    exit -1
fi

source ./functions.sh

########################################

SCRIPT1_PYTHON=`myrealpath ${SCRIPT1_PYTHON}`

${PYTHON} ${SCRIPT1_PYTHON} $@
