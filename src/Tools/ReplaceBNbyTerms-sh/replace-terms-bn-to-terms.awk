#! /bin/awk

# Change every occurrences of "term bn:ID" by "bn:ID" only in every column
# possible

# Variables :
# OFS = ";"

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

function GetWordFromText(MyText)
{
    STR = MyText;

    # match :    /:[^:]*$/
    # [^:]*  (a [^...] is a negated bracket expression) will match 0+ chars
    #  other than :, so, only the last : is matched with the first :.
    # Pattern details :
    # ^      - begin of string
    # :      - a : followed with...
    # [^:]*  - any 0+ chars other than :
    # $      - end of string.
    BN_ID_POS = match(STR, / [^ ]*$/);

    # match puts variables RSTART and RLENGTH to indicate the matched pattern
    BN_ID_BRUT = substr(STR, RSTART, RLENGTH);

    # Substr gets : ' bn:XXXXX"' let's remove first and last chars
    BN_ID = substr(BN_ID_BRUT, 2, (length(BN_ID_BRUT) - 1));

    MATCHING_PART = RSTART;
    # Extract the word part ("Word bn:ID"), in other word, the beginning
    WORD = substr(STR, 1, (MATCHING_PART - 1));

    # If word begins by double quote
    if (substr(WORD, 0, 1) == "\"")
        WORD = substr(WORD, 2, length(WORD));

    return (WORD);
}


{
    for (i = 1; i <= NF; i++)
    {
	col = trim($i);
	MATCHING = match(col, "bn:");
	if (MATCHING != 0)
	{
	    # bn:id found
	    WORD = GetWordFromText(col);
	    OUT = WORD;
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
