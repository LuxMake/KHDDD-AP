--Diveskip Mod

--Standalone mod to skip dives in Kingdom Hearts Dream Drop Distance

DockPoints = {
	TT = {Sora = {0x109790E2, 0x10978962}, Riku={0x1097914A, 0x109789CA}},
	LCDC = {Sora = {0x109790EE, 0x1097896E}, Riku = {0x10979176, 0x109789F6}},
	TG = {Sora = {0x109790F6, 0x10978976}, Riku = {0x10979162, 0x109789E2}},
	PP =  {Sora = {0x10979122, 0x109789A2}, Riku = {0x1097917E, 0x109789FE}},
	COTM = {Sora = {0x10979132, 0x109789B2}, Riku={0x1097916A, 0x109789EA}},
	SOS = {Sora = {0x10979106, 0x10978986}, Riku={0x1097916E, 0x109789EE}},
	TWTNW = {Sora = {0x1097913A, 0x109789BA}, Riku={0x1097919E, 0x10978A1E}}
}

Story = {
	TT = {Sora={0xA41DA4, 0xA41624}, Riku={0xA445BC, 0xA43E3C}},
	LCDC = {Sora={0xA41DCC, 0xA4164C}, Riku={0xA445E4, 0xA43E64}},
	TG = {Sora={0xA41DD4, 0xA41654}, Riku = {0xA445EC, 0xA43E6C}},
	PP = {Sora={0xA41DBC, 0xA4163C}, Riku={0xA445D4, 0xA43E54}},
	COTM = {Sora={0xA41DAC, 0xA4162C}, Riku={0xA445C4, 0xA43E44}},
	SOS = {Sora={0xA41DB4, 0xA41634}, Riku={0xA445CC, 0xA43E4C}},
	TWTNW = {Sora={0xA41DDC, 0xA4165C}, Riku={0xA445F4, 0xA43E74}}
}

World = {0x9CF730, 0x9CF720}
Character = {0xA40760, 0xA3FFE0}
WorldStatusS = {0xA41ED8, 0xA41758}
WorldStatusR = {0xA446F0, 0xA43F70}

--Game Version
local _isEpic = 0x7F7109
local _isSteam = 0x7F7041

local _gameVer = 0 --1 for Steam; 2 for Epic

local _gameStarted = false
local _canExecute = false

local _currentWorld = 0x00
local _currentRoom = 0x00

function _OnInit()
	local _gameDetected = GameVersion()

	if _gameDetected then
    	_canExecute = true
  	else
    	ConsolePrint("Dream Drop Distance not detected. Make sure your game is up to date.")
	end
end

function GameVersion()
  if ReadLong(_isEpic) == 0x7265737563697065 then
    ConsolePrint("Running KHDDD Dive Skip for EGS")
    _gameVer = 2
    return true
  elseif ReadLong(_isSteam) == 0x7265737563697065 then
    ConsolePrint("Running KHDDD Dive Skip for Steam")
    _gameVer = 1
    return true
  end
  return false
end

function SetWorldProg()
	if ReadByte(Story.TWTNW.Sora[_gameVer]+0x01) == 0x00 then --Mod is not active
		--Set initial story progression
		WriteShort(Story.TT.Sora[_gameVer], 0x0101)
		WriteShort(Story.LCDC.Sora[_gameVer], 0x0101)
		WriteShort(Story.TG.Sora[_gameVer], 0x0101)
		WriteShort(Story.PP.Sora[_gameVer], 0x0101)
		WriteShort(Story.COTM.Sora[_gameVer], 0x0101)
		WriteShort(Story.SOS.Sora[_gameVer], 0x0101)
		WriteShort(Story.TWTNW.Sora[_gameVer], 0x0101)

		WriteShort(Story.TT.Riku[_gameVer], 0x0101)
		WriteShort(Story.LCDC.Riku[_gameVer], 0x0101)
		WriteShort(Story.TG.Riku[_gameVer], 0x0101)
		WriteShort(Story.PP.Riku[_gameVer], 0x0101)
		WriteShort(Story.COTM.Riku[_gameVer], 0x0101)
		WriteShort(Story.SOS.Riku[_gameVer], 0x0101)
		WriteShort(Story.TWTNW.Riku[_gameVer], 0x0101)
	end
