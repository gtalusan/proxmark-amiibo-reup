local cmds = require('commands')
local getopt = require('getopt')
local ansicolors = require('ansicolors')

copyright = ''
author = 'George Talusan'
version = 'v0.0.1'
desc = [[
Infinitely re-up your Amiibo
]]
example = [[
    1. script run hf_mfu_amiibo_infinite_reup
    2. script run hf_mfu_amiibo_infinite_reup -f myfile
]]
usage = [[
script run hf_mfu_amiibo_infinite_reup [-h] [-f <filename>]
]]
arguments = [[
    -h             : this help
    -f             : filename for the datadump to read (bin)
]]

local DEBUG = false -- the debug flag

local sub = string.sub
local format = string.format

---
-- A debug printout-function
local function dbg(args)
    if not DEBUG then return end
    if type(args) == 'table' then
        local i = 1
        while result[i] do
            dbg(result[i])
            i = i+1
        end
    else
        print('###', args)
    end
end
---
-- This is only meant to be used when errors occur
local function oops(err)
    print('ERROR:', err)
    core.clearCommandBuffer()
    return nil, err
end
---
-- Usage help
local function help()
    print(copyright)
    print(author)
    print(version)
    print(desc)
    print(ansicolors.cyan..'Usage'..ansicolors.reset)
    print(usage)
    print(ansicolors.cyan..'Arguments'..ansicolors.reset)
    print(arguments)
    print(ansicolors.cyan..'Example usage'..ansicolors.reset)
    print(example)
end
--
-- Exit message
local function ExitMsg(msg)
    print( string.rep('--',20) )
    print( string.rep('--',20) )
    print(msg)
    print()
end

local function random_num_hex(length)
    local str = ''
    local i
    for i = 1, length, 1 do
        str = str..string.format("%x", math.random(0, 15))
    end
    return str
end

local function main(args)
    local result, err, hex
    local inputTemplate = 'dumpdata.bin'

    for o, a in getopt.getopt(args, 'hf:u:') do
        if o == 'h' then return help() end
        if o == 'f' then inputTemplate = a end
    end

    local tmp = ('%s.bin'):format(os.tmpname())
    while true do
        local uid = '04'..random_num_hex(12)
        core.console(('script run amiibo_change_uid %s %s %s %s'):format(uid, inputTemplate, tmp, core.search_file('resources/key_retail', '.bin')))
        core.console(('script run hf_mfu_amiibo_sim -f %s'):format(tmp))
    end
end
main(args)
