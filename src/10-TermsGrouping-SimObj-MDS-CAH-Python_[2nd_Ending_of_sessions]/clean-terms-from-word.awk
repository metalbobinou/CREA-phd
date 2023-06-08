#! /bin/awk

# Remove the word (keep the bn:ID) in order to ease the next automated processings

# Variables :
# OFS = ";"

# Input file :
# X ; Word1 bn:xxn ; Word2 bn:xxxxn ; ...
# Word1 bn:xxn ; 1 ; 0,5 ; ...
# Word2 bn:xxxxn ; 0,5 ; 1 ; ...

# Output file :
# X ; bn:xxn ; bn:xxxxn ; ...
# bn:xxn ; 1 ; 0,5 ; ...
# bn:xxxxn ; 0,5 ; 1 ; ...

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

# Exception : first line/header has (N - 1) words
# X ; Word1 bn:xxxxxn ; Word2 bn:xxxxxxn ; ...
NR == 1 {
    # First column is just "X" (or space)
    printf("%s", " ");

    # For each column, print the word
    for (i = 2; i <= NF; i++)
    {
	col = $i;
	col = trim(col);
	WORD = GetWordFromText(col);
	BN_ID = GetBNIDFromText(col);
	printf("%s%s", OFS, BN_ID);
    }

    # End of line
    printf("\n");
}

# Other lines are processed
# WordN bn:xxxxxn ; 1 ; 0,5 ; ...
NR != 1 {
    # First column is the word
    col = $1;
    col = trim(col);
    WORD = GetWordFromText(col);
    BN_ID = GetBNIDFromText(col);
    printf("%s", BN_ID);

    # For each column, print the number
    for (i = 2; i <= NF; i++)
    {
	col = $i;
	printf("%s%s", OFS, col);
    }

    printf("\n");
}
