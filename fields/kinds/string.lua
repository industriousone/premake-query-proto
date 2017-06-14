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

		if newValue ~= nil and field.properties.allowed ~= nil then
			local value, err = m._checkAllowedValues(field, newValue)
			if err then
				error { msg = err }
			end
		end

		return newValue
	end



	function m._checkAllowedValues(field, newValue)
		local canonical

		local allowed = field.properties.allowed
		local aliases = field.properties.aliases

		if aliases then
			m._findCaseInsensitiveValueInList(aliases, newValue)
		end

		if not canonical then
			if type(allowed) == "function" then
				canonical = allowed(value, "string")
			else
				canonical = m._findCaseInsensitiveValueInList(allowed, newValue)
			end
		end

		if not canonical then
			return nil, "invalid value '" .. value .. "' for " .. field.name
		end

		-- if field.deprecated and field.deprecated[canonical] then
		-- 	local handler = field.deprecated[canonical]
		-- 	handler.add(canonical)
		-- 	if handler.message and api._deprecations ~= "off" then
		-- 		local caller =  filelineinfo(9)
		-- 		local key = field.name .. "_" .. value .. "_" .. caller
		-- 		p.warnOnce(key, "the %s value %s has been deprecated and will be removed.\n   %s\n   @%s\n", field.name, canonical, handler.message, caller)
		-- 		if api._deprecations == "error" then
		-- 			return nil, "deprecation errors enabled"
		-- 		end
		-- 	end
		-- end

		return canonical
	end



	function m._findCaseInsensitiveValueInList(list, value)
		local result

		local loweredValue = value:lower()

		for _, value in pairs(list) do
			if value:lower() == loweredValue then
				result = value
			end
		end

		return result
	end


	return m
