local FrameStyle = import("../Enum/FrameStyle")
local GuiObject = import("./GuiObject")
local InstanceProperty = import("../InstanceProperty")

local Frame = GuiObject:extend("Frame", {
	creatable = true,
})

Frame.properties.Style = InstanceProperty.enum(FrameStyle, {
	getDefault = function()
		return FrameStyle.Custom
	end,
})

return Frame