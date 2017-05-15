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
-- Compare two sets of conditions. All of the terms in this set must
-- be matched by a corresponding term in the other set to pass.
---

	function m.matches(self, conditions)
		local selfTerms = self.terms
		local otherTerms = conditions.terms

		for key, value in pairs(selfTerms) do
			if value ~= otherTerms[key] then
				return false
			end
		end

		return true
	end


return m
