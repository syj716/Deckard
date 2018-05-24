#!/bin/sh

# Define the following DEBUGFLAGS to enable debug build
# The default value for DEBUGFLAGS may be conditionally defined in the makefile for each module
#export DEBUGFLAGS="-g -pg"
# This way is similar to enable the following two (depending on the way invoked makefiles are defined): 
#export CFLAGS="-g -pg"
#export CXXFLAGS="-g -pg"

# re-compile parse tree generators
(
cd ../ptgen/ || exit 1
make clean
make
errcode=$?
if [ $errcode -ne 0 ]; then
	echo "Error: ptgen make failed. Exit."
	exit $errcode
fi
)

# re-compile vector generator and vector grouping code
(
cd ../vgen/treeTra/ || exit 1
rm -f *.d
make clean
make
errcode=$?
if [ $errcode -ne 0 ]; then
	echo "Error: vcgen make failed. Exit."
	exit 1
fi
cd ../vgrouping/ || exit 1
make clean
make
errcode=$?
if [ $errcode -ne 0 ]; then
	echo "Error: vgrouping make failed. Exit."
	exit $errcode
fi
)

# re-compile code for main entries
make clean
make
errcode=$?
if [ $errcode -ne 0 ]; then
	echo "Error: main make failed. Exit."
	exit $errcode
fi

# re-compile LSH
(
cd ../lsh/ || exit 1
make clean_all
make
errcode=$?
if [ $errcode -ne 0 ]; then
	echo "error: lsh make failed. exit."
	exit $errcode
fi
)

# re-compile additional library code for trees and graphs
(
cd ../lib || exit 1
make clean
make
errcode=$?
if [ $errcode -ne 0 ]; then
	echo "error: lib make failed. exit."
	exit $errcode
fi
)

# compile additional tests
(
cd ../ptgen/sol || exit 1
make test
errcode=$?
if [ $errcode -ne 0 ]; then
	echo "Error: ptgen/sol 'make test' failed. Exit."
	exit $errcode
fi
)
