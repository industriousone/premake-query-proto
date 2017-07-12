---
-- fields/kinds/list.lua
--
-- Author Jason Perkins
-- Copyright (c) 2014-2017 Jason Perkins and the Premake project
--
-- A data handler for the "list" field type.
---

	local m = {}


	local function removeAll(list, pattern)
		local n = #list

		for i = n, 1, -1 do
			local value = list[i]
			if value == pattern then
				table.remove(list, i)
			end
		end

		return list
	end



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



	function m.remove(field, currentValue, valuesToRemove, nextMutator)
		currentValue = currentValue or m.empty()

		valuesToRemove = table.flatten({ valuesToRemove })

		local n = #valuesToRemove
		for i = 1, n do
			local pattern = valuesToRemove[i]
			currentValue = removeAll(currentValue, pattern)
		end

		return currentValue
	end


	return m

