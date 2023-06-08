#! /bin/awk

{
    #
    # Cas directs
    #
    if ($3 == "<unknown>")
    {
	# Si mot est inconnu, on garde le mot d'origine
	BestWord = $1;
    }
    else if (index($3, "|") != 0)
    {
	# Si il y a ambiguite en sortie, on garde le mot d'origine
	BestWord = $1;
    }
    else if ($3 == "@card@")
    {
	# Si c'est un nombre, on le garde
	BestWord = $1;
    }
    #
    #  Ambiguites a decider
    #
    else if (substr($2, 0, 3) == "VER")
    {
	# Si c'est un verbe, on prend l'infinitif....
	BestWord = $3;
    }
    else if (($2 == "NUM") || ($2 == "NOM"))
    {
	# Si c'est un ordinal (ex : 1er)  ou un nom, on prend la forme standard
	BestWord = $3;
    }
    #
    # Dans le doute... on prend le mot d'origine
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
