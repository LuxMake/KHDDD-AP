---------------------------------------------------
------ Kingdom Hearts Dream Drop Distance AP ------
------                by Lux                 ------
---------------------------------------------------
------ Special Thanks to Sonicshadowsilver2, Meebo, & Krujo
---------------------------------------------------

local socket = require("socket")
ItemHandler = require("KHDDD.Items.ItemHandler")
local ItemDefs = require("KHDDD.Items.ItemDefs")
local Spirits = require("KHDDD.Items.Spirits")
local LocationDefs = require("KHDDD.Locations.LocationDefs")
local LocationHandler = require("KHDDD.Locations.LocationHandler")
local StoryHandler = require("KHDDD.Locations.StoryHandler")
local PromptTask = require("KHDDD.Tasks.PromptTask")
local CheatTask = require("KHDDD.Tasks.CheatTask")
local ConfigTask = require("KHDDD.Tasks.ConfigTask")
local RoomSaveTask = require("KHDDD.Tasks.RoomSaveTask")
local SoftlockTask = require("KHDDD.Tasks.SoftlockTask")

LUAGUI_NAME = "DDD AP Connector [Socket]"
LUAGUI_AUTH = "Lux"
LUAGUI_DESC = "Kingdom Hearts DDD AP Integration using Socket"


--Define Globals
local gameID = GAME_ID
local engineType = ENGINE_TYPE

local canExecute = false
local gameStarted = false
local connectionInitialized = false

frameCount = 0
connected = false

local client



-- ############################################################
-- ####################  Globals  #############################
-- ############################################################
--  --rikuKeyblades = 0xA4C288,
MemoryAddresses = { --Primary memory addresses to reference
  keyblades = 0xA4C264,
  rikuKeyblades = 0xA4C2A2,
  commandStock = 0xA4C77C,
  commandDeckPopup = 0xA4C404,
  equippedCommands = 0xA4D9D8,
  dodgeRollStock = 0xA4C70C,
  airSlideStock = 0xA4C714,
  blockStock = 0xA4C71C,
  consumableStart = 0xA4C6FC,
  actionFlags = 0xA98088,
  soraChests = 0x00A42DC0,
  rikuChests = 0x00A455D8,
  toys = 0xA4C535,
  food = 0xA4C4E8,
  dreamPieces = 0xA4C468,
  keyItems = 0xA4C2A4,
  malleableFantasy = 0xA4C498,
  recipes = 0xA4C2F4, --Drak Quack: 0xA4C34A
  soraExp = 0xA98010, --Actual xp
  supportAbilities = 0xA4D85C,
  world = 0x9CF730,
  room = 0x9CF731,
  map = 0x9CF734,
  btl = 0x9CF736,
  evt = 0x9CF738,
  entr = 0x9CF732,
  save = 0xA40760,
  shop = 0x10AD8A20,
  worldStatusS = 0xA41ED8,
  worldStatusR = 0xA446F0,
  chestDataS = 0x1097AE00,
  chestDataR = 0x1097CEC0,
  dropEnabler = 0xA45A6C, --C004 disables drop to Sora
  dropPtr = 0xA97FC0,
  dropOffset = 0x1B0,
  pauseType = 0xA9B2D8, --03 is normal pause
  character = 0xA40760,
  deathPtr = 0xA97FC0,
  deathOffset = 0x1A0,
  enablePause = 0xA9B31C,
  --cutscenePauseType = 0xA3D050, --Accidentally was using auto-skip byte; this might break things later
  cutscenePauseType = 0xA3D06C,
  medals = 0xA51768,
}

EquippedCommands = {
  0xA4D9D8, --Sora Deck 1
  0xA4DB16, --Sora Deck 2
  0xA4DC54, --Sora Deck 3
  0xA4DD92, --Riku Deck 1
  0xA4DED0, --Riku Deck 2
  0xA4E00E  --Riku Deck 3
}

DropAddresses = {
  sora = {
    world = 0xA41D10,
    room = 0xA41D11,
    map = 0xA41D14,
    btl = 0xA41D16,
    evt = 0xA41D18
  },
  riku = {
    world = 0xA44528,
    room = 0xA44529,
    map = 0xA4452C,
    btl = 0xA4452E,
    evt = 0xA44530
  }
}

Configs = {
  --Game Settings
  WorldScaling = true,
  SkipDI = true,
  SkipLightCycle = true,
  AutoCraftSpirits = true,
  FastGoMode = false,
  ExpMult = 10,
  StatBonus = 2,

  --AP Settings
  Character = 0, --0 for both; 1 for Sora Only; 2 for Riku Only
  Deathlink = false,
  RecipeReqs = 0, --Additional recipes needed to win the seed (Meow Wow and Komory Bat are always required)
  Goal = 0 --0: Final Boss; 1: Super Boss
}

ItemOverwrite = {
  dummyNameAddr = 0x10944CF2,
  dummyDescAddr = 0x1095622C,
  --dummyDesc = "An AP Item.",
  dummyDesc = "An item for another world.",
  dummyId = {0x13, 0x08},
  dummyName = "AP Item",
  levelUpTxtAddr = 0x10946494,
  strIncreasedTxt = 0x10946494,
  magIncreasedTxt = 0x109464BC,
  defIncreasedTxt = 0x109464DE,
  hpIncreasedTxt = 0x10946504,
  deckCapIncreasedTxt = 0x10946530,
  dropBonusTxt = 0x10946562,
  keyItemNames = 0x10943EEC,
  keyItemDescs = 0x10952ACA
}

KHSCII = {
  A = 0x41,B = 0x42,C = 0x43,D = 0x44,E = 0x45,F = 0x46,
  G = 0x47,H = 0x48,I = 0x49,J = 0x4A,K = 0x4B,
  L = 0x4C,M = 0x4D,N = 0x4E,O = 0x4F,P = 0x50,
  Q = 0x51,R = 0x52,S = 0x53,T = 0x54,U = 0x55,
  V = 0x56,W = 0x57,X = 0x58,Y = 0x59,Z = 0x5A,
  a = 0x61,b = 0x62,c = 0x63,d = 0x64,e = 0x65,f = 0x66,
  g = 0x67,h = 0x68,i = 0x69,j = 0x6A,k = 0x6B,
  l = 0x6C,m = 0x6D,n = 0x6E,o = 0x6F,p = 0x70,
  q = 0x71,r = 0x72,s = 0x73,t = 0x74,u = 0x75,
  v = 0x76,w = 0x77,x = 0x78,y = 0x79,z = 0x7A,
  Period = 0x2E,Space = 0x20,Exclamation = 0x21, And = 0x26
}

--Record: A51940