end

function SetWorldStatus()
	--Set world statuses

	local _char = ReadByte(Character[_gameVer])

	if _char == 0x00 then
		--Sora
		if ReadShort(Story.PP.Sora[_gameVer]) == 0x0101 then
			WriteInt(WorldStatusS[_gameVer]+0xB4, 0xFFFFFFFE) --PP
		end
		if ReadShort(Story.LCDC.Sora[_gameVer]) == 0x0101 then
			WriteInt(WorldStatusS[_gameVer]+0xB8, 0xFFFFFFFE) --LCdC
		end
		if ReadShort(Story.TG.Sora[_gameVer]) == 0x0101 then
  		WriteInt(WorldStatusS[_gameVer]+0xAC, 0xFFFFFFFE) --TG
  	end
  	if ReadShort(Story.COTM.Sora[_gameVer]) == 0x0101 then
  		WriteInt(WorldStatusS[_gameVer]+0x94, 0xFFFFFFFE) --CotM
  	end
  else  
  	--Riku
  	if ReadShort(Story.SOS.Riku[_gameVer]) == 0x0101 then
  		WriteInt(WorldStatusR[_gameVer]+0xA4, 0xFFFFFFFE) --SoS
  	end
  	if ReadShort(Story.TG.Riku[_gameVer]) == 0x0101 then
  		WriteInt(WorldStatusR[_gameVer]+0xBC, 0xFFFFFFFE) --TG
  	end
  	if ReadShort(Story.LCDC.Riku[_gameVer]) == 0x0101 then
  		WriteInt(WorldStatusR[_gameVer]+0xC4, 0xFFFFFFFD) --LCdC
  	end
  	if ReadShort(Story.TWTNW.Riku[_gameVer]) == 0x0101 then
  		WriteInt(WorldStatusR[_gameVer]+0xCC, 0xFFFFFFFD) --TWTNW
  	end
	end
end

function RemoveWorldPoints()
	WriteByte(DockPoints.TT.Sora[_gameVer], 0x00)
	WriteByte(DockPoints.LCDC.Sora[_gameVer], 0x00)
	WriteByte(DockPoints.TG.Sora[_gameVer], 0x00)
	WriteByte(DockPoints.PP.Sora[_gameVer], 0x00)
	WriteByte(DockPoints.COTM.Sora[_gameVer], 0x00)
	WriteByte(DockPoints.SOS.Sora[_gameVer], 0x00)
	WriteByte(DockPoints.TWTNW.Sora[_gameVer], 0x00)

	WriteByte(DockPoints.TT.Riku[_gameVer], 0x00)
	WriteByte(DockPoints.LCDC.Riku[_gameVer], 0x00)
	WriteByte(DockPoints.TG.Riku[_gameVer], 0x00)
	WriteByte(DockPoints.PP.Riku[_gameVer], 0x00)
	WriteByte(DockPoints.COTM.Riku[_gameVer], 0x00)
	WriteByte(DockPoints.SOS.Riku[_gameVer], 0x00)
	WriteByte(DockPoints.TWTNW.Riku[_gameVer], 0x00)
end

function SkipFirstDive()
	--No menu options are presented for the first dives; auto-skip them
	if ReadByte(World[_gameVer]) == 0x03 then
		if ReadByte(World[_gameVer]+0x01) == 0x3C and ReadShort(World[_gameVer]+0x10) ~= 0x010B then --Sora dive
			if ReadByte(Story.TT.Sora[_gameVer]+0x01) == 0x01 then
				WriteByte(World[_gameVer]+0x01, 0x01)
        WriteByte(World[_gameVer]+0x04, 0x0036)
        WriteByte(World[_gameVer]+0x06, 0x0036)
        WriteByte(World[_gameVer]+0x08, 0x0036)
			end
		elseif ReadByte(World[_gameVer]+0x01) == 0x3D and ReadShort(World[_gameVer]+0x10) ~= 0x010B then
			if ReadByte(Story.TT.Riku[_gameVer]+0x01) == 0x01 then
				WriteByte(World[_gameVer]+0x01, 0x03)
        WriteByte(World[_gameVer]+0x04, 0x0041)
        WriteByte(World[_gameVer]+0x06, 0x0041)
        WriteByte(World[_gameVer]+0x08, 0x0041)
			end
		end
	end
