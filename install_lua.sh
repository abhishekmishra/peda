#!/bin/bash

# ****************************************************************************
# install_lua.sh: Install lua and luarocks
# author: Abhishek Mishra
# date: 09 Nov 2022
#
# This is mostly for unix like systems. This will not work on windows.
#
# Instructions for install are taken from the respective lua and luarocks docs.
# The script creates a work directory at ".luainstall" in the current directory
# and then cleans up the files in the folder at the end.
#
# ****************************************************************************

function usage {
	echo "Usage:"
	echo ""
	echo "	install_lua.sh <top_installation_folder>"
	echo ""
	echo "	where,"
	echo "		<top_installation_folder> is the installation folder"
	echo "			which constains the directories bin, lib, share etc."
	echo "			For a global install this could be /usr/local, and"
	echo "			for a user install this could be ~/local."
	echo ""
}

if [ $# -eq 0 ]
then
	echo "Error: No arguments supplied."
	echo ""
	usage
	exit
fi

CURRENT_DIR=`pwd`

LUA_VERSION=5.4.6
LUAROCKS_VERSION=3.9.2
WORK_DIR=.luainstall

# top folder of lua install where
# bin, lib, share etc. dirs are found
LUA_INSTALL_TOP_DIR=${1}

# create workdir if it does not exist
mkdir -p ${WORK_DIR}

# Download and install lua
# for instructions see lua documentation.
cd ${WORK_DIR}

curl -R -O https://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz

echo "********** Downloaded lua ..."

tar zxf lua-${LUA_VERSION}.tar.gz

echo "********** Unzip complete ..."

cd lua-${LUA_VERSION}
make all test
make install INSTALL_TOP=${LUA_INSTALL_TOP_DIR}

echo "********** Build+Install done ..."

cd ${CURRENT_DIR}

# Download and install luarocks
export PATH=${LUA_INSTALL_TOP_DIR}/bin:${PATH}
cd ${WORK_DIR}

curl -R -O https://luarocks.github.io/luarocks/releases/luarocks-${LUAROCKS_VERSION}.tar.gz

echo "********** Downloaded luarocks ..."

tar zxpf luarocks-${LUAROCKS_VERSION}.tar.gz

echo "********** Unzip complete ..."

cd luarocks-${LUAROCKS_VERSION}
./configure --prefix=${LUA_INSTALL_TOP_DIR}
make
make install

echo "********** Build+Install done ..."

# Return to current directory to clean-up
cd ${CURRENT_DIR}

rm -fR ${WORK_DIR}/lua-${LUA_VERSION}
rm ${WORK_DIR}/lua-${LUA_VERSION}.tar.gz
rm -fR ${WORK_DIR}/luarocks-${LUAROCKS_VERSION}
rm ${WORK_DIR}/luarocks-${LUAROCKS_VERSION}.tar.gz

rmdir ${WORK_DIR}

echo "********** Cleanup done ..."
