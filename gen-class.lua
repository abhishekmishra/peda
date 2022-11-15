--[[
gen-class.lua: generate a class declaration(hpp) and definition(cpp) file
	given a class name.

author: Abhishek Mishra
date  : 15/11/2022
--]]

local etlua = require "etlua"
local cpptemplate = etlua.compile([[
#include "<%- classname %>.hpp"

<%- classname %>::<%- classname %>()
{
};

<%- classname %>::~<%- classname %>()
{
};

]])

local hpptemplate = etlua.compile([[
#pragma once

#ifndef <%- classname:upper() %>_H
#define <%- classname:upper() %>_H

class <%- classname %>
{

public:
    <%- classname %>();
    ~<%- classname %>();

};

#endif // <%- classname:upper() %>_H
]])

function usage()
	print('gen-class.lua: generate a class declaration(hpp) and definition(cpp) file')
	print()
	print('Usage')
	print('	lua gen-class.lua classname')
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
config.classname = arg[1]
config.runargs = ''

local cppoutput = cpptemplate(config)
local cppfile = io.open(config.classname .. '.cpp', 'w')
cppfile:write(cppoutput)
cppfile:close()

local hppoutput = hpptemplate(config)
local hppfile = io.open(config.classname .. '.hpp', 'w')
hppfile:write(hppoutput)
hppfile:close()

print('Wrote cpp and hpp file!')
