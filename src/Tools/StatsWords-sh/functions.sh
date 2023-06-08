#! /bin/sh

SED=sed
AWK=awk
PYTHON=python3
SORT=sort
UNIQ=uniq

VARS_FILE=./vars.sh
if [ -f ${VARS_FILE} ]; then
    source ${VARS_FILE}
fi

# Obtain the real physical path of an object (file or directory)
myrealpath()
{
    echo $(cd $(dirname "$1") && pwd -P)/$(basename "$1")
}
