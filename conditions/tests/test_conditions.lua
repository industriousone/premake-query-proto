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
		local c = Conditions.new { workspaces = "Workspace1" }
		test.istrue(c:matches { workspaces = "Workspace1" })
	end

	function suite.matches_onSingleSimpleValue_mismatch()
		local c = Conditions.new { workspaces = "Workspace1" }
		test.isfalse(c:matches { workspaces = "Workspace2" })
	end

	function suite.matches_onMultipleSimpleValues_match()
		local c = Conditions.new { workspaces = "Workspace1", project = "Project1" }
		test.istrue(c:matches { workspaces = "Workspace1", project = "Project1" })
	end

	function suite.matches_onMultipleSimpleValues_matchAndMismatch()
		local c = Conditions.new { workspaces = "Workspace1", project = "Project1" }
		test.isfalse(c:matches { workspaces = "Workspace1", project = "Project2" })
	end

	function suite.matches_ignoresExtraEnvironmentValues()
		local c = Conditions.new { workspaces = "Workspace1" }
		test.istrue(c:matches { workspaces = "Workspace1", project = "Project1" })
	end

	function suite.matches_failsIfMissingValuesOnRightSide()
		local c = Conditions.new { workspaces = "Workspace1", project = "Project1" }
		test.isfalse(c:matches { workspaces = "Workspace1" })
	end