Stats = { --Stats for sora and riku
  currHpPtr = 0xA37DB8,
  currHpOffset = 0x71C,
  sora = {
    maxHp = 0xA4D8D0, --HP Bonus is +20 --Also potentially 0xA98022
    currHp = 0xA4D8D2,
    strength = {0xA4D8E5, 0xA98035}, --Also potentially 0xA98035
    magic = {0xA4D8E6, 0xA98036}, --Also potentially 0xA98036
    defense = {0xA4D8E7, 0xA98037}, --Also potentially 0xA98037
    exp = 0xA98010,
    nextLevel = 0xA4D8CC,
    deckSize = 0xA98039
  },
  riku = {
    maxHp = 0xA98020
  }
}

KeybladeStats = {
  soraBase = 0x9D6F9C, --+0 is strength, +1 is magic
  rikuBase = 0x9D6FA8, --15 kbs
  offset = 0x18 --# of bytes between each keyblade entry
}

WorldFlags = {
  destinyIslands = {
    worldNo = 0x01,
    sora = {
      story = 0xA41D94,
    }
  },
  traverseTown = {
    worldNo = 0x03,
    sora = {
      story = 0xA41DA4,
      unlocked = 0xA41F04, 
      battle = 0xA41DFF,
      selectable = 0x10978F18,
      startRoom = 0x01,
      secretPortal = {0x64, 0x01, 0x05}
    },
    riku = {
      story = 0xA445BC,
      unlocked = 0xA4471C,
      battle = 0xA44617,
      selectable = 0x10978FD0,
      startRoom = 0x01,
      secretPortal = {0x65, 0x01, 0x06}
    },

    secretPortalAddr = 0xA515C0
  },
  laCiteDesCloches = {
    worldNo = 0x08,
    sora = {
      unlocked = 0xA41F18,
      selectable = 0x10978F28,
      story = 0xA41DCC,
      startRoom = 0x0A,
      battle = 0xA41E04,
      secretPortal = {0x66, 0x01, 0x01}
    },
    riku = {
      unlocked = 0xA44730,
      selectable = 0x10978FE0,
      story = 0xA445E4,
      startRoom = 0x0A,
      battle = 0xA4461C,
      secretPortal = {0x67, 0x01, 0x01}
    },

    secretPortalAddr = 0xA515C4
  },
  theGrid = {
    worldNo = 0x09,
    sora = {
      unlocked = 0xA41F1C,
      selectable = 0x10978F48,
      story = 0xA41DD4,
      startRoom = 0x08,
      battle = 0xA41E05,
      secretPortal = {0x6A, 0x01, 0x04}
    },
    riku = {
      unlocked = 0xA44734,
      story = 0xA445EC,
      selectable = 0x10979000,
      startRoom = 0x08,
      battle = 0xA4461D,
      secretPortal = {0x6B, 0x01, 0x01}
    },

    secretPortalAddr = 0xA515CC
  },
  prankstersParadise = {
    worldNo = 0x06,
    sora = {
      unlocked = 0xA41F10,
      selectable = 0x10978F38,
      story = 0xA41DBC,
      startRoom = 0x01,
      battle = 0xA41E02,
      secretPortal = {0x68, 0x01, 0x04}
    },
    riku = {
      unlocked = 0xA44728,
      story = 0xA445D4,
      selectable = 0x10978FF0,
      startRoom = 0x06,
      battle = 0xA4461A,
      secretPortal = {0x69, 0x01, 0x0A}
    },

    secretPortalAddr = 0xA515C8
  },
  countryOfMusketeers = {
    worldNo = 0x04,
    sora = {
      unlocked = 0xA41F08,
      selectable = 0x10978F68,
      story = 0xA41DAC,
      startRoom = 0x0F,
      battle = 0xA41E00,
      secretPortal = {0x6C, 0x01, 0x03}
    },
    riku = {
      unlocked = 0xA44720,
      story = 0xA445C4,
      selectable = 0x10979020,
      startRoom = 0x02,
      battle = 0xA44618,
      secretPortal = {0x6D, 0x01, 0x0C}
    },

    secretPortalAddr = 0xA515D0
  },
  symphonyOfSorcery = {
    worldNo = 0x05,
    sora = {
      unlocked = 0xA41F0C,
      selectable = 0x10978F78,
      story = 0xA41DB4,
      startRoom = 0x0F,
      dockPoint = 0x10979106,
      battle = 0xA41E01,
      secretPortal = {0x6E, 0x01, 0x01}
    },
    riku = {
      unlocked = 0xA44724,
      story = 0xA445CC,
      selectable = 0x10979030,
      startRoom = 0x0F,
      battle = 0xA44619
    },

    secretPortalAddr = 0xA515D4
  },
  theWorldThatNeverWas = {
    worldNo = 0x0A,
    sora = {
      unlocked = 0xA41F20,
      selectable = 0x10978F88,
      story = 0xA41DDC,
      startRoom = 0x01,
      dockPoint = 0x1097913A,
      battle = 0xA41E06
    },
    riku = {
      unlocked = 0xA44738,
      story = 0xA445F4,
      selectable = 0x10979040,
      startRoom = 0x04,
      battle = 0xA4461E,
      dockPoint = 0x1097919E,
      GOPoint = 0x109791AA --For the real TWTNW; unlocks for GO mode
    },
  }
}

--Dream Eater Address: 0xA62244

item_usefulness = {
  trap = 0,
  useless = 1,
  normal = 2,
  progression = 3,
  special = 4
}

MessageTypes = {
  Invalid = -1,
  Test = 0,
  ChestChecked = 1,
  LevelChecked = 2,
  ReceiveAllItems = 3,
  RequestAllItems = 4,
  ReceiveSingleItem = 5,
  StoryChecked = 6,
  ClientCommand = 7,
  Deathlink = 8,
  PortalChecked = 9,
  SendSlotData = 10,
  Victory = 11
}

--Items
items = {}
abilities = {}

--Locations
chests = {}
levels = {
  soraLevel = 1,
  soraLevelID = 2660008,
  rikuLevel = 1,
  rikuLevelID = 2660058,
  levelCap=50
}
worldEvents = {}
portalDigits = {}
expTable = {40,250,600,1120,1760,2520,3400,4400,5520,6760,8154,
9621,11351,13157,15135,17242,19530,21990,24560,27305,30249,
33331,36620,40052,43700,47492,51510,55675,60075,64625,69325,
74175,79175,84325,89625,95175,100675,106424,112325,118375,125195,
132175,139329,146644,154125,161770,169580,177555,185695}

SpiritStats = {}

--Needed to fix pause after DE tutorial
fixPause = false

keepDropActive = -1 --Prevent the drop manager from doing its thing

lastHp = 80 --Prevents deathlink from triggering in succession
lastDeathTime = 0
holdDeathlink = false

holdDropTrap = false

