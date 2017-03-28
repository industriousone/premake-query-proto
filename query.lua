local m = {}


	local metatable = {
		__index = function(self, key)
			return m[key] or m.fetch(self, key)
		end
	}


---
-- Construct a new Query object.
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
		for i = 1, #blocks do
			value = blocks[i][key]
		end

		return value
	end


return m
