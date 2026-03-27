--Check for and prevent potential softlocks

local SoftlockTask = {}

function SoftlockTask:PreventSoftlocks()
	self:BeagleBoys()
	--self:LeaveMT()
	--self:EscapePurgatory()
	self:MontSaintMichel()
end

function SoftlockTask:BeagleBoys()
	local _currWorld = ReadByte(MemoryAddresses.world[gameVer])
	local _currChar = getCharacter()

	if _currChar == 1 and _currWorld == 0x04 then
		--Disable flag preventing Riku from leaving the beagle boys room
		local _storyProg = ReadByte(WorldFlags.countryOfMusketeers.riku.story[gameVer]+0x01)
		if _storyProg < 0x3F and _storyProg >= 0x1F then --Player has started the fight but has not obtained the stage gadget yet
			local _beaglePrompt = {0xA44792, 0xA44012}
			if ReadByte(_beaglePrompt[gameVer]) == 0x0A then --Flag is enabled; disable it
				WriteArray(_beaglePrompt[gameVer], {0x00, 0x00})
			end
		end
	end
end

function SoftlockTask:LeaveMT()
	--Leave the mysterious tower if no cutscene gets triggered
	local _currWorld = ReadByte(MemoryAddresses.world[gameVer])
	local _currRoom = ReadByte(MemoryAddresses.room[gameVer])
	local _currEvt = ReadByte(MemoryAddresses.evt[gameVer])

	if _currWorld == 0x02 and _currRoom == 0x01 and _currEvt == 0x01 then --Leave this world
		WriteByte(MemoryAddresses.world[gameVer], 0x0B)
	end

end

function SoftlockTask:EscapePurgatory()
	local _currWorld = ReadByte(MemoryAddresses.world[gameVer])
	if _currWorld == 0x07 then
		--Is player in a purgatory room?
		local _currRoom = ReadByte(MemoryAddresses.room[gameVer])
		if _currRoom == 0x03 or _currRoom == 0x01 or _currRoom == 0x05 then
			--See if player is actually stuck
			if ReadByte(MemoryAddresses.cutscenePauseType[gameVer]) == 0x00 then
				--Send the player to the world map
				WriteByte(MemoryAddresses.world[gameVer], 0x0B)
				WriteByte(MemoryAddresses.room[gameVer], 0x01)
				WriteByte(MemoryAddresses.map[gameVer], 0x01)
				WriteByte(MemoryAddresses.btl[gameVer], 0x01)
				WriteByte(MemoryAddresses.evt[gameVer], 0x01)
			end
		end
	end
end

--Escape Mont Saint Michel
local _soraPos = {0xA37DB8, 0xA37638}
local _xOffset = 0x1F4
local _yOffset = 0x1F8
local _zOffset = 0x1FC

local _jumpFixed = false
local _actionVal = 0x00
local _inBounds = false

function SoftlockTask:MontSaintMichel()
	local _soraX = GetPointer(_soraPos[gameVer],_xOffset)
	local _soraY = GetPointer(_soraPos[gameVer], _yOffset)
	local _soraZ = GetPointer(_soraPos[gameVer], _zOffset)
	local _xCord = ReadFloat(_soraX, true)
	local _yCord = ReadFloat(_soraY, true)
	local _zCord = ReadFloat(_soraZ, true)

	--Bounds to grant High Jump in:
	--Lower X: -3.5
	--Upper X: -0.5
	--Lower Y: 1.34
	--Upper Y: 5
	--Lower Z: 29.0
	--Upper Z: 33.8

	--World/Room Check
	if ReadByte(MemoryAddresses.world[gameVer]) == 0x04 and ReadByte(MemoryAddresses.room[gameVer]) == 0x04 then
		--Is this needed?
		local _cmdActionByte = ReadByte(MemoryAddresses.commandActions[gameVer])
		local _cmdActionBits = toBits(_cmdActionByte)
		local _flowByte = ReadByte(MemoryAddresses.actionFlags[gameVer])
		local _flowBits = toBits(_flowByte)

		if _cmdActionBits[2] ~= 1 and _flowBits[2] ~= 1 or _inBounds then
			--Needed movement not available; Position Check
			if _xCord >= -3.5 and _xCord <= -0.5 and _yCord >= 1.34 and _yCord <= 5 and _zCord >= 29 and _zCord <= 33.8 then
				if not _inBounds then --Update actionval if just entering bounds
					_actionVal = ReadByte(MemoryAddresses.commandActions[gameVer])
				end
				_inBounds = true
				WriteByte(MemoryAddresses.commandActions[gameVer], 0x02)
				_jumpFixed = true
			else
				_inBounds = false
			end
		end

		if _jumpFixed and not _inBounds then --Revert command actions
			WriteByte(MemoryAddresses.commandActions[gameVer], _actionVal)
			_jumpFixed = false
			_actionVal = 0x00
		end

	end

	--Debugging
	--if ReadByte(0x9E9E89) == 0x01 then --Check for L2 press
	--	ConsolePrint("X: "..tostring(_xCord).." | Y: "..tostring(_yCord).." | Z: "..tostring(_zCord))
	--end
end

return SoftlockTask