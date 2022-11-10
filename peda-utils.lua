--[[
	peda-utils.lua: provides some util functions for use in other cli programs
	author: Abhishek Mishra
	date: 10th Nov 2022
]]--

local ABOUT = {
	VERSION = "0.0.1a",
	AUTHOR = "Abhishek Mishra",
	PROGRAM_NAME = "peda-utils.lua"
}

--[[
Based on https://stackoverflow.com/a/34325723
---------------------------------------------
Print iteration progress
Call in a loop to show terminal progress-bar.

@params:
    iteration   - Required  : current iteration (Int)
    total       - Required  : total iterations (Int)
    prefix      - Optional  : prefix string (Str)
    suffix      - Optional  : suffix string (Str)
    decimals    - Optional  : positive number of decimals in percent complete (Int)
    length      - Optional  : character length of bar (Int)
    fill        - Optional  : bar fill character (Str)
    printEnd    - Optional  : end character (e.g. "\r", "\r\n") (Str)
]]--
function progress_bar(iteration, total, prefix, suffix,
	decimals, length, fill, print_end)
	prefix = prefix or ''
	suffix = suffix or ''
	decimals = decimals or 1
	length = length or 50
	fill = fill or '█'
	print_end = print_end or '\r'

	percent = string.format("%." .. tostring(decimals) .. "f", 100 * (iteration * 1.0 / total))
	filledLength = length * math.ceil(iteration / total)
	bar = ''
	for i=1,filledLength do
		bar = bar .. fill
	end
	for i=1,(length - filledLength) do
		bar = bar .. '-'
	end
	io.write('\r' .. prefix .. "|" .. bar .. "|" .. percent .. "% " .. suffix .. print_end)
	-- Print New Line on Complete
	if iteration == total then
		print()
	end
end

progress_bar(0, 56, 'whaa', 'y', 2, nil, nil, nil)
for i=1,56 do
	progress_bar(i, 56, 'whaa', 'y', 2, nil, nil, nil)
end
