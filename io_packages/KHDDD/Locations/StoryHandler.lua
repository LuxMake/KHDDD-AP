local StoryHandler = {}

function StoryHandler:SetRoomFlags(worldNo, currChar)
  local flagVals = {}
  local flagAddrs = {}
  if worldNo == 0x03 then --Traverse Town
    --Dive room is 3C
    if currChar == 0 then
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x00)
      table.insert(flagVals, 0x00)
      table.insert(flagAddrs, 0xA40C24)
      table.insert(flagAddrs, 0xA40C1E)
      table.insert(flagAddrs, 0xA40C26)
      table.insert(flagAddrs, 0xA40C20)
    end
  end
  if worldNo == 0x04 then --Country of the Musketeers
    if currChar == 0 then
      table.insert(flagVals, 0x03)
      table.insert(flagVals, 0x03)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagAddrs, 0x1B3180DB6)
      table.insert(flagAddrs, 0x1B3180DBA)
      table.insert(flagAddrs, 0x1B3180DBC)
      table.insert(flagAddrs, 0x1B3180DCE)
      table.insert(flagAddrs, 0x1B3180DD2)
      table.insert(flagAddrs, 0x1B3180DF2)
      table.insert(flagAddrs, 0x1B3180DF6)
    else
      

      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagAddrs, 0xA435BC)
      table.insert(flagAddrs, 0xA435EC)
      table.insert(flagAddrs, 0xA435EE)
      table.insert(flagAddrs, 0xA435F0)
      table.insert(flagAddrs, 0xA435F2)
      table.insert(flagAddrs, 0xA435F4)
      table.insert(flagAddrs, 0xA435F6)
      table.insert(flagAddrs, 0xA43616)
    end
  end

  if worldNo == 0x05 then --Symphony of Sorcery
    --Insert into locals
    if currChar == 0 then
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x03)
      table.insert(flagVals, 0x02)
      table.insert(flagAddrs, 0x1B3180F36)
      table.insert(flagAddrs, 0x1B3180F72)
      table.insert(flagAddrs, 0x1B3180F76)
    else
      table.insert(flagVals, 0x02)
      table.insert(flagAddrs, 0xA43758)
    end
  end

  if worldNo == 0x06 then --Prankster's Paradise
    if currChar == 0 then
      table.insert(flagVals, 0x02)
      table.insert(flagAddrs, 0x19E4C10A4)
    else
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x00)
      table.insert(flagAddrs, 0xA438D4)
      table.insert(flagAddrs, 0xA438D6)
    end
  end

  if worldNo == 0x08 then --La Cite de Cloches
    if currChar == 0 then
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x03)
      table.insert(flagVals, 0x02)
      table.insert(flagAddrs, 0x19E4C13CE)
      table.insert(flagAddrs, 0x19E4C13D4)
      table.insert(flagAddrs, 0x19E4C13D8)
    else
      table.insert(flagVals, 0x03)
      table.insert(flagVals, 0x00)
      table.insert(flagAddrs, 0xA433BEC)
      table.insert(flagAddrs, 0xA433BEE)
    end
  end

  if worldNo == 0x09 then --The Grid
    if currChar == 0 then
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x03)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagAddrs, 0x19E4C1536)
      table.insert(flagAddrs, 0x19E4C1542)
      table.insert(flagAddrs, 0x19E4C1548)
      table.insert(flagAddrs, 0x19E4C154E)
      table.insert(flagAddrs, 0x19E4C1556)
    else
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagAddrs, 0xA43D4E)
      table.insert(flagAddrs, 0xA43D5A)
      table.insert(flagAddrs, 0xA43D60)
    end
  end

  for i=1, #flagVals do
    WriteByte(flagAddrs[i], flagVals[i])
  end
end

