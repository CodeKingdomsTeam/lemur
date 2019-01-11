local Color3 = import("../types/Color3")
local GuiObject = import("./GuiObject")
local InstanceProperty = import("../InstanceProperty")
local UDim2 = import("../types/UDim2")
local Rect = import("../types/Rect")
local ScaleType = import("../Enum/ScaleType")

local ImageLabel = GuiObject:extend("ImageLabel", {
	creatable = true,
})

ImageLabel.properties.Image = InstanceProperty.typed("string", {
	getDefault = function()
		return ""
	end,
})

ImageLabel.properties.ImageColor3 = InstanceProperty.typed("Color3", {
	getDefault = function()
		return Color3.new()
	end,
})

ImageLabel.properties.ScaleType = InstanceProperty.enum(ScaleType, {
	getDefault = function()
		return ScaleType.Stretch
	end,
})

ImageLabel.properties.Rotation = InstanceProperty.typed("number", {
	getDefault = function()
		return 0
	end,
})

ImageLabel.properties.TileSize = InstanceProperty.typed("UDim2", {
	getDefault = function()
		return UDim2.new(1, 0, 1, 0)
	end,
})

ImageLabel.properties.SliceCenter = InstanceProperty.typed("Rect", {
	getDefault = function()
		return Rect.new(0, 0, 1, 1)
	end,
})

return ImageLabel