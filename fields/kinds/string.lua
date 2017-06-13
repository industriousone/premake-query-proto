---
-- fields/kinds/string.lua
--
-- Author Jason Perkins
-- Copyright (c) 2014-2017 Jason Perkins and the Premake project
--
-- A data handler for the "string" field type.
---

	local m = {}



	function m.merge(field, currentValue, newValue, nextMutator)
		if type(newValue) == "table" then
			error { msg = "expected string; got table" }
		end

		-- if newValue ~= nil then
		-- 	local err
		-- 	newValue, err = api.checkValue(field, newValue)
		-- 	if err then
		-- 		error { msg = err }
		-- 	end
		-- end

		return newValue
	end



	return m
