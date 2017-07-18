---
-- conditions/conditions.lua
--
-- Author Jason Perkins
-- Copyright (c) 2017 Jason Perkins and the Premake project
---

	local m = {}


---
-- Set up ":" style calling
---

	local metatable = {
		__index = function(self, key)
			return m[key]
		end
	}



---
-- Construct a new object.
---

	function m.new(terms)
		local self = {
			terms = terms or {}
		}
		setmetatable(self, metatable)
		return self
	end



---
-- Evaluates this set of conditions against a collection of key-value terms.
--
-- @return
--    True if all of the condition clauses are fully matched by the key-value
--    pairs in the specified environment.
---

	function m.matches(self, environment)
		local selfTerms = self.terms

		for key, value in pairs(selfTerms) do
			if value ~= environment[key] then
				return false
			end
		end

		return true
	end


return m
