#! /bin/awk

# Replace column 1 by column 2 :
# pattern[NR] = $1;
# replacement[NR] = $2;
#
# Replace column 2 by column 1 :
# pattern[NR] = $2;
# replacement[NR] = $1; 

# gsub(/"/, "", $2);    => deletes the double quotes around column 2

NR == FNR {
    gsub(/"/, "", $2);
    pattern[NR] = $2;
    replacement[NR] = $1;
    count++;
    next
}

{
    for (i = 1; i <= count; i++)
    {
        sub(pattern[i], replacement[i])
    }
    print $0
}
