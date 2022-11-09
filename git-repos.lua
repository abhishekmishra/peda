#!/usr/bin/env lua

--[[
    git-repos.lua: bulk operations on git repos
    author: Abhishek Mishra
    date: 9th Nov 2022
]]--

local cli = require 'cliargs'
local PATH = require "path"
require 'lfs'

local ABOUT = {
    VERSION = "0.0.1a",
    AUTHOR = "Abhishek Mishra",
    PROGRAM_NAME = "git-repos.lua",
}

-- this is called when the flag -v or --version is set
local function print_version()
    print(ABOUT.PROGRAM_NAME .. ": version " .. ABOUT.VERSION)
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

local config = {}

config.workspaces = {
	PATH.user_home() .. "/programs"
}

config.repos = {
	"~/dotfiles"
}

function pull_repo(repo)
	print('pulling remote for ' .. repo)
	os.execute('git -C ' .. repo .. ' pull')
end

function is_git_repo(dir)
	local dotgit_dir = PATH.join(dir, '.git')
	if PATH.isdir(dotgit_dir) then
		return true
	end
	return false
end

-- iterate over solo repos and pull them
for idx, repo in ipairs(config.repos) do
	pull_repo(repo)
end

-- iterate over entries in workspaces
-- and pull if any of them is a directory
-- which is a git repo
for idx, workspace in ipairs(config.workspaces) do
	-- print(PATH.abspath(workspace))
	for entry in lfs.dir(workspace) do
		-- print(entry)
		entry = PATH.join(workspace, entry)
		if PATH.isdir(entry) then
			-- print(entry .. ' is a directory')
			if is_git_repo(entry) then
				pull_repo(entry)
			end
		end
	end
end
