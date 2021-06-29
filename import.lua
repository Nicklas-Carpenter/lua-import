strings = require("useful.strings")
split = strings.split

Import = { }

local function import_star(words)
	if words[2] ~= "from" or #words > 3 then
		error('expected statement of the form "* from <mod>"')
	end
	
	local success, result =  pcall(require, words[3])
	
	if not success then
		error(result:gsub(":.*$", ""))
	end

	-- Extract each member from the mmodule into the global
	-- namespace.
	for k, v in pairs(result) do
		load(string.format("%s = ... ", k))(v)
	end
end

function Import.import(statement)
	assert(type(statement) == 'string', "expected string")	
	local substatements = statement:split(";")

	for _, v in ipairs(substatements) do
		-- import[[* from <module>]]
		if v:sub(1,1) = "*" then
			import_star(v)
		
		else
			first, last = v:find("from", 1, true)
			if first then
				import_individuals(first, last)
			end
				
		-- Importing a single member
			
		end
	end
end
