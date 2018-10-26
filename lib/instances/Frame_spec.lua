local FrameStyle = import("../Enum/FrameStyle")
local Instance = import("../Instance")
local typeof = import("../functions/typeof")

describe("instances.Frame", function()
	it("should instantiate", function()
		local instance = Instance.new("Frame")

		assert.not_nil(instance)
	end)

	it("should have properties defined", function()
		local instance = Instance.new("Frame")

		assert.equals(typeof(instance.Style), "EnumItem")
		assert.equals(instance.Style.EnumType, FrameStyle)
	end)
end)