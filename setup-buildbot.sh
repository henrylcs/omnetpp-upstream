#!/bin/bash -e

BUILT_STAMP="${PWD}/built.stamp"
CURRENT_REVISION=$(git rev-parse HEAD)
BUILT_REVISION=$(cat $BUILT_STAMP 2> /dev/null || echo "")

if [ "$BUILT_REVISION" == "$CURRENT_REVISION" ] ; then
	echo "Looks like we're up-to-date"
	exit 0
fi

mkdir -p bin
source setenv -f
./configure

echo "Compiling OMNetC++"
NUM_PROCS=$(getconf _NPROCESSORS_ONLN)
make -j $NUM_PROCS

echo "Compiling INET"
cd samples/inet
make makefiles
make -j $NUM_PROCS

echo "OMNetC++/INET is ready"
echo "$CURRENT_REVISION"  > "$BUILT_STAMP"
