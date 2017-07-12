---
-- fields/tests/test_lists.lua
--
-- Author Jason Perkins
-- Copyright (c) 2017 Jason Perkins and the Premake project
---

	local suite = test.declare("field_lists")

	local Field = require("fields")


---
-- Setup
---

	local f

	function suite.setup()
		f = Field.new("defines", "list:string")
	end



---
-- Empty value should be an empty collection.
---

	function suite.emptyValue_isEmptyCollection()
		local value = f:emptyValue()
		test.isequal({}, value)
	end


---
-- Test merging of values into a list.
---


	function suite.merge_list_onInitialMerge()
		local value = f:merge(nil, { "DEBUG", "_DEBUG" })
		test.isequal({ "DEBUG", "_DEBUG" }, value)
	end



	function suite.merge_list_onSecondMerge()
		local value = f:merge({ "DEBUG", "_DEBUG" }, { "WINDOWS", "_WINDOWS" })
		test.isequal({ "DEBUG", "_DEBUG", "WINDOWS", "_WINDOWS" }, value)
	end



	function suite.merge_list_onNestedMerge()
		local value = f:merge({ "DEBUG", "_DEBUG" }, { { "WINDOWS" }, { "_WINDOWS" } })
		test.isequal({ "DEBUG", "_DEBUG", "WINDOWS", "_WINDOWS" }, value)
	end



	function suite.merge_string_onInitialMerge()
		local value = f:merge(nil, "DEBUG")
		test.isequal({"DEBUG"}, value)
	end



	function suite.merge_string_onSecondMerge()
		local value = f:merge({"DEBUG"}, "WINDOWS")
		test.isequal({"DEBUG", "WINDOWS"}, value)
	end


---
-- Lists allow duplicate values.
---

	function suite.merge_string_onDuplicateValue()
		local value = f:merge({"DEBUG"}, "DEBUG")
		test.isequal({"DEBUG", "DEBUG"}, value)
	end



---
-- Test removing values from a list.
---

	function suite.remove_string()
		local value = f:remove({ "DEBUG", "_DEBUG" }, "DEBUG")
		test.isequal({ "_DEBUG" }, value)
	end



	function suite.remove_list()
		local value = f:remove({ "DEBUG", "_DEBUG", "WINDOWS", "_WINDOWS" }, { "_DEBUG", "_WINDOWS" })
		test.isequal({ "DEBUG", "WINDOWS" }, value)
	end



	function suite.remove_nested_list()
		local value = f:remove({ "DEBUG", "_DEBUG", "WINDOWS", "_WINDOWS" }, { { "_DEBUG" }, { "_WINDOWS" } })
		test.isequal({ "DEBUG", "WINDOWS" }, value)
	end



	function suite.remove_duplicates()
		local value = f:remove({ "DEBUG", "_DEBUG", "DEBUG", "WINDOWS" }, "DEBUG")
		test.isequal({ "_DEBUG", "WINDOWS" }, value)
	end
