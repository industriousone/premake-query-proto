local m = {}

-- Set up ":" style calling

	local metatable = {
		__index = function(self, key)
			return m[key]
		end
	}


---
-- Construct a new Array object.
---

	function m.new(data)
		local self = data or {}
		setmetatable(self, metatable)
		return self
	end



---
-- Append a new value to the end of the array.
---

	function m.append(self, ...)
		local values = { ... }
		local n = #values
		for i = 1, n do
			table.insert(self, values[i])
		end
		return self
	end



return m
