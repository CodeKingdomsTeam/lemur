local Color3 = import("../types/Color3")
local Font = import("../Enum/Font")
local GuiObject = import("./GuiObject")
local InstanceProperty = import("../InstanceProperty")
local TextTruncate = import("../Enum/TextTruncate")
local TextXAlignment = import("../Enum/TextXAlignment")
local TextYAlignment = import("../Enum/TextYAlignment")
local Signal = import("../Signal")

local TextBox = GuiObject:extend("TextBox", {
	creatable = true,
})

TextBox.properties.ClearTextOnFocus = InstanceProperty.typed("boolean", {
	getDefault = function()
		return true
	end,
})

TextBox.properties.Font = InstanceProperty.enum(Font, {
	getDefault = function()
		return Font.SourceSans
	end,
})

TextBox.properties.PlaceholderText = InstanceProperty.typed("string", {
	getDefault = function()
		return ""
	end,
})

TextBox.properties.ShowNativeInput = InstanceProperty.typed("boolean", {
	getDefault = function()
		return true
	end,
})

TextBox.properties.Text = InstanceProperty.typed("string", {
	getDefault = function()
		return "TextBox"
	end,
})

TextBox.properties.TextColor3 = InstanceProperty.typed("Color3", {
	getDefault = function()
		return Color3.new()
	end,
})

TextBox.properties.TextSize = InstanceProperty.typed("number", {
	getDefault = function()
		return 14
	end,
})

TextBox.properties.TextTransparency = InstanceProperty.typed("number", {
	getDefault = function()
		return 0
	end,
})

TextBox.properties.TextTruncate = InstanceProperty.enum(TextTruncate, {
	getDefault = function()
		return TextTruncate.None
	end,
})

TextBox.properties.TextWrapped = InstanceProperty.typed("boolean", {
	getDefault = function()
		return false
	end,
})

TextBox.properties.TextScaled = InstanceProperty.typed("boolean", {
	getDefault = function()
		return false
	end,
})

TextBox.properties.TextXAlignment = InstanceProperty.enum(TextXAlignment, {
	getDefault = function()
		return TextXAlignment.Center
	end,
})

TextBox.properties.TextYAlignment = InstanceProperty.enum(TextYAlignment, {
	getDefault = function()
		return TextYAlignment.Center
	end,
})

TextBox.properties.Focused = InstanceProperty.readOnly({
	getDefault = function()
		return Signal.new()
	end,
})

TextBox.properties.FocusLost = InstanceProperty.readOnly({
	getDefault = function()
		return Signal.new()
	end,
})

return TextBox
