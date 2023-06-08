#! /bin/sh

OUTPUT_PREFIX=scenario_

function MyUsage()
{
    echo "Usage:"
    echo "$0 NbParts Ordered-Fragments-file [...] "
    echo ""
    echo "NbParts : an integer giving the number of parts (NbParts > 0)"
    echo ""
    echo "Format of Fragments-file-union: (1st line Object, 2nd line Attribute, 3rd line Part, ...)"
    echo "Concept ID ; Level ; Type Obj/Attr/Part ; Nb O ; Nb A ; Nb P ; Obj1/Attr1/Part1 [; O/A/P2 ; ... ]"
    echo "... ; ... ; ... ; ... "
    echo ""
}

if [ $# -lt 2 ]; then
    echo "Missing arguments"
    echo ""
    MyUsage
    exit -1
fi

source ./functions.sh

########################################

MAX_PARTS=$1

if [ $1 -le 0 ]; then
    echo "NbParts must be positive and not null"
    echo ""
    MyUsage
    exit -1
fi

# Let's skip the number of parts, now
shift

NUM_FILE=0
for ARG in "$@"
do
    if [ -f "${ARG}" ]; then
        INPUT_NAME="${ARG}"
        INPUT_BASENAME=`basename "${INPUT_NAME}"`
        echo "${INPUT_BASENAME}"

        OUTPUT_NAME="${OUTPUT_PREFIX}${INPUT_BASENAME}"

	FRAGMENTS_FILE="${INPUT_NAME}"
	TMP1_OUT=`mktemp tmp1.XXXXX`
	TMP2_OUT=`mktemp tmp2.XXXXX`
	TMP3_OUT=`mktemp tmp3.XXXXX`
	TMP4_OUT=`mktemp tmp4.XXXXX`
	TMP5_OUT=`mktemp tmp5.XXXXX`
	TMP6_OUT=`mktemp tmp6.XXXXX`
	TMP7_OUT=`mktemp tmp7.XXXXX`

	# Input :
	# Concept ID ; Level ; Type Obj/Attr/Part ; Nb Obj ; Nb Attr ; Nb Part ; Object1/Attribute1/Part1 ; Obj2/Attr2/Part2 ; ...

	# Select useful fragments for each part
	#  (select those with one or more part(s))
	${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," \
	       -v MAX_PARTS="${MAX_PARTS}" \
	       -f select-fragments-with-part.awk \
	       ${FRAGMENTS_FILE} > ${TMP1_OUT}

	# Select useful fragments for each part
	#  (select those without any part(s))
	${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," \
	       -v MAX_PARTS="${MAX_PARTS}" \
	       -f select-fragments-without-part.awk \
	       ${FRAGMENTS_FILE} > ${TMP2_OUT}


	# Intermediate output :
	# Part ; Nb Fragments ; ID Fragment 1 ; ID Fragment 2 ; ...

	# Merge selected fragments in each part (remove duplicates)
	${AWK} -v FS=";" -v OFS=";" \
	       -v MAX_PARTS="${MAX_PARTS}" \
	       -f merge-selected-fragments-in-parts.awk \
	       ${TMP1_OUT} ${TMP2_OUT} > ${TMP3_OUT}

	# Sort fragments ID by ID order within each part
	${AWK} -v FS=";" -v OFS=";" \
	       -v MAX_PARTS="${MAX_PARTS}" \
	       -f sort-fragments-by-ID-in-parts.awk \
	       ${TMP3_OUT} > ${TMP4_OUT}



	# Intermediate output :
	# Part ; Nb Fragments ; ID Fragment 1 ; ID Fragment 2 ; ...

	# Priorize fragments (bigger fragments with an explicit part are 1st)
	${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," \
	       -v MAX_PARTS="${MAX_PARTS}" \
               -f priorize-fragments-per-part-and-terms.awk \
               ${FRAGMENTS_FILE} ${TMP4_OUT} > ${TMP5_OUT}



	# Intermediate output :
	# Part ; Nb Fragments ; ID Fragment 1 ; ID Fragment 2 ; ...

	# Transpose CSV for pretty print (column will describe content)
	${AWK} -v FS=";" -v SEP=";" \
	       -f transpose-csv.awk \
	       ${TMP5_OUT} > ${TMP6_OUT}



	# Intermediate-End output :
	# Part 0 ; Part 1 ; ...
	# Nb Fragments ; Nb Fragments ; ...
	# ID Fragment 1 ; ID Fragment 1 ; ...
	# ID Fragment 2 ; ID Fragment 2 ; ...

	# Write back terms contained in Fragments (and print the result)
	${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," \
	       -v MAX_PARTS="${MAX_PARTS}" \
               -f write-back-terms-from-fragments.awk \
               ${FRAGMENTS_FILE} ${TMP6_OUT} > ${TMP7_OUT}

	# Output :
	#    Part 0   |   Part 1   |   Part 2   |   Part 3
	#   Nb Frags  |  Nb Frags  |  Nb Frags  |  Nb Frags
	#  Fragment 1 | Fragment 1 | Fragment 4 | [Unordered Fragment]
	# [Unordered] | Fragment 2 | Fragment 2 |
	#             | Fragment 3 | [Unordered]|
	#             | [Unordered]|


	cp -f ${TMP7_OUT} "${OUTPUT_NAME}"

	rm -f ${TMP1_OUT}
	rm -f ${TMP2_OUT}
	rm -f ${TMP3_OUT}
	rm -f ${TMP4_OUT}
	rm -f ${TMP5_OUT}
	rm -f ${TMP6_OUT}
	rm -f ${TMP7_OUT}

    else
        echo "File ${ARG} not found (skipping it)"
    fi
    NUM_FILE=$(( NUM_FILE + 1 ))
done
