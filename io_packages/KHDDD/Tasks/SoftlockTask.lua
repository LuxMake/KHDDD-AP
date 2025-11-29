--Check for and prevent potential softlocks

local SoftlockTask = {}

function SoftlockTask:PreventSoftlocks()
	self:BeagleBoys()
	self:LeaveMT()
end

function SoftlockTask:BeagleBoys()
	--If riku has to leave the Beagle Boys fight via /unstuck, he is unable to reinitiate the fight
	--Player may find themselves in this situation if they enter the fight without polespin

	local _currWorld = ReadByte(MemoryAddresses.world)
	local _currChar = getCharacter()

	if _currChar == 1 and _currWorld == 0x04 then
		--Riku is in CotM; check if he has initiated the beagle boys fight
		local _storyProg = ReadByte(WorldFlags.countryOfMusketeers.riku.story+0x01)
		if _storyProg < 0x3F and _storyProg >= 0x1F then --Player has started the fight but has not obtained the stage gadget yet
			local _currRoom = ReadByte(MemoryAddresses.room)
			if _currRoom == 0x03 then --Riku is in the theater. This is only possible if the player abandoned the fight
				WriteByte(MemoryAddresses.room, 0x0B) --Move player to the machine room
				WriteByte(MemoryAddresses.map, 0x02) --Event data for beagle boys fight
				WriteByte(MemoryAddresses.evt, 0x02)
				WriteByte(MemoryAddresses.btl, 0x02)
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