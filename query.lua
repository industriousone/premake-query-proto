local m = {}


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

	function m.new(settings)
		local self = {
			_settings = settings
		}
		setmetatable(self, metatable)
		return self
	end



---
-- Fetch a value.
---

	function m.fetch(self, key)
		local value

		local blocks = self._settings
		local n = #blocks
		for i = 1, n do
			value = blocks[i]:get(key)
		end

		return value
	end



return m