end

function WorldStart()
	--Make sure a dive is not being attempted
	if ReadByte(World[_gameVer]+0x01) > 0x30 or ReadByte(World[_gameVer]) > 0x0B then
		return
	end

	local _map = 0x00
	local _evtVals = 0x00
	local _worldId = ReadByte(World[_gameVer])
	local _char = ReadByte(Character[_gameVer])
	if _worldId == 0x03 then --TT; for open world support
		if _char == 0x00 then --Sora
			if ReadByte(Story.TT.Sora[_gameVer]+0x01) == 0xF1 then --Check for F1 as it's used for extra menu options
				_map = 0x01
				_evtVals = 0x36
				WriteByte(Story.TT.Sora[_gameVer]+0x01, 0x01) --Ensure progression is stable
			end
		else --Riku
			if ReadByte(Story.TT.Riku[_gameVer]+0x01) == 0x1F then
				_map = 0x03
				_evtVals = 0x41
				WriteByte(Story.TT.Riku[_gameVer]+0x01, 0x01) --Ensure progression is stable
			end
		end

	elseif _worldId == 0x04 then --CotM
		if _char == 0x00 then --Sora
			if ReadShort(Story.COTM.Sora[_gameVer]) == 0x0101 then
				_map = 0x08
				_evtVals = 0x33
			end
		else --Riku
			if ReadShort(Story.COTM.Riku[_gameVer]) == 0x0101 then
				_map = 0x11
				_evtVals = 0x3A
			end
		end
	elseif _worldId == 0x05 then
		if _char == 0x00 then
			if ReadShort(Story.SOS.Sora[_gameVer]) == 0x0101 then
				_map = 0x01
				_evtVals = 0x33
			end
		else
			if ReadShort(Story.SOS.Riku[_gameVer]) == 0x0101 then
				_map = 0x13
				_evtVals = 0x36
			end
		end
	elseif _worldId == 0x06 then
		if _char == 0x00 then
			if ReadShort(Story.PP.Sora[_gameVer]) == 0x0101 then
				_map = 0x01
				_evtVals = 0x33
			end
		else
			if ReadShort(Story.PP.Riku[_gameVer]) == 0x0101 then
				_map = 0x06
				_evtVals = 0x3A
			end
		end
	elseif _worldId == 0x08 then
		if _char == 0x00 then
			if ReadShort(Story.LCDC.Sora[_gameVer]) == 0x0101 then
				_map = 0x0A
				_evtVals = 0x33
			end
		else
			if ReadShort(Story.LCDC.Riku[_gameVer]) == 0x0101 then
				_map = 0x01
				_evtVals = 0x38
			end
		end
	elseif _worldId == 0x09 then
		if _char == 0x00 then
			if ReadShort(Story.TG.Sora[_gameVer]) == 0x0101 then
				_map = 0x08
				_evtVals = 0x33
			end
		else
			if ReadShort(Story.TG.Riku[_gameVer]) == 0x0101 then
				_map = 0x08
				_evtVals = 0x36
			end
		end
	elseif _worldId == 0x0A then
		if _char == 0x00 then
			if ReadShort(Story.TWTNW.Sora[_gameVer]) == 0x0101 then
				_map = 0x0D
				_evtVals = 0x33
			end
		else
			if ReadShort(Story.TWTNW.Riku[_gameVer]) == 0x0101 then
				_map = 0x04
				_evtVals = 0x35
			end
		end
	end

	if _map > 0x00 then --Player is starting a world for the first time
		WriteByte(World[_gameVer]+0x01, _map)
		WriteArray(World[_gameVer]+0x04, {_evtVals, 0x00, _evtVals, 0x00, _evtVals, 0x00})
	end
