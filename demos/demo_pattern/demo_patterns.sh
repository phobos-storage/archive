#!/bin/sh

# This demo was based on the work available in Phobos 1.91.2.
# May not work for the following versions.

echo "# Demo -- 'phobos extent list'"

sleep 5

echo "#                                                                               "
echo "# The previous version of 'phobos extent list' considered that each provided    "
echo "# argument was a POSIX pattern, which leads to bad performances if the extent   "
echo "# table has a lot of extent, due to pattern comparison.                       "

sleep 10

echo "#                                                                               "
echo "# The new version will still offer this pattern comparison, but as an optional  "
echo "# behavior using the '--pattern' option.                                        "

sleep 5

echo "#                                                                               "
echo "# The default behavior of the command is now to make exact comparisons.         "

sleep 5

echo "#                                                                               "
echo "#                                                                               "
echo "# Considering a phobos system with a directory and objects already pushed:       "
echo "$ phobos object list --output all"
phobos object list --output all

sleep 10

echo "#                                                                               "
echo "#                                                                               "
echo "# Here are the extents associated with each object:       "
echo "$ phobos extent list --output all"
phobos extent list --output all

sleep 10

echo "#                                                                               "
echo "#                                                                               "
echo "# There are the results of the different commands when targetting 'dummy':       "
echo "$ phobos extent list --output all dummy "
phobos extent list --output all dummy

sleep 10

echo "#                                                                               "
echo "#                                                                               "
echo "$ phobos extent list --output all --pattern dummy"
phobos extent list --output all --pattern dummy

sleep 10

echo "#                                                                               "
echo "#                                                                               "
echo "# We can also have multiple oids/patterns:                                      "
echo "$ phobos extent list --output all --pattern blob ummy"
phobos extent list --output all --pattern blob ummy

sleep 10

echo "#                                                                               "
echo "#                                                                               "
echo "# Last time, we also mentionned that we could search multiple              "
echo "# oids/patterns using object list, but it wasn't implemented yet.               "
echo "# It is now working and usable :)                                               "
echo "$ phobos object list --output all --pattern blob ummy"
phobos object list --output all --pattern blob ummy

sleep 10

echo "#                                                                               "
echo "# End of demonstration                                                          "
exit
