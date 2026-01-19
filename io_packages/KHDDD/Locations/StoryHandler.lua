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
      table.insert(flagAddrs, {0xA40C24, 0xA404A4}) --EGS: A404A4
      table.insert(flagAddrs, {0xA40C1E, 0xA4049E}) --EGS: A4049E
      table.insert(flagAddrs, {0xA40C26, 0xA404A6})
      table.insert(flagAddrs, {0xA40C20, 0xA404A0})
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
      table.insert(flagAddrs, {0x1B3180DB6, 0xA40636}) --A40636 --1B3180636
      table.insert(flagAddrs, {0x1B3180DBA, 0xA4063A})
      table.insert(flagAddrs, {0x1B3180DBC, 0xA4063C})
      table.insert(flagAddrs, {0x1B3180DCE, 0xA4064E})
      table.insert(flagAddrs, {0x1B3180DD2, 0xA40652})
      table.insert(flagAddrs, {0x1B3180DF2, 0xA40672})
      table.insert(flagAddrs, {0x1B3180DF6, 0xA40676})
    else
      

      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagAddrs, {0xA435BC, 0xA42E3C})
      table.insert(flagAddrs, {0xA435EC, 0xA42E6C})
      table.insert(flagAddrs, {0xA435EE, 0xA42E6E})
      table.insert(flagAddrs, {0xA435F0, 0xA42E70})
      table.insert(flagAddrs, {0xA435F2, 0xA42E72})
      table.insert(flagAddrs, {0xA435F4, 0xA42E74})
      table.insert(flagAddrs, {0xA435F6, 0xA42E76})
      table.insert(flagAddrs, {0xA43616, 0xA42E96})
    end
  end

  if worldNo == 0x05 then --Symphony of Sorcery
    --Insert into locals
    if currChar == 0 then
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x03)
      table.insert(flagVals, 0x02)
      table.insert(flagAddrs, {0x1B3180F36, 0xA407B6}) --1B31807B6
      table.insert(flagAddrs, {0x1B3180F72, 0xA407F2})
      table.insert(flagAddrs, {0x1B3180F76, 0xA407F6})
    else
      table.insert(flagVals, 0x02)
      table.insert(flagAddrs, {0xA43758, 0xA42FD8})
    end
  end

  if worldNo == 0x06 then --Prankster's Paradise
    if currChar == 0 then
      table.insert(flagVals, 0x02)
      table.insert(flagAddrs, {0x19E4C10A4, 0xA40924}) --19E4C0924
    else
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x00)
      table.insert(flagAddrs, {0xA438D4, 0xA43154})
      table.insert(flagAddrs, {0xA438D6, 0xA43156})
    end
  end

  if worldNo == 0x08 then --La Cite de Cloches
    if currChar == 0 then
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x03) --D4: 03 D5: 00 D6: 01 D7: 00 D8:02
      table.insert(flagVals, 0x02)
      table.insert(flagAddrs, {0x19E4C13CE, 0xA40C4E}) --19E4C0C4E
      table.insert(flagAddrs, {0x19E4C13D4, 0xA40C54})
      table.insert(flagAddrs, {0x19E4C13D8, 0xA40C58})
    else
      table.insert(flagVals, 0x03)
      table.insert(flagVals, 0x00)
      table.insert(flagAddrs, {0xA43BEC, 0xA4346C}) --Might need to be A433BEC
      table.insert(flagAddrs, {0xA43BEE, 0xA4346E})
    end
  end

  if worldNo == 0x09 then --The Grid
    if currChar == 0 then
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x03)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagAddrs, {0x19E4C1536, 0xA40DB6})
      table.insert(flagAddrs, {0x19E4C1542, 0xA40DC2})
      table.insert(flagAddrs, {0x19E4C1548, 0xA40DC8})
      table.insert(flagAddrs, {0x19E4C154E, 0xA40DCE})
      table.insert(flagAddrs, {0x19E4C1556, 0xA40DD6})
    else
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagVals, 0x02)
      table.insert(flagAddrs, {0xA43D4E, 0xA435CE})
      table.insert(flagAddrs, {0xA43D5A, 0xA435DA})
      table.insert(flagAddrs, {0xA43D60, 0xA435E0})
    end
  end

  for i=1, #flagVals do
    WriteByte(flagAddrs[i][gameVer], flagVals[i])
  end
end

