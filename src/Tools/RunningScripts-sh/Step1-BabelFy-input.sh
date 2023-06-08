#! /bin/sh

COMMON_PREFIX=/Users/metalman/svn/these/Experiences/CourseContentComparator
#COMMON_PREFIX=/home/metalman/svn/these/Experiences/CourseContentComparator
INPUT_VERSION=

BABELFY_JAVA_DIR=${COMMON_PREFIX}/BabelFy-Java
BABELFY_JAVA=${BABELFY_JAVA_DIR}/BabelFyFiles.jar
INPUT_DIR=${COMMON_PREFIX}/BabelFy-Java/input-data/PHP-automatic
DISAMBIGUATE_DIR=${COMMON_PREFIX}/3-disambiguated
SCRIPTS_DIR=${COMMON_PREFIX}/RunningScripts-sh

JAVA_EXEC=${BABELFY_JAVA}
JAVA_DIR=${BABELFY_JAVA_DIR}
INPUT_DIR=${INPUT_DIR}
OUTPUT_DIR=${DISAMBIGUATE_DIR}

CWD=`pwd`

##############

echo "# Disambiguation started"

source ${SCRIPTS_DIR}/Step1.sh

javaprocessfolder

echo "# Disambiguation finished"
