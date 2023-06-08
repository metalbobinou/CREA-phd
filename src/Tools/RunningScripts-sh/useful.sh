#! /bin/sh

# Obtain the real physical path of an object (file or directory)
myrealpath()
{
    echo $(cd $(dirname "$1") && pwd -P)/$(basename "$1")
}
