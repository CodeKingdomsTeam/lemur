local Instance = import("../Instance")

describe("instances.RemoteEvent", function()
	it("should instantiate", function()
		local instance = Instance.new("RemoteEvent")

		assert.not_nil(instance)
		assert.not_nil(instance.OnClientEvent)
		assert.not_nil(instance.OnServerEvent)
	end)

	it("should fire OnServerEvent when FireServer is called", function()
		local instance = Instance.new("RemoteEvent")

		local testSpy = spy.new(function() end)
		instance.OnServerEvent:Connect(testSpy)

		instance:FireServer("arg1")

		assert.spy(testSpy).was_called(1)
		-- Expect a nil value for the player, as passing through the player responsible
		-- for firing the event is not yet supported.
		assert.spy(testSpy).was_called_with(nil, "arg1")
	end)

	it("should fire OnClientEvent when FireClient is called", function()
		local instance = Instance.new("RemoteEvent")

		local testSpy = spy.new(function() end)
		instance.OnClientEvent:Connect(testSpy)

		-- Pass in nil for the player, as this currently does not support firing the event
		-- for a particular player.
		instance:FireClient(nil, "arg1")

		assert.spy(testSpy).was_called(1)
		assert.spy(testSpy).was_called_with("arg1")
	end)

	it("should fire OnClientEvent when FireAllClients is called", function()
		local instance = Instance.new("RemoteEvent")

		local testSpy = spy.new(function() end)
		instance.OnClientEvent:Connect(testSpy)

		instance:FireAllClients("arg1")

		assert.spy(testSpy).was_called(1)
		assert.spy(testSpy).was_called_with("arg1")
	end)
end)