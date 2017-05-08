---
-- query/query.lua
--
-- Author Jason Perkins
-- Copyright (c) 2016-2017 Jason Perkins and the Premake project
---


	local m = {}

	local Conditions = require('conditions')


---
-- Set up ":" style calling, and enable values to be fetched as
-- fields, e.g. `q.kind` instead of `q:fetch("kind")`
---

	local metatable = {
		__index = function(self, key)
			return m[key] or m.fetch(self, key)
		end
	}


---
-- Construct a new Query object.
--
-- Queries are evaluated lazily. They are cheap to create and extend.
---

	function m.new(settings, conditions)
		local self = {
			_settings = settings,
			_conditions = conditions
		}
		setmetatable(self, metatable)
		return self
	end



---
-- Fetch a value.
---

	function m.fetch(self, key)
		local value

		local conditions = rawget(self, "_conditions")

		local blocks = self._settings
		local n = #blocks
		for i = 1, n do
			local block = blocks[i]
			if conditions == nil or block:appliesTo(conditions) then
				value = blocks[i]:get(key)
			end
		end

		return value
	end


---
-- Apply a set of conditions to the query.
---

	function m.filter(self, conditions)
		local settings = rawget(self, "_settings")
		local q = m.new(settings, conditions)
		return q
	end


return m
