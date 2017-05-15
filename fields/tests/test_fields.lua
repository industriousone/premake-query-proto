---
-- fields/tests/test_fields.lua
--
-- Author Jason Perkins
-- Copyright (c) 2017 Jason Perkins and the Premake project
---

	local suite = test.declare("fields")

	local Field = require("fields")


---
-- Setup
---

	local f



---
-- Check object construction
---

	function suite.createStringField()
		f = Field.new("language", "string")
		test.isnil(s)
	end
