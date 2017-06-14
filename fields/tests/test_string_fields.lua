---
-- fields/tests/test_string_fields.lua
--
-- Author Jason Perkins
-- Copyright (c) 2017 Jason Perkins and the Premake project
---

	local suite = test.declare("field_string_fields")

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
