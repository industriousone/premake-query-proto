---
-- fields/kinds/list.lua
--
-- Author Jason Perkins
-- Copyright (c) 2014-2017 Jason Perkins and the Premake project
--
-- A data handler for the "list" field type.
---

	local m = {}


	function m.empty()
		return {}
	end



	function m.merge(field, currentValue, newValue, nextMutator)
		currentValue = currentValue or m.empty()

		newValue = table.flatten({ newValue })

		local n = #newValue
		for i = 1, n do
			local value = nextMutator(field, nil, newValue[i])
			table.insert(currentValue, value)
		end

		return currentValue
	end


	return m

