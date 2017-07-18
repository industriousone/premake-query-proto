---
-- settings/tests/test_settings.lua
--
-- Author Jason Perkins
-- Copyright (c) 2017 Jason Perkins and the Premake project
---

	local suite = test.declare("settings")

	local Settings = require("settings")
	local Conditions = require("conditions")


---
-- Construct a new object.
---

	function suite.createNewUnfilteredInstance()
		local s = Settings.new()
		test.isnotnil(s)
	end

	function suite.createNew_withConditions()
		local s = Settings.new { workspaces = "Workspace1" }
		test.isnotnil(s)
	end


---
-- Round-trip some values.
---

	function suite.canRoundtripSimpleValue()
		local s = Settings.new():put("key", "value")
		test.isequal("value", s:get("key"))
	end


	function suite.canRoundtripListValue()
		local s = Settings.new():put("key", { "value1", "value2" })
		test.isequal({ "value1", "value2" }, s:get("key"))
	end


---
-- Sanity check the condition testing.
---

	function suite.appliesTo_passesOnMatch()
		local s = Settings.new({ workspaces = "Workspace1" })
		test.istrue(s:appliesTo { workspaces = "Workspace1" })
	end

	function suite.appliesTo_failsOnMismatch()
		local s = Settings.new({ workspaces = "Workspace2" })
		test.isfalse(s:appliesTo { workspaces = "Workspace1" })
	end
