---
-- fields/tests/test_strings.lua
--
-- Author Jason Perkins
-- Copyright (c) 2017 Jason Perkins and the Premake project
---

	local suite = test.declare("field_strings")

	local Field = require("fields")


---
-- Setup
---

	local f

	function suite.setup()
		f = Field.new("language", "string", {
			allowed = { "C", "C++", "C#" }
		})
	end



---
-- Empty value should be an nil.
---

	function suite.emptyValue_isNil()
		local value = f:emptyValue()
		test.isnil(value)
	end


---
-- New values overwrite old values.
---

	function suite.merge_onInitialSet()
		local value = f:merge(nil, "C")
		test.isequal("C", value)
	end

	function suite.merge_overwritesOnNextSet()
		local value = f:merge("C", "C++")
		test.isequal("C++", value)
	end



---
-- Returns the canonical version of allowed values.
---

	function suite.merge_usesCanonicalVersionOfAllowedValue()
		local value = f:merge(nil, "c#")
		test.isequal("C#", value)
	end


---
-- Raises an error on attempt to set a table value.
---

	function suite.merge_raisesError_onTableValue()
		local ok, err = pcall(function ()
			f:merge(nil, { "C" })
		end)
		test.isfalse(ok)
	end



---
-- Raises an error if value is not in the allowed values list.
---

	function suite.merge_raisesError_onValueNotAllowed()
		local ok, err = pcall(function ()
			f:merge(nil, "Cobol")
		end)
		test.isfalse(ok)
	end



---
-- Warns if a deprecated value is used.
---
