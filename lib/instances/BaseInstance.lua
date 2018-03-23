--[[
	Provides a base implementation for all Instances in Lemur.

	When adding a new instance, you can define:
	* properties, using helpers in InstanceProperty
	* prototype, used for defining methods and static values
	* init, called by the class's constructor
]]

local InstanceProperty = import("../InstanceProperty")
local Signal = import("../Signal")

local function assign(target, ...)
	for i = 1, select("#", ...) do
		for key, value in pairs((select(i, ...))) do
			target[key] = value
		end
	end

	return target
end

local function isInstance(value)
	local metatable = getmetatable(value)

	return metatable and metatable.instance ~= nil
end

local BaseInstance = {}

BaseInstance.name = "Instance"

BaseInstance.properties = {}

BaseInstance.properties.Name = InstanceProperty.normal({
	getDefault = function(self)
		return getmetatable(self).class.name
	end,
})

BaseInstance.properties.ClassName = InstanceProperty.readOnly({
	getDefault = function(self)
		return getmetatable(self).class.name
	end,
})

BaseInstance.properties.Changed = InstanceProperty.readOnly({
	getDefault = function()
		return Signal.new()
	end,
})

BaseInstance.properties.Parent = InstanceProperty.normal({
	set = function(self, key, value)
		local instance = getmetatable(self).instance

		if instance.destroyed then
			error("Attempt to set parent after being destroyed!")
		end

		if instance.properties.Parent == value then
			return
		end

		if value ~= nil and not isInstance(value) then
			error(string.format("Can't set Parent to %q; Parent must be an Instance!"), tostring(value))
		end

		if instance.properties.Parent ~= nil then
			getmetatable(instance.properties.Parent).instance.children[self] = nil
		end

		instance.properties.Parent = value

		if value ~= nil then
			getmetatable(value).instance.children[self] = true
		end
	end,
})

BaseInstance.prototype = {}

function BaseInstance.prototype:FindFirstChild(name)
	local children = getmetatable(self).instance.children

	-- Search for existing children
	-- This is a set stored by child instead of by name, since names are not unique.
	for child in pairs(children) do
		if child.Name == name then
			return child
		end
	end

	return nil
end

function BaseInstance.prototype:GetChildren()
	local children = getmetatable(self).instance.children
	local result = {}

	for child in pairs(children) do
		table.insert(result, child)
	end

	return result
end

function BaseInstance.prototype:IsA(className)
	-- TODO: Hierarchy stuff

	return self.ClassName == className
end

function BaseInstance.prototype:Destroy()
	local children = getmetatable(self).instance.children

	for child in pairs(children) do
		child:Destroy()
	end

	if self.Parent ~= nil then
		self.Parent = nil
	end

	getmetatable(self).instance.destroyed = true
end

function BaseInstance.prototype:GetPropertyChangedSignal(key)
	local properties = getmetatable(self).class.properties
	local propertySignals = getmetatable(self).instance.propertySignals

	local listener = propertySignals[key]

	if not listener then
		assert(properties[key], key .. " is not a valid property name.")

		listener = Signal.new()
		propertySignals[key] = listener
	end

	return listener
end

BaseInstance.metatable = {}

function BaseInstance.metatable.__index(self, key)
	local class = getmetatable(self).class

	if class.properties[key] then
		return class.properties[key].get(self, key)
	end

	if class.prototype[key] then
		return class.prototype[key]
	end

	local object = self:FindFirstChild(key)
	if object then
		return object
	end

	error(string.format("%q is not a valid member of %s", tostring(key), self.ClassName), 2)
end

function BaseInstance.metatable.__newindex(self, key, value)
	local class = getmetatable(self).class

	if class.properties[key] then
		class.properties[key].set(self, key, value)

		self.Changed:Fire(key)

		local propertyChangedSignal = getmetatable(self).instance.propertySignals[key]

		if propertyChangedSignal then
			propertyChangedSignal:Fire()
		end

		return
	end

	error(string.format("%q is not a valid member of %s", tostring(key), self.ClassName), 2)
end

function BaseInstance.metatable:__tostring()
	return self.Name
end

function BaseInstance:new()
	local internalInstance = {
		destroyed = false,
		properties = {},
		propertySignals = {},
		children = {},
	}

	local instance = newproxy(true)

	-- Because userdata have a fixed metatable, merge values onto it.
	assign(getmetatable(instance), self.metatable)
	getmetatable(instance).instance = internalInstance
	getmetatable(instance).class = self

	for key, property in pairs(self.properties) do
		internalInstance.properties[key] = property.getDefault(instance)
	end

	self:init(instance)

	return instance
end

function BaseInstance:init(instance)
end

--[[
	Create a new instance class with the given name.
]]
function BaseInstance:extend(name)
	assert(type(name) == "string", "Expected string name as argument to BaseInstance:extend.")

	local newClass = assign({}, self)

	newClass.name = name

	newClass.properties = assign({}, self.properties)
	newClass.prototype = assign({}, self.prototype)
	newClass.metatable = assign({}, self.metatable)

	return newClass
end

return BaseInstance