function StoryHandler:OverwriteStoryVars()

  local _currWorld = ReadByte(MemoryAddresses.world[gameVer])
  local _currRoom = ReadByte(MemoryAddresses.room[gameVer])

  --See if menu fix should be re-enabled
  if menuFixApplied == 2 then
    if getCharacter() == 1 and not fixPause or _currRoom ~= 0x02 and not fixPause or _currWorld ~= 0x03 and not fixPause then
      --Reapply the menu fix
      fixMenuOptions()
    end
  end

  --Skip DI if applicable
  if _currWorld == 0x01 then
    if Configs.SkipDI and ReadByte(WorldFlags.destinyIslands.sora.story[gameVer]) == 0x00 then
      WriteArray(WorldFlags.destinyIslands.sora.story[gameVer], {0xFF, 0xFF, 0x1F})
      SetStartingLocation()
    end
  end

  --Correct story for TT
  if _currWorld == 0x03 then

    if getCharacter() == 0 and ReadByte(WorldFlags.traverseTown.sora.story[gameVer]+0x03) == 0x72 then --Start Sora TT2
      WriteByte(MemoryAddresses.room[gameVer], 0x05)
      WriteByte(MemoryAddresses.map[gameVer], 0x0035)
      WriteByte(MemoryAddresses.btl[gameVer], 0x0035)
      WriteByte(MemoryAddresses.evt[gameVer], 0x0035)
    end

    if getCharacter() == 1 and ReadByte(WorldFlags.traverseTown.riku.story[gameVer]+0x03) == 0x01 then --Start Riku TT2
      WriteByte(MemoryAddresses.room[gameVer], 0x01)
      WriteByte(MemoryAddresses.map[gameVer], 0x0040)
      WriteByte(MemoryAddresses.btl[gameVer], 0x0040)
      WriteByte(MemoryAddresses.evt[gameVer], 0x0040)
    end

    if getCharacter() == 0 and _currRoom == WorldFlags.traverseTown.sora.startRoom then
      if ReadByte(WorldFlags.traverseTown.sora.story[gameVer]+0x01) == 0xF1 and ReadByte(WorldFlags.traverseTown.sora.story[gameVer]+0x02) == 0x00 then
        --WriteByte(WorldFlags.traverseTown.sora.story+0x01, 0xF1)
        --fixMenuOptions()
        WriteByte(MemoryAddresses.room[gameVer], 0x01)
        WriteByte(MemoryAddresses.map[gameVer], 0x0036)
        WriteByte(MemoryAddresses.evt[gameVer], 0x0036)
        WriteByte(MemoryAddresses.btl[gameVer], 0x0036)
        self:SetRoomFlags(0x03, 0)
      end

    elseif getCharacter() == 1 and _currRoom == WorldFlags.traverseTown.riku.startRoom then
      if ReadByte(WorldFlags.traverseTown.riku.story[gameVer]+0x01) == 0x01 then
        WriteByte(WorldFlags.traverseTown.riku.story[gameVer], 0x31)
        WriteByte(MemoryAddresses.room[gameVer], 0x03)
        WriteByte(MemoryAddresses.map[gameVer], 0x0041)
        WriteByte(MemoryAddresses.evt[gameVer], 0x0041)
        WriteByte(MemoryAddresses.btl[gameVer], 0x0041)
        rikuSpiritFix = 2
      elseif rikuSpiritFix == 1 and _currRoom == WorldFlags.traverseTown.riku.startRoom then --Hasn't been to TT yet
        WriteArray(WorldFlags.traverseTown.riku.story[gameVer], {0x31, 0x01})
        WriteByte(MemoryAddresses.room[gameVer], 0x03)
        WriteByte(MemoryAddresses.map[gameVer], 0x0041)
        WriteByte(MemoryAddresses.evt[gameVer], 0x0041)
        WriteByte(MemoryAddresses.btl[gameVer], 0x0041)
        rikuSpiritFix = 2
        ConsolePrint("Starting Riku TT")
      elseif ReadByte(WorldFlags.traverseTown.riku.story[gameVer]+0x03) > 0x00 and countValues(ItemHandler.State.World.ids, 2691014) < 2 then
        --Prevent TT2 events from starting
        WriteByte(WorldFlags.traverseTown.riku.story[gameVer]+0x03, 0x00)
        WriteByte(MemoryAddresses.map[gameVer], 0x01)
        WriteByte(MemoryAddresses.btl[gameVer], 0x01)
        WriteByte(MemoryAddresses.evt[gameVer], 0x01)
      end
    end

    if _currRoom == 0x3C and ReadByte(WorldFlags.traverseTown.sora.story[gameVer]+0x01) == 0x01 then --Skip Sora TT Dive
      SetStartingLocation()
    end

    --Julius
      if ReadByte(MemoryAddresses.room[gameVer]) == 0x09 and ReadByte(MemoryAddresses.map[gameVer]) == 0x0034 then --Don't play rematch cutscene
        WriteByte(MemoryAddresses.map[gameVer], 0x04)
        WriteByte(MemoryAddresses.btl[gameVer], 0x02)
        WriteByte(MemoryAddresses.evt[gameVer], 0x04)
      end

    --Menu fix stuff
    if _currRoom == 0x02 and menuFixApplied == 1 and getCharacter() == 0 and not fixPause then --Reset some story vals for sora to progress normally
      WriteByte(WorldFlags.traverseTown.sora.story[gameVer]+0x01, 0x03)
      menuFixApplied = 2
    end
    if menuFixApplied == 2 and ReadByte(WorldFlags.traverseTown.sora.story[gameVer]+0x01) > 0x11 and not fixPause then
      menuFixApplied = 0 --Menu fix no longer needed
    end 

    --Attempt to correct menu fix when it is no longer relevant
    if menuFixApplied == 0 and ReadByte(WorldFlags.traverseTown.sora.story[gameVer]+0x02) > 0x03 then
      menuFixApplied = 2
      fixPause = false
    end
    
  end

  --Correct story for CotM

  --Room;Evt: 0x07; 0x0026
  --Before Slide Roll: 0x7FFF01
  --After Slide Roll: 0xFFFF01

  if _currWorld == 0x04 and _currRoom == 0x0F then
    if ReadByte(WorldFlags.countryOfMusketeers.sora.story[gameVer]+0x01) == 0x01 and getCharacter() == 0 then
      ConsolePrint("Attempting to set event values")
      WriteByte(MemoryAddresses.room[gameVer], 0x08)
      WriteByte(MemoryAddresses.map[gameVer], 0x0033)
      WriteByte(MemoryAddresses.evt[gameVer], 0x0033)
      WriteByte(MemoryAddresses.btl[gameVer], 0x0033)
      self:SetRoomFlags(_currWorld, 0)
    end
  elseif _currWorld == 0x04 and _currRoom == 0x02 then
    if ReadByte(WorldFlags.countryOfMusketeers.riku.story[gameVer]+0x01) == 0x01 and getCharacter() == 1 then
      WriteByte(MemoryAddresses.room[gameVer], 0x11)
      WriteByte(MemoryAddresses.map[gameVer], 0x003A)
      WriteByte(MemoryAddresses.btl[gameVer], 0x003A)
      WriteByte(MemoryAddresses.evt[gameVer], 0x003A)
      self:SetRoomFlags(_currWorld, 1)
    end
  end

  --Correct story for SoS
  if _currWorld == 0x05 then
    if _currRoom == 0x0F then --World Start
      if ReadByte(WorldFlags.symphonyOfSorcery.sora.story[gameVer]+0x01) == 0x01 and getCharacter() == 0 then
        --Unlock Sora's dock point for SoS
        WriteByte(WorldFlags.symphonyOfSorcery.sora.dockPoint[gameVer], 0x05)

        --Start Sora's story for SoS
        WriteByte(MemoryAddresses.room[gameVer], 0x01)
        WriteByte(MemoryAddresses.map[gameVer], 0x0033)
        WriteByte(MemoryAddresses.evt[gameVer], 0x0033)
        WriteByte(MemoryAddresses.btl[gameVer], 0x0033)
        self:SetRoomFlags(_currWorld, 0)
      elseif ReadByte(WorldFlags.symphonyOfSorcery.riku.story[gameVer]+0x01) == 0x01 and getCharacter() == 1 then
        WriteByte(MemoryAddresses.room[gameVer], 0x13)
        WriteByte(MemoryAddresses.map[gameVer], 0x0036)
        WriteByte(MemoryAddresses.evt[gameVer], 0x0036)
        WriteByte(MemoryAddresses.btl[gameVer], 0x0036)
        self:SetRoomFlags(_currWorld, 1)
      end
    end
  end

  --Correct story for PP

  if _currWorld == 0x06 and _currRoom == 0x01 then
    if ReadByte(WorldFlags.prankstersParadise.sora.story[gameVer]+0x01) == 0x01 and getCharacter() == 0 then
      WriteByte(MemoryAddresses.map[gameVer], 0x0033)
      WriteByte(MemoryAddresses.evt[gameVer], 0x0033)
      WriteByte(MemoryAddresses.btl[gameVer], 0x0033)
      self:SetRoomFlags(_currWorld, 0)
    end
  elseif _currWorld == 0x06 and _currRoom == 0x06 then
    if ReadByte(WorldFlags.prankstersParadise.riku.story[gameVer]+0x01) == 0x01 and getCharacter() == 1 then
      WriteByte(MemoryAddresses.map[gameVer], 0x003A)
      WriteByte(MemoryAddresses.evt[gameVer], 0x003A)
      WriteByte(MemoryAddresses.btl[gameVer], 0x003A)
      self:SetRoomFlags(_currWorld, 1)
    end
  end

  --Correct story for LCdC
  if _currWorld == 0x08 and _currRoom == 0x0A then
    if ReadByte(WorldFlags.laCiteDesCloches.sora.story[gameVer]+0x01) == 0x01 and getCharacter() == 0 then
      WriteByte(MemoryAddresses.map[gameVer], 0x0033)
      WriteByte(MemoryAddresses.evt[gameVer], 0x0033)
      WriteByte(MemoryAddresses.btl[gameVer], 0x0033)
      self:SetRoomFlags(ReadByte(MemoryAddresses.world[gameVer]))
    elseif ReadByte(WorldFlags.laCiteDesCloches.riku.story[gameVer]+0x01) == 0x01 and getCharacter() == 1 then
      WriteByte(MemoryAddresses.room[gameVer], 0x01)
      WriteByte(MemoryAddresses.map[gameVer], 0x0038)
      WriteByte(MemoryAddresses.evt[gameVer], 0x0038)
      WriteByte(MemoryAddresses.btl[gameVer], 0x0038)
      self:SetRoomFlags(ReadByte(MemoryAddresses.world[gameVer]), 1)
    end
  end

  --Correct story for TG
  if _currWorld == 0x09 then
    if _currRoom == 0x08 then
      if ReadByte(WorldFlags.theGrid.sora.story[gameVer]+0x01) == 0x01 and getCharacter() == 0 then
        WriteByte(MemoryAddresses.map[gameVer], 0x0033)
        WriteByte(MemoryAddresses.evt[gameVer], 0x0033)
        WriteByte(MemoryAddresses.btl[gameVer], 0x0033)
        self:SetRoomFlags(_currWorld, 0)
      elseif ReadByte(WorldFlags.theGrid.riku.story[gameVer]+0x01) == 0x01 and getCharacter() == 1 then
        --TODO: Setting to skip light cycle section
        WriteByte(MemoryAddresses.room[gameVer], 0x08) --0x0B; 0x0039 m/e/b to warp directly to light cycle
        WriteByte(MemoryAddresses.map[gameVer], 0x0036)
        WriteByte(MemoryAddresses.evt[gameVer], 0x0036)
        WriteByte(MemoryAddresses.btl[gameVer], 0x0036)
        self:SetRoomFlags(_currWorld, 1)
      end
    end

    --Skip light cycle if Riku
    if _currRoom == 0x0B and ReadByte(MemoryAddresses.evt[gameVer]) == 0x0039 then
      if Configs.SkipLightCycle then
        WriteByte(WorldFlags.theGrid.riku.story[gameVer]+0x01, 0x1F)
        WriteByte(MemoryAddresses.room[gameVer], 0x0A)
        WriteByte(MemoryAddresses.map[gameVer], 0x0001)
        WriteByte(MemoryAddresses.evt[gameVer], 0x0001)
        WriteByte(MemoryAddresses.btl[gameVer], 0x0001)
      end
    end
  end

  --Correct story for TWTNW
  if _currWorld == 0x0A and _currRoom == 0x01 then
    if ReadByte(WorldFlags.theWorldThatNeverWas.sora.story[gameVer]+0x01) == 0x01 and getCharacter() == 0 then
      WriteByte(MemoryAddresses.map[gameVer], 0x0033)
      WriteByte(MemoryAddresses.evt[gameVer], 0x0033)
      WriteByte(MemoryAddresses.btl[gameVer], 0x0033)
      WriteByte(MemoryAddresses.room[gameVer], 0x0D)
      --setRoomFlags(ReadByte(MemoryAddresses.world)) TWTNW doesn't need room flags(?)
    end
  elseif _currWorld == 0x0A and _currRoom == 0x04 then
    if ReadByte(WorldFlags.theWorldThatNeverWas.riku.story[gameVer]+0x01) == 0x01 and getCharacter() == 1 then
      WriteByte(MemoryAddresses.map[gameVer], 0x0035)
      WriteByte(MemoryAddresses.evt[gameVer], 0x0035)
      WriteByte(MemoryAddresses.btl[gameVer], 0x0035)
    end
  elseif _currWorld == 0x0A and ReadByte(WorldFlags.theWorldThatNeverWas.riku.dockPoint[gameVer]) == 0x00 and ReadByte(WorldFlags.theWorldThatNeverWas.riku.story[gameVer]+0x01) > 0x01 then
    --Re-enable docking point at Riku's TWTNW if the world has already been visited
    WriteByte(WorldFlags.theWorldThatNeverWas.riku.dockPoint[gameVer], 0x0A)
  end

  --Check for macguffins
  if _currWorld == 0x0A and getCharacter() == 1 then --Check for Riku's wincon
    if ItemHandler:CheckMacguffins() and Configs.Goal == 0 then
      if Configs.Character == 2 then --Set Xemnas defeated flag
        if Configs.Character == 2 and ReadByte(WorldFlags.theWorldThatNeverWas.sora.story[gameVer]+0x02) < 0xFF then
          WriteByte(WorldFlags.theWorldThatNeverWas.sora.story[gameVer]+0x02, 0xFF)
        end
      end
    else
      if Configs.Character == 2 and ReadByte(WorldFlags.theWorldThatNeverWas.sora.story[gameVer]+0x02) > 0x00 then
        WriteByte(WorldFlags.theWorldThatNeverWas.sora.story[gameVer]+0x02, 0x00)
      end
      if Configs.Character == 0 and ReadByte(WorldFlags.theWorldThatNeverWas.sora.story[gameVer]+0x02) == 0xFF then
        WriteByte(WorldFlags.theWorldThatNeverWas.sora.story[gameVer]+0x02, 0x00)
      end
    end
  end

  --Check if fast go mode conditions are met
  if Configs.FastGoMode and Configs.Goal == 0 then
    if Configs.Character == 0 or Configs.Character == 2 then
      if ItemHandler:CheckMacguffins() and getCharacter() == 1 then
        if ReadByte(MemoryAddresses.room[gameVer]) == 0x0D and ReadByte(MemoryAddresses.world[gameVer]) == 0x0A and ReadByte(WorldFlags.theWorldThatNeverWas.riku.story[gameVer]+0x02) < 0x7F then --Skip story stuff if memory's skyscraper is entered
          --ConsolePrint("Memory's Skyscraper Entered...Updating flags.")
          WriteByte(WorldFlags.theWorldThatNeverWas.sora.story[gameVer]+0x02, 0xFF)
          WriteArray(WorldFlags.theWorldThatNeverWas.riku.story[gameVer], {0x11, 0xFF, 0x7F})
        end
      end
    end
  end

  --TODO: Maybe rewrite Sora check to simply set last byte to 03 to prevent the cutscene from starting
  --Make sure it won't interfere with YX condition
  if _currWorld == 0x0A and getCharacter() == 0 then --Check for Sora's wincon
    if not ItemHandler:CheckMacguffins() then --Prevent sora from doing the xemnas fight
      if ReadByte(MemoryAddresses.room[gameVer]) == 0x0C and ReadByte(MemoryAddresses.evt[gameVer]) == 0x34 then
        --Player is illegally doing the xemnas fight; stop them
        forceDrop()
      end
    end

  end

  if ReadByte(DropAddresses.sora.world[gameVer]) == 0x0A then
    if ReadByte(DropAddresses.sora.evt[gameVer]) == 0x34 and ReadByte(DropAddresses.sora.room[gameVer]) == 0x0C then
      --Player tried to do the xemnas fight
      if getCharacter() == 1 then --Make sure we are already Riku
        WriteByte(DropAddresses.sora.world[gameVer], 0x0B)
        WriteByte(DropAddresses.sora.room[gameVer], 0x01)
        --Correct the story so the cutscene can be repeated
        WriteArray(WorldFlags.theWorldThatNeverWas.sora.story[gameVer], {0x01, 0xFF, 0x00})
      end
    end
  end

  --Update battle levels on the world map
  if _currWorld == 0x0B then
    ItemHandler:ApplyScaling()
  end

end

return StoryHandler