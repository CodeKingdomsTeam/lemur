local Signal = import("../Signal")
local BaseInstance = import("./BaseInstance")
local InstanceProperty = import("../InstanceProperty")

local RemoteEvent = BaseInstance:extend("RemoteEvent", {
	creatable = true,
})

RemoteEvent.properties.OnClientEvent = InstanceProperty.readOnly({
	getDefault = Signal.new,
})

RemoteEvent.properties.OnServerEvent = InstanceProperty.readOnly({
	getDefault = Signal.new,
})

function RemoteEvent.prototype:FireClient(_, ...)
	-- Do not pass through the player argument (the first one).
	self.OnClientEvent:Fire(...)
end

function RemoteEvent.prototype:FireAllClients(...)
	self.OnClientEvent:Fire(...)
end

function RemoteEvent.prototype:FireServer(...)
	-- Pass nil for the player argument, as there is no concept of which player fired the event.
	self.OnServerEvent:Fire(nil, ...)
end

return RemoteEvent