local StoryHandler = {}

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

    if getCharacter() == 1 and _currRoom == WorldFlags.traverseTown.riku.startRoom then
      if ReadByte(WorldFlags.traverseTown.riku.story[gameVer]+0x03) > 0x00 and WorldHandler.WorldsUnlocked.Riku[2] == 0 then
        --Prevent TT2 events from starting
        WriteByte(WorldFlags.traverseTown.riku.story[gameVer]+0x03, 0x00)
        WriteByte(MemoryAddresses.map[gameVer], 0x01)
        WriteByte(MemoryAddresses.btl[gameVer], 0x01)
        WriteByte(MemoryAddresses.evt[gameVer], 0x01)
      end

      if ReadByte(WorldFlags.traverseTown.riku.story[gameVer]+0x03) == 0x01 and WorldHandler.WorldsUnlocked.Riku[2] > 0 then
        WriteByte(MemoryAddresses.map[gameVer], 0x40)
        WriteByte(MemoryAddresses.btl[gameVer], 0x40)
        WriteByte(MemoryAddresses.evt[gameVer], 0x40)
      end
    end

    if _currRoom == 0x3C and ReadShort(World[_gameVer]+0x10) ~= 0x010B then --Skip Sora TT Dive
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

  --Skip light cycle if Riku
  if _currWorld == 0x09 then
    if _currRoom == 0x0B and ReadByte(MemoryAddresses.evt[gameVer]) == 0x0039 and getCharacter() == 1 then
      if Configs.SkipLightCycle then
        WriteByte(WorldFlags.theGrid.riku.story[gameVer]+0x01, 0x1F)
        WriteByte(MemoryAddresses.room[gameVer], 0x0A)
        WriteByte(MemoryAddresses.map[gameVer], 0x0001)
        WriteByte(MemoryAddresses.evt[gameVer], 0x0001)
        WriteByte(MemoryAddresses.btl[gameVer], 0x0001)
      end
    end
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

    --If YX is defeated, set MT vars to prevent crash
    if ReadByte(WorldFlags.theWorldThatNeverWas.riku.story[gameVer]+0x04) == 0x1F then
      local _mtSora = {0xA41D9C, 0xA4161C}
      local _mtRiku = {0xA445B4, 0xA43E34}
      local _rgSora = {0xA41DC4, 0xA41644}
      local _rgRiku = {0xA445DC, 0xA43E5C}
      
      if ReadByte(_mtRiku[gameVer]) ~= 0x0F then
        WriteArray(_mtRiku[gameVer], {0xFF, 0x0F})
        WriteArray(_mtSora[gameVer], {0xFF, 0x0F})
        WriteArray(_rgSora[gameVer], {0xFF, 0xFF, 0xFF, 0xFF}) --Radiant Garden Sora
        WriteArray(_rgRiku[gameVer], {0xFF, 0xFF, 0xFF, 0xFF}) --Radiant Garden Riku
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

end

return StoryHandler