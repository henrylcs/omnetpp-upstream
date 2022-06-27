#!/bin/bash -e

echo "Installing extra packages"
if [ -f /etc/debian_version ] ; then
	echo "Running on debian/ubuntu, using apt"
	sudo apt-get install -y build-essential gcc g++ bison flex perl \
	 python python3 qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libqt5opengl5-dev tcl-dev tk-dev \
	 libxml2-dev zlib1g-dev default-jre doxygen graphviz libwebkitgtk-1.0 libopenscenegraph-dev openscenegraph
elif [ -f /etc/SUSE-brand ] ; then
	echo "Running on SuSE, using zypper"
	sudo zypper -n install --type pattern devel_basis
	sudo zypper -n install qt5ct tcl-devel tk-devel libxml2-devel \
		zlib-devel doxygen graphviz python-xml qtermwidget-qt5-devel \
		libQt5OpenGL-devel libQt5PrintSupport-devel
else
	echo "Unsupported linux distribution!"
	exit 1
fi

mkdir -p bin
source setenv -f
#./configure

echo "Compiling OMNetC++"
NUM_PROCS=$(getconf _NPROCESSORS_ONLN)
make -j $NUM_PROCS

echo "Compiling INET"
cd samples/inet
source setenv -f
make makefiles
make -j $NUM_PROCS

echo "OMNetC++/INET is ready"
