#!/usr/bin/env lua

local etlua = require "etlua"
local template = etlua.compile([[
.PHONY: all genbuild delbuild build run clean install help sln

# see https://gist.github.com/sighingnow/deee806603ec9274fd47
# for details on the following snippet to get the OS
# (removed the flags about arch as it is not needed for now)
OSFLAG :=
ifeq ($(OS),Windows_NT)
	OSFLAG = WIN32
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		OSFLAG = LINUX
	endif
	ifeq ($(UNAME_S),Darwin)
		OSFLAG = OSX
	endif
endif

all: clean build run

genbuild:
ifeq ($(OSFLAG),WIN32)
	cmake . -B <%= builddir %> -DCMAKE_TOOLCHAIN_FILE=D:/vcpkg/scripts/buildsystems/vcpkg.cmake -DCMAKE_INSTALL_PREFIX=./install
else
	cmake . -B <%= builddir %> -DCMAKE_TOOLCHAIN_FILE=${VCPKG_HOME}/scripts/buildsystems/vcpkg.cmake -DCMAKE_INSTALL_PREFIX=./install
endif

delbuild:
	rm -fR <%= builddir %>

build:
	cmake --build <%= builddir %>

run:
ifeq ($(OSFLAG),WIN32)
	<%= builddir %>/bin/Debug/<%= projectname %> <%= runargs %>
#uncomment the lines below to run macos bundles (if build produces one on macos)
#else ifeq ($(OSFLAG),OSX)
#	#open -n <%= builddir %>/bin/<%= projectname %>.app --args <%= runargs %>
#	<%= builddir %>/bin/<%= projectname %>.app/Contents/MacOS/<%= projectname %> --args <%= runargs %>
else
	<%= builddir %>/bin/<%= projectname %> <%= runargs %>
endif

clean:
	cmake --build <%= builddir %> --target clean

install:
	cmake --build <%= builddir %> --target install

sln:
ifeq ($(OSFLAG),WIN32)
	cygstart ".\build\<%= projectname %>.sln"
else
	echo "No solution file available on this platform"
endif

help:
		@echo "********************************************************"
		@echo "  Makefile to build [<%= projectname %>]"
		@echo "  (generated by gen-makefile.lua script)"
		@echo "********************************************************"
		@echo "  (The project uses CMake. This Makefile provides"
		@echo "   convenient shortcuts to common build tasks.)"
		@echo ""
		@echo "  all:      Runs the clean, build, and run targets."
		@echo "  build:    Runs the cmake project build target."
		@echo "  run:      Runs the debug executable."
		@echo "  clean:    Runs the cmake project clean target."
		@echo "  install:  Runs the cmake project install target."
		@echo "  delbuild: Deletes the cmake build directory!"
		@echo "  genbuild: Generates the cmake build."
		@echo "********************************************************"
]])

function usage()
	print('gen-makefile.lua: generate a Makefile to run common cmake project tasks')
	print()
	print('Usage')
	print('	lua gen-makefile.lua <project name> [<run args>*]')
end

if arg[1] == nil then
	print('Error:: Project name is required!')
	print()
	usage()
	return
end

if arg[1] == '-h' or arg[1] == '--help' then
	usage()
	return
end

local config = {}
config.builddir = './build'
config.projectname = arg[1]
config.runargs = ''
local ac = 2
while arg[ac] ~= nil do
	config.runargs = config.runargs .. ' ' .. arg[ac]
	ac = ac + 1
end

local output = template(config)
local mkfile = io.open('Makefile', 'w')
mkfile:write(output)
mkfile:close()

print('Wrote Makefile!')
