#! /bin/sh

SED=sed
AWK=awk
GREP=grep
PYTHON=python3

CAT=cat
CUT=cut
FIND=find
HEAD=head
JOIN=join
PASTE=paste
SORT=sort
TAIL=tail
TR=tr
UNIQ=uniq
WC=wc

VARS_FILE=./vars.sh
if [ -f ${VARS_FILE} ]; then
    source ${VARS_FILE}
fi

# Obtain the real physical path of an object (file or directory)
function myrealpath()
{
    echo $(cd $(dirname "$1") && pwd -P)/$(basename "$1")
}

# Trim all leadings and trailing spaces (thanks stack overflow)
function trim()
{
    local trimmed="$1"

    # Strip leading spaces.
    while [[ $trimmed == ' '* ]]; do
       trimmed="${trimmed## }"
    done
    # Strip trailing spaces.
    while [[ $trimmed == *' ' ]]; do
        trimmed="${trimmed%% }"
    done

    echo "$trimmed"
}

# Transpose a CSV file (Thanks StackOverflow)
# $1 = FILE    $2 = OFS    $3 = OUTFILE
function transposeCSV()
{
    if [ $# -eq 3 ]; then
	file=$1
	sep=$2
	outfile=$3

	${AWK} -F"${sep}" -v SEP="${sep}" \
	       -f transpose-csv.awk \
	       ${file} > ${outfile}
    else
	echo 'TRANSPOSE FAILED'
	echo 'Check args: $1=file.csv $2=separator $3=outfile.csv'
    fi
}
