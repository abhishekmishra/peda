#!/usr/bin/env lua

--[[
peda.lua: util methods to build commands for cli etc.

date: 13/02/2022
author: Abhishek Mishra

changes:
* 08/10/2022 - renamed all cmdpeda to peda, and added to public repo
* 11/03/2022 - adding some documentation, log levels
--]] --
-- global list of commands
local _COMMANDS = {}

-- a peda app config
local _CMDPEDA_APP = {
    name = nil,
    description = nil,
    version = nil
}

-- the default command
local _CMDPEDA_DEFAULT_CMD = nil

-- log levels
local _CMDPEDA_LOG_LEVELS = {
    fatal = 1,
    warn = 2,
    info = 3
}

-- current log level
local _CMDPEDA_LOG_LEVEL = "info"

local function setLogLevel(level)
    if _CMDPEDA_LOG_LEVELS[level] ~= nil then
        _CMDPEDA_LOG_LEVEL = level
    else
        error("unknown log level " .. level)
    end
end

local function setDefaultCommand(cmdName)
    _CMDPEDA_DEFAULT_CMD = cmdName
end

local function getDefaultCommand()
    return _CMDPEDA_DEFAULT_CMD
end

local function message(level, ...)
    local mesg_prefix = string.format('%s: %s: ', _CMDPEDA_APP.name, level)
    io.write(mesg_prefix)
    print(...)
    if level == "fatal" then
        error(..., 3)
    end
end

local function info(...)
    if _CMDPEDA_LOG_LEVELS[_CMDPEDA_LOG_LEVEL] >= _CMDPEDA_LOG_LEVELS['info'] then
        message("info", ...)
    end
end

local function warn(...)
    if _CMDPEDA_LOG_LEVELS[_CMDPEDA_LOG_LEVEL] >= _CMDPEDA_LOG_LEVELS['warn'] then
        message("warn", ...)
    end
end

local function fatal(...)
    if _CMDPEDA_LOG_LEVELS[_CMDPEDA_LOG_LEVEL] >= _CMDPEDA_LOG_LEVELS['fatal'] then
        message("fatal", ...)
    end
end

local function addCommand(cmdname, cmdfn, cmddesc, ...)
    if cmdfn == nil then
        error('command function cannot be nil')
    end

    if cmdname == nil then
        error('command name cannot be nil')
    end

    local cmddesc = cmddesc or ''

    local cmdprops = table.pack(...)
    cmdprops['___fn'] = cmdfn
    cmdprops['___name'] = cmdname
    cmdprops['___description'] = cmddesc

    if _COMMANDS[cmdname] then
        warn('command definition for ' .. cmdname .. ' is replaced.')
    end
    _COMMANDS[cmdname] = cmdprops
end

local function hasCommand(cmdname)
    return _COMMANDS[cmdname] ~= nil
end

local function runCommand(cmdname, ...)
    if cmdname == nil then
        error('command name is nil')
    end

    if not hasCommand(cmdname) then
        error('command ' .. cmdname .. ' not found.')
    end

    local cmdprops = _COMMANDS[cmdname]
    if cmdprops == nil then
        error('command properties empty.')
    end

    if cmdprops['___fn'] then
        info('running command -> ' .. cmdname)
        return cmdprops['___fn'](...)
    else
        error('command function not found')
    end
end

local function Command(t)
    local nm = t.name or nil
    local fn = t.fn or nil
    local desc = t.description or nil

    t.name = nil
    t.fn = nil
    t.desc = nil

    addCommand(nm, fn, desc, table.unpack(t))
end

local function App(t)
    _CMDPEDA_APP.name = t.name or nil
    _CMDPEDA_APP.version = t.version or nil
    _CMDPEDA_APP.description = t.description or nil
end

Command {
    name = 'list',
    description = 'list all commands available',
    fn = function(...)
        print('\nList of available build commands \n')
        print('================================ \n')
        for k, v in pairs(_COMMANDS) do
            print(k .. ' :\n\t' .. _COMMANDS[k].___description .. '\n')
            --[[
			local cmdprops = _COMMANDS[k]
			for k1, v1 in pairs(cmdprops) do
				print(k1 .. ' ' .. tostring(v1))
			end
			--]]
        end
    end
}

local function main()
    if #arg > 0 then
        cmd = arg[1]
        if hasCommand(cmd) then
            runCommand(cmd, table.unpack(arg, 2))
        else
            error('Command not found -> ' .. cmd)
        end
    else
        runCommand(getDefaultCommand())
    end
end

return {
    message = message,
    info = info,
    warn = warn,
    fatal = fatal,
    setLogLevel = setLogLevel,
    addCommand = addCommand,
    hasCommand = hasCommand,
    runCommand = runCommand,
    setDefaultCommand = setDefaultCommand,
    getDefaultCommand = getDefaultCommand,
    Command = Command,
    App = App,
    main = main
}
