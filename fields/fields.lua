---
-- fields/fields.lua
--
-- Author Jason Perkins
-- Copyright (c) 2014-2017 Jason Perkins and the Premake project
--
-- A field represents a configuration value that is set by a project script. It has
-- a name (e.g. "language") and a value (e.g. "C++"). Field values may be simple
-- primitives like strings and integers, or more complex types like lists and key-
-- value sets. The field system provides the ability to merge these complex value
-- types together, so that a field with values set at multiple points in a script
-- ends up with the correct, complete set of of values at the end.
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
-- Construct a new Field object.
--
-- @param name
--    A unique name for the new field.
-- @param valueType
--    A description of the values to be stored in this field, e.g. "string". More
--    complex types can be described by chaining together these together, e.g.
--    "list:string" to specify a list of string values.
--
-- @return
--    A populated field object, or nil and an error message if the field could not
--    be registered successfully.
---

	function m.new(name, valueType)
		local self = {
		}
		setmetatable(self, metatable)
		return self
	end



	return m
