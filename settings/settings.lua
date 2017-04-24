---
-- settings/settings.lua
--
-- Author Jason Perkins
-- Copyright (c) 2017 Jason Perkins and the Premake project
---

	local m = {}

	local Conditions = require('conditions')


---
-- Set up ":" style calling
---

	local metatable = {
		__index = function(self, key)
			return m[key]
		end
	}


---
-- Construct a new Settings object.
---

	function m.new(conditions)
		local self = {
			conditions = Conditions.new(conditions),
			data = {}
		}
		setmetatable(self, metatable)
		return self
	end


---
-- Returns true if all of the terms in the provided conditions
-- are matched by the terms associated with this settings block.
---

	function m.appliesTo(self, conditions)
		return (conditions:matches(self.conditions))
	end



---
-- Retrieve a value by key.
---

	function m.get(self, key)
		return self.data[key]
	end


---
-- Store a value with the specified key.
---

	function m.put(self, key, value)
		self.data[key] = value
		return self
	end


return m
