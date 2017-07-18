---
-- query/query.lua
--
-- Author Jason Perkins
-- Copyright (c) 2016-2017 Jason Perkins and the Premake project
---


	local m = {}


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
--
-- @param settings
--    The array of Settings objects to be queried.
-- @param environment
--    A key-value table representing the current evaluation environment. This
--    is usually specified via `filter()` instead. May be `nil`.
-- @return
--    A new Query object.
---

	function m.new(settings, environment)
		local self = {
			_settings = settings or {},
			_environment = environment or {}
		}
		setmetatable(self, metatable)
		return self
	end



---
-- Fetch a value.
---

	function m.fetch(self, key)
		local value

		local settings = self._settings
		local environment = self._environment

		local n = #settings
		for i = 1, n do
			local s = settings[i]
			if s:appliesTo(environment) then
				value = s:get(key)
			end

		end

		return value
	end



---
-- Apply a set of conditions to the query.
--
-- @param environment
--    A key-value table representing the current evaluation environment, e.g.
--    `{ workspace="Workspace1", project="Project1", system="Windows"}`.
-- @return
--    A new Query object with the additional environment settings.
---

	function m.filter(self, environment)
		local settings = rawget(self, "_settings")
		local q = m.new(settings, environment)
		return q
	end


return m
