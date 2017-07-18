---
-- settings/settings.lua
--
-- Author Jason Perkins
-- Copyright (c) 2017 Jason Perkins and the Premake project
--
-- Settings represent a "chunk" of key-value configuration pairs, along with a set
-- of conditions under which those values should be applied. The configuration pairs
-- are the kinds of things you would set in a project script:
--
--  {
--    ["symbols"] = "On"
--    ["files"] = { "**.h", "**.cpp" }
--  }
--
-- Settings blocks do not try to interpret any of the values they are given; they
-- simply store the value pairs and hand them back again on request.
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

	function m.appliesTo(self, environment)
		return (self.conditions:matches(environment))
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


---
-- Mark a value for removal.
---

	function m.remove(self, key, value)
		return self
	end


return m
