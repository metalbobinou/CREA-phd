#! /bin/awk

# Change every occurrences of "term bn:ID" by "bn:ID" only in every column
# possible

# Variables :
# OFS = ";"

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

function GetBNIDFromText(MyText)
{
    STR = MyText;

    # match :    /:[^:]*$/
    # [^:]*  (a [^...] is a negated bracket expression) will match 0+ chars
    #  other than :, so, only the last : is matched with the first :.
    # Pattern details :
    # :      - a : followed with...
    # [^:]*  - any 0+ chars other than :
    # $      - end of string.
    BN_ID_POS = match(STR, / [^ ]*$/);

    # match puts variables RSTART and RLENGTH to indicate the matched pattern
    BN_ID_BRUT = substr(STR, RSTART, RLENGTH);

    # Substr gets : ' bn:XXXXX"' let's remove first and last chars
    BN_ID = substr(BN_ID_BRUT, 2, (length(BN_ID_BRUT) - 1));

    # If word ends by double quote
    if (substr(BN_ID, (length(BN_ID_BRUT) - 1), 1) == "\"")
        BN_ID = substr(BN_ID_BRUT, 0, (length(BN_ID_BRUT) - 1));
    BN_ID = trim(BN_ID);

    return (BN_ID);
}


{
    for (i = 1; i <= NF; i++)
    {
        col = trim($i);
        MATCHING = match(col, "bn:");
        if (MATCHING != 0)
        {
            # bn:id found
	    BN_ID = GetBNIDFromText(col);
            OUT = BN_ID;
        }
        else
        {
            # bn:id not found (regular column)
            OUT = col;
        }
        if (i == 1)
            printf("%s", OUT);
        else
            printf("%s%s", OFS, OUT);

    }
    printf("\n");
}
