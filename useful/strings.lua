-- From https://github.com/msg/luajit-useful.git
-- Modified to remove LuaJIT dependencies so it can be used with
--regular Lua. Also added code to forward the library to the
-- builtin strings metatable to reduce the verbosity.
local strings = { }

local system		= require('useful.system')
local  unpack		=  system.unpack
local tables		= require('useful.tables')

local  insert		=  table.insert
local  concat		=  table.concat

local  byte		=  string.byte
local  char		=  string.char
local  rep		=  string.rep
local  sprintf		=  string.format
strings.lstrip		= function(s) return (s:gsub('^%s*', '')) end
strings.rstrip		= function(s) return (s:gsub('%s*$', '')) end
strings.strip		= function(s) return strings.lstrip(s:rstrip()) end
strings.join		= concat -- join(s, sep)

function strings.capitalize(s)
	return s:sub(1,1):upper() .. s:sub(2):lower()
end

function strings.split(s, sep, count)
	local fields = {}
	sep = sep or '%s+'
	count = count or #s
	local first, last
	local next = 0
	for _=1,count do
		first, last = s:find(sep, next + 1)
		if first == nil then break end
		insert(fields, s:sub(next + 1, first - 1))
		next = last
	end
	if next <= #s then
		insert(fields, s:sub(next + 1))
	end
	return fields
end

function strings.title(s)
	local fields = { }
	for i,field in ipairs(strings.split(s)) do
		fields[i] = strings.capitalize(field)
	end
	return strings.join(fields, ' ')
end

function strings.ljust(s, w, c)
	local l = #s
	if l > w then
		return s:sub(1, w)
	else
		return s .. rep(c or ' ', w-l)
	end
end

function strings.rjust(s, w, c)
	local l = #s
	if l > w then
		return s:sub(1, w)
	else
		return rep(c or ' ', w-l) .. s
	end
end

function strings.center(s, w, c)
	local l = #s
	if l > w then
		return s
	else
		local n = (w - l) / 2
		return rep(c or ' ', n) .. s .. rep(c or ' ', n)
	end
end

function strings.parse_ranges(str)
	local ranges = {}
	for _,range in ipairs(strings.split(str, ',')) do
		local s, e = unpack(
			tables.imap(strings.split(range, '-'), function (_,v)
				return tonumber(v)
			end)
		)
		e = e or s
		for i=s,e do
			insert(ranges, i)
		end
	end
	return ranges
end

local string_builtin_functions = getmetatable("").__index
for k, v in pairs(strings) do
	string_builtin_functions[k] = v
end

return strings
