LBoardFinder = {}

--LBoard Finder Mod

--No static pointer, so we need some helper functions to locate the memory address for lboard contents

--It is loaded once the link board is opened once

local _fileGroups = {0x14C89890} -- ([0x14C89890 + group*8])
local _offsetAddr = {0x9DF2EE}

local _scanLimit = 2000
local _lboardFile = "game/de/bin/lboard.bin"

function Lboard_Addr()
	--Location file group pointer
	local _scanOffset = ReadByte(_offsetAddr[gameVer])*8
	local _pointerAddr = ReadLong(_fileGroups[gameVer]+_scanOffset)

	--Verify that stuff is at the address

	local _filesAddr = ReadLong(_pointerAddr+0x50, true)

	if _filesAddr == nil then
		return nil
	end
	if _filesAddr == 0 then
		return nil
	end
	
	--Find pointer for lboard.bin
	for x = 1, _scanLimit do
		if ReadString(_filesAddr+0x44, #_lboardFile, true) == _lboardFile then
			return ReadLong(_filesAddr+0x20, true)
		end
		_filesAddr = ReadLong(_filesAddr + 0x08, true)
	end

	--Not found
	return nil
end

function toHex(str)
  return string.format("%X", str)
end

function _OnInit()
	if GameVersion() then
		canExecute = true
	end
end

--Only run function if we can be confident the board is actually loaded
local _activeBoard = {0x9E9A40, 0x9E9A30}
local _activeBoardOffset = 0x490

LBoardFinder.LBoard = nil

function LBoardFinder:FinderUpdate()
	local _activeBoardInfo = GetPointer(_activeBoard[gameVer], _activeBoardOffset)
	local _activeInfo = ReadArray(_activeBoardInfo, 6, true)

	--Is a spirit board active
	for x=2, #_activeInfo do
		if _activeInfo[x] > 0 then --Something other than the link board has been loaded
			self.LBoard = nil
			return
		end
	end

	--If we make it here the link board is likely loaded
	if self.LBoard == nil then --Perform the check
		self.LBoard = Lboard_Addr()
		if self.LBoard ~= nil then --Did the check succeed
			ConsolePrint("Link board loaded")
		end
	end
end

return LBoardFinder