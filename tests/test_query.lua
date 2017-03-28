---
-- query/tests/test_query.lua
--
-- Author Jason Perkins
-- Copyright (c) 2016-2017 Jason Perkins and the Premake project
---

	local suite = test.declare("query")

	local Query = require("query")



---
-- Setup
---

	local settings

	function suite.setup()
		settings = {}
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

	function suite.fetchSimpleValue_fromSingleBlock_withNoFiltering()
		table.insert(settings, { value = "Hello" })

		local q = Query.new(settings)
		test.isequal("Hello", q:fetch("value"))
	end


---
-- Fetch a simple value as a direct field.
---

	function suite.fetchSimpleValue_fromSingleBlock_withNoFiltering_asField()
		table.insert(settings, { value = "Hello" })

		local q = Query.new(settings)
		test.isequal("Hello", q.value)
	end


---
-- Fetch a simple value with no filtering but multiple blocks.
---

	function suite.fetchSimpleValue_fromMultipleBlocks_withNoFiltering()
		table.insert(settings, { value = "Hello" })
		table.insert(settings, { value = "Greetings" })

		local q = Query.new(settings)
		test.isequal("Greetings", q:fetch("value"))
	end
