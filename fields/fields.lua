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
--
-- For historical reasons, fields don't store the value of a particular setting, but
-- rather provide a (purely functional) set of methods for manipulating values, which
-- must be stored elsewhere.
---

	local m = {}


	m._mutators = {
		empty = {},
		merge = {},
		remove = {}
	}

	m._valueTypes = {}



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
-- @param properties
--    A arbitrary key-value list of properties to be associated with the field.
--    It can be accessed as `f.properties` once the field is created. This may
--    contain any arbitrary set of values, but certain keys may have meaning to
--    specific value types, e.g. "allowed" is recognized by the "string" value
--    type as the list of values that may be stored in the field.
-- @return
--    A populated field object, or nil and an error message if the field could not
--    be registered successfully.
---

	function m.new(name, valueType, properties)
		local self = {
			name = name,
			properties = properties or {},
			valueType = valueType
		}
		setmetatable(self, metatable)
		return self
	end



---
-- Return the appropriate "empty" value for the field. For collections this
-- would be a table or one of Premake's collection classes. For simple values
-- it would be a nil.
---

	function m.emptyValue(self)
		local mutator = self:mutator("empty")
		if mutator then
			return mutator(self)
		else
			return nil
		end
	end



---
-- Merge new and old values together, taking the field's data type description
-- into account. Simple values will overwrite, collection values will merge.
--
-- @param oldValue
--   The original value of the field.
-- @param newValue
--   The new value being set on the field.
-- @return
--    The new field value.
---

	function m.merge(self, oldValue, newValue)
		local mutator = self:mutator("merge")
		if mutator then
			return mutator(self, oldValue, newValue)
		else
			return newValue
		end
	end


---
-- Assemble a mutator function to to apply a specific type of change to a
-- field's values. Mutators include:
--
--  * "merge" to assign a new value to a field; may merge or overwrite.
--  * "remove" to remove previously set values from a collection field.
--
-- The generated mutator function expects to receive the target field
-- instance, the current value of that field, and the new value to be
-- stored or removed. It performs the appropriate mutation, and returns
-- the result.
--
-- I assemble mutators in this dynamic way to enable complex value types
-- to be created from more primitve types. For example "list:string" is
-- an ordered collection of strings. Other examples include "list:integer"
-- or even "list:list:string".
--
-- @param method
--    The type of mutator function required, one of "assign" or "remove".
-- @return
--    A corresponding mutator function
--    An accessor function for the field's kind and method. May return
--    nil if no processing functions are available for the given method.
---

	function m.mutator(self, method)
		-- These are kind of expensive to build and tend to be reused so cache
		local cache = m._mutators[method]

		-- Helper function recurses over each piece of the field's value type,
		-- building up the mutator function as it goes.
		local function mutatorForValueType(valueType)

			-- Have I hit the end of the type definition string? End recursion.
			if valueType == "" then
				return nil
			end

			-- Have I already cached a mutator for the requested type?
			if cache[valueType] then
				return cache[valueType]
			end

			-- Split of the first piece of the value type. If the incoming
			-- type is "list:key:string", thisValueType will be "list" and
			-- nextValueType will be "key:string".
			local thisValueType = valueType:match('(.-):') or valueType
			local nextValueType = valueType:sub(#thisValueType + 2)

			-- Get the processor for this specific bit of the value type,
			-- e.g. the processor for "list".
			local processors = m._valueTypes[thisValueType]
			if not processors then
				return nil, "Invalid field value type '" .. thisValueType .. "'"
			end

			local processor = processors[method]
			if not processor then
				return nil
			end

			-- Now recurse to get a mutator function for the remaining parts of
			-- of the field's value type. If the type was "list:key:string", then
			-- the processor function handles the "list" part, and this mutator
			-- takes care of the "key:string" part.
			local nextMutator = mutatorForValueType(nextValueType)

			-- Now here's the magic: wrap the processor and the next mutator
			-- up together into a Matryoshka doll of function calls, each call
			-- handling just it's level of the value type.
			local mutator = function(self, currentValue, newValue)
				return processor(self, currentValue, newValue, nextMutator)
			end

			-- And cache the result so I don't have to go through that again
			cache[valueType] = mutator
			return mutator
		end

		return mutatorForValueType(self.valueType)
	end



---
-- Register a new kind of data for field storage.
--
-- @param tag
--    A unique name of the kind; used in the kind string in new field
--    definitions (see new(), above).
-- @param settings
--    A table containing the processor functions for the new kind. If
--    nil, no change is made to the current field settings.
-- @return
--    The settings table for the specified tag.
---

	function m.registerValueType(tag, settings)
		if settings then
			m._valueTypes[tag] = settings
		end
		return m._valueTypes[tag]
	end




	function m.remove(self, currentValue, valuesToRemove)
		local mutator = self:mutator("remove")
		if mutator then
			return mutator(self, currentValue, valuesToRemove)
		end
	end



---
-- Register all of the built-in field data types.
---

	m.registerValueType("list", dofile("kinds/list.lua"))
	m.registerValueType("string", dofile("kinds/string.lua"))


	return m