end

function OnGameStart()
	RemoveWorldPoints()
	SetWorldProg()
end

function OnRoomChange()
	SkipFirstDive()
end

local waitTime = 0
function OnWorldChange()
	if _currentWorld == 0x0B then --Player is on the world map
		RemoveWorldPoints()
		SetWorldStatus()
		--Restore dock points if needed
		if ReadByte(Character[_gameVer]) == 0x00 then
			if ReadByte(Story.TT.Sora[_gameVer]+0x03) > 0x7F then
				WriteByte(DockPoints.TT.Sora[_gameVer], 0x03)
			end
			if ReadByte(Story.LCDC.Sora[_gameVer]+0x01) > 0x01 then
				WriteByte(DockPoints.LCDC.Sora[_gameVer], 0x08)
			end
			if ReadByte(Story.TG.Sora[_gameVer]+0x01) > 0x01 then
				WriteByte(DockPoints.TG.Sora[_gameVer], 0x09)
			end
			if ReadByte(Story.PP.Sora[_gameVer]+0x01) > 0x01 then
				WriteByte(DockPoints.PP.Sora[_gameVer], 0x06)
			end
			if ReadByte(Story.COTM.Sora[_gameVer]+0x01) > 0x01 then
				WriteByte(DockPoints.COTM.Sora[_gameVer], 0x04)
			end
			if ReadByte(Story.SOS.Sora[_gameVer]+0x01) > 0x01 then
				WriteByte(DockPoints.SOS.Sora[_gameVer], 0x05)
			end
			if ReadByte(Story.TWTNW.Sora[_gameVer]+0x01) > 0x01 then
				WriteByte(DockPoints.TWTNW.Sora[_gameVer], 0x0A)
			end
		else
			if ReadByte(Story.TT.Riku[_gameVer]+0x02) > 0x1F then
				WriteByte(DockPoints.TT.Riku[_gameVer], 0x03)
			end
			if ReadByte(Story.LCDC.Riku[_gameVer]+0x01) > 0x01 then
				WriteByte(DockPoints.LCDC.Riku[_gameVer], 0x08)
			end
			if ReadByte(Story.TG.Riku[_gameVer]+0x01) > 0x01 then
				WriteByte(DockPoints.TG.Riku[_gameVer], 0x09)
			end
			if ReadByte(Story.PP.Riku[_gameVer]+0x01) > 0x01 then
				WriteByte(DockPoints.PP.Riku[_gameVer], 0x06)
			end
			if ReadByte(Story.COTM.Riku[_gameVer]+0x01) > 0x01 then
				WriteByte(DockPoints.COTM.Riku[_gameVer], 0x04)
			end
			if ReadByte(Story.SOS.Riku[_gameVer]+0x01) > 0x01 then
				WriteByte(DockPoints.SOS.Riku[_gameVer], 0x05)
			end
			if ReadByte(Story.TWTNW.Riku[_gameVer]+0x01) > 0x01 then
				WriteByte(DockPoints.TWTNW.Riku[_gameVer], 0x0A)
			end
		end
	elseif ReadByte(World[_gameVer]) == 0xFF then --Title Screen
		RemoveWorldPoints()
	else
		if ReadShort(World[_gameVer]) ~= 0x0403 then
			WorldStart()
		end
	end
end

function _OnFrame()
	if not _canExecute then
		return
	end
	if not _gameStarted then
		if ReadByte(World[_gameVer]) ~= 0xFF then
			_gameStarted = true
			OnGameStart()
		end
		return
	end

	if ReadByte(World[_gameVer]) ~= _currentWorld then
		_currentWorld = ReadByte(World[_gameVer])
		OnWorldChange()
	end
	if ReadByte(World[_gameVer]+0x01) ~= _currentRoom then
		_currentRoom = ReadByte(World[_gameVer]+0x01)
		OnRoomChange()
	end
end