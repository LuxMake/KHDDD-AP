--Check for and prevent potential softlocks

local SoftlockTask = {}

function SoftlockTask:PreventSoftlocks()
	self:BeagleBoys()
	self:LeaveMT()
	self:EscapePurgatory()
end

function SoftlockTask:BeagleBoys()
	local _currWorld = ReadByte(MemoryAddresses.world)
	local _currChar = getCharacter()

	if _currChar == 1 and _currWorld == 0x04 then
		--Disable flag preventing Riku from leaving the beagle boys room
		local _storyProg = ReadByte(WorldFlags.countryOfMusketeers.riku.story+0x01)
		if _storyProg < 0x3F and _storyProg >= 0x1F then --Player has started the fight but has not obtained the stage gadget yet
			if ReadByte(0xA44792) == 0x0A then --Flag is enabled; disable it
				WriteArray(0xA44792, {0x00, 0x00})
			end
		end
	end
end

function SoftlockTask:LeaveMT()
	--Leave the mysterious tower if no cutscene gets triggered
	local _currWorld = ReadByte(MemoryAddresses.world)
	local _currRoom = ReadByte(MemoryAddresses.room)
	local _currEvt = ReadByte(MemoryAddresses.evt)

	if _currWorld == 0x02 and _currRoom == 0x01 and _currEvt == 0x01 then --Leave this world
		WriteByte(MemoryAddresses.world, 0x0B)
	end

end

function SoftlockTask:EscapePurgatory()
	local _currWorld = ReadByte(MemoryAddresses.world)
	if _currWorld == 0x07 then
		--Is player in a purgatory room?
		local _currRoom = ReadByte(MemoryAddresses.room)
		if _currRoom == 0x03 or _currRoom == 0x01 or _currRoom == 0x05 then
			--See if player is actually stuck
			if ReadByte(MemoryAddresses.cutscenePauseType == 0x00 and ReadByte(MemoryAddresses.enablePause) == 0x00) then
				--Send the player to the world map
				WriteByte(MemoryAddresses.world, 0x0B)
				WriteByte(MemoryAddresses.room, 0x01)
				WriteByte(MemoryAddresses.map, 0x01)
				WriteByte(MemoryAddresses.btl, 0x01)
				WriteByte(MemoryAddresses.evt, 0x01)
			end
		end
	end
end

return SoftlockTask