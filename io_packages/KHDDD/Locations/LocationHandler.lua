local LocationHandler = {}

---------------------------------------------------------------
---------------Prevent Invalid World Access--------------------
---------------------------------------------------------------
function LocationHandler:PreventWorldVisit()
  if ReadByte(WorldFlags.symphonyOfSorcery.sora.story[gameVer]) == 0x00 then --Fix story flags
    
    --Set initial story progression

    --Sora
    WriteArray(WorldFlags.traverseTown.sora.story[gameVer], {0x11, 0x01})
    WriteArray(WorldFlags.symphonyOfSorcery.sora.story[gameVer], {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
    WriteArray(WorldFlags.countryOfMusketeers.sora.story[gameVer], {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
    WriteArray(WorldFlags.laCiteDesCloches.sora.story[gameVer], {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
    WriteArray(WorldFlags.theGrid.sora.story[gameVer], {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
    WriteArray(WorldFlags.prankstersParadise.sora.story[gameVer], {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
    WriteArray(WorldFlags.theWorldThatNeverWas.sora.story[gameVer], {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})

    --Riku
    WriteArray(WorldFlags.traverseTown.riku.story[gameVer], {0x31, 0x01})
    WriteArray(WorldFlags.symphonyOfSorcery.riku.story[gameVer], {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
    WriteArray(WorldFlags.countryOfMusketeers.riku.story[gameVer], {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
    WriteArray(WorldFlags.laCiteDesCloches.riku.story[gameVer], {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
    WriteArray(WorldFlags.theGrid.riku.story[gameVer], {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
    WriteArray(WorldFlags.prankstersParadise.riku.story[gameVer], {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
    WriteArray(WorldFlags.theWorldThatNeverWas.riku.story[gameVer], {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})

    --Story-Relevant
    local _mtSora = {0xA41D9C, 0xA4161C}
    local _mtRiku = {0xA445B4, 0xA43E34}
    WriteArray(_mtSora[gameVer], {0xFF, 0x0F}) --Mysterious Tower Sora
    WriteArray(_mtRiku[gameVer], {0xFF, 0x0F}) --Mysterious Tower Riku
    --WriteArray(0xA41DC4, {0xFF, 0xFF, 0xFF, 0xFF}) --Radiant Garden Sora
    --WriteArray(0xA445DC, {0xFF, 0xFF, 0xFF, 0xFF}) --Radiant Garden Riku

    --self:LockSavePoints()
    
  end
end

function LocationHandler:LockSavePoints()
    --Lock save points
    --Sora
    --WriteInt(MemoryAddresses.worldStatusS+0x64, 0xFFFFFFFE) --TT (Sora & Riku)
    WriteLong(MemoryAddresses.worldStatusS[gameVer]+0xB4, 0xFFFFFFFEFFFFFFFE) --PP & LCdC
    WriteInt(MemoryAddresses.worldStatusS[gameVer]+0xAC, 0xFFFFFFFE) --TG
    WriteInt(MemoryAddresses.worldStatusS[gameVer]+0x94, 0xFFFFFFFE) --CotM
    
    --Riku
    WriteInt(MemoryAddresses.worldStatusR[gameVer]+0xA4, 0xFFFFFFFE) --Lock SoS Save Points (Riku)
    WriteInt(MemoryAddresses.worldStatusR[gameVer]+0xBC, 0xFFFFFFFE) --Lock TG Save Points (Riku)
    WriteInt(MemoryAddresses.worldStatusR[gameVer]+0xC4, 0xFFFFFFFD) --Lock LCdC Save Points (Riku)
    WriteInt(MemoryAddresses.worldStatusR[gameVer]+0xCC, 0xFFFFFFFD) --Lock TWTNW Save Points (Riku)


    --Lock SoS; idk why it needs a funkier setup to work
    --Original warp byte is 0x05
    WriteByte(WorldFlags.symphonyOfSorcery.sora.dockPoint[gameVer], 0x00)
    --WriteByte(0x10978F78, 0x00)

    --Lock TWTNW
    --Original warp byte is 0x0A
    WriteByte(WorldFlags.theWorldThatNeverWas.sora.dockPoint[gameVer], 0x00)

    --Grid needs to be locked for Riku
    --Original warp byte is 0x09
    local _gridDock = {0x10979162, 0x109789E2}
    WriteByte(_gridDock[gameVer], 0x00)

    --Riku TWTNW needs additional lock for Delusive Beginning
    WriteByte(WorldFlags.theWorldThatNeverWas.riku.dockPoint[gameVer], 0x00)

    --TT Lock
    local _ttDockSora = {0x10978F18, 0x10978798}
    local _ttDockRiku = {0x10978FD0, 0x10978850}
    WriteByte(_ttDockSora[gameVer], 0x00) --Sora
    WriteByte(_ttDockRiku[gameVer], 0x00) --Riku
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
  local _currWorld = ReadByte(MemoryAddresses.world[gameVer])
  local _currChar = getCharacter()

  if _currWorld == 0x0B then --Additional check needed for TT
    local _worldInvItem = getItemById(2691113)
    if ReadByte(MemoryAddresses.keyItems[gameVer]+_worldInvItem.Offset) == 0x00 then --No access
      WriteInt(MemoryAddresses.worldStatusS[gameVer]+self.StatusOffsets.Sora.tt, 0xFFFFFFFE)
    else
      --Verify story progression for save unlock
      if ReadByte(WorldFlags.traverseTown.sora.story[gameVer]+0x02) == 0x00 then
        --Makes visit this world prompt appear
        WriteByte(WorldFlags.traverseTown.sora.selectable[gameVer], 0x03)
        WriteInt(MemoryAddresses.worldStatusS[gameVer]+self.StatusOffsets.Sora.tt, 0xFFFFFFFE)
      else
        --Makes save points selectable
        WriteInt(MemoryAddresses.worldStatusS[gameVer]+self.StatusOffsets.Sora.tt, 0)
      end
    end

    --Verify Riku TT is locked
    _worldInvItem = getItemById(2691114)
    if ReadByte(MemoryAddresses.keyItems[gameVer]+_worldInvItem.Offset) > 0x00 then --Should have access
      WriteByte(WorldFlags.traverseTown.riku.selectable[gameVer], 0x03)
    end
  end

  if _currWorld == 0x03 then --Disable TT status lock
    if _currChar == 0 then --Only Sora has status lock for this world
      if ReadByte(MemoryAddresses.enablePause[gameVer]) == 0x00 and ReadByte(MemoryAddresses.cutscenePauseType[gameVer]) == 0x00 then --Ensure we actually visited the world
        WriteInt(MemoryAddresses.worldStatusS[gameVer]+self.StatusOffsets.Sora.tt, 0)
      end
    end
  elseif _currWorld == 0x04 then --Disable CotM status lock
    if _currChar == 0 and ReadByte(WorldFlags.countryOfMusketeers.sora.story[gameVer]) >= 0x11 then --Only Sora has status lock for this world
      WriteInt(MemoryAddresses.worldStatusS[gameVer]+self.StatusOffsets.Sora.cotm, 0)
    end
  elseif _currWorld == 0x05 then --Disable SoS status lock
    if _currChar == 1 and ReadByte(WorldFlags.symphonyOfSorcery.riku.story[gameVer]) >= 0x11 then --Only Riku has status lock for this world
      WriteInt(MemoryAddresses.worldStatusR[gameVer]+self.StatusOffsets.Riku.sos, 0)
    end
  elseif _currWorld == 0x06 then --Disable PP status lock
    if _currChar == 0 and ReadByte(WorldFlags.prankstersParadise.sora.story[gameVer]) >= 0x11 then --Only Sora has status lock for this world
      WriteInt(MemoryAddresses.worldStatusS[gameVer]+self.StatusOffsets.Sora.pp, 0)
    end
  elseif _currWorld == 0x08 then --Disable LCdC status lock
    if _currChar == 0 and ReadByte(WorldFlags.laCiteDesCloches.sora.story[gameVer]) >= 0x11 or _currChar == 0 and ReadByte(MemoryAddresses.room) <= 0x02  then --Sora
      WriteInt(MemoryAddresses.worldStatusS[gameVer]+self.StatusOffsets.Sora.lcdc, 0)
    elseif _currChar == 1 and ReadByte(WorldFlags.laCiteDesCloches.riku.story[gameVer]) >= 0x11 then --Riku
      WriteInt(MemoryAddresses.worldStatusR[gameVer]+self.StatusOffsets.Riku.lcdc, 0)
    end
  elseif _currWorld == 0x09 then --Disable TG status lock
    if _currChar == 0 and ReadByte(WorldFlags.theGrid.sora.story[gameVer]) >= 0x11 then
      WriteInt(MemoryAddresses.worldStatusS[gameVer]+self.StatusOffsets.Sora.tg, 0)
    elseif _currChar == 1 and ReadByte(WorldFlags.theGrid.riku.story[gameVer]+0x03) >= 0x03 then
      WriteInt(MemoryAddresses.worldStatusR[gameVer]+self.StatusOffsets.Riku.tg, 0)
      --Unlock additional save point
      local _rikuGridWarps = {0xA446F0, 0xA43F70}
      WriteByte(_rikuGridWarps[gameVer], 0x30) --Ensures Riku's entire grid can be accessed
    end
  end

  --Ensure TWTNW stays locked if needed
  if getCharacter() == 0 then --Check Sora TWTNW
    local _worldInvItem = getItemById(2691106)
    if ReadByte(MemoryAddresses.keyItems[gameVer]+_worldInvItem.Offset) == 0x00 then --No access; hide world
      WriteArray(WorldFlags.theWorldThatNeverWas.sora.unlocked[gameVer], {0x00, 0x00})
    end
  else --Check Riku TWTNW
    local _worldInvItem = getItemById(2691112)
    if ReadByte(MemoryAddresses.keyItems[gameVer]+_worldInvItem.Offset) == 0x00 then --No access; hide world
      WriteArray(WorldFlags.theWorldThatNeverWas.riku.unlocked[gameVer], {0x00, 0x00})
    end

    --See if save point needs to be unlocked
    if ReadByte(WorldFlags.theWorldThatNeverWas.riku.story[gameVer]+0x02) >= 0x03 then
      --Ensure Memory's Skyscraper is unlocked if Ansem is defeated
      local _memSkyscraper = {0x109791AA, 0x10978A2A}
      WriteArray(_memSkyscraper[gameVer], {0x0A, 0x0D})
      WriteInt(MemoryAddresses.worldStatusR[gameVer]+0xCC, 0)
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
  if ReadByte(WorldFlags.traverseTown.sora.unlocked[gameVer]+0x01) < 0x02 then --Don't overwrite world completion status
    WriteArray(WorldFlags.traverseTown.sora.unlocked[gameVer], unlockedFlags)
  end
  if ReadByte(WorldFlags.laCiteDesCloches.sora.unlocked[gameVer]+0x01) < 0x02 then
    WriteArray(WorldFlags.laCiteDesCloches.sora.unlocked[gameVer], unlockedFlags)
  end
  if ReadByte(WorldFlags.theGrid.sora.unlocked[gameVer]+0x01) < 0x02 then
    WriteArray(WorldFlags.theGrid.sora.unlocked[gameVer], unlockedFlags)
  end
  if ReadByte(WorldFlags.prankstersParadise.sora.unlocked[gameVer]+0x01) < 0x02 then
    WriteArray(WorldFlags.prankstersParadise.sora.unlocked[gameVer], unlockedFlags)
  end
  if ReadByte(WorldFlags.countryOfMusketeers.sora.unlocked[gameVer]+0x01) < 0x02 then
    WriteArray(WorldFlags.countryOfMusketeers.sora.unlocked[gameVer], unlockedFlags)
  end
  if ReadByte(WorldFlags.symphonyOfSorcery.sora.unlocked[gameVer]+0x01) < 0x02 then
    WriteArray(WorldFlags.symphonyOfSorcery.sora.unlocked[gameVer], unlockedFlags)
  end

  --Riku
  if ReadByte(WorldFlags.traverseTown.riku.unlocked[gameVer]+0x01) < 0x02 then
    WriteArray(WorldFlags.traverseTown.riku.unlocked[gameVer], unlockedFlags)
  end
  if ReadByte(WorldFlags.laCiteDesCloches.riku.unlocked[gameVer]+0x01) < 0x02 then
    WriteArray(WorldFlags.laCiteDesCloches.riku.unlocked[gameVer], unlockedFlags)
  end
  if ReadByte(WorldFlags.theGrid.riku.unlocked[gameVer]+0x01) < 0x02 then
    WriteArray(WorldFlags.theGrid.riku.unlocked[gameVer], unlockedFlags)
  end
  if ReadByte(WorldFlags.prankstersParadise.riku.unlocked[gameVer]+0x01) < 0x02 then
    WriteArray(WorldFlags.prankstersParadise.riku.unlocked[gameVer], unlockedFlags)
  end
  if ReadByte(WorldFlags.countryOfMusketeers.riku.unlocked[gameVer]+0x01) < 0x02 then
    WriteArray(WorldFlags.countryOfMusketeers.riku.unlocked[gameVer], unlockedFlags)
  end
  if ReadByte(WorldFlags.symphonyOfSorcery.riku.unlocked[gameVer]+0x01) < 0x02 then
    WriteArray(WorldFlags.symphonyOfSorcery.riku.unlocked[gameVer], unlockedFlags)
  end

  --Lock worlds
  --Sora
  WriteByte(WorldFlags.laCiteDesCloches.sora.selectable[gameVer], 0x00)
  WriteByte(WorldFlags.theGrid.sora.selectable[gameVer], 0x00)
  WriteByte(WorldFlags.prankstersParadise.sora.selectable[gameVer], 0x00)
  WriteByte(WorldFlags.countryOfMusketeers.sora.selectable[gameVer], 0x00)
  WriteByte(WorldFlags.symphonyOfSorcery.sora.selectable[gameVer], 0x00)
  WriteByte(WorldFlags.theWorldThatNeverWas.sora.selectable[gameVer], 0x00)

  --Riku
  WriteByte(WorldFlags.laCiteDesCloches.riku.selectable[gameVer], 0x00)
  WriteByte(WorldFlags.theGrid.riku.selectable[gameVer], 0x00)
  WriteByte(WorldFlags.prankstersParadise.riku.selectable[gameVer], 0x00)
  WriteByte(WorldFlags.countryOfMusketeers.riku.selectable[gameVer], 0x00)
  WriteByte(WorldFlags.symphonyOfSorcery.riku.selectable[gameVer], 0x00)
  WriteByte(WorldFlags.theWorldThatNeverWas.riku.selectable[gameVer], 0x00)

  ConsolePrint("Unlocked all worlds")
end

---------------------------------------------------------------
------------------------Chests---------------------------------
---------------------------------------------------------------

function LocationHandler:CheckChestBits()
  --New function for tracking which chests have been opened
  if getCharacter() == 0 then --Track Sora's chests
    for i=1, #chests.sora do
      local _chestByte = ReadByte(MemoryAddresses.soraChests[gameVer]+chests.sora[i].offset)
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
      local _chestByte = ReadByte(MemoryAddresses.rikuChests[gameVer]+chests.riku[i].offset)
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

  local _currExp = ReadInt(MemoryAddresses.soraExp[gameVer])
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
  local _currWorld = ReadByte(MemoryAddresses.world[gameVer])
  local _currChar = getCharacter()
  local _storyAddr = 0x00
  if _currWorld == 0x03 then --Traverse Town
    if _currChar == 0 then
      _storyAddr = WorldFlags.traverseTown.sora.story[gameVer]
    else
      _storyAddr = WorldFlags.traverseTown.riku.story[gameVer]
    end
  elseif _currWorld == 0x01 then --Destiny Islands
    _storyAddr = WorldFlags.destinyIslands.sora.story[gameVer]
  elseif _currWorld == 0x04 then --CotM
    if _currChar == 0 then
      _storyAddr = WorldFlags.countryOfMusketeers.sora.story[gameVer]
    else
      _storyAddr = WorldFlags.countryOfMusketeers.riku.story[gameVer]
    end
  elseif _currWorld == 0x05 then --SoS
    if _currChar == 0 then
      _storyAddr = WorldFlags.symphonyOfSorcery.sora.story[gameVer]
    else
      _storyAddr = WorldFlags.symphonyOfSorcery.riku.story[gameVer]
    end
  elseif _currWorld == 0x06 then --PP
    if _currChar == 0 then
      _storyAddr = WorldFlags.prankstersParadise.sora.story[gameVer]
    else
      _storyAddr = WorldFlags.prankstersParadise.riku.story[gameVer]
    end
  elseif _currWorld == 0x08 then --LCdC
    if _currChar == 0 then
      _storyAddr = WorldFlags.laCiteDesCloches.sora.story[gameVer]
    else
      _storyAddr = WorldFlags.laCiteDesCloches.riku.story[gameVer]
    end
  elseif _currWorld == 0x09 then --TG
    if _currChar == 0 then
      _storyAddr = WorldFlags.theGrid.sora.story[gameVer]
    else
      _storyAddr = WorldFlags.theGrid.riku.story[gameVer]
    end
  elseif _currWorld == 0x0A then --TWTNW
    if _currChar == 0 then
      _storyAddr = WorldFlags.theWorldThatNeverWas.sora.story[gameVer]
    else
      _storyAddr = WorldFlags.theWorldThatNeverWas.riku.story[gameVer]
    end
  elseif _currWorld == 0x02 then --Check for AVN beaten
    if _currChar == 1 then
      local _avnCheck = {0xA445B4, 0xA43E34}
      if ReadByte(_avnCheck[gameVer]+0x02) >= 0x07 then
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
          if ReadByte(MemoryAddresses.room[gameVer]) ~= 0x02 and ReadByte(WorldFlags.traverseTown.sora.story[gameVer]+0x02) < 0x03 then --Prevent command menu fix from erroneously sending this out
            return
          end
        end
        if worldEvents[i].ID == 2670249 and ReadByte(WorldFlags.traverseTown.riku.story[gameVer]+0x01) == 0x1F and rikuSpiritFix == 1 then --Do not send out Komory Bat check prematurely
          return
        end
        table.insert(_storiesFound, tostring(worldEvents[i].ID))
        worldEvents[i].sent = true --Prevents this story point from being checked repeatedly
      end
    end
  end

  if #_storiesFound > 0 then
    SendToApClient(MessageTypes.StoryChecked, _storiesFound)
  end

end

---------------------------------------------------------------
-------------------Secret Portals------------------------------
---------------------------------------------------------------
LocationHandler.inAPortal = false
LocationHandler.portalsWon = 0
function LocationHandler:CheckPortal()
  local _portalsWonAddr = {0xA51940, 0xA511C0}

  local _currChar = getCharacter()
  local _world = ReadByte(MemoryAddresses.world[gameVer])
  local _room = ReadByte(MemoryAddresses.room[gameVer])
  local _evt = ReadByte(MemoryAddresses.evt[gameVer])
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
      self.portalsWon = ReadByte(_portalsWonAddr[gameVer])
    end
  else
    --Check for fail condition
    if _evt ~= _portalDetails.evt then --Fight exited
      if ReadByte(_portalsWonAddr[gameVer]) > self.portalsWon then --Player won the fight
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
  if ReadByte(WorldFlags.traverseTown.sora.story[gameVer]+0x05) >= 0x04 then
    _soraDefeated = true
  end
  if ReadByte(WorldFlags.traverseTown.riku.story[gameVer]+0x04) >= 0x7F then
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