#!/usr/bin/env lua

--[[
    peda.lua: kitchen sink of command line utilities for common c/c++/lua dev tasks
    author: Abhishek Mishra
    date: 9th Nov 2022
]]--

local cli = require 'cliargs'

local ABOUT = {
    VERSION = "0.0.1a",
    AUTHOR = "Abhishek Mishra",
    PROGRAM_NAME = "cliargs.lua",
}

-- this is called when the flag -v or --version is set
local function print_version()
    print(ABOUT.PROGRAM_NAME .. ": version " .. ABOUT.VERSION)
    print("lua_cliargs: version " .. cli.VERSION)
    os.exit(0)
end

cli:set_name(ABOUT.PROGRAM_NAME)

-- A flag with both the short-key and --expanded-key notations, and callback function
cli:flag("-v, --version", "prints the program's version and exits", print_version)

-- Parses from _G['arg']
local args, err = cli:parse(arg)

if not args and err then
  -- something wrong happened and an error was printed
  print(string.format('%s: %s; re-run with help for usage', cli.name, err))
  os.exit(1)
end

for k, v in ipairs(args) do
    print(k .. v)
end
