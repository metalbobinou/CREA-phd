import os
import sys

import csv
#from itertools import izip

def BuildOutputName(filename):
    InBaseName = os.path.basename(filename)
    OutName = "transposed-" + InBaseName
    return OutName


def TransposeCSV(filename, outfile="NULL"):
    # izip can be found in ZIP... do not search, it's Python3 things...
    izip = zip

    # Open input file for reading
    InFile = open(filename, "r")

    # Create a CSV structure
    CSVReader = csv.reader(InFile,
                           delimiter=';',
                           quoting=csv.QUOTE_MINIMAL)

    # Transpose the CSV
    TransposedCSV = izip(*CSVReader)

    # Open output file for writing
    if (outfile == "NULL"):
        OutName = BuildOutputName(filename)
    else:
        OutName = outfile
    OutFile = open(OutName, "w+")

    # Write the transposed data
    CSVWriter = csv.writer(OutFile,
                           lineterminator="\n", # UNIX end of line
                           delimiter=';')
                           ### LET'S LET AWK ADD DOUBLE QUOTE ON 1ST COLS...
                           #,
                           #quoting=csv.QUOTE_NONNUMERIC)
    CSVWriter.writerows(TransposedCSV)

    # Close files
    InFile.close()
    OutFile.close()


def main():
    if (len(sys.argv) > 2):
        TransposeCSV(sys.argv[1], sys.argv[2])
    else:
        if (len(sys.argv) > 1):
            TransposeCSV(sys.argv[1])
        else:
            print("Error: No parameters given")
            exit(-1)
    exit(0)
#    for arg in sys.argv:
#        print(arg)
#        TransposeCSV(arg)

main()
