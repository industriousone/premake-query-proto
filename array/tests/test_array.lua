---
-- array/tests/test_array.lua
--
-- Author Jason Perkins
-- Copyright (c) 2017 Jason Perkins and the Premake project
---

	local suite = test.declare("array")

	local Array = require("array")



---
-- Setup
---

	local arr

	function suite.setup()
		arr = Array.new()
	end



---
-- Construct a new, empty array.
---

	function suite.createNewEmptyArray()
		test.isnotnil(arr)
		test.isequal(0, #arr)
	end


---
-- Construct and populate a new array.
---

	function suite.createAndInitializeArray()
		arr = Array.new { 1, 2 }
		test.isnotnil(arr)
		test.isequal(2, #arr)
		test.isequal(1, arr[1])
		test.isequal(2, arr[2])
	end



---
-- Append adds a new item to the end of the array.
---

	function suite.appendToEmptyArray()
		arr:append(1)
		test.isequal(1, #arr)
		test.isequal(1, arr[1])
	end

	function suite.appendToExistingData()
		arr = Array.new { 1 }
		arr:append(2)
		test.isequal(2, #arr)
		test.isequal(2, arr[2])
	end

	function suite.appendArray()
		arr = Array.new { 1 }
		arr:append(2, 3)
		test.isequal(3, #arr)
		test.isequal(2, arr[2])
		test.isequal(3, arr[3])
	end