menuFixApplied = 0 --Tracks if story vals need to be reset for sora TT1
--0: Menu fix did not get applied or no longer needs to
--1: Menu fix was applied and sora's story needs to be corrected later
--2: Menu fix temporarily disabled; awaiting sora's events to finish

rikuSpiritFix = 0 --Tracks if story vals need to be reset for riku TT1
--0: Menu fix did not get applied or no longer needs to
--1: Menu fix was applied and riku's story needs to be corrected
--2: Menu fix disabled

activeCharacter = 0

currentReceivedIndex = 0 --Updates when a new item is obtained and is saved to the medals value on change
lastReceivedIndex = 0 --Updates when save file is loaded
receivedInit = false --Have we received our items after connecting to the server?

local _soraUnboundSent = false
local _rikuUnboundSent = false

local _activeRoom = 0x00

-- ############################################################
-- ######################  Game State  ########################
-- ############################################################
function initGameState() --Updates various world/event flags to an intial state after connecting
  --Write Traverse Town story flag to immediately unlock World Map
  if ReadByte(WorldFlags.traverseTown.sora.story) < 0x11 then
    WriteByte(WorldFlags.traverseTown.sora.story, 0x11)
  end
  makeDummyItem()

  fixMenuOptions()
  removeInitialMovement()

  LocationHandler:ShowAllWorlds() --Allows full navigation of world map
  LocationHandler:LockSavePoints() --Prevents docking

  ItemHandler:FixAirSlide() --Prevents air slide from being inaccessible

  RoomSaveTask:Init() --Initialize room saves

end

function allPortalsWon()
  local _soraPortalsWon = true
  local _rikuPortalsWon = true

  local _soraPortals = {}
  table.insert(_soraPortals, ReadByte(WorldFlags.traverseTown.sora.story+0x07))
  table.insert(_soraPortals, ReadByte(WorldFlags.laCiteDesCloches.sora.story+0x07))
  table.insert(_soraPortals, ReadByte(WorldFlags.theGrid.sora.story+0x07))
  table.insert(_soraPortals, ReadByte(WorldFlags.prankstersParadise.sora.story+0x07))
  table.insert(_soraPortals, ReadByte(WorldFlags.countryOfMusketeers.sora.story+0x07))
  table.insert(_soraPortals, ReadByte(WorldFlags.symphonyOfSorcery.sora.story+0x07))

  local _rikuPortals = {}
  table.insert(_rikuPortals, ReadByte(WorldFlags.traverseTown.riku.story+0x07))
  table.insert(_rikuPortals, ReadByte(WorldFlags.laCiteDesCloches.riku.story+0x07))
  table.insert(_rikuPortals, ReadByte(WorldFlags.theGrid.riku.story+0x07))
  table.insert(_rikuPortals, ReadByte(WorldFlags.prankstersParadise.riku.story+0x07))
  table.insert(_rikuPortals, ReadByte(WorldFlags.countryOfMusketeers.riku.story+0x07))

  if Configs.Character < 2 then --Check Sora's worlds
    for x=1, #_soraPortals do
      if _soraPortals[x] == 0x00 then
        _soraPortalsWon = false
      end
    end
  end
  if Configs.Character == 0 or Configs.Character == 2 then --Check Riku's worlds
    for x=1, #_rikuPortals do
      if _rikuPortals[x] == 0x00 then
        _rikuPortalsWon = false
      end
    end
  end

  local _returnWin = -1 --Neither character has cleared every portal
  if _soraPortalsWon and not _rikuPortalsWon then
    _returnWin = 1
    --Send location for Sora Unbound
    if not _soraUnboundSent then
      SendToApClient(MessageTypes.PortalChecked, {"2680212"})
      _soraUnboundSent = true
    end
  elseif not _soraPortalsWon and _rikuPortalsWon then
    _returnWin = 2
    --Send location for Riku Unbound
    if not _rikuUnboundSent then
      SendToApClient(MessageTypes.PortalChecked, {"2680213"})
      _rikuUnboundSent = true
    end
  elseif _soraPortalsWon and _rikuPortalsWon then
    --Send location for both Unbound keyblades
    if not _soraUnboundSent then
      SendToApClient(MessageTypes.PortalChecked, {"2680212"})
      _soraUnboundSent = true
    end
    if not _rikuUnboundSent then
      SendToApClient(MessageTypes.PortalChecked, {"2680213"})
      _rikuUnboundSent = true
    end
    _returnWin = 3
  end
  return _returnWin

end

function setSecretPortals()
    --Enable Secret Portals if the world is beaten
    local _ttSecret = WorldFlags.traverseTown.sora.secretPortal
    local _lcdsSecret = WorldFlags.laCiteDesCloches.sora.secretPortal
    local _ppSecret = WorldFlags.prankstersParadise.sora.secretPortal
    local _tgSecret = WorldFlags.theGrid.sora.secretPortal
    local _cotmSecret = WorldFlags.countryOfMusketeers.sora.secretPortal
    local _sosSecret = WorldFlags.symphonyOfSorcery.sora.secretPortal

    if getCharacter() == 1 then
      _ttSecret = WorldFlags.traverseTown.riku.secretPortal
      _lcdsSecret = WorldFlags.laCiteDesCloches.riku.secretPortal
      _ppSecret = WorldFlags.prankstersParadise.riku.secretPortal
      _tgSecret = WorldFlags.theGrid.riku.secretPortal
      _cotmSecret = WorldFlags.countryOfMusketeers.riku.secretPortal

      if ReadByte(WorldFlags.traverseTown.riku.story+0x04) >= 0x01 and allPortalsWon() >= 2 then --Riku beat TT2; Enable Julius
        --Advance story to allow manhole to spawn
        if ItemHandler:CheckMacguffins() then
          if ReadByte(WorldFlags.traverseTown.riku.story+0x04) < 0x4F then
            WriteByte(WorldFlags.traverseTown.riku.story+0x04, 0x4F)
          end
          --Write Fountain Plaza Room Flags
          WriteByte(0xA43466, 0x04)
          WriteByte(0xA43468, 0x01)
          WriteByte(0xA4346A, 0x05)
        end
      end

    else
      if ReadByte(WorldFlags.traverseTown.sora.story+0x04) >= 0x3F then --Sora beat TT2; Enable Julius
        if allPortalsWon() == 1 or allPortalsWon() == 3 then
          if ItemHandler:CheckMacguffins() then
            --Advance story to allow manhole to spawn
            if ReadByte(WorldFlags.traverseTown.sora.story+0x04) < 0x8F then
              WriteByte(WorldFlags.traverseTown.sora.story+0x04, 0x8F)
            end
            --Write Fountain Plaza Room Flags
            WriteByte(0xA40C4E, 0x04)
            WriteByte(0xA40C50, 0x01)
            WriteByte(0xA40C52, 0x05)
          end
        end
      end
    end

    WriteArray(WorldFlags.traverseTown.secretPortalAddr, _ttSecret)
    WriteArray(WorldFlags.laCiteDesCloches.secretPortalAddr, _lcdsSecret)
    WriteArray(WorldFlags.theGrid.secretPortalAddr, _tgSecret)
    WriteArray(WorldFlags.prankstersParadise.secretPortalAddr, _ppSecret)
    WriteArray(WorldFlags.countryOfMusketeers.secretPortalAddr, _cotmSecret)
    WriteArray(WorldFlags.symphonyOfSorcery.secretPortalAddr, _sosSecret)

