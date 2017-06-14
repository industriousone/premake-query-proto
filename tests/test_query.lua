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
-- Most project formats do not have the ability to remove previously set values, only
-- to add to the values which have been previously set. If a symbol has been defined
-- at the project level, you can not remove it from a specific configuration, you can
-- only add new values.
--
-- Verify that a value removed from a more specific scope is also filtered out of
-- the general scopes that would contain it, while still applied to the specific
-- scopes where the value was *not* removed.
--
-- The project scope defines symbols "A", "B", and "C". Symbol "B" is removed from
-- the "Release" configuration. "A" and "C" should appear at the project level and
-- in the Release configuration. The "Debug" configuration should define all three.
---

	function suite.valueSetAtProjectOverriddenInConfig_withInheritance()
		settings:append(
			Settings.new({ projects = "Project1" })
				:put("defines", { "A", "B", "C" }),
			Settings.new({ projects = "Project1", configuration = "Release" })
				:remove("defines", "B")
		)

		local q = Query.new(settings):filter({ projects = "Project1" })
		test.isequal({ "A", "C" }, q:fetch("defines"))

		q = Query.new(settings):filter({ projects = "Project1", configuration = "Debug" })
		test.isequal({ "A", "B", "C" }, q:fetch("defines"))

		q = Query.new(settings):filter({ projects = "Project1", configuration = "Release" })
		test.isequal({ "A", "C" }, q:fetch("defines"))
	end


	function suite.valueSetAtProjectOverriddenInConfig_withoutInheritance()
		settings:append(
			Settings.new({ projects = "Project1" })
				:put("defines", { "A", "B", "C"}),
			Settings.new({ projects = "Project1", configuration = "Release" })
				:remove("defines", "B")
		)

		local q = Query.new(settings):filter({ projects = "Project1" })
		test.isequal({ "A", "C" }, q:fetch("defines"))

		q = Query.new(settings):filter({ projects = "Project1", configuration = "Debug" })
		test.isequal({ "B" }, q:fetchLocal("defines"))

		q = Query.new(settings):filter({ projects = "Project1", configuration = "Release" })
		test.isequal({ }, q:fetchLocal("defines"))
	end
