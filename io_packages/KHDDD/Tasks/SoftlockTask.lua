--Check for and prevent potential softlocks

local SoftlockTask = {}

function SoftlockTask:PreventSoftlocks()
	self:BeagleBoys()
	self:LeaveMT()
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

return SoftlockTask