end

function removeInitialMovement()
  if ReadByte(MemoryAddresses.dodgeRollStock) ~= 0x00 and lastReceivedIndex == 0 then --Get rid of initial movement
    local _removeBytes = {0x00, 0x00, 0x00, 0x00}
    local _unequipArr = {0xFF, 0xFF}

    for i=1, #EquippedCommands do
      --Unequip Dodge Roll
      --WriteArray(EquippedCommands[i]+0x36, _unequipArr)
      --WriteByte(EquippedCommands[i]+0xBE, 0xFF)

      --Unequip Air Slide
      WriteArray(EquippedCommands[i]+0x3C, _unequipArr)
      WriteByte(EquippedCommands[i]+0xC0, 0xFF)

      --Unequip Block
      --WriteArray(EquippedCommands[i]+0x54, _unequipArr)
      --WriteByte(EquippedCommands[i]+0xC6, 0xFF)
    end

    --Remove commands from inventory
    --WriteArray(MemoryAddresses.blockStock, _removeBytes)
    WriteArray(MemoryAddresses.airSlideStock, _removeBytes)
    --WriteArray(MemoryAddresses.dodgeRollStock, _removeBytes)
  end
end

function fixMenuOptions()
  --Reveal Commmand Deck and Spirit menu options at the start of the playthrough
  local _soraProg = ReadArray(WorldFlags.traverseTown.sora.story, 0x08)
  local _rikuProg = ReadArray(WorldFlags.traverseTown.riku.story, 0x08)

  --Prevent tutorial message from popping up for the command deck
  WriteArray(MemoryAddresses.commandDeckPopup, {0x10, 0x0A})
  --Remove tutorial messsages for world map and drop
  WriteArray(0xA4C3F2, {0x07, 0x0A, 0x00, 0x00, 0x00, 0x00, 0x0A, 0x0A})

  if _soraProg[3] <= 0x01 then --Player has not advanced far enough into TT
    WriteByte(WorldFlags.traverseTown.sora.story+0x01, 0xF1) --Unveils spirit and command options
    menuFixApplied = 1
  else --Player has progressed far enough to keep this disabled
    menuFixApplied = 0
  end

  if _rikuProg[2] < 0x1F and rikuSpiritFix == 0 then
    ConsolePrint("Fixing riku menu")
    WriteByte(WorldFlags.traverseTown.riku.story+0x01, 0x1F) --Unveils spirit option for riku
    rikuSpiritFix = 1
  end
  if _rikuProg[2] == 0x1F and rikuSpiritFix == 0 then
    if _rikuProg[3] == 0x00 then
      rikuSpiritFix = 1
    end
  end

end

function checkCharacterChange()
  if getCharacter() ~= activeCharacter then
    activeCharacter = getCharacter()
    onCharacterChange()
  end
end

function onCharacterChange()
  --TODO: Fix stat abilities getting disabled
  ConsolePrint("Character changed")

  --Fix Sora getting stuck after Xemnas
  if ReadByte(DropAddresses.sora.world) < 0x03 or ReadByte(DropAddresses.sora.world) == 0x0A and ReadByte(DropAddresses.sora.room) == 0x13 then --Sora is in an invalid world
    WriteByte(DropAddresses.sora.world, 0x0B)
    WriteByte(DropAddresses.sora.room, 0x01)
  end

  setSecretPortals()
end

function onRoomChange()
  setSecretPortals()
end

function makeDummyItem()
  --TOY 20 is unused, so we will make it our dummy item
  --Overwrite the item details
  writeTxtToGame(ItemOverwrite.dummyNameAddr, ItemOverwrite.dummyName, 0)
  --writeTxtToGame(ItemOverwrite.dummyDescAddr, ItemOverwrite.dummyDesc, 7)
  writeTxtToGame(ItemOverwrite.dummyDescAddr, ItemOverwrite.dummyDesc, 3)

  --Replace chest data with this item
  for i=0, 255 do
    WriteArray(MemoryAddresses.chestDataS+0x1A+(8*i), ItemOverwrite.dummyId)
    WriteArray(MemoryAddresses.chestDataR+0x1A+(8*i), ItemOverwrite.dummyId)
  end

  --Overwrite unused Key Items for AP specific items
  local _nameSize = 10 --Number of characters per name
  local _descSize = 15 --Number of characters per desc

  --Write replacement key items
  writeTxtToGame(ItemOverwrite.keyItemNames, "TWTNW Sora", 0) --Key Item 2 replacement
  writeTxtToGame(ItemOverwrite.keyItemDescs, "The World That Never Was for Sora", 3)

  writeTxtToGame(ItemOverwrite.keyItemNames+(22*2), "TWTNW Riku", 0) --Key Item 4 replacement
  writeTxtToGame(ItemOverwrite.keyItemDescs+(38*2), "World That Never Was for Riku", 3)

  writeTxtToGame(ItemOverwrite.keyItemNames+(22*4), "TT Sora", 2) --Key Item 6 replacement
  writeTxtToGame(ItemOverwrite.keyItemDescs+140, "Traverse Town for Sora", 3)

  writeTxtToGame(ItemOverwrite.keyItemNames+(22*6), "TT Riku", 2) --Key Item 8 replacement
  writeTxtToGame(ItemOverwrite.keyItemDescs+204, "Traverse Town for Riku", 3)

  writeTxtToGame(ItemOverwrite.keyItemNames+(22*8), "LCdC Sora", 2) --Key Item 10 replacement
  writeTxtToGame(ItemOverwrite.keyItemDescs+268, "La Cite des Cloches for Sora", 3)

  writeTxtToGame(ItemOverwrite.keyItemNames+224, "LCdC Riku", 2) --Key Item 12 replacement
  writeTxtToGame(ItemOverwrite.keyItemDescs+336, "La Cite des Cloches for Riku", 3)

  writeTxtToGame(ItemOverwrite.keyItemNames+272, "TG Sora", 2) --Key Item 14 replacement
  writeTxtToGame(ItemOverwrite.keyItemDescs+404, "The Grid for Sora", 3)

  writeTxtToGame(ItemOverwrite.keyItemNames+320, "TG Riku", 2) --Key Item 16 replacement
  writeTxtToGame(ItemOverwrite.keyItemDescs+472, "The Grid for Riku", 3)

  writeTxtToGame(ItemOverwrite.keyItemNames+368, "PP Sora", 2) --Key Item 18 replacement
  writeTxtToGame(ItemOverwrite.keyItemDescs+540, "Pranksters Paradise for Sora", 3)

  writeTxtToGame(ItemOverwrite.keyItemNames+416, "PP Riku", 2) --Key Item 20 replacement
  writeTxtToGame(ItemOverwrite.keyItemDescs+608, "Pranksters Paradise for Riku", 3)

  writeTxtToGame(ItemOverwrite.keyItemNames+464, "CotM Sora", 2) --Key Item 22 replacement
  writeTxtToGame(ItemOverwrite.keyItemDescs+676, "Country of Musketeers for Sora", 3)

  writeTxtToGame(ItemOverwrite.keyItemNames+512, "CotM Riku", 2) --Key Item 24 replacement
  writeTxtToGame(ItemOverwrite.keyItemDescs+744, "Country of Musketeers for Riku", 3)

