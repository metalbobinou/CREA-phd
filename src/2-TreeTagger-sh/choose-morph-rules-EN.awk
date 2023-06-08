#! /bin/awk

{
    #
    # Direct case
    #
    if ($3 == "<unknown>")
    {
	# If unknown word, we take the original one
	BestWord = $1;
    }
    else if (index($3, "|") != 0)
    {
	# If there is an ambiguity in output, let's take the original word
	BestWord = $1;
    }
    else if (($3 == "@card@") || ($3 == "@ord@"))
    {
	# If it's a number, we keep it
	BestWord = $1;
    }
    #
    #  Ambiguites a decider
    #
    else if ((substr($2, 0, 3) == "VB") ||
	     (substr($2, 0, 3) == "VBD") ||
	     (substr($2, 0, 3) == "VBG") ||
	     (substr($2, 0, 3) == "VBN") ||
	     (substr($2, 0, 3) == "VBP") ||
	     (substr($2, 0, 3) == "VBZ"))
    {
	# If it's a verb, we take the infinitive
	BestWord = $3;
    }
    else if (($2 == "NN") || ($2 == "NNS") || ($2 == "NP") || ($2 == "NPS"))
    {
	# If it's a noun, we take the standard form
	BestWord = $3;
    }
    #
    # In case of doubt... let's take the original
    #
    else
    {
	BestWord = $1;
    }

    #
    # Processing normal
    #
    BestWord = tolower(BestWord);
    print BestWord;
}
