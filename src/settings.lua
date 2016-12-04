settings = {
	beepSampleRate = config.get("client.beepSampleRate", 44100),
	beepVolume = config.get("client.beepVolume", 32),
	monochromeColor = tonumber(config.get("client.monochromeColor", "0xFFFFFF")),

	allowBytecode = config.get("computer.lua.allowBytecode",false),
	allowGC = config.get("computer.lua.allowGC",false),
	timeout = config.get("computer.timeout",5),

	components = config.get("emulator.components"),
	emulatorDebug = config.get("emulator.debug",false),
	fast = config.get("emulator.fast",true),
	vagueErrors = config.get("emulator.vague",true),

	maxReadBuffer = config.get("filesystem.maxReadBuffer",2048),

	httpEnabled = config.get("internet.enableHttp",true),
	tcpEnabled = config.get("internet.enableTcp",true),

	maxNetworkPacketSize = config.get("misc.maxNetworkPacketSize",8192),
	maxWirelessRange = config.get("misc.maxWirelessRange",400),
}

if settings.monochromeColor == nil then
	settings.monochromeColor = 0xFFFFFF
	config.set("client.monochromeColor", "0xFFFFFF")
end

-- Config version upgrade

if config.get("version") == nil then
	if settings.components ~= nil then
		for _, v in pairs(settings.components) do
			-- Set all nil slots to -1
			if v[3] == nil then
				v[3] = -1
			end
			if v[1] == "filesystem" then
				v[6]=v[5]
				-- Infer label and speed from directory
				if v[4] and v[4]:sub(1,5) == "loot/" then
					v[5] = v[4]:sub(6)
					v[7] = 1
				elseif v[4] == "tmpfs" then
					v[5] = v[4]
					v[7] = 5
				else
					if elsa.filesystem.read(elsa.filesystem.getSaveDirectory().."/"..v[2].."/.prop") == "{label = \"OpenOS\", reboot=true, setlabel=true, setboot=true}\n" then
						v[5] = "OpenOS"
					else
						v[5] = nil
					end
					v[7] = 4
				end
			elseif v[1] == "internet" and v[3] == -1 then
				v[3] = 2
			end
		end
	end
	config.set("version", 2)
end