--add 10 if wrong
  writeTxtToGame(ItemOverwrite.keyItemNames+560, "SoS Sora", 2) --Key Item 26 replacement
  writeTxtToGame(ItemOverwrite.keyItemDescs+812, "Symphony of Sorcery for Sora", 3)

  writeTxtToGame(ItemOverwrite.keyItemNames+608, "SoS Riku", 2) --Key Item 28 replacement
  writeTxtToGame(ItemOverwrite.keyItemDescs+880, "Symphony of Sorcery for Riku", 3)

  --Recusant's Sigil for additional ending condition
  writeTxtToGame(ItemOverwrite.keyItemNames+656, "Recusant Sigil", 2) --Key Item 30 replacement
  writeTxtToGame(ItemOverwrite.keyItemDescs+948, "Sigil of the Recusant.", 3)

  --Replace reward text
  writeTxtToGame(ItemOverwrite.hpIncreasedTxt, "Archipelago Item!", 4)
  writeTxtToGame(ItemOverwrite.dropBonusTxt, "Archipelago Item!", 9)
  writeTxtToGame(ItemOverwrite.deckCapIncreasedTxt, "Archipelago Item!", 7)

  writeTxtToGame(ItemOverwrite.strIncreasedTxt, "Archipelago Item", 2)
  writeTxtToGame(ItemOverwrite.magIncreasedTxt, "Archipelago Item", 0)
  writeTxtToGame(ItemOverwrite.defIncreasedTxt, "Archipelago Item", 1)

end

function removeDummyItem()
  local _dummyInv = 0xA4C580 --This might need to be scanned for
  if ReadByte(_dummyInv) ~= 0x00 then --We have a dummy; wipe it
    WriteArray(_dummyInv, {0x00, 0x00, 0x00})
  end
end

function ReceiveDeathlink(dateTime) --For receiving deathlink
  deathTime = tonumber(dateTime)
  if deathTime ~= nil and lastDeathTime ~= nil then
    if deathTime >= lastDeathTime + 3 then
      ConsolePrint("Deathlink Received")
      holdDeathlink = true
      --killPlayer()
      lastDeathTime = deathTime
    end
  end
end

function DropTrap()
  holdDropTrap = true
end

function DeliverDrop()
  if holdDropTrap then
    --Make sure player can drop
    local _currWorld = ReadByte(MemoryAddresses.world)

    if _currWorld == 0x0B or _currWorld == 0x01 then
      return
    end

    if ReadByte(MemoryAddresses.enablePause) == 0x00 and ReadByte(MemoryAddresses.cutscenePauseType) == 0x00 then
      forceDrop()
    end

    --See if drop has succeeded
    local _ptr = GetPointer(MemoryAddresses.deathPtr, MemoryAddresses.deathOffset)
    if ReadByte(_ptr, true) == 4 then --Drop happened
      ConsolePrint("Drop happened")
      holdDropTrap = false
    end

  end
end

local _deathlinkSent = false
local _fromDeathlink = false
function CheckDeathlink() --For sending deathlink
  --Get current hp
  local _currWorld = ReadByte(MemoryAddresses.world)

  if _currWorld == 0x0B or _currWorld == 0x01 or _activeRoom >= 0x3C then
    return
  end

  local _hpPtr = GetPointer(Stats.currHpPtr, Stats.currHpOffset)
  local _hpVal = ReadByte(_hpPtr, true)
  local _statePtr = GetPointer(MemoryAddresses.deathPtr, MemoryAddresses.deathOffset)
  local _stateVal = ReadByte(_statePtr, true)

  local _canPause = ReadByte(MemoryAddresses.enablePause)
  local _canPause2 = ReadByte(MemoryAddresses.cutscenePauseType)

  if _stateVal == 3 and not _deathlinkSent and not _fromDeathlink then --Player is dead
    if _hpVal == 0x00 then --Make sure death wasn't caused by some other source
      ConsolePrint("Player died; sending deathlink")
      _deathlinkSent = true
      deathDate = os.date("!%Y%m%d%H%M%S")
      SendToApClient(MessageTypes.Deathlink, {tostring(deathDate)})
    end
  end

  if _hpVal > 0x00 and _canPause == 0x00 and _canPause2 == 0x00 then --Deathlink status can be cleared
    _deathlinkSent = false
    _fromDeathlink = false
  end

end

function ManageDrop()

  if keepDropActive > -1 then --We are not disabling the drop right now
    if keepDropActive ~= getCharacter() then
      keepDropActive = -1
    end
    return
  end

  --Trying an alternate method to manage drop meter
  local _dropVal = ReadByte(MemoryAddresses.dropEnabler)
  if _dropVal ~= 0x00 then
    WriteArray(MemoryAddresses.dropEnabler, {0x00, 0x00})
  end

  local _dropGaugeAddr = GetPointer(MemoryAddresses.dropPtr, MemoryAddresses.dropOffset)
  --Keep gauge full
  WriteByte(_dropGaugeAddr+0x01, 0xFF, true)
  WriteByte(_dropGaugeAddr+0x02, 0x47, true)
  WriteByte(_dropGaugeAddr+0x03, 0x47, true)
end

