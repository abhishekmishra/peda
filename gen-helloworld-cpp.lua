--[[
gen-helloworld-cpp.lua: generates a main.cpp with helloworld, and a cmake build CMakeLists.txt.

author: Abhishek Mishra
date  : 16/11/2022
--]]

local etlua = require "etlua"
local hwtemplate = etlua.compile([[
#include <iostream>

using namespace std;

int main(int argc, char* argv[])
{
	cout << "hello world\n";
	return 0;
}]])

local cmtemplate = etlua.compile([[
cmake_minimum_required(VERSION 3.22)

# set the CPP standard to 17
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# set the cmake build directory to bin
# https://stackoverflow.com/a/47260387/9483968
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

project(<%- projectname %> <%- lang %>)

add_executable(<%- projectname %>
	main.cpp
)
]])

function usage()
	print('gen-helloworld-cpp.lua: generate a main.cpp hello world program,')
	print('	and a CMakeLists.txt cmake build file.')
	print()
	print('Usage')
	print('	lua gen-helloworld-cpp.lua projectname')
end

if arg[1] == nil then
	print('Error:: Class name is required!')
	print()
	usage()
	return
end

if arg[1] == '-h' or arg[1] == '--help' then
	usage()
	return
end

local config = {}
config.projectname = arg[1]
config.lang = 'CXX'
config.runargs = ''

local hwoutput = hwtemplate(config)
local hwfile = io.open('main.cpp', 'w')
hwfile:write(hwoutput)
hwfile:close()

local cmoutput = cmtemplate(config)
local cmfile = io.open('CMakeLists.txt', 'w')
cmfile:write(cmoutput)
cmfile:close()

print('Wrote helloworld cmake project!')
