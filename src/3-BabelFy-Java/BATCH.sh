#! /bin/sh

# Please, call this script like this :
# ./BATCH.SH > logs_yyyy-mm-dd.log 2>&1

echo "Please, call this script like this :"
echo "./BATCH.SH > logs_yyyy-mm-dd.log 2>&1"

sleep 5

echo "-------- Java"
java -jar BabelFyFiles.jar FR input-data/Java-Courses/CJA-automatic.txt
java -jar BabelFyFiles.jar FR input-data/Java-Courses/CJA-manual.txt


echo "-------- PHP-automatic"
java -jar BabelFyFiles.jar FR input-data/PHP-automatic/C1.txt
java -jar BabelFyFiles.jar FR input-data/PHP-automatic/C2.txt
java -jar BabelFyFiles.jar FR input-data/PHP-automatic/C3.txt
java -jar BabelFyFiles.jar FR input-data/PHP-automatic/C4.txt
java -jar BabelFyFiles.jar FR input-data/PHP-automatic/C5.txt
java -jar BabelFyFiles.jar FR input-data/PHP-automatic/C6.txt
java -jar BabelFyFiles.jar FR input-data/PHP-automatic/C7.txt
java -jar BabelFyFiles.jar FR input-data/PHP-automatic/C8.txt
java -jar BabelFyFiles.jar FR input-data/PHP-automatic/C9.txt
java -jar BabelFyFiles.jar FR input-data/PHP-automatic/C10.txt


echo "-------- PHP-manual"
java -jar BabelFyFiles.jar FR input-data/PHP-manual/C1.txt
java -jar BabelFyFiles.jar FR input-data/PHP-manual/C2.txt
java -jar BabelFyFiles.jar FR input-data/PHP-manual/C3.txt
java -jar BabelFyFiles.jar FR input-data/PHP-manual/C4.txt
java -jar BabelFyFiles.jar FR input-data/PHP-manual/C5.txt
java -jar BabelFyFiles.jar FR input-data/PHP-manual/C6.txt
java -jar BabelFyFiles.jar FR input-data/PHP-manual/C7.txt
java -jar BabelFyFiles.jar FR input-data/PHP-manual/C8.txt
java -jar BabelFyFiles.jar FR input-data/PHP-manual/C9.txt
java -jar BabelFyFiles.jar FR input-data/PHP-manual/C10.txt
