#!/bin/bash

LUA_VERSION=5.4.4
WORK_DIR=~/tmp/luainstall

# top folder of lua install where
# bin, lib, share etc. dirs are found
LUA_INSTALL_TOP_DIR=$WORK_DIR/install

# create workdir if it does not exist
mkdir -p ${WORK_DIR}

cd ${WORK_DIR}
curl -R -O http://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz
tar zxf lua-${LUA_VERSION}.tar.gz
cd lua-${LUA_VERSION}
make all test
make install INSTALL_TOP=${LUA_INSTALL_TOP_DIR}
cd -

rm -fR ${WORK_DIR}/lua-${LUA_VERSION}
rm ${WORK_DIR}/lua-${LUA_VERSION}.tar.gz
