---
-- settings/tests/test_settings.lua
--
-- Author Jason Perkins
-- Copyright (c) 2017 Jason Perkins and the Premake project
---

	local suite = test.declare("settings")

	local Settings = require("settings")



---
-- Setup
---

	local s

	function suite.setup()
		s = Settings.new()
	end



---
-- Construct a new, empty array.
---

	function suite.createNewUnfilteredInstance()
		test.isnotnil(s)
	end


---
-- Round-trip a simple value.
--

	function suite.canRoundtripSimpleValue()
		s:put("key", "value")
		test.isequal("value", s:get("key"))
	end
