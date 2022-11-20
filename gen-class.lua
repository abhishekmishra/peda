--[[
gen-class.lua: generate a class declaration(hpp) and definition(cpp) file
	given a class name.

author: Abhishek Mishra
date  : 15/11/2022
--]]

local cli = require 'cliargs'
local etlua = require "etlua"

local ABOUT = {
	VERSION = "0.0.2a",
	AUTHOR = "Abhishek Mishra",
	PROGRAM_NAME = "gen-class.lua",
}

-- this is called when the flag -v or --version is set
local function print_version()
	print(ABOUT.PROGRAM_NAME .. ": version " .. ABOUT.VERSION)
	print("lua_cliargs: version " .. cli.VERSION)
	os.exit(0)
end

cli:set_name(ABOUT.PROGRAM_NAME)
cli:set_description('generate a class declaration(hpp) and definition(cpp) file')
cli:argument('classname', 'classname to be generated')
cli:option('-n, --namespace=namespace', 'namespace of the class')
cli:flag("-v, --version", "prints the program's version and exits", print_version)

-- Parses from _G['arg']
local args, err = cli:parse(arg)

if (not args) and err and err ~= "" then
	print(string.format('%s: %s; re-run with help for detailed help', cli.name, err))
	os.exit(1)
end

print('generating class: ' .. args.classname .. ' with namespace ' .. tostring(args.namespace))
-- os.exit(0)

local cpptemplate = etlua.compile([[
#include "<%- classname %>.hpp"

<% if namespace ~= nil then %>
using namespace <%- namespace %>;
<% end %>

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

<% if namespace ~= nil then %>
namespace <%- namespace %>
{
<% end %>
	
class <%- classname %>
{

public:
    <%- classname %>();
    ~<%- classname %>();

};

<% if namespace ~= nil then %>
};
<% end %>
	
#endif // <%- classname:upper() %>_H
]])

local cppoutput = cpptemplate(args)
local cppfile = io.open(args.classname .. '.cpp', 'w')
if cppfile == nil then
	error('error opening cpp file ' .. args.classname .. '.cpp')
	return -1
else
	cppfile:write(cppoutput)
	cppfile:close()
end

local hppoutput = hpptemplate(args)
local hppfile = io.open(args.classname .. '.hpp', 'w')
if hppfile == nil then
	error('error opening cpp file ' .. args.classname .. '.hpp')
	return -1
else
	hppfile:write(hppoutput)
	hppfile:close()
end

print('Wrote cpp and hpp file!')
