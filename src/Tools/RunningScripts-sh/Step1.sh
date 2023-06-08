#! /bin/sh

# Useful functions (like "realpath")
source ${SCRIPTS_DIR}/useful.sh

# Process each file of the "input" directory with the "java program" given
javaprocessfolder()
{
    JAVA_EXEC=`myrealpath ${JAVA_EXEC}`
    JAVA_DIR=`myrealpath ${JAVA_DIR}`
    INPUT_DIR=`myrealpath ${INPUT_DIR}`
    OUTPUT_DIR=`myrealpath ${OUTPUT_DIR}`
    CWD=`myrealpath $CWD`

    if [ ! -d ${OUTPUT_DIR} ]; then
	mkdir -p ${OUTPUT_DIR}
    fi

    echo "# Processing inputs from folder: ${INPUT_DIR}/*"

    cd ${JAVA_DIR}
    for EACHFILE in ${INPUT_DIR}/*
    do
	echo "-- Processing: ${EACHFILE}"
	FILE_BASENAME=`basename ${EACHFILE}`
	FILE_FINAL_NAME="out_${FILE_BASENAME}.csv"
	### java, jar, executable, langue, fichier
	java -jar ${JAVA_EXEC} FR ${EACHFILE}
	mv -f ${INPUT_DIR}/${FILE_FINAL_NAME} ${OUTPUT_DIR}
    done
    cd ${CWD}
}
