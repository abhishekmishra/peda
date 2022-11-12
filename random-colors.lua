local term = require 'term'
local colors = term.colors

function command_result(command, ...)
    local handle = io.popen(command, ...)
    local res = handle:read('*a')
    handle:close()
    return res
end

local rows = tonumber(command_result('tput lines'))
local cols = tonumber(command_result('tput cols'))

term.clear()

for i=1,rows do
    for j=1,cols do
        term.cursor.jump(i, j)
        io.write('█')
    end
end

io.read()
