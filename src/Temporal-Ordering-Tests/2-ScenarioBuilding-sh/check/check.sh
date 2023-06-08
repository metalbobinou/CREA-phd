gawk -v FS=";" -v OFS=";" -v MAX_PARTS="5" -f merge-selected-fragments-in-parts.awk test-input1.csv test-input2.csv > out-merge-test.csv



gawk -v FS=";" -v OFS=";" -v MAX_PARTS="5" -f sort-fragments-by-ID-in-parts.awk out-merge-test.csv > out-sort-test.csv