local _fixPause = false
function SkipDETutorial()
  if ReadByte(0xA9B2D0) == 0x0E then
    --Prevent tutorial from showing up
    WriteByte(0xA9B2D0, 0x01)
    WriteByte(MemoryAddresses.pauseType, 0x03)
    _fixPause = true
  end

  --Fix Riku's 2nd District cutscene
  if getCharacter() == 1 and _activeRoom == 0x02 then
    if ReadByte(WorldFlags.traverseTown.riku.story+0x01) == 0x07 and ReadByte(MemoryAddresses.evt) <= 0x0001 and ReadByte(MemoryAddresses.cutscenePauseType) ~= 0x03 then
      if ReadByte(0xA43440) == 0x00 and ReadByte(0xA9B2D0) ~= 0x00 then
        WriteByte(MemoryAddresses.evt, 0x0001)
        WriteByte(MemoryAddresses.map, 0x0001)
        WriteByte(MemoryAddresses.btl, 0x0001)
        --WriteByte(MemoryAddresses.room, 0x03)
        WriteByte(0xA43440, 0x01) --Evt flag for Riku 2nd District

        WriteByte(0xA9B2F4, 0x04) --Some kind of pause state
      end
    end
  end

  if _fixPause and ReadByte(MemoryAddresses.pauseType) == 0x03 and ReadByte(0xA9B302) == 0x00 and ReadByte(0xA9B2D0) == 0x00 and ReadByte(MemoryAddresses.cutscenePauseType) == 0x00 then
    --Prevent game from allowing player to open the main menu in battle
    WriteByte(MemoryAddresses.pauseType, 0x00)
    _fixPause = false
  end
end


function SetStartingLocation() --Sends player to the world map
  fixMenuOptions()
  WriteByte(WorldFlags.traverseTown.sora.story, 0x11)
  WriteByte(WorldFlags.traverseTown.riku.story+0x01, 0x1F) --Force enable the menu fix for riku initially
  WriteByte(MemoryAddresses.world, 0x0B)
  WriteByte(MemoryAddresses.room, 0x01)
  WriteByte(DropAddresses.riku.world, 0x0B)
  WriteByte(DropAddresses.riku.room, 0x01)

  --Write some main story so it doesn't interfere during gameplay
  WriteArray(0xA41DC4, {0xFF, 0xFF, 0xFF, 0xFF}) --Radiant Garden Sora
  WriteArray(0xA445DC, {0xFF, 0xFF, 0xFF, 0xFF}) --Radiant Garden Riku

  --Update save location
  WriteArray(0xA40764, {0x0B, 0x01, 0x01})
end

-- ############################################################
-- ######################Game Commands#########################
-- ############################################################

function forceDrop()
  --ConsolePrint("Received forced drop")
  
  --Where are the drop gauge values
  ptr = GetPointer(0xA97FC0, 0x1B0)

  --Quickly re-enable dropping
  --WriteArray(MemoryAddresses.dropEnabler, {0x00, 0x00})
  keepDropActive = getCharacter()

  --Force the drop; set related gauge and bonus time bytes to 0
  WriteArray(ptr+0x01, {0x00, 0x00, 0x00}, true) --Gauge value
  WriteArray(ptr+0x0A, {0x00, 0x00, 0x00, 0x00}, true) --Bonus time value

end

function unstuck()
  if getCharacter() == 0 then
    --Send Riku to World Map
    ConsolePrint("Sending Riku to the World Map")
    WriteByte(DropAddresses.riku.world, 0x0B)
    WriteByte(DropAddresses.riku.room, 0x01)
    --WriteByte(DropAddresses.riku.map, 0x0001)
    --WriteByte(DropAddresses.riku.btl, 0x0001)
    --WriteByte(DropAddresses.riku.evt, 0x0001)
  else
    --Send Sora to World Map
    ConsolePrint("Sending Sora to the World Map")
    WriteByte(DropAddresses.sora.world, 0x0B)
    WriteByte(DropAddresses.sora.room, 0x01)
    --WriteByte(DropAddresses.sora.map, 0x0001)
    --WriteByte(DropAddresses.sora.btl, 0x0001)
    --WriteByte(DropAddresses.sora.evt, 0x0001)

  end
end

function killPlayer() --For death link
  
  if holdDeathlink then
    if ReadByte(MemoryAddresses.cutscenePauseType) ~= 0x00 then
      return
    end
    if ReadByte(MemoryAddresses.pauseType) ~= 0x00 then
      return
    end
    ConsolePrint("Deathlink triggered")
    local _ptr = GetPointer(MemoryAddresses.deathPtr, MemoryAddresses.deathOffset)
    WriteByte(_ptr, 3, true) --Set to 4 for instant drop
    holdDeathlink = false
    _fromDeathlink = true
  end
end

-- ############################################################
-- ######################  Socket  ############################
-- #############  Special Thanks to Krujo  ####################
-- ############################################################

function ConnectToApClient()
  client = socket.connect("127.0.0.1", 13713)
  if client then
    ConsolePrint("Connected to client!")
    return true
  else
    ConsolePrint("Failed to connect")
    return false
  end
end

function SendToApClient(type,messages)
  if client then
    local message = tostring(type)
    for i = 1, #messages do
      message = message .. ";" .. tostring(messages[i])
    end
    message = message .. "\n"

    ConsolePrint("Sending message:" .. message)
    client:send(message)
  end
end

function SocketHasMessages()
  if client then
    local ready = socket.select({client}, nil, 0)
    if #ready > 0 then
      return true
    end
  end
  return false
end

