local LocationHandler = {}

---------------------------------------------------------------
---------------Prevent Invalid World Access--------------------
---------------------------------------------------------------
function LocationHandler:PreventWorldVisit()
  if ReadByte(WorldFlags.symphonyOfSorcery.sora.story) == 0x00 then --Fix story flags
    
    --Set initial story progression

    --Sora
    WriteArray(WorldFlags.traverseTown.sora.story, {0x11, 0x01})
    WriteArray(WorldFlags.symphonyOfSorcery.sora.story, {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
    WriteArray(WorldFlags.countryOfMusketeers.sora.story, {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
    WriteArray(WorldFlags.laCiteDesCloches.sora.story, {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
    WriteArray(WorldFlags.theGrid.sora.story, {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
    WriteArray(WorldFlags.prankstersParadise.sora.story, {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
    WriteArray(WorldFlags.theWorldThatNeverWas.sora.story, {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})

    --Riku
    WriteArray(WorldFlags.traverseTown.riku.story, {0x31, 0x01})
    WriteArray(WorldFlags.symphonyOfSorcery.riku.story, {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
    WriteArray(WorldFlags.countryOfMusketeers.riku.story, {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
    WriteArray(WorldFlags.laCiteDesCloches.riku.story, {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
    WriteArray(WorldFlags.theGrid.riku.story, {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
    WriteArray(WorldFlags.prankstersParadise.riku.story, {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
    WriteArray(WorldFlags.theWorldThatNeverWas.riku.story, {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})

    --Story-Relevant
    WriteArray(0xA41D9C, {0xFF, 0x0F}) --Mysterious Tower Sora
    WriteArray(0xA445B4, {0xFF, 0x0F}) --Mysterious Tower Riku
    --WriteArray(0xA41DC4, {0xFF, 0xFF, 0xFF, 0xFF}) --Radiant Garden Sora
    --WriteArray(0xA445DC, {0xFF, 0xFF, 0xFF, 0xFF}) --Radiant Garden Riku

    self:LockSavePoints()
    
  end
end

function LocationHandler:LockSavePoints()
    --Lock save points
    --Sora
    --WriteInt(MemoryAddresses.worldStatusS+0x64, 0xFFFFFFFE) --TT (Sora & Riku)
    WriteLong(MemoryAddresses.worldStatusS+0xB4, 0xFFFFFFFEFFFFFFFE) --PP & LCdC
    WriteInt(MemoryAddresses.worldStatusS+0xAC, 0xFFFFFFFE) --TG
    WriteInt(MemoryAddresses.worldStatusS+0x94, 0xFFFFFFFE) --CotM
    
    --Riku
    WriteInt(MemoryAddresses.worldStatusR+0xA4, 0xFFFFFFFE) --Lock SoS Save Points (Riku)
    WriteInt(MemoryAddresses.worldStatusR+0xBC, 0xFFFFFFFE) --Lock TG Save Points (Riku)
    WriteInt(MemoryAddresses.worldStatusR+0xC4, 0xFFFFFFFD) --Lock LCdC Save Points (Riku)
    WriteInt(MemoryAddresses.worldStatusR+0xCC, 0xFFFFFFFD) --Lock TWTNW Save Points (Riku)


    --Lock SoS; idk why it needs a funkier setup to work
    --Original warp byte is 0x05
    WriteByte(0x10979106, 0x00)
    --WriteByte(0x10978F78, 0x00)

    --Lock TWTNW
    --Original warp byte is 0x0A
    WriteByte(0x1097913A, 0x00)

    --Grid needs to be locked for Riku
    --Original warp byte is 0x09
    WriteByte(0x10979162, 0x00)

    --Riku TWTNW needs additional lock for Delusive Beginning
    WriteByte(WorldFlags.theWorldThatNeverWas.riku.dockPoint, 0x00)

    --TT Lock
    WriteByte(0x10978F18, 0x00) --Sora
    WriteByte(0x10978FD0, 0x00) --Riku
end

LocationHandler.StatusOffsets = {
  Sora = {
    tt = 0x64,
    pp = 0xB4,
    lcdc = 0xB8,
    tg = 0xAC,
    cotm = 0x94
  },
  Riku = {
    lcdc = 0xC4,
    tg = 0xBC,
    sos = 0xA4
  }
}

function LocationHandler:WorldAccess()
  local _currWorld = ReadByte(MemoryAddresses.world)
  local _currChar = getCharacter()

  if _currWorld == 0x0B then --Additional check needed for Sora TT
    local _worldInvItem = getItemById(2691113)
    if ReadByte(MemoryAddresses.keyItems+_worldInvItem.Offset) == 0x00 then --No access
      WriteInt(MemoryAddresses.worldStatusS+self.StatusOffsets.Sora.tt, 0xFFFFFFFE)
    end
  end

  if _currWorld == 0x03 then --Disable TT status lock
    if _currChar == 0 then --Only Sora has status lock for this world
      if ReadByte(MemoryAddresses.enablePause) == 0x00 and ReadByte(MemoryAddresses.cutscenePauseType) == 0x00 then --Ensure we actually visited the world
        WriteInt(MemoryAddresses.worldStatusS+self.StatusOffsets.Sora.tt, 0)
      end
    end
  elseif _currWorld == 0x04 then --Disable CotM status lock
    if _currChar == 0 and ReadByte(WorldFlags.countryOfMusketeers.sora.story) >= 0x11 then --Only Sora has status lock for this world
      WriteInt(MemoryAddresses.worldStatusS+self.StatusOffsets.Sora.cotm, 0)
    end
  elseif _currWorld == 0x05 then --Disable SoS status lock
    if _currChar == 1 and ReadByte(WorldFlags.symphonyOfSorcery.riku.story) >= 0x11 then --Only Riku has status lock for this world
      WriteInt(MemoryAddresses.worldStatusR+self.StatusOffsets.Riku.sos, 0)
    end
  elseif _currWorld == 0x06 then --Disable PP status lock
    if _currChar == 0 and ReadByte(WorldFlags.prankstersParadise.sora.story) >= 0x11 then --Only Sora has status lock for this world
      WriteInt(MemoryAddresses.worldStatusS+self.StatusOffsets.Sora.pp, 0)
    end
  elseif _currWorld == 0x08 then --Disable LCdC status lock
    if _currChar == 0 and ReadByte(WorldFlags.laCiteDesCloches.sora.story) >= 0x11 then --Sora
      WriteInt(MemoryAddresses.worldStatusS+self.StatusOffsets.Sora.lcdc, 0)
    elseif _currChar == 1 and ReadByte(WorldFlags.laCiteDesCloches.riku.story) >= 0x11 then --Riku
      WriteInt(MemoryAddresses.worldStatusR+self.StatusOffsets.Riku.lcdc, 0)
    end
  elseif _currWorld == 0x09 then --Disable TG status lock
    if _currChar == 0 and ReadByte(WorldFlags.theGrid.sora.story) >= 0x11 then
      WriteInt(MemoryAddresses.worldStatusS+self.StatusOffsets.Sora.tg, 0)
    elseif _currChar == 1 and ReadByte(WorldFlags.theGrid.riku.story+0x03) >= 0x03 then
      WriteInt(MemoryAddresses.worldStatusR+self.StatusOffsets.Riku.tg, 0)
    end
  end

  --Ensure TWTNW stays locked if needed
  if getCharacter() == 0 then --Check Sora TWTNW
    local _worldInvItem = getItemById(2691106)
    if ReadByte(MemoryAddresses.keyItems+_worldInvItem.Offset) == 0x00 then --No access; hide world
      WriteArray(WorldFlags.theWorldThatNeverWas.sora.unlocked, {0x00, 0x00})
    end
  else --Check Riku TWTNW
    local _worldInvItem = getItemById(2691112)
    if ReadByte(MemoryAddresses.keyItems+_worldInvItem.Offset) == 0x00 then --No access; hide world
      WriteArray(WorldFlags.theWorldThatNeverWas.riku.unlocked, {0x00, 0x00})
    end
  end
end

function LocationHandler:WorldAccessLegacy() --Manages lock status of worlds
  local _currWorld = ReadByte(MemoryAddresses.world)

  if _currWorld == 0x03 and ReadInt(MemoryAddresses.worldStatusS+0x64) == 0xFFFFFFFE then --Checking TT
    WriteInt(MemoryAddresses.worldStatusS+0x64, 0)
  elseif _currWorld == 0x06 and ReadLong(MemoryAddresses.worldStatusS+0xB4) == 0xFFFFFFFEFFFFFFFE then --PP and LCDS [Sora]
    WriteLong(MemoryAddresses.worldStatusS+0xB4, 0)
  end

  if _currWorld == 0x08 and ReadLong(MemoryAddresses.worldStatusS+0xB8) == 0xFFFFFFFE then
    WriteInt(MemoryAddresses.worldStatusS+0xB8, 0)
  end
  if _currWorld == 0x08 and ReadInt(MemoryAddresses.worldStatusR+0xC4) == 0xFFFFFFFD then
    WriteInt(MemoryAddresses.worldStatusR+0xC4, 0)
  end

  if _currWorld == 0x0B then
    WriteInt(MemoryAddresses.worldStatusS+0x64, 0xFFFFFFFE) --TT Sora
    WriteInt(MemoryAddresses.worldStatusS+0xB8, 0xFFFFFFFE) --LCdC Sora
    WriteInt(MemoryAddresses.worldStatusR+0xC4, 0xFFFFFFFD) --LCdC Riku

    --See if TG needs portal stairs unlocked
    if ReadByte(WorldFlags.theGrid.riku.story) >= 0x11 and getCharacter() == 1 then
      --World beaten; status can be reset
      WriteInt(MemoryAddresses.worldStatusR+0xBC, 0)
    end
  end

  if _currWorld == 0x09 then --Need to double-check grid status
    --See if TG needs portal stairs unlocked
    if ReadByte(WorldFlags.theGrid.riku.story) >= 0x11 and getCharacter() == 1 then
      --World beaten; status can be reset
      WriteInt(MemoryAddresses.worldStatusR+0xBC, 0)
    end
  end

  --Ensure TWTNW stays locked if needed
  if getCharacter() == 0 then --Check Sora TWTNW
    local _worldInvItem = getItemById(2691106)
    if ReadByte(MemoryAddresses.keyItems+_worldInvItem.Offset) == 0x00 then --No access; hide world
      WriteArray(WorldFlags.theWorldThatNeverWas.sora.unlocked, {0x00, 0x00})
    end
  else --Check Riku TWTNW
    local _worldInvItem = getItemById(2691112)
    if ReadByte(MemoryAddresses.keyItems+_worldInvItem.Offset) == 0x00 then --No access; hide world
      WriteArray(WorldFlags.theWorldThatNeverWas.riku.unlocked, {0x00, 0x00})
    end
  end
end

---------------------------------------------------------------
--------------------Reveal All Worlds--------------------------
---------------------------------------------------------------
function LocationHandler:ShowAllWorlds() --Reveals all worlds on the world map for nav
  local unlockedFlags = {0x02, 0x00}

  --Reveal the worlds on the map
  --Sora
  if ReadByte(WorldFlags.traverseTown.sora.unlocked+0x01) < 0x02 then --Don't overwrite world completion status
    WriteArray(WorldFlags.traverseTown.sora.unlocked, unlockedFlags)
  end
  if ReadByte(WorldFlags.laCiteDesCloches.sora.unlocked+0x01) < 0x02 then
    WriteArray(WorldFlags.laCiteDesCloches.sora.unlocked, unlockedFlags)
  end
  if ReadByte(WorldFlags.theGrid.sora.unlocked+0x01) < 0x02 then
    WriteArray(WorldFlags.theGrid.sora.unlocked, unlockedFlags)
  end
  if ReadByte(WorldFlags.prankstersParadise.sora.unlocked+0x01) < 0x02 then
    WriteArray(WorldFlags.prankstersParadise.sora.unlocked, unlockedFlags)
  end
  if ReadByte(WorldFlags.countryOfMusketeers.sora.unlocked+0x01) < 0x02 then
    WriteArray(WorldFlags.countryOfMusketeers.sora.unlocked, unlockedFlags)
  end
  if ReadByte(WorldFlags.symphonyOfSorcery.sora.unlocked+0x01) < 0x02 then
    WriteArray(WorldFlags.symphonyOfSorcery.sora.unlocked, unlockedFlags)
  end

  --Riku
  if ReadByte(WorldFlags.traverseTown.riku.unlocked+0x01) < 0x02 then
    WriteArray(WorldFlags.traverseTown.riku.unlocked, unlockedFlags)
  end
  if ReadByte(WorldFlags.laCiteDesCloches.riku.unlocked+0x01) < 0x02 then
    WriteArray(WorldFlags.laCiteDesCloches.riku.unlocked, unlockedFlags)
  end
  if ReadByte(WorldFlags.theGrid.riku.unlocked+0x01) < 0x02 then
    WriteArray(WorldFlags.theGrid.riku.unlocked, unlockedFlags)
  end
  if ReadByte(WorldFlags.prankstersParadise.riku.unlocked+0x01) < 0x02 then
    WriteArray(WorldFlags.prankstersParadise.riku.unlocked, unlockedFlags)
  end
  if ReadByte(WorldFlags.countryOfMusketeers.riku.unlocked+0x01) < 0x02 then
    WriteArray(WorldFlags.countryOfMusketeers.riku.unlocked, unlockedFlags)
  end
  if ReadByte(WorldFlags.symphonyOfSorcery.riku.unlocked+0x01) < 0x02 then
    WriteArray(WorldFlags.symphonyOfSorcery.riku.unlocked, unlockedFlags)
  end

  --Lock worlds
  --Sora
  WriteByte(WorldFlags.laCiteDesCloches.sora.selectable, 0x00)
  WriteByte(WorldFlags.theGrid.sora.selectable, 0x00)
  WriteByte(WorldFlags.prankstersParadise.sora.selectable, 0x00)
  WriteByte(WorldFlags.countryOfMusketeers.sora.selectable, 0x00)
  WriteByte(WorldFlags.symphonyOfSorcery.sora.selectable, 0x00)
  WriteByte(WorldFlags.theWorldThatNeverWas.sora.selectable, 0x00)

  --Riku
  WriteByte(WorldFlags.laCiteDesCloches.riku.selectable, 0x00)
  WriteByte(WorldFlags.theGrid.riku.selectable, 0x00)
  WriteByte(WorldFlags.prankstersParadise.riku.selectable, 0x00)
  WriteByte(WorldFlags.countryOfMusketeers.riku.selectable, 0x00)
  WriteByte(WorldFlags.symphonyOfSorcery.riku.selectable, 0x00)
  WriteByte(WorldFlags.theWorldThatNeverWas.riku.selectable, 0x00)

  ConsolePrint("Unlocked all worlds")
end

---------------------------------------------------------------
------------------------Chests---------------------------------
---------------------------------------------------------------

function LocationHandler:CheckChestBits()
  --New function for tracking which chests have been opened
  if getCharacter() == 0 then --Track Sora's chests
    for i=1, #chests.sora do
      local _chestByte = ReadByte(MemoryAddresses.soraChests+chests.sora[i].offset)
      local _chestBits = toBits(_chestByte)

      local _validBits = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80}
      local _chestCheck = 0
      for j=1, #_chestBits do
        if hasValue(chests.sora[i].bitFlags, _validBits[j]) then
          _chestCheck = _chestCheck+1
          --Check if we have this found
          if _chestBits[j] == 1 and not chests.sora[i].foundChests[_chestCheck] then --Chest was found; send to AP client
            --TODO: Make sure this doesn't send repeatedly
            chests.sora[i].foundChests[_chestCheck] = true
            SendToApClient(MessageTypes.ChestChecked,{chests.sora[i].locationIDStart+(_chestCheck-1)})
          end
        end
      end
    end
  else --Track Riku's chests
    for i=1, #chests.riku do
      local _chestByte = ReadByte(MemoryAddresses.rikuChests+chests.riku[i].offset)
      local _chestBits = toBits(_chestByte)

      local _validBits = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80}
      local _chestCheck = 0
      for j=1, #_chestBits do
        if hasValue(chests.riku[i].bitFlags, _validBits[j]) then
          _chestCheck = _chestCheck+1
          --Check if we have this found
          if _chestBits[j] == 1 and not chests.riku[i].foundChests[_chestCheck] then --Chest was found; send to AP client
            --TODO: Make sure this doesn't send repeatedly
            chests.riku[i].foundChests[_chestCheck] = true
            SendToApClient(MessageTypes.ChestChecked,{chests.riku[i].locationIDStart+(_chestCheck-1)})
          end
        end
      end
    end
  end
end

---------------------------------------------------------------
------------------------Levels---------------------------------
---------------------------------------------------------------
function LocationHandler:CheckLevel()
  local _currChar = getCharacter()

  if levels.soraLevel >= levels.levelCap and _currChar == 0 or levels.rikuLevel >= levels.levelCap and _currChar == 1 then
    return
  end

  local _levelsToUse = levels.soraLevel
  if _currChar == 1 then
    _levelsToUse = levels.rikuLevel
  end

  local _currExp = ReadInt(MemoryAddresses.soraExp)
  if _currExp >= expTable[_levelsToUse] then
    --Send check
    if _currChar == 0 then
      levels.soraLevel = levels.soraLevel + 1
      SendToApClient(MessageTypes.LevelChecked, {tostring(levels.soraLevelID+levels.soraLevel)})
      ConsolePrint("Attempting to send a check for level "..tostring(levels.soraLevel))
    else
      levels.rikuLevel = levels.rikuLevel + 1
      SendToApClient(MessageTypes.LevelChecked, {tostring(levels.rikuLevelID+levels.rikuLevel)})
      ConsolePrint("Attempting to send a check for level "..tostring(levels.rikuLevel))
    end
  end
end

---------------------------------------------------------------
-------------------Story Locations-----------------------------
---------------------------------------------------------------
function LocationHandler:CheckStory()
  local _currWorld = ReadByte(MemoryAddresses.world)
  local _currChar = getCharacter()
  local _storyAddr = 0x00
  if _currWorld == 0x03 then --Traverse Town
    if _currChar == 0 then
      _storyAddr = WorldFlags.traverseTown.sora.story
    else
      _storyAddr = WorldFlags.traverseTown.riku.story
    end
  elseif _currWorld == 0x01 then --Destiny Islands
    _storyAddr = WorldFlags.destinyIslands.sora.story
  elseif _currWorld == 0x04 then --CotM
    if _currChar == 0 then
      _storyAddr = WorldFlags.countryOfMusketeers.sora.story
    else
      _storyAddr = WorldFlags.countryOfMusketeers.riku.story
    end
  elseif _currWorld == 0x05 then --SoS
    if _currChar == 0 then
      _storyAddr = WorldFlags.symphonyOfSorcery.sora.story
    else
      _storyAddr = WorldFlags.symphonyOfSorcery.riku.story
    end
  elseif _currWorld == 0x06 then --PP
    if _currChar == 0 then
      _storyAddr = WorldFlags.prankstersParadise.sora.story
    else
      _storyAddr = WorldFlags.prankstersParadise.riku.story
    end
  elseif _currWorld == 0x08 then --LCdC
    if _currChar == 0 then
      _storyAddr = WorldFlags.laCiteDesCloches.sora.story
    else
      _storyAddr = WorldFlags.laCiteDesCloches.riku.story
    end
  elseif _currWorld == 0x09 then --TG
    if _currChar == 0 then
      _storyAddr = WorldFlags.theGrid.sora.story
    else
      _storyAddr = WorldFlags.theGrid.riku.story
    end
  elseif _currWorld == 0x0A then --TWTNW
    if _currChar == 0 then
      _storyAddr = WorldFlags.theWorldThatNeverWas.sora.story
    else
      _storyAddr = WorldFlags.theWorldThatNeverWas.riku.story
    end
  elseif _currWorld == 0x02 then --Check for AVN beaten
    if _currChar == 1 then
      if ReadByte(0xA445B4+0x02) >= 0x07 then
        for i=1, #worldEvents do
          if worldEvents[i].ID == 2670295 then --AVN location ID
            if not worldEvents[i].sent then
              SendToApClient(MessageTypes.StoryChecked, {worldEvents[i].ID})
              worldEvents[i].sent = true
            end
          end
        end
      end
      return
    end
  end

  local _storiesFound = {}
  for i=1, #worldEvents do
    if worldEvents[i].worldNo == _currWorld and worldEvents[i].char == _currChar and not worldEvents[i].sent then
      if ReadByte(_storyAddr+(worldEvents[i].LookAt-0x01)) >= worldEvents[i].StoryBit[worldEvents[i].LookAt] then
        if worldEvents[i].ID == 2670206 or worldEvents[i].ID == 2670207 or worldEvents[i].ID == 2670248 then
          if ReadByte(MemoryAddresses.room) ~= 0x02 and ReadByte(WorldFlags.traverseTown.sora.story+0x02) < 0x03 then --Prevent command menu fix from erroneously sending this out
            return
          end
        end
        if worldEvents[i].ID == 2670249 and ReadByte(WorldFlags.traverseTown.riku.story+0x01) == 0x1F and rikuSpiritFix == 1 then --Do not send out Komory Bat check prematurely
          return
        end
        table.insert(_storiesFound, tostring(worldEvents[i].ID))
        worldEvents[i].sent = true --Prevents this story point from being checked repeatedly
      end
    end
  end

  --Do special check for sora ultima weapon cuz it needs it for some reason idk
  --if ReadByte(WorldFlags.traverseTown.sora.story+0x05) >= 0x0F and not _soraUltima then
  --  table.insert(_storiesFound, "2670292")
  --  _soraUltima = true
  --end

  if #_storiesFound > 0 then
    SendToApClient(MessageTypes.StoryChecked, _storiesFound)
  end

end
local _soraUltima = false

---------------------------------------------------------------
-------------------Secret Portals------------------------------
---------------------------------------------------------------
LocationHandler.inAPortal = false
LocationHandler.portalsWon = 0
function LocationHandler:CheckPortal()
  local _portalsWonAddr = 0xA51940

  local _currChar = getCharacter()
  local _world = ReadByte(MemoryAddresses.world)
  local _room = ReadByte(MemoryAddresses.room)
  local _evt = ReadByte(MemoryAddresses.evt)
  local _worldCheck = {}

  --Check which world to look at
  if _world == 0x03 then
    _worldCheck = portalDigits.traverseTown
  elseif _world == 0x04 then
    _worldCheck = portalDigits.countryOfMusketeers
  elseif _world == 0x05 then
    _worldCheck = portalDigits.symphonyOfSorcery
  elseif _world == 0x06 then
    _worldCheck = portalDigits.prankstersParadise
  elseif _world == 0x08 then
    _worldCheck = portalDigits.laCiteDesCloches
  elseif _world == 0x09 then
    _worldCheck = portalDigits.theGrid
  else --Invalid world
    return
  end

  --Determine which portal details to look at based on character
  if _currChar == 0 then
    _portalDetails = _worldCheck.sora
  else
    if _world == 0x05 then
      return --Riku has no secret portal in SoS
    end
    _portalDetails = _worldCheck.riku
  end

  if not self.inAPortal then --Player is not yet in a secret portal fight
    if _room == _portalDetails.bossRoom and _evt == _portalDetails.evt then --Portal fight is being done
      self.inAPortal = true
      self.portalsWon = ReadByte(_portalsWonAddr)
    end
  else
    --Check for fail condition
    if _evt ~= _portalDetails.evt then --Fight exited
      if ReadByte(_portalsWonAddr) > self.portalsWon then --Player won the fight
        ConsolePrint("Portal fight won")
        SendToApClient(MessageTypes.PortalChecked, {tostring(_portalDetails.portalId)})

        --Write Portal Fight victory status to the story progression
        WriteByte(_portalDetails.saveAddr, 0x01)

        --Recheck secret portals (for granting access to julius)
        setSecretPortals()

        self.inAPortal = false
      else --Player did not win the fight
        self.inAPortal = false
        ConsolePrint("Portal fight failed")
      end
    end
  end
end

---------------------------------------------------------------
-------------------Julius Defeated-----------------------------
---------------------------------------------------------------
LocationHandler.superbossesDefeated = false
function LocationHandler:JuliusDefeated()
  --Check if all superbosses location should be sent
  local _allBossesDefeated = false

  local _soraDefeated = false
  local _rikuDefeated = false
  if ReadByte(WorldFlags.traverseTown.sora.story+0x05) >= 0x04 then
    _soraDefeated = true
  end
  if ReadByte(WorldFlags.traverseTown.riku.story+0x04) >= 0x7F then
    _rikuDefeated = true
  end

  if Configs.Character == 1 and _soraDefeated then
    _allBossesDefeated = true
  elseif Configs.Character == 2 and _rikuDefeated then
    _allBossesDefeated = true
  elseif Configs.Character == 0 and _soraDefeated and _rikuDefeated then
    _allBossesDefeated = true
  end

  if _allBossesDefeated and not self.superbossesDefeated then --Send the message that all superbosses have been defeated
    SendToApClient(MessageTypes.StoryChecked, {2670294})
    self.superbossesDefeated = true
  end
  
end

return LocationHandler