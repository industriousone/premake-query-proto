---
-- conditions/tests/test_conditions.lua
--
-- Author Jason Perkins
-- Copyright (c) 2017 Jason Perkins and the Premake project
---

	local suite = test.declare("conditions")

	local Conditions = require("conditions")



---
-- Test new object creation.
---

	function suite.new_onNoTerms()
		local cond = Conditions.new()
		test.isnotnil(cond)
	end

	function suite.new_withTerms()
		local cond = Conditions.new { workspaces = "Workspace1" }
		test.isnotnil(cond)
	end


---
-- Test comparison of simple values.
---

	function suite.matches_onSingleSimpleValue_match()
		local a = Conditions.new { workspaces = "Workspace1" }
		local b = Conditions.new { workspaces = "Workspace1" }
		test.istrue(a:matches(b))
		test.istrue(b:matches(a))
	end

	function suite.matches_onSingleSimpleValue_mismatch()
		local a = Conditions.new { workspaces = "Workspace1" }
		local b = Conditions.new { workspaces = "Workspace2" }
		test.isfalse(a:matches(b))
		test.isfalse(b:matches(a))
	end

	function suite.matches_onMultipleSimpleValues_match()
		local a = Conditions.new { workspaces = "Workspace1", project = "Project1" }
		local b = Conditions.new { workspaces = "Workspace1", project = "Project1" }
		test.istrue(a:matches(b))
		test.istrue(b:matches(a))
	end

	function suite.matches_onMultipleSimpleValues_matchAndMismatch()
		local a = Conditions.new { workspaces = "Workspace1", project = "Project1" }
		local b = Conditions.new { workspaces = "Workspace1", project = "Project2" }
		test.isfalse(a:matches(b))
		test.isfalse(b:matches(a))
	end

	function suite.matches_ignoresExtraValuesOnRightSide()
		local a = Conditions.new { workspaces = "Workspace1" }
		local b = Conditions.new { workspaces = "Workspace1", project = "Project1" }
		test.istrue(a:matches(b))
	end

	function suite.matches_failsIfMissingValuesOnRightSide()
		local a = Conditions.new { workspaces = "Workspace1", project = "Project1" }
		local b = Conditions.new { workspaces = "Workspace1" }
		test.isfalse(a:matches(b))
	end
