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
		f = Field.new("language", "string")
	end



---
-- New values overwrite old values.
---

	function suite.merge_onInitialSet()
		local value = f:merge(nil, "NewValue")
		test.isequal("NewValue", value)
	end

	function suite.merge_overwritesOnNextSet()
		local value = f:merge("Value1", "Value2")
		test.isequal("Value2", value)
	end



---
-- Raises an error on attempt to set a table value.
---

	function suite.merge_raisesError_onTableValue()
		local ok, err = pcall(function ()
			f:merge(nil, { "NewValue" })
		end)
		test.isfalse(ok)
	end



---
-- Raises an error if value is not in the allowed values list.
---

