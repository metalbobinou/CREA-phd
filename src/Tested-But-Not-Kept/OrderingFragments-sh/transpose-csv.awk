#! /bin/awk

# Transpose a CSV
# (Thanks StackOverflow)

# Variable:
# SEP=";"

BEGIN { FS=OFS=SEP }

{
    for (rowNr = 1; rowNr <= NF; rowNr++)
    {
        cell[rowNr, NR] = $rowNr
    }
    maxRows = (NF > maxRows ? NF : maxRows)
    maxCols = NR
}

END {
    for (rowNr = 1; rowNr <= maxRows; rowNr++)
    {
        for (colNr = 1; colNr <= maxCols; colNr++)
	{
            printf "%s%s", cell[rowNr, colNr], (colNr < maxCols ? OFS : ORS)
        }
    }
}
