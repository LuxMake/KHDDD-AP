local ItemHandler = {}

ItemHandler.State = {
  SpecialItems = {
    KingdomKey = 0,
    WayToTheDawn = 0,
    Filler = 0
  },
  Keyblades = {Sora={},Riku={}},

  BonusStats = {
    Sora = {Hp = {0x50}, Deck = {0x04}, Strength = {0x06}, Magic = {0x07}, Defense = {0x06}},
    Riku = {Hp = {0x50}, Deck = {0x04}, Strength = {0x06}, Magic = {0x07}, Defense = {0x06}}
  },
  Commands = {

  },
  MiscItems = {
    Toys = {},
    DreamPieces = {},
    Food = {}
  },
  Recipes = {},
  Abilities = {
    Shared = {}
  },
  Flowmotion = {},

  World = {sora={},riku={},ids={}},
  Recusant = false
}

ItemHandler.BattleLevels = {0x01, 0x03, 0x08, 0x0E, 0x12, 0x1A, 0x22, 0x26}

function ItemHandler:Reset()
  --self:ResetKeyblades()
  -- self:RebuildKeyblades(true)
  --self:RebuildKeyblades(false)


  ConsolePrint("Item Handler Reset")
end

function ItemHandler:Receive(type, value)
  ConsolePrint("Received " .. type .. " with value " .. value)
  
  if type == "Keyblades [Sora]" or type == "Keyblades [Riku]" then
    self:GiveKeyblade(value)
  elseif type == "Flowmotion" then
    self:GiveFlowmotion(value)
  elseif type == "Command" or type == "Consumable" then
    self:GiveCommand(value)
  elseif type == "World" then
    self:GiveWorld(value, true)
  elseif type == "Stats [Sora]" or type == "Stats [Riku]" then
    self:GiveStatBonus(value)
  elseif type == "Recipe" then
    self:GiveRecipe(value)
  elseif type == "Key" then
    self:GiveKeyItem(value)
  else
    self:GiveMiscItem(value, type)
  end
  
end

function ItemHandler:ReceiveAbility(value)
  --TODO: Sora/Riku considerations
  self:GiveAbility(value, true)
end

function ItemHandler:Request()
  SendToApClient(MessageTypes.RequestAllItems,{})
end

function ItemHandler:ReceiveSpecial(value)
  ConsolePrint('todo: receive special item')
end

function ItemHandler:FindEmptySlot(addrStart, invSize, byteSize, offset) --Returns address of first empty slot
  --local slotFound = false
  --local resAddr = addrStart+offset+(invSize*byteSize)
  local _resAddr = addrStart
  local _resFound = false
  for i=0, invSize do
    if not _resFound and ReadByte(addrStart+offset+(i*byteSize)) == 0x00 then
      --Ensure a proper gap for the whole byte size
      local _isEmpty = true
      for j=1, byteSize do
        if ReadByte(addrStart+offset+(i*byteSize)+j) ~= 0x00 then
          _isEmpty = false
        end
      end
      if _isEmpty then
        _resAddr = addrStart+offset+(i*byteSize)
        _resFound = true
      end
    end
  end

  return _resAddr
end

function ItemHandler:FindExistingSlot(addrStart, invSize, bytes, byteSize, offset) --Returns address bytes exist in
  local resAddr = 0x00
  
  local resAddrFound = false

  for i=0, invSize do
    --if math.fmod(i-1, byteSize) == 0 then 
      if ReadByte(addrStart+i+offset) == bytes[1] then
        --See if the rest of the bytes match
        resAddrFound = true
        for j=2, #bytes do
          if ReadByte(addrStart+offset+i+(j-1)) ~= bytes[j] then
            resAddrFound = false
            ConsolePrint("First byte matched but not following ones")
          end
        end
        if resAddrFound then
          resAddr = addrStart+i+offset
          resAddrFound = false
        end
      end
    --end
  end

  return resAddr
end

-- ############################################################
-- ####################  Key Items  ###########################
-- ############################################################
function ItemHandler:GiveKeyItem(value)
  local _key = getItemById(value)
  WriteArray(MemoryAddresses.keyItems+_key.Offset, _key.Bytes)
  self.State.Recusant = true --Only key item is the recusant sigil
end


