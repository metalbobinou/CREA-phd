#! /bin/sh

OUTPUT_PREFIX=kept_

function MyUsage()
{
    echo "Usage:"
    echo "$0 Ordered-Fragments-File [...]"
    echo ""
    echo "Format of Ordered-Fragments-File: "
    echo "Concept ID ; Level ; Type Obj/Att/Part ; Nb Obj ;Nb Att ;Nb Part ; "
    echo "Objects/Attributes/Parts ; ..."
    echo "1;6;Objects;1;7;8;\"web bn:00080772n\" , bn:00080772n"
    echo "1;6;Attributes;1;7;8;C2;C3;C4;C5;C6;C8;C9;"
    echo "1;6;Parts;1;7;8;0;1;2;3;4;5;6;7"
}

if [ $# -lt 1 ]; then
    echo "Missing arguments"
    echo ""
    MyUsage
    exit -1
fi

source ./functions.sh

########################################

NUM_FILE=0
for ARG in "$@"
do
    if [ -f "${ARG}" ]; then
        INPUT_NAME="${ARG}"
        INPUT_BASENAME=`basename "${INPUT_NAME}"`
        echo "${INPUT_BASENAME}"

        OUTPUT_NAME="${OUTPUT_PREFIX}${INPUT_BASENAME}"

	TMP1_OUT=`mktemp tmp1.XXXXX`

# OUTPUT FILE :
# Concept ID ; Level ; Type Obj/Attr/Parts ; Nb O ; Nb A ; Nb Parts ; ATT1/OBJ1 ("Name bn:ID", bn:ID)/PART1 [ ; ATT2/OBJ2/PART2 ; ... ]


	# Keep only Nb Parts not at 0
	${AWK} -v FS=";" -v OFS=";" -v SUB_OFS="," \
	       -f keep-fragments-with-order.awk  \
	       "${INPUT_NAME}" > ${TMP1_OUT}

	cp -f ${TMP1_OUT} "${OUTPUT_NAME}"

	rm -f ${TMP1_OUT}
    fi
done
