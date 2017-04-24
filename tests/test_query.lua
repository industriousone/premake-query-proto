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
-- Check filtering against a single equality condition.
---

	function suite.postiveMatch_simpleValue_singleBlock()
		settings:append(
			Settings.new({ workspaces = "Workspace1" })
				:put("kind", "ConsoleApp")
		)

		local q = Query.new(settings)
			:filter({ workspaces = "Workspace1" })

		test.isequal("ConsoleApp", q:fetch("kind"))
	end


	function suite.negativeMatch_simpleValue_singleBlock()
		settings:append(
			Settings.new({ workspaces = "Workspace1" })
				:put("kind", "ConsoleApp")
		)

		local q = Query.new(settings)
			:filter({ workspaces = "Workspace2" })

		test.isnil(q:fetch("kind"))
	end



---
-- Working up to...
--
--  project "MyProject"
--    files { "hello.c", "goodbye.c", "test_hello.c", "test_goodbye.c" }
--
--    filter { configurations = "Release" }
--       removefiles "test_*"
--
--  assert(project does not contains "test_hello.c")
--  assert(configuration "Debug" does contain "test_hello.c")
--  assert(configuration "Release" does not contain "test_hello.c")
---

-- Inherit value from global scope
-- Don't inherit value from global scope
-- Fetch project scoped value with global and workspace inheritance
-- Fetch project scoped with no inheritance
-- Fetch configuration scope
-- Fetch file scope