-- ############################################################
-- ######################  Worlds  ############################
-- ############################################################

-------------------WORLD DEFINITIONS---------------------
  --_world.Bytes[1] = unlocked flag address
  --_world.Bytes[2] = story flag address
  --_world.Bytes[3] = world number
  --_world.Bytes[4] = start room number
  --_world.Bytes[5] = battle level addr
  --_world.Bytes[6] = selectable address
  --_world.Bytes[7] = starting dock point address (optional)
--------------------------------------------------------- 

function ItemHandler:GiveWorld(value, addToTable)
  local _world = getItemById(value)
  local _unlocked = _world.Bytes[1]
  local _story = _world.Bytes[2]
  local _select = _world.Bytes[6]
  local _no = _world.Bytes[3]
  local _startRoom = _world.Bytes[4]

  --Enable the world for selection on the map
  WriteArray(_select, {_no, _startRoom})

  --Show that progress can be made in the world
  if ReadByte(_unlocked+0x01) == 0x00 then
    WriteByte(_unlocked+0x01, 0x01)
  end


  if value == 2691006 or value == 2691012 then --TWTNW needs docking point unlocked
    WriteByte(_world.Bytes[7], _no)
    if value == 2691006 then --Set unlocked flags for TWTNW [Sora]
      WriteArray(WorldFlags.theWorldThatNeverWas.sora.unlocked, {0x02, 0x01})
    elseif value == 2691012 then --Set unlocked flags for TWTNW [Riku]
      WriteArray(WorldFlags.theWorldThatNeverWas.riku.unlocked, {0x02, 0x01})
    end
  end

  if addToTable then
    if _world.ID < 2691006 or _world.ID == 2691013 then --Sora world
      table.insert(self.State.World.sora, _world)
    elseif _world.ID > 2691006 and _world.ID < 2691012 or _world.ID == 2691014 then --Riku world
      table.insert(self.State.World.riku, _world)
    end
    table.insert(self.State.World.ids, value)

    --Write world to the inventory
    self:PlaceWorldItem(value)
  end

  if Configs.WorldScaling and _world.ID < 2691006 or Configs.WorldScaling and _world.ID == 2691013 then --Don't do scaling for TWTNW
    local _battle = _world.Bytes[5]
    --Apply battle level to this world
    WriteByte(_battle, self.BattleLevels[#self.State.World.sora])
  elseif Configs.WorldScaling and _world.ID > 2691006 and _world.ID < 2691012 or Configs.WorldScaling and _world.ID == 2691014 then
    local _battle = _world.Bytes[5]
    WriteByte(_battle, self.BattleLevels[#self.State.World.riku])
  end

end

function ItemHandler:PlaceWorldItem(value) --Places world items in designated inventory spot
  local _worldInvItem = getItemById(value+100)
  WriteArray(MemoryAddresses.keyItems+_worldInvItem.Offset, _worldInvItem.Bytes)
end

function ItemHandler:ApplyScaling()
  if getCharacter() == 0 then
    for i=1, #self.State.World.sora do
      local _world = self.State.World.sora[i]
      local _battle = _world.Bytes[5]
      if i < #self.BattleLevels then
        WriteByte(_battle, self.BattleLevels[i])
      else
        WriteByte(_battle, self.BattleLevels[#self.BattleLevels-1])
      end
    end
  else
    for i=1, #self.State.World.riku do
      local _world = self.State.World.riku[i]
      local _battle = _world.Bytes[5]
      if i < #self.BattleLevels then
        WriteByte(_battle, self.BattleLevels[i])
      else
        WriteByte(_battle, self.BattleLevels[#self.BattleLevels-1])
      end
    end
  end
end

function ItemHandler:TT2Access()
  local _currWorld = ReadByte(MemoryAddresses.world)
  local _currChar = getCharacter()

  local _ttId = 0

  if _currChar == 0 then
    _ttId = 2691013
  else
    _ttId = 2691014
  end

  if ttId == 0 then
    return
  end

  local _tt2Ready = false

  if _currWorld == 0x03 and countValues(self.State.World.ids, _ttId) < 2 then --In Traverse Town
    if _currChar == 0 then --Check for sora
      local _ttSoraProg = ReadByte(WorldFlags.traverseTown.sora.story+0x03)
      if _ttSoraProg >= 0x40 then
        --Get rid of premature TT2 unlock
          WriteByte(WorldFlags.traverseTown.sora.story+0x03, _ttSoraProg-0x40)
      end
    else --Check for Riku
      local _ttRikuProg = ReadByte(WorldFlags.traverseTown.riku.story+0x03)
      if _ttRikuProg >= 0x01 then --Get rid of premature TT2 unlock
        WriteByte(WorldFlags.traverseTown.riku.story+0x03, 0x00)
      end
    end
  end

  if _currWorld == 0x0B then
    --Should the player have TT2
    if countValues(self.State.World.ids, _ttId) > 1 then --TT2 unlocked
      --Ensure world is cleared
      if _currChar == 0 then
        if ReadByte(WorldFlags.traverseTown.sora.story+0x03) >= 0x02 then
          _tt2Ready = true
        end

        --Fix world if it's already started
        if ReadByte(WorldFlags.traverseTown.sora.story) == 0x31 and ReadByte(WorldFlags.traverseTown.sora.story+0x03) < 0x91 then
          WriteByte(WorldFlags.traverseTown.sora.story+0x03, 0x91)
        end
      else
        if ReadByte(WorldFlags.traverseTown.riku.story+0x02) >= 0x7F then
          _tt2Ready = true
        end

        --Fix the world if it's already started
        if ReadByte(WorldFlags.traverseTown.riku.story+0x04) > 0x00 then --World was already beaten
          WriteByte(WorldFlags.traverseTown.riku.story+0x03, 0xFF)
        end
      end

    else --TT2 not unlocked
      if _currChar == 0 then --Check for Sora
        local _ttSoraProg = ReadByte(WorldFlags.traverseTown.sora.story+0x03)
        if _ttSoraProg >= 0x40 then
          --Get rid of premature TT2 unlock
          WriteByte(WorldFlags.traverseTown.sora.story+0x03, _ttSoraProg-0x40)
        end
      else
        local _ttRikuProg = ReadByte(WorldFlags.traverseTown.riku.story+0x03)
        if _ttRikuProg >= 0x01 then --Get rid of premature TT2 unlock
          WriteByte(WorldFlags.traverseTown.riku.story+0x03, 0x00)
        end
      end
    end

    if _tt2Ready then
      if _currChar == 0 then --Prepare for Sora
        if ReadByte(WorldFlags.traverseTown.sora.story+0x03) < 0x72 then
          WriteByte(WorldFlags.traverseTown.sora.story+0x03, 0x72)
        end
      else --Prepare for Riku
        if ReadByte(WorldFlags.traverseTown.riku.story+0x03) < 0x01 then
          WriteByte(WorldFlags.traverseTown.riku.story+0x03, 0x01)
        end
      end
    else --Ensure neither character can access tt2
      if _currChar == 0 then --Block for Sora
        if ReadByte(WorldFlags.traverseTown.sora.story+0x03) == 0x72 then
          WriteByte(WorldFlags.traverseTown.sora.story+0x03, 0x12)
        end
      else --Block for Riku
        if ReadByte(WorldFlags.traverseTown.riku.story+0x03) == 0x01 then
          WriteByte(WorldFlags.traverseTown.riku.story+0x03, 0x00)
        end
      end
    end
  end
end

function ItemHandler:RebuildWorlds()
  --Reset world lock status
  for i=2691001, 2691014 do
    local _world = getItemById(i)
    if ReadByte(_world.Bytes[6]) == 0x00 then --Only reset lock status if world is not selectable
      if ReadByte(_world.Bytes[2]) < 0x11 then --Do not reset if world is cleared
        WriteByte(_world.Bytes[1]+0x01, 0x00) 
      end
    end
  end

  --Reinstate worlds
  for i=1, #self.State.World do
    self:GiveWorld(self.State.World[i].ID, false)
  end

end

-- ############################################################
-- ######################  Keyblades  #########################
-- ############################################################

function ItemHandler:GiveKeyblade(value)
  local _keyAddr = MemoryAddresses.keyblades
  local _keyblade = getItemById(value)

  if _keyblade.Type == "Keyblades [Riku]" then
    _keyAddr = MemoryAddresses.rikuKeyblades
  end

  local _keybladeSlot = _keyAddr-_keyblade.Offset
  if _keyblade.Type == "Keyblades [Sora]" then
    _keybladeSlot = _keyAddr+_keyblade.Offset
  end

  WriteArray(_keybladeSlot, _keyblade.Bytes)

  if _keyblade.Type == "Keyblades [Riku]" then
    table.insert(self.State.Keyblades.Riku, value)
  else
    table.insert(self.State.Keyblades.Sora, value)
  end

end

-- ############################################################
-- ########################  Stats  ###########################
-- ############################################################
function ItemHandler:GiveStatBonus(value)
  local _stat = getItemById(value)
  if _stat.Type == "Stats [Sora]" then
    if string.find(_stat.Name, "HP") then
      ConsolePrint("Inserting HP increase")
      table.insert(self.State.BonusStats.Sora.Hp, _stat.Bytes[1])
    elseif string.find(_stat.Name, "Deck") then
      ConsolePrint("Inserting deck increase")
      table.insert(self.State.BonusStats.Sora.Deck, _stat.Bytes[1])
    elseif string.find(_stat.Name, "Strength") then
      ConsolePrint("Inserting strength increase")
      table.insert(self.State.BonusStats.Sora.Strength, Configs.StatBonus)
    elseif string.find(_stat.Name, "Magic") then
      ConsolePrint("Inserting magic increase")
      table.insert(self.State.BonusStats.Sora.Magic, Configs.StatBonus)
    elseif string.find(_stat.Name, "Defense") then
      ConsolePrint("Inserting defense increase")
      table.insert(self.State.BonusStats.Sora.Defense, Configs.StatBonus)
    end
  elseif _stat.Type == "Stats [Riku]" then
    if string.find(_stat.Name, "HP") then
      ConsolePrint("Inserting HP increase")
      table.insert(self.State.BonusStats.Riku.Hp, _stat.Bytes[1])
    elseif string.find(_stat.Name, "Deck") then
      ConsolePrint("Inserting deck increase")
      table.insert(self.State.BonusStats.Riku.Deck, _stat.Bytes[1])
    elseif string.find(_stat.Name, "Strength") then
      ConsolePrint("Inserting strength increase")
      table.insert(self.State.BonusStats.Riku.Strength, Configs.StatBonus)
    elseif string.find(_stat.Name, "Magic") then
      ConsolePrint("Inserting magic increase")
      table.insert(self.State.BonusStats.Riku.Magic, Configs.StatBonus)
    elseif string.find(_stat.Name, "Defense") then
      ConsolePrint("Inserting defense increase")
      table.insert(self.State.BonusStats.Riku.Defense, Configs.StatBonus)
    end
  end
end

function ItemHandler:RebuildStats()
  --local _hpAddr = Stats.sora.maxHp
  local _hpAddr = Stats.riku.maxHp
  local _deckAddr = Stats.sora.deckSize
  local _strAddrs = Stats.sora.strength
  local _magAddrs = Stats.sora.magic
  local _defAddrs = Stats.sora.defense

  --Initialize intended stat values
  local _hpVal = 0x00
  local _deckVal = 0x00
  local _strVal = 0x00
  local _magVal = 0x00
  local _defVal = 0x00

  --Get bonus HP from HP Boost Ability
  --local _hpBoostAddr = 0xA4D808 --Add 1 to check Riku
  --local _hpBoostVals = {0x09, 0x1A, 0x3B, 0x7C, 0xFD}
  --local _hpBoost = ReadByte(_hpBoostAddr+getCharacter())
  --local _currBoost = 0
  --for i=1, #_hpBoostVals do
  --  if _hpBoost == _hpBoostVals[i] then
  --    _currBoost = _hpBoostVals[i]
  --  end
  --end

  --Each HP Boost gives +5% HP
  --local _hpVal = _currBoost*0x04 --Each level of HP boost should add 4 HP

  --Calculate stat amounts
  if getCharacter() == 0 then
    for i=1, #self.State.BonusStats.Sora.Hp do
      _hpVal = _hpVal + self.State.BonusStats.Sora.Hp[i]
    end
    for i=1, #self.State.BonusStats.Sora.Deck do
      _deckVal = _deckVal + self.State.BonusStats.Sora.Deck[i]
    end
    for i=1, #self.State.BonusStats.Sora.Strength do
      _strVal = _strVal + self.State.BonusStats.Sora.Strength[i]
    end
    for i=1, #self.State.BonusStats.Sora.Magic do
      _magVal = _magVal + self.State.BonusStats.Sora.Magic[i]
    end
    for i=1, #self.State.BonusStats.Sora.Defense do
      _defVal = _defVal + self.State.BonusStats.Sora.Defense[i]
    end
  else
    for i=1, #self.State.BonusStats.Riku.Hp do
      _hpVal = _hpVal + self.State.BonusStats.Riku.Hp[i]
    end
    for i=1, #self.State.BonusStats.Riku.Deck do
      _deckVal = _deckVal + self.State.BonusStats.Riku.Deck[i]
    end
    for i=1, #self.State.BonusStats.Riku.Strength do
      _strVal = _strVal + self.State.BonusStats.Riku.Strength[i]
    end
    for i=1, #self.State.BonusStats.Riku.Magic do
      _magVal = _magVal + self.State.BonusStats.Riku.Magic[i]
    end
    for i=1, #self.State.BonusStats.Riku.Defense do
      _defVal = _defVal + self.State.BonusStats.Riku.Defense[i]
    end
  end

  --Account for HP boost; should grant +5% HP per installed ability
  --local _boostAmt = (_hpVal*0.05)*_currBoost


  --Write stats
  WriteShort(_hpAddr, _hpVal)
  WriteByte(_deckAddr, _deckVal)

  WriteByte(_strAddrs[1], _strVal)
  WriteByte(_strAddrs[2], _strVal)
  WriteByte(_magAddrs[1], _magVal)
  WriteByte(_magAddrs[2], _magVal)
  WriteByte(_defAddrs[1], _defVal)
  WriteByte(_defAddrs[2], _defVal)

end

-- ############################################################
-- ######################  Commands  ##########################
-- ############################################################
function ItemHandler:GiveCommand(value)
  local _cmdAddr = MemoryAddresses.commandStock
  local _cmd = getItemById(value)

  if _cmd.Type == "Consumable" then
    --Scan to see if consumable exists
    local _hasItem = self:FindExistingSlot(MemoryAddresses.consumableStart, 500, _cmd.Bytes, 0x08, 0x00)
    if _hasItem == 0x00 then
      local _emptySlotAddr = self:FindEmptySlot(_cmdAddr, 500, 0x08, 0x00)
      WriteByte(_emptySlotAddr, _cmd.Bytes[1])
      WriteByte(_emptySlotAddr+0x05, 0x01)
      table.insert(self.State.Commands, value)
    else
      local _currStock = ReadByte(_hasItem+0x05)
      WriteByte(_hasItem+0x05, _currStock+0x01)
    end

  elseif _cmd.Type == "Command" then
    local _emptySlotAddr = self:FindEmptySlot(_cmdAddr, 500, 0x08, 0x00)

    WriteByte(_emptySlotAddr, _cmd.Bytes[1])
    table.insert(self.State.Commands, value)
  end
end

function ItemHandler:FixAirSlide()
  --Sometimes when loading a save, the game thinks that Air Slide is equipped when it is not
  --To prevent this from happening, make sure it''s equipped

  --Last slot of deck 1 will be reserved for Air Slide
  local _airSlideEquipped = self:FindExistingSlot(MemoryAddresses.commandStock, 1000, {0x06, 0x00}, 0x08, 0x00)
  if _airSlideEquipped ~= nil then
    ConsolePrint("Air Slide found; fixing...")
    --Air slide was obtained; check and see if either character have it equipped

    --Get index of air slide in inventory
    local _cmdStart = 0xA4C6D4
    local _airSlideIndex = (_airSlideEquipped-_cmdStart)/0x08

    --TODO: Might need to account for command index greater than 255

    if ReadByte(_airSlideEquipped+0x02) > 0x00 then --Equipped for sora
      ConsolePrint("Fixing Air Slide for Sora")
      local _equipBits = toBits(ReadByte(_airSlideEquipped+0x02))
      if _equipBits[1] == 0x01 then --Equipped in Deck 1
        WriteArray(0xA4DA14, {_airSlideIndex, 0x00})
      end
      if _equipBits[2] == 0x01 then --Equipped in Deck 2
        WriteArray(0xA4DB52, {_airSlideIndex, 0x00})
      end
      if _equipBits[3] == 0x01 then --Equipped in Deck 3
        WriteArray(0xA4DC90, {_airSlideIndex, 0x00})
      end
    end

    if ReadByte(_airSlideEquipped+0x03) > 0x00 then --Equipped for riku
      ConsolePrint("Fixing Air Slide for Riku")
      local _equipBits = toBits(ReadByte(_airSlideEquipped+0x03))
      if _equipBits[1] == 0x01 then --Equipped in Deck 1
        WriteArray(0xA4DDCE, {_airSlideIndex, 0x00})
      end
      if _equipBits[2] == 0x01 then --Equipped in Deck 2
        WriteArray(0xA4DF0C, {_airSlideIndex, 0x00})
      end
      if _equipBits[3] == 0x01 then --Equipped in Deck 3
        WriteArray(0xA4E04A, {_airSlideIndex, 0x00})
      end
    end

  end

end

-- ############################################################
-- ######################  Flowmotion  ########################
-- ############################################################

--Documentation:
--Base
--?: 0x01
--Wall Kick: 0x02 - Bit 2
--Pole Spin: 0x04 - Bit 3
--Pole Swing: 0x08 - Bit 4
--Rail Slide: 0x10 - Bit 5
--?: 0x20 - Bit 6
--Superjump: 0x40 - Bit 7
--ShockDive: 0x80 - Bit 8

--Offset +0x01
--Buzzsaw: 0x01
--Blow-Off: 0x02
--Wheel Rush: 0x04
--Sliding Dive: 0x08


function ItemHandler:GiveFlowmotion(value)
  --Add the flowmotion to the itemhandler state
  local _flow = getItemById(value)
  ConsolePrint("Granting flowmotion ".._flow.Name.." inserting "..tostring(_flow.Bytes[1]))
  table.insert(self.State.Flowmotion, _flow.Bytes[1])
  if value == 2661003 then --Need to grant shock dive with super jump
    table.insert(self.State.Flowmotion, 0x80)
  end
  --table.insert(self.State.Flowmotion, 0x00)
end

function ItemHandler:RebuildFlowmotion()
  local _flowAddr = MemoryAddresses.actionFlags
  local intendedValue = 0

  local _flowTable = removeDuplicates(self.State.Flowmotion)

  for i=1, #_flowTable do
    intendedValue = intendedValue + _flowTable[i]
  end

  if intendedValue > 0xDE then
    intendedValue = 0xDE
  end

  if ReadShort(_flowAddr) ~= intendedValue then --Player has too much flowmotion; rebuild
    WriteByte(_flowAddr, intendedValue)
  end


end

-- ############################################################
-- ######################  Abilities  #########################
-- ############################################################

--Byte 0: Sora Count/Equip
--Byte 1: Riku Count/Equip (Stat abilities only)
--Byte 2: Visible (not sure what values greater than 5 mean)

function ItemHandler:GiveAbility(value, addToTable)
  local _ability = getAbilityById(value)
  local _addr = MemoryAddresses.supportAbilities+_ability.Offset

  local _equipBytes = {0x08, 0x10, 0x20, 0x40, 0x80}
  

  if _ability.Type == "Stat" then --Auto-equip
    --Calculate expected value from item state
    local _amtObtained = 0
    local _equipVal = 0
    for i=1, #self.State.Abilities.Shared do
      if self.State.Abilities.Shared[i] == value then
        _amtObtained = _amtObtained+1
        if _amtObtained > #_equipBytes then
          _equipVal = _equipBytes[#_equipBytes]
        else
          _equipVal = _equipVal+_equipBytes[_amtObtained]
        end
      end
    end
    _equipVal = _equipVal + _amtObtained

    local _isSoraOrRiku = getCharacter()
    _addr = _addr+_isSoraOrRiku --Stat abilities for Riku are offset by 1
    WriteByte(_addr, _equipVal)
    WriteByte(_addr+1+math.abs(_isSoraOrRiku-1), 0x05)
  else --Toggleable ability
    local _currByte = ReadByte(_addr)
    WriteByte(_addr, _currByte+1)
    WriteByte(_addr+0x02, 0x05)
  end

  --TODO: Write stat ups to sora/riku specific table
  if addToTable then
    table.insert(self.State.Abilities.Shared, value)
  end
end

function ItemHandler:RebuildAbilities()
  --Reset status of all Stat abilities
  for i=1, #self.State.Abilities.Shared do
    local _ability = getAbilityById(self.State.Abilities.Shared[i])
    local _addr = MemoryAddresses.supportAbilities+_ability.Offset
    if _ability.Type == "Stat" then --Stat ups need to be re-equipped
      WriteByte(_addr, 0x00)
    end
  end

  --Re-equip all Stat abilities
  for i=1, #self.State.Abilities.Shared do
    local _ability = getAbilityById(self.State.Abilities.Shared[i])
    local _addr = MemoryAddresses.supportAbilities+_ability.Offset
    if _ability.Type == "Stat" then --Stat ups need to be re-equipped
      self:GiveAbility(_ability.ID, false)
    end
  end
end

-- ############################################################
-- #######################  Recipes  ##########################
-- ############################################################
function ItemHandler:GiveRecipe(value)
  local _item = getItemById(value)
  local _slotNo = value-2701001 --Base address for meow wow; recipes need to go in proper slot
  local _targetSlot = MemoryAddresses.recipes+(_slotNo*2)
  ConsolePrint("Target Slot: "..toHex(tostring(_targetSlot)))
  WriteArray(_targetSlot, _item.Bytes)
  table.insert(self.State.Recipes, value)
  if Configs.AutoCraftSpirits then
    self:CraftSpirits(value)
  end
end

function ItemHandler:RecipeToState(value)
  --This table only logs a recipe to the state table without adding to inventory or auto-crafting
  table.insert(self.State.Recipes, value)
end

function ItemHandler:RecipeToInv(value)
  --This only adds the recipe to inventory; does not add to state
  local _item = getItemById(value)
  local _slotNo = value-2701001 --Base address for meow wow; recipes need to go in proper slot
  local _targetSlot = MemoryAddresses.recipes+(_slotNo*2)
  ConsolePrint("Target Slot: "..toHex(tostring(_targetSlot)))
  WriteArray(_targetSlot, _item.Bytes)
end

function ItemHandler:CheckMacguffins()
  local _hasMacguffin = false

  local _uniqueRecipes = removeDuplicates(self.State.Recipes)

  --Standard Goal

  --Check for required items on standard run
  if Configs.Goal == 0 and hasValue(self.State.Recipes, 2701001) and hasValue(self.State.Recipes, 2701004) and #_uniqueRecipes >= Configs.RecipeReqs and self.State.Recusant then
    _hasMacguffin = true

    --Unlock save points if fast go mode
    if Configs.FastGoMode then
      --TODO: Might need to update story flags
      --Unlock for Sora
      WriteArray(0x1097913E, {0x0A, 0x03, 0x57})

      --Unlock for Riku
      WriteArray(0x109791AA, {0x0A, 0x0D})
      WriteInt(MemoryAddresses.worldStatusR+0xCC, 0)
    end
  end

  if Configs.Goal == 1 and #_uniqueRecipes >= Configs.RecipeReqs then --Simplified goal for superbosses
    _hasMacguffin = true
  end

  return _hasMacguffin

end

function ItemHandler:CraftSpirits(value)
  math.randomseed(os.time()) --Set seed to ensure randomness

  local _baseRecipe = getItemById(value)

  local _spiritId = (value - 2701001)+1 --Get int value representing spirit

  local _spiritInv = 0xA45A70
  local _spiritOffset = 0x100 --Add this to base address for each spirit in inventory

  --TODO: Make this account for local spirit crafting
  local _spiritAddr = _spiritInv + (_spiritOffset * #self.State.Recipes)

  --Write Spirit Type to inventory
  WriteInt(_spiritAddr, _spiritId)

  --Assign a random disposition
  local _dispositionOffset = 0x02
  local _dispositions = {0x00, 0x10, 0x20, 0x30}
  WriteByte(_spiritAddr+_dispositionOffset, _dispositions[math.random(1, 4)])

  local _levelOffset = 0x03 --Add this to spirit addr to change spirit level
  local _currHpOffset = 0x04 --This is the Hp of the spirit
  local _nameOffset = 0x06 --Spirit Name

  --Write level
  WriteByte(_spiritAddr+_levelOffset, 0x01)

  --Write Spirit Name
  local _spiritName = string.sub(_baseRecipe.Name, 1, #_baseRecipe.Name-7)
  writeTxtToGame(_spiritAddr+_nameOffset, _spiritName, 0)

  local _affinityOffset = 0x1E
  WriteByte(_spiritAddr+_affinityOffset, 0x22) --2/2 Affinity
  --0x1F Unknown

  --Color
  local _colorOffset = 0x20
  --TODO: Get colors from AP side
  WriteInt(_spiritAddr+_colorOffset, math.random(0x00, 0xFF)) --R
  WriteInt(_spiritAddr+_colorOffset+0x01, math.random(0x00, 0xFF)) --G
  WriteInt(_spiritAddr+_colorOffset+0x02, math.random(0x00, 0xFF)) --B
  --WriteArray(_spiritAddr+_colorOffset, {0xFF, 0xFF, 0xFF}) --White Dream Eater
  local _expOffset = 0x24
  WriteInt(_spiritAddr+_expOffset, ReadInt(Stats.sora.exp))

  local _maxHpOffset = 0x30
  local _statOffset = 0x3D

  --Write Spirit Stats
  local _spiritStats = SpiritStats[_spiritId]
  local _hpBonus = math.random()+math.random(0, 3)
  local _strBonus = math.random()+math.random(0, 3)
  local _magBonus = math.random()+math.random(0, 3)
  local _defBonus = math.random()+math.random(0, 3)
  WriteByte(_spiritAddr+_maxHpOffset, math.floor(_spiritStats.hp+_hpBonus))
  WriteByte(_spiritAddr+_currHpOffset, math.floor(_spiritStats.hp+_hpBonus))
  WriteByte(_spiritAddr+_statOffset, math.floor(_spiritStats.str+_strBonus))
  WriteByte(_spiritAddr+_statOffset+1, math.floor(_spiritStats.mag+_magBonus))
  WriteByte(_spiritAddr+_statOffset+2, math.floor(_spiritStats.def+_defBonus))
  WriteByte(_spiritAddr+_statOffset+3, _spiritStats.fireRes)
  WriteByte(_spiritAddr+_statOffset+4, _spiritStats.iceRes)
  WriteByte(_spiritAddr+_statOffset+5, _spiritStats.elecRes)
  WriteByte(_spiritAddr+_statOffset+6, _spiritStats.waterRes)
  WriteByte(_spiritAddr+_statOffset+7, _spiritStats.darkRes)
  WriteByte(_spiritAddr+_statOffset+8, _spiritStats.lightRes)


end

-- ############################################################
-- ######################  Misc Items  ########################
-- ############################################################

function ItemHandler:GiveMiscItem(value, type)
  local _itemAddr = 0x00
  local _invList

  if type == "Toy" then
    _itemAddr = MemoryAddresses.toys
    _invList = self.State.MiscItems.Toys
  elseif type == "Food" then
    _itemAddr = MemoryAddresses.food
    _invList = self.State.MiscItems.Food
  elseif type == "DreamPieces" then
    _itemAddr = MemoryAddresses.dreamPieces
    _invList = self.State.MiscItems.DreamPieces
  end
  local _item = getItemById(value)

  local _hasItem = self:FindExistingSlot(_itemAddr, #_invList, _item.Bytes, 4, 0x00)

  if _hasItem == 0x00 then
    local emptySlotAddr = self:FindEmptySlot(_itemAddr, #_invList, 4, 0x00)
    WriteArray(emptySlotAddr, _item.Bytes) --TODO: CONSIDER EXISTING QUANTITIES
    WriteByte(emptySlotAddr+0x02, 0x01) --Writes one of this item
    table.insert(_invList, value)


    if type == "Toy" then
      self.State.MiscItems.Toys = _invList
    elseif type == "Food" then
      self.State.MiscItems.Food = _invList
    elseif type == "DreamPieces" then
      self.State.MiscItems.DreamPieces = _invList
    end

  else
    local _currAmt = ReadByte(_hasItem+0x02)
    WriteByte(_hasItem+0x02, _currAmt+0x01)
  end

end



return ItemHandler