function HandleMessage(msg)
  if msg.type == nil then
    ConsolePrint("No message type defined; cannot handle")
    return
  end

  if msg.type == MessageTypes.ReceiveAllItems then
    ConsolePrint("Receiving all items")
    ItemHandler:Reset()
    local i = 1; 
    while i <= #msg.values-1 do
      local _msg = msg.values[i]
      if tonumber(_msg) == 2639999 then --Victory; Not a real item
        GoalGame()
        return
      end
      ConsolePrint("Msg Value: ".._msg)
      local _item = getItemById(tonumber(_msg))
      if _item == nil then
        ConsolePrint("Invalid item received. Val: ".._msg)
        return
      end
      local type = _item.Type
      local itemID = _item.ID

      local _itemCnt = tonumber(msg.values[#msg.values])+i

      if itemID < 2630000 then --Trap received
        if lastReceivedIndex <= currentReceivedIndex then --Prevents drop trap from triggering if we already got it
          DropTrap()
          return
        end
      end

      if itemID >= 2670000 and itemID < 2680000 then --Receive ability
        ItemHandler:ReceiveAbility(itemID)
        RoomSaveTask:StoreItem(itemID)
        updateReceived(_itemCnt)
      else
        if _itemCnt <= currentReceivedIndex or lastReceivedIndex > currentReceivedIndex then
          --TODO: Verify what should still be added for the sake of state containers
          updateReceived(_itemCnt)
          checkIfCanReceive(itemID, type)
        else
          ItemHandler:Receive(type, itemID)
          RoomSaveTask:StoreItem(itemID)
          updateReceived(_itemCnt)
        end
      end
      i = i + 1
    end
  elseif msg.type == MessageTypes.ReceiveSingleItem then
    ConsolePrint("Receiving single item")
    if tonumber(msg.values[1]) == 2639999 then --Victory; Not a real item
      GoalGame()
      return
    end
    local _id = tonumber(msg.values[1])
    local _itemCnt = tonumber(msg.values[2])
    if _id == nil then
        ConsolePrint("Invalid item received. Val: ".._id)
        return
    end

    if _id < 2630000 then --Trap received
      ConsolePrint("Sending drop trap")
      if lastReceivedIndex < currentReceivedIndex then
        DropTrap()
      end
      return
    end

    if _id < 2670000 or _id > 2680000 then --Normal item received
      local _item = getItemById(_id)
      local type = _item.Type
      local itemID = _item.ID
      if _itemCnt <= currentReceivedIndex or lastReceivedIndex > currentReceivedIndex then
        updateReceived(_itemCnt)
        checkIfCanReceive(itemID, type)
      else
        ItemHandler:Receive(type, itemID)
        RoomSaveTask:StoreItem(_id)
        updateReceived(_itemCnt)
      end
    else --Ability received
      ItemHandler:ReceiveAbility(_id)
      RoomSaveTask:StoreItem(_id)
      updateReceived(_itemCnt)
    end

  elseif msg.type == MessageTypes.ClientCommand then
    local _cmdId = tonumber(msg.values[1])
    
    if _cmdId == 0 then --Force drop command
      forceDrop()
    elseif _cmdId == 1 then --Unstuck command
      unstuck()
    elseif _cmdId == 2 then --Death
      --killPlayer()
      holdDeathlink = true
    elseif _cmdId == 3 then --Deathlink Toggle
      if msg.values[2] ~= nil then
        if msg.values[2] == "True" then
          ConsolePrint("Enabling Deathlink")
          Configs.Deathlink = true
        else
          ConsolePrint("Disabling Deathlink")
          Configs.Deathlink = false
        end
      end
    end
  elseif msg.type == MessageTypes.Deathlink then
    local _deathTime = msg.values[1]
    ReceiveDeathlink(_deathTime)

  elseif msg.type == MessageTypes.SendSlotData then
    local _slotType = tonumber(msg.values[1])
    local _sentVals = {}
    for i=2, #msg.values do
      table.insert(_sentVals, tostring(msg.values[i]))
    end

    ConfigTask:ParseSlotData(_slotType, _sentVals)
  end


end

function ReceiveFromApClient()
  if SocketHasMessages() then
    local message, err = client:receive('*l')
    if message then
      ConsolePrint("Full message received: "..message)
      local parts = SplitString(message, ";")
      local type = tonumber(parts[1])
      local newMessage = {
        type = GetMessageType(type),
        values = {}
      }

      for i = 2, #parts do
        table.insert(newMessage.values, parts[i])
      end

      return newMessage
    elseif err then
      ConsolePrint("Error receiving message: " .. err)
    end
  else
    return nil
  end
end

-- ############################################################
-- ######################  Helpers  ###########################
-- ############################################################

function toHex(str)
  return string.format("%X", str)
end

function toBits(num)
    -- returns a table of bits, least significant first.
    local t={} -- will contain the bits
    while num>0 do
        rest=math.fmod(num,2)
        t[#t+1]=rest
        num=(num-rest)/2
    end
    return t
end

function hasValue(arr, val)
  for index, value in ipairs(arr) do
    if value == val then
      return true
    end
  end
  return false
end

function countValues(arr, val)
  local _cnt = 0
  for index, value in ipairs(arr) do
    if value == val then
      _cnt = _cnt + 1
    end
  end
  return _cnt
end

function removeDuplicates(arr)
  local _uniqueArr = {}
  local _seen = {}

  for _, value in ipairs(arr) do
    if not _seen[value] then
      table.insert(_uniqueArr, value)
      _seen[value] = true
    end
  end

  return _uniqueArr

end

function getItemById(item_id)
  for i = 1, #items do
    if items[i].ID == item_id then
      return items[i]
    end
  end
  for i = 1, #abilities do
    if abilities[i].ID == item_id then
      return abilities[i]
    end
  end
end
function getAbilityById(ab_id)
  for i = 1, #abilities do
    if abilities[i].ID == ab_id then
      return abilities[i]
    end
  end
end

function SplitString(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

function GetArraySum(arr)
  local _arrSum = 0
  for i=1, #arr do
    _arrSum = _arrSum + arr[i]
  end
  return _arrSum
end

function GetMessageType(value)
  for name, number in pairs(MessageTypes) do
    if number == value then
        return MessageTypes[name]
    end
  end
  return nil
end

function textToKHSCII(value)
  --Returns byte array based on string
  returnArr = {}
  for i=1, #value do
    local c = value:sub(i, i)
    local charCode = charToKHSCII(c)
    table.insert(returnArr, charCode)
    table.insert(returnArr, 0x00)
  end
  return returnArr
end

function charToKHSCII(char)
  local returnChars = {
    ["A"] = KHSCII.A,["B"] = KHSCII.B,["C"] = KHSCII.C,["D"] = KHSCII.D,
    ["E"] = KHSCII.E,["F"] = KHSCII.F,["G"] = KHSCII.G,["H"] = KHSCII.H,
    ["I"] = KHSCII.I,["J"] = KHSCII.J,["K"] = KHSCII.K,["L"] = KHSCII.L,
    ["M"] = KHSCII.M,["N"] = KHSCII.N,["O"] = KHSCII.O,["P"] = KHSCII.P,
    ["Q"] = KHSCII.Q,["R"] = KHSCII.R,["S"] = KHSCII.S,["T"] = KHSCII.T,
    ["U"] = KHSCII.U,["V"] = KHSCII.V,["W"] = KHSCII.W,["X"] = KHSCII.X,
    ["Y"] = KHSCII.Y,["Z"] = KHSCII.Z,
    ["a"] = KHSCII.a,["b"] = KHSCII.b,["c"] = KHSCII.c,["d"] = KHSCII.d,
    ["e"] = KHSCII.e,["f"] = KHSCII.f,["g"] = KHSCII.g,["h"] = KHSCII.h,
    ["i"] = KHSCII.i,["j"] = KHSCII.j,["k"] = KHSCII.k,["l"] = KHSCII.l,
    ["m"] = KHSCII.m,["n"] = KHSCII.n,["o"] = KHSCII.o,["p"] = KHSCII.p,
    ["q"] = KHSCII.q,["r"] = KHSCII.r,["s"] = KHSCII.s,["t"] = KHSCII.t,
    ["u"] = KHSCII.u,["v"] = KHSCII.v,["w"] = KHSCII.w,["x"] = KHSCII.x,
    ["y"] = KHSCII.y,["z"] = KHSCII.z,
    ["."] = KHSCII.Period,[" "] = KHSCII.Space,["!"] = KHSCII.Exclamation,["&"] = KHSCII.And
  }

  return returnChars[char]
end

function writeTxtToGame(startAddr, txt, fillerCnt)
  txtBytes = textToKHSCII(txt)
  for i=1, fillerCnt do
    table.insert(txtBytes, 0x00)
    table.insert(txtBytes, 0x00)
  end
  WriteArray(startAddr, txtBytes)
end

function getCharacter() --Returns 0 for sora, 1 for riku
  if ReadByte(MemoryAddresses.character) == 0x01 then
    return 1
  end
  return 0
end

function updateReceived(itemCnt)
  if currentReceivedIndex < lastReceivedIndex then --Increment current received until we reach our last received
    currentReceivedIndex = currentReceivedIndex+1
  else --Fill with item index of latest received
    if itemCnt > currentReceivedIndex then
      currentReceivedIndex = itemCnt
    end
    receivedInit = true --We have finished receiving the intial set of items from the mod
  end
  WriteInt(MemoryAddresses.medals, currentReceivedIndex)
  ConsolePrint("Current Received Index: "..tostring(currentReceivedIndex))
  ConsolePrint("Last Received Index: "..tostring(lastReceivedIndex))
  ConsolePrint("Item Cnt: "..tostring(itemCnt))
end

--This function is needed for room save to work
function sendToInv(itemId)
  local _item = getItemById(itemId)
  if _item.Type == "Support" or _item.Type == "Spirit" then --Ability redeemed
    ItemHandler:ReceiveAbility(itemId)
  elseif _item.Type == "World" then --Send world item
    ItemHandler:PlaceWorldItem(itemId)
  elseif _item.Type == "Recipe" then --Recipes don't need to be re-added to our state
    ItemHandler:RecipeToInv(itemId)
  else
    ItemHandler:Receive(_item.Type, itemId)
  end
end

function checkIfCanReceive(id, type)
  local validTypes = {"Stats [Sora]", "Stats [Riku]", "Recipe", "Flowmotion", "World", "Key"}
  if hasValue(validTypes, type) and not receivedInit then
    --For recipe, create a version that only adds to table and bypasses adding recipe to inventory and auto-craft
    if type ~= "Recipe" and type ~= "Key" then
      ConsolePrint("Successfully received stat/movement/world")
      ItemHandler:Receive(type, id)
      RoomSaveTask:StoreItem(id)
    elseif type == "Key" then
      ItemHandler:Receive(type, id) --Don't store this in room save
    else
      ConsolePrint("Successfully received recipe")
      ItemHandler:RecipeToState(id)
    end
  end
end

function cheatGame()
  --Grant these items
  for i=1, #items do
    local _item = items[i]
    if _item.Type == "Flowmotion" then
      --if _item.ID == 2661005 then --Rail slide
      --  ItemHandler:Receive(_item.Type, _item.ID)
      --end
      --ItemHandler:Receive(_item.Type, _item.ID)
    end
    if _item.ID == 2681060 or _item.ID == 2631001 or _item.ID == 2631003 then --Balloonra and HP boosts
      ItemHandler:Receive(_item.Type, _item.ID)
      ItemHandler:Receive(_item.Type, _item.ID)
      ItemHandler:Receive(_item.Type, _item.ID)
    end
    if _item.ID == 2631003 or _item.ID == 2631004 or _item.ID == 2631005 or _item.ID == 2631010 or _item.ID == 2631008 then
      for j=1, 90 do
        ItemHandler:Receive(_item.Type, _item.ID)
      end
    end
  end
end

-- ############################################################
-- ######################  Game Setup  ########################
-- ############################################################

function main()
  LocationHandler:CheckChestBits()
  LocationHandler:CheckLevel()
  LocationHandler:PreventWorldVisit()
  LocationHandler:CheckStory()
  LocationHandler:JuliusDefeated()

  ItemHandler:TT2Access()
  ItemHandler:RebuildWorlds()

  killPlayer() --Check if deathlink is received

  removeDummyItem()

  checkCharacterChange()

  LocationHandler:WorldAccess()

  if _activeRoom ~= ReadByte(MemoryAddresses.room) then
    --Room change occurred; check some stuff
    onRoomChange()
    _activeRoom = ReadByte(MemoryAddresses.room)
  end

  local msg = ReceiveFromApClient()
  if msg then
    HandleMessage(msg)
  end
end

function OnGameStart()
  local connected =  ConnectToApClient()

  if connected then
    connectionInitialized = true
    gameStarted = true
    initGameState()
    lastReceivedIndex = ReadInt(MemoryAddresses.medals)
    --Request items from server
    SendToApClient(MessageTypes.RequestAllItems, {"Requesting Items"})
    

    --Game Clear Flag
    --WriteByte(0xA40780, 0x01)

    ------------------ENABLE DEV CHEATS--------------------
    --cheatGame()
  end
end

function GoalGame()
  SendToApClient(MessageTypes.Victory, {"Game Completed"})
end

function _OnInit()
  ConsolePrint("Game ID: ".. tostring(gameID))

  --Initialize items and locations
  LocationDefs:DefineChests()
  LocationDefs:DefineWorldEvents()
  LocationDefs:DefinePortals()
  ItemDefs:DefineItems()
  ItemDefs:DefineAbilities()
  CheatTask:Init()
  Spirits:DefineSpiritStats()

  if gameID == 3899271824 then
    canExecute = true
  else
    ConsolePrint("You are not running Dream Drop Distance for Steam! Cannot run script.")
  end
end

function _OnFrame()
  frameCount = (frameCount+1)%15
  if not gameStarted then
    if ReadByte(MemoryAddresses.keyblades+0x01) == 2 and frameCount == 0 then --Save file is loaded if keyblade exists here
      OnGameStart()
    end
    return
  end

  if frameCount == 0 and canExecute then --Dont run main logic every frame
    main()
  end

  --Skip Dream Eater Tutorial
  SkipDETutorial()

  ItemHandler:RebuildFlowmotion() --This needs to be checked every frame in case of pause
  ItemHandler:RebuildStats() --This tends to reset every so often
  ItemHandler:RebuildAbilities() --This too
  StoryHandler:OverwriteStoryVars() --Need to run every frame in case we need to quickly overwrite something
  LocationHandler:CheckPortal() --Needs to be checked every frame for activation/completion
  ManageDrop() --Disabled dropping
  DeliverDrop() --For sending drop traps

  --Room Save
  RoomSaveTask:GetRoomChange()
  RoomSaveTask:CheckPlayerState()

  --Prevent potential softlocks
  SoftlockTask:PreventSoftlocks()



  if Configs.Deathlink then
    CheckDeathlink()
  end

  --Run certain cheats every loop
  CheatTask:ExpMult()
end