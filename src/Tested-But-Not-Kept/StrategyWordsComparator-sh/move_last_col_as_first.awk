#! /bin/awk

{
    score = $NF;
    # $NF = "#"$NF;
    $NF = "";
    print score, $0
}
