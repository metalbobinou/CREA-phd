#! /bin/sh

COMMON_PREFIX=/Users/metalman/svn/these/Experiences/CourseContentComparator
#COMMON_PREFIX=/home/metalman/svn/these/Experiences/CourseContentComparator
INPUT_VERSION=content

SEPARATOR_JAVA_DIR=${COMMON_PREFIX}/SeparateWords-Java
SEPARATOR_JAVA=${SEPARATOR_JAVA_DIR}/SeparateWordsFiles.jar
INPUT_DIR=${COMMON_PREFIX}/input/${INPUT_VERSION}
DISAMBIGUATE_DIR=${COMMON_PREFIX}/disambiguate
SCRIPTS_DIR=${COMMON_PREFIX}/RunningScripts-sh

JAVA_EXEC=${SEPARATOR_JAVA}
JAVA_DIR=${SEPARATOR_JAVA_DIR}
INPUT_DIR=${INPUT_DIR}
OUTPUT_DIR=${DISAMBIGUATE_DIR}

CWD=`pwd`

##############

echo "# Separation started"

source ${SCRIPTS_DIR}/Step1.sh

javaprocessfolder

echo "# Separation finished"