function StoryHandler:OverwriteStoryVars()

  local _currWorld = ReadByte(MemoryAddresses.world)
  local _currRoom = ReadByte(MemoryAddresses.room)

  --See if menu fix should be re-enabled
  if menuFixApplied == 2 then
    if getCharacter() == 1 and not fixPause or _currRoom ~= 0x02 and not fixPause or _currWorld ~= 0x03 and not fixPause then
      --Reapply the menu fix
      fixMenuOptions()
    end
  end

  --Skip DI if applicable
  if _currWorld == 0x01 then
    if Configs.SkipDI and ReadByte(WorldFlags.destinyIslands.sora.story) == 0x00 then
      WriteArray(WorldFlags.destinyIslands.sora.story, {0xFF, 0xFF, 0x1F})
      SetStartingLocation()
    end
  end

  --Correct story for TT
  if _currWorld == 0x03 then

    if getCharacter() == 0 and ReadByte(WorldFlags.traverseTown.sora.story+0x03) == 0x72 then --Start Sora TT2
      WriteByte(MemoryAddresses.room, 0x05)
      WriteByte(MemoryAddresses.map, 0x0035)
      WriteByte(MemoryAddresses.btl, 0x0035)
      WriteByte(MemoryAddresses.evt, 0x0035)
    end

    if getCharacter() == 1 and ReadByte(WorldFlags.traverseTown.riku.story+0x03) == 0x01 then --Start Riku TT2
      WriteByte(MemoryAddresses.room, 0x01)
      WriteByte(MemoryAddresses.map, 0x0040)
      WriteByte(MemoryAddresses.btl, 0x0040)
      WriteByte(MemoryAddresses.evt, 0x0040)
    end

    if getCharacter() == 0 and _currRoom == WorldFlags.traverseTown.sora.startRoom then
      if ReadByte(WorldFlags.traverseTown.sora.story+0x01) == 0xF1 and ReadByte(WorldFlags.traverseTown.sora.story+0x02) == 0x00 then
        --WriteByte(WorldFlags.traverseTown.sora.story+0x01, 0xF1)
        --fixMenuOptions()
        WriteByte(MemoryAddresses.room, 0x01)
        WriteByte(MemoryAddresses.map, 0x0036)
        WriteByte(MemoryAddresses.evt, 0x0036)
        WriteByte(MemoryAddresses.btl, 0x0036)
        self:SetRoomFlags(0x03, 0)
      end

    elseif getCharacter() == 1 and _currRoom == WorldFlags.traverseTown.riku.startRoom then
      if ReadByte(WorldFlags.traverseTown.riku.story+0x01) == 0x01 then
        WriteByte(WorldFlags.traverseTown.riku.story, 0x31)
        WriteByte(MemoryAddresses.room, 0x03)
        WriteByte(MemoryAddresses.map, 0x0041)
        WriteByte(MemoryAddresses.evt, 0x0041)
        WriteByte(MemoryAddresses.btl, 0x0041)
        rikuSpiritFix = 2
      elseif rikuSpiritFix == 1 and _currRoom == WorldFlags.traverseTown.riku.startRoom then --Hasn't been to TT yet
        WriteArray(WorldFlags.traverseTown.riku.story, {0x31, 0x01})
        WriteByte(MemoryAddresses.room, 0x03)
        WriteByte(MemoryAddresses.map, 0x0041)
        WriteByte(MemoryAddresses.evt, 0x0041)
        WriteByte(MemoryAddresses.btl, 0x0041)
        rikuSpiritFix = 2
        ConsolePrint("Starting Riku TT")
      elseif ReadByte(WorldFlags.traverseTown.riku.story+0x03) > 0x00 and countValues(ItemHandler.State.World.ids, 2691014) < 2 then
        --Prevent TT2 events from starting
        WriteByte(WorldFlagss.traverseTown.riku.story+0x03, 0x00)
        WriteByte(MemoryAddresses.map, 0x01)
        WriteByte(MemoryAddresses.btl, 0x01)
        WriteByte(MemoryAddresses.evt, 0x01)
      end
    end

    if _currRoom == 0x3C and ReadByte(WorldFlags.traverseTown.sora.story+0x01) == 0x01 then --Skip Sora TT Dive
      SetStartingLocation()
    end

    --Julius
      if ReadByte(MemoryAddresses.room) == 0x09 and ReadByte(MemoryAddresses.map) == 0x0034 then --Don't play rematch cutscene
        WriteByte(MemoryAddresses.map, 0x04)
        WriteByte(MemoryAddresses.btl, 0x02)
        WriteByte(MemoryAddresses.evt, 0x04)
      end

    --Menu fix stuff
    if _currRoom == 0x02 and menuFixApplied == 1 and getCharacter() == 0 and not fixPause then --Reset some story vals for sora to progress normally
      WriteByte(WorldFlags.traverseTown.sora.story+0x01, 0x03)
      menuFixApplied = 2
    end
    if menuFixApplied == 2 and ReadByte(WorldFlags.traverseTown.sora.story+0x01) > 0x11 and not fixPause then
      menuFixApplied = 0 --Menu fix no longer needed
    end 

    --Attempt to correct menu fix when it is no longer relevant
    if menuFixApplied == 0 and ReadByte(WorldFlags.traverseTown.sora.story+0x02) > 0x03 then
      menuFixApplied = 2
      fixPause = false
    end
    
  end

  --Correct story for CotM

  --Room;Evt: 0x07; 0x0026
  --Before Slide Roll: 0x7FFF01
  --After Slide Roll: 0xFFFF01

  if _currWorld == 0x04 and _currRoom == 0x0F then
    if ReadByte(WorldFlags.countryOfMusketeers.sora.story+0x01) == 0x01 and getCharacter() == 0 then
      ConsolePrint("Attempting to set event values")
      WriteByte(MemoryAddresses.room, 0x08)
      WriteByte(MemoryAddresses.map, 0x0033)
      WriteByte(MemoryAddresses.evt, 0x0033)
      WriteByte(MemoryAddresses.btl, 0x0033)
      self:SetRoomFlags(_currWorld, 0)
    end
  elseif _currWorld == 0x04 and _currRoom == 0x02 then
    if ReadByte(WorldFlags.countryOfMusketeers.riku.story+0x01) == 0x01 and getCharacter() == 1 then
      WriteByte(MemoryAddresses.room, 0x11)
      WriteByte(MemoryAddresses.map, 0x003A)
      WriteByte(MemoryAddresses.btl, 0x003A)
      WriteByte(MemoryAddresses.evt, 0x003A)
      self:SetRoomFlags(_currWorld, 1)
    end
  end

  --Correct story for SoS
  if _currWorld == 0x05 then
    if _currRoom == 0x0F then --World Start
      if ReadByte(WorldFlags.symphonyOfSorcery.sora.story+0x01) == 0x01 and getCharacter() == 0 then
        --Unlock Sora's dock point for SoS
        WriteByte(WorldFlags.symphonyOfSorcery.sora.dockPoint, 0x05)

        --Start Sora's story for SoS
        WriteByte(MemoryAddresses.room, 0x01)
        WriteByte(MemoryAddresses.map, 0x0033)
        WriteByte(MemoryAddresses.evt, 0x0033)
        WriteByte(MemoryAddresses.btl, 0x0033)
        self:SetRoomFlags(_currWorld, 0)
      elseif ReadByte(WorldFlags.symphonyOfSorcery.riku.story+0x01) == 0x01 and getCharacter() == 1 then
        WriteByte(MemoryAddresses.room, 0x13)
        WriteByte(MemoryAddresses.map, 0x0036)
        WriteByte(MemoryAddresses.evt, 0x0036)
        WriteByte(MemoryAddresses.btl, 0x0036)
        self:SetRoomFlags(_currWorld, 1)
      end
    end
  end

  --Correct story for PP

  if _currWorld == 0x06 and _currRoom == 0x01 then
    if ReadByte(WorldFlags.prankstersParadise.sora.story+0x01) == 0x01 and getCharacter() == 0 then
      WriteByte(MemoryAddresses.map, 0x0033)
      WriteByte(MemoryAddresses.evt, 0x0033)
      WriteByte(MemoryAddresses.btl, 0x0033)
      self:SetRoomFlags(_currWorld, 0)
    end
  elseif _currWorld == 0x06 and _currRoom == 0x06 then
    if ReadByte(WorldFlags.prankstersParadise.riku.story+0x01) == 0x01 and getCharacter() == 1 then
      WriteByte(MemoryAddresses.map, 0x003A)
      WriteByte(MemoryAddresses.evt, 0x003A)
      WriteByte(MemoryAddresses.btl, 0x003A)
      self:SetRoomFlags(_currWorld, 1)
    end
  end

  --Correct story for LCdC
  if _currWorld == 0x08 and _currRoom == 0x0A then
    if ReadByte(WorldFlags.laCiteDesCloches.sora.story+0x01) == 0x01 and getCharacter() == 0 then
      WriteByte(MemoryAddresses.map, 0x0033)
      WriteByte(MemoryAddresses.evt, 0x0033)
      WriteByte(MemoryAddresses.btl, 0x0033)
      self:SetRoomFlags(ReadByte(MemoryAddresses.world))
    elseif ReadByte(WorldFlags.laCiteDesCloches.riku.story+0x01) == 0x01 and getCharacter() == 1 then
      WriteByte(MemoryAddresses.room, 0x01)
      WriteByte(MemoryAddresses.map, 0x0038)
      WriteByte(MemoryAddresses.evt, 0x0038)
      WriteByte(MemoryAddresses.btl, 0x0038)
      self:SetRoomFlags(ReadByte(MemoryAddresses.world), 1)
    end
  end

  --Correct story for TG
  if _currWorld == 0x09 then
    if _currRoom == 0x08 then
      if ReadByte(WorldFlags.theGrid.sora.story+0x01) == 0x01 and getCharacter() == 0 then
        WriteByte(MemoryAddresses.map, 0x0033)
        WriteByte(MemoryAddresses.evt, 0x0033)
        WriteByte(MemoryAddresses.btl, 0x0033)
        self:SetRoomFlags(_currWorld, 0)
      elseif ReadByte(WorldFlags.theGrid.riku.story+0x01) == 0x01 and getCharacter() == 1 then
        --TODO: Setting to skip light cycle section
        WriteByte(MemoryAddresses.room, 0x08) --0x0B; 0x0039 m/e/b to warp directly to light cycle
        WriteByte(MemoryAddresses.map, 0x0036)
        WriteByte(MemoryAddresses.evt, 0x0036)
        WriteByte(MemoryAddresses.btl, 0x0036)
        self:SetRoomFlags(_currWorld, 1)
      end
    end

    --Skip light cycle if Riku
    if _currRoom == 0x0B and ReadByte(MemoryAddresses.evt) == 0x0039 then
      if Configs.SkipLightCycle then
        WriteByte(WorldFlags.theGrid.riku.story+0x01, 0x1F)
        WriteByte(MemoryAddresses.room, 0x0A)
        WriteByte(MemoryAddresses.map, 0x0001)
        WriteByte(MemoryAddresses.evt, 0x0001)
        WriteByte(MemoryAddresses.btl, 0x0001)
      end
    end
  end

  --Correct story for TWTNW
  if _currWorld == 0x0A and _currRoom == 0x01 then
    if ReadByte(WorldFlags.theWorldThatNeverWas.sora.story+0x01) == 0x01 and getCharacter() == 0 then
      WriteByte(MemoryAddresses.map, 0x0033)
      WriteByte(MemoryAddresses.evt, 0x0033)
      WriteByte(MemoryAddresses.btl, 0x0033)
      WriteByte(MemoryAddresses.room, 0x0D)
      --setRoomFlags(ReadByte(MemoryAddresses.world)) TWTNW doesn't need room flags(?)
    end
  elseif _currWorld == 0x0A and _currRoom == 0x04 then
    if ReadByte(WorldFlags.theWorldThatNeverWas.riku.story+0x01) == 0x01 and getCharacter() == 1 then
      WriteByte(MemoryAddresses.map, 0x0035)
      WriteByte(MemoryAddresses.evt, 0x0035)
      WriteByte(MemoryAddresses.btl, 0x0035)
    end
  elseif _currWorld == 0x0A and ReadByte(WorldFlags.theWorldThatNeverWas.riku.dockPoint) == 0x00 and ReadByte(WorldFlags.theWorldThatNeverWas.riku.story+0x01) > 0x01 then
    --Re-enable docking point at Riku's TWTNW if the world has already been visited
    WriteByte(WorldFlags.theWorldThatNeverWas.riku.dockPoint, 0x0A)
  end

  --Check for macguffins
  if _currWorld == 0x0A and getCharacter() == 1 then --Check for Riku's wincon
    if ItemHandler:CheckMacguffins() and Configs.Goal == 0 then
      if Configs.Character == 2 then --Set Xemnas defeated flag
        if Configs.Character == 2 and ReadByte(WorldFlags.theWorldThatNeverWas.sora.story+0x02) < 0xFF then
          WriteByte(WorldFlags.theWorldThatNeverWas.sora.story+0x02, 0xFF)
        end
      end
    else
      if Configs.Character == 2 and ReadByte(WorldFlags.theWorldThatNeverWas.sora.story+0x02) > 0x00 then
        WriteByte(WorldFlags.theWorldThatNeverWas.sora.story+0x02, 0x00)
      end
      if Configs.Character == 0 and ReadByte(WorldFlags.theWorldThatNeverWas.sora.story+0x02) == 0xFF then
        WriteByte(WorldFlags.theWorldThatNeverWas.sora.story+0x02, 0x00)
      end
    end
  end

  --Check if fast go mode conditions are met
  if Configs.FastGoMode and Configs.Goal == 0 then
    if Configs.Character == 0 or Configs.Character == 2 then
      if ItemHandler:CheckMacguffins() and getCharacter() == 1 then
        if ReadByte(MemoryAddresses.room) == 0x0D and ReadByte(MemoryAddresses.world) == 0x0A and ReadByte(WorldFlags.theWorldThatNeverWas.riku.story+0x02) < 0x7F then --Skip story stuff if memory's skyscraper is entered
          --ConsolePrint("Memory's Skyscraper Entered...Updating flags.")
          WriteByte(WorldFlags.theWorldThatNeverWas.sora.story+0x02, 0xFF)
          WriteArray(WorldFlags.theWorldThatNeverWas.riku.story, {0x11, 0xFF, 0x7F})
        end
      end
    end
  end

  --TODO: Maybe rewrite Sora check to simply set last byte to 03 to prevent the cutscene from starting
  --Make sure it won't interfere with YX condition
  if _currWorld == 0x0A and getCharacter() == 0 then --Check for Sora's wincon
    if not ItemHandler:CheckMacguffins() then --Prevent sora from doing the xemnas fight
      if ReadByte(MemoryAddresses.room) == 0x0C and ReadByte(MemoryAddresses.evt) == 0x34 then
        --Player is illegally doing the xemnas fight; stop them
        forceDrop()
      end
    end

  end

  if ReadByte(DropAddresses.sora.world) == 0x0A then
    if ReadByte(DropAddresses.sora.evt) == 0x34 and ReadByte(DropAddresses.sora.room) == 0x0C then
      --Player tried to do the xemnas fight
      if getCharacter() == 1 then --Make sure we are already Riku
        WriteByte(DropAddresses.sora.world, 0x0B)
        WriteByte(DropAddresses.sora.room, 0x01)
        --Correct the story so the cutscene can be repeated
        WriteArray(WorldFlags.theWorldThatNeverWas.sora.story, {0x01, 0xFF, 0x00})
      end
    end
  end

  --Update battle levels on the world map
  if _currWorld == 0x0B then
    ItemHandler:ApplyScaling()
  end

end

return StoryHandler