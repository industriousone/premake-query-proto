---
-- query/tests/test_query.lua
--
-- Author Jason Perkins
-- Copyright (c) 2016-2017 Jason Perkins and the Premake project
---

	local suite = test.declare("query")

	local Query = require("query")

	local Array = require("array")
	local Settings = require("settings")



---
-- Setup
---

	local settings

	function suite.setup()
		settings = Array.new()
	end



---
-- Make sure I can construct a new query object.
---

	function suite.createNewQueryObject()
		local q = Query.new(settings)
		test.isnotnil(q)
	end


---
-- Fetch a simple value with no filtering and just a single block to consider.
---

	function suite.fetchGlobalValue_fromSingleBlock_withNoFiltering()
		settings:append(
			Settings.new():put("kind", "ConsoleApp")
		)

		local q = Query.new(settings)
		test.isequal("ConsoleApp", q:fetch("kind"))
	end


---
-- Fetch a simple value as a direct field.
---

	function suite.fetchGlobalValue_fromSingleBlock_withNoFiltering_asField()
		settings:append(
			Settings.new():put("kind", "ConsoleApp")
		)

		local q = Query.new(settings)
		test.isequal("ConsoleApp", q.kind)
	end


---
-- Fetch a simple value with no filtering but multiple blocks.
---

	function suite.fetchGlobalValue_fromMultipleBlocks_withNoFiltering()
		settings:append(
			Settings.new():put("kind", "ConsoleApp"),
			Settings.new():put("kind", "SharedLib")
		)

		local q = Query.new(settings)
		test.isequal("SharedLib", q:fetch("kind"))
	end


---
-- Positive match workspace scope against a single block.
---

	function suite.fetchWorkspaceValue_withNoFiltering()
		-- create a setting blocks that looks like:
		-- {
		-- 	_conditions = { workspaces = "Workspace1" },
		--  value = "Hello"
		-- }

		-- then query it
		-- query { workspaces = "MyWorkspace" }:fetch("value")
	end


-- Inherit value from global scope
-- Don't inherit value from global scope
-- Fetch project scoped value with global and workspace inheritance
-- Fetch project scoped with no inheritance
-- Fetch configuration scope
-- Fetch file scope
