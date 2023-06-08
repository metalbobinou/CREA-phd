#! /bin/awk

# Extract the bn:ID and Terms from a reference matrix, and create a list of
# bn:ID and Terms for further reuse.
# HORIZONTAL VERSION : the matrix contains the bn:ID in the 1st line

# Variables :
# OFS = ";"

# Input file :
# X ; "Term1 bn:xxn" ; "Term2 bn:xxxxn" ; ...
# file1.csv ; 0 ; 1 ; ...
# ... ; ... ; ... ; ...

# Output file :
# bn:ID ; Terms
# bn:xxn ; Term1
# bn:xxn ; Term2
# ... ; ...

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


# Print header
BEGIN {
    printf("%s%s%s\n", "bn:ID", OFS, "Terms");
}

# X ; Word1 bn:xxxxxn ; Word2 bn:xxxxxxn ; ...
NR == 1 {
    # For each column, print the bn:ID and word
    for (i = 2; i <= NF; i++)
    {
	col = trim($i);
	WORD = GetWordFromText(col);
	BN_ID = GetBNIDFromText(col);
	printf("%s%s%s\n", BN_ID, OFS, WORD);
    }
}
