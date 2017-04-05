local m = {}

-- Set up ":" style calling

	local metatable = {
		__index = function(self, key)
			return m[key]
		end
	}


---
-- Construct a new Settings object.
---

	function m.new()
		local self = {
			conditions = {},
			data = {}
		}
		setmetatable(self, metatable)
		return self
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
