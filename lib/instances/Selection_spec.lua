local Selection = import("./Selection")

describe("instances.Selection", function()
	it("should instantiate", function()
		local instance = Selection:new()

		assert.not_nil(instance)
	end)
end)
