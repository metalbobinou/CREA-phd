#! /bin/awk

NR == 1 {
    print SEP $1
}

NR != 1 {
    print (NR - 1) SEP $1
}
