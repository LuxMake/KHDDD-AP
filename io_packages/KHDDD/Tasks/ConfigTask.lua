local ConfigTask = {}

ConfigTask.State = {
	SavedKbStats = {},
	ExpSet = false
}

ConfigTask.SlotDataTypes = {
  KeybladeStats = 0,
  Character = 1,
  SkipDI = 2,
  Exp = 3,
  SkipLC = 4,
  FastGoMode = 5,
  RecipeCnt = 6,
  WinCon = 7,
  StatBoost = 8,
  LordKyroo = 9,
  LocalItemNotifs = 10,
  RemoteItemNotifs = 11
}

function ConfigTask:ParseSlotData(slotType, msgVal)
	if slotType == self.SlotDataTypes.KeybladeStats then
      self:SaveKeybladeStats(msgVal)
    elseif slotType == self.SlotDataTypes.Character then
      self:SetCharacter(msgVal)
    elseif slotType == self.SlotDataTypes.SkipDI then
      self:SetDI(msgVal)
    elseif slotType == self.SlotDataTypes.Exp then
      self:SetExpMult(msgVal)
    elseif slotType == self.SlotDataTypes.SkipLC then
      self:SetLC(msgVal)
    elseif slotType == self.SlotDataTypes.FastGoMode then
    	self:SetFastGoMode(msgVal)
    elseif slotType == self.SlotDataTypes.RecipeCnt then
      self:SetRecipeReq(msgVal)
    elseif slotType == self.SlotDataTypes.WinCon then
      self:SetGoal(msgVal)
    elseif slotType == self.SlotDataTypes.StatBoost then
    	self:SetStatBoost(msgVal)
    elseif slotType == self.SlotDataTypes.LordKyroo then
    	self:SetLordKyroo(msgVal)
    elseif slotType == self.SlotDataTypes.LocalItemNotifs then
    	self:SetItemNotifs(msgVal)
    elseif slotType == self.SlotDataTypes.RemoteItemNotifs then
    	self:SetRemoteNotifs(msgVal)
    end
end

function ConfigTask:SaveKeybladeStats(msgVals)
	--Save this stat
	--local _kbStr = tonumber(msgVals[1])
	--local _kbMag = tonumber(msgVals[2])
	--table.insert(self.State.SavedKbStats, msgVals)

	for i=1, #msgVals do
		if i%2 == 0 then --Ensure we have the stat pairs
			table.insert(self.State.SavedKbStats, {msgVals[i-1], msgVals[i]})
			local _kbStr = tonumber(msgVals[i-1])
			local _kbMag = tonumber(msgVals[i])

			--Apply this stat
			if #self.State.SavedKbStats-1 < 30 then
				--Apply the stats
				ConsolePrint("Recording str "..tostring(_kbStr).." mag "..tostring(_kbMag).." for kb "..tostring(#self.State.SavedKbStats-1))

				if #self.State.SavedKbStats-1 < 15 then --Sora keyblade
					WriteArray(KeybladeStats.soraBase[gameVer] + (KeybladeStats.offset * (#self.State.SavedKbStats-1)), {_kbStr, _kbMag})
				else --Riku keyblade
					WriteArray(KeybladeStats.rikuBase[gameVer] + ((KeybladeStats.offset) * (#self.State.SavedKbStats-16)), {_kbStr, _kbMag})
				end
			end
		end
	end
end

--Config Setters
function ConfigTask:SetCharacter(msgVal)
	Configs.Character = tonumber(msgVal[1])
	ConsolePrint("Setting Character to "..msgVal[1])
end

function ConfigTask:SetRecipeReq(msgVal)
	Configs.RecipeReqs = tonumber(msgVal[1])
	local _reqStr = "Required Recipes: "..msgVal[1]
	writeTxtToGame(ItemOverwrite.recipeDescAddr[gameVer], _reqStr, 1)
	ConsolePrint("Setting required recipes to "..msgVal[1])
end

function ConfigTask:SetGoal(msgVal)
	Configs.Goal = tonumber(msgVal[1])
	ConsolePrint("Goal value: "..tostring(Configs.Goal))
	ConsolePrint("Setting goal to "..tostring(msgVal[1]))
end

function ConfigTask:SetDI(msgVal)
	if msgVal[1] == "1" then --Want to play DI
		Configs.SkipDI = false
	else
		Configs.SkipDI = true
	end
	ConsolePrint("Setting DI Skip to "..msgVal[1])
end

function ConfigTask:SetLC(msgVal)
	if msgVal[1] == "1" then --Want to skip LC
		Configs.SkipLightCycle = true
	else
		Configs.SkipLightCycle = false
	end
	ConsolePrint("Setting LC Skip to "..msgVal[1])
end

function ConfigTask:SetFastGoMode(msgVal)
	if msgVal[1] == "1" then
		Configs.FastGoMode = true
	else
		Configs.FastGoMode = false
	end
	ConsolePrint("Setting Fast GO to "..msgVal[1])
end

function ConfigTask:SetExpMult(msgVal)
	Configs.ExpMult = tonumber(msgVal[1])
	self:WriteExpTable()
	ConsolePrint("Setting Exp Mult to "..msgVal[1])
end

function ConfigTask:SetStatBoost(msgVal)
	Configs.StatBonus = tonumber(msgVal[1])
	ConsolePrint("Setting Stat Bonus to "..msgVal[1])
end

function ConfigTask:SetLordKyroo(msgVal)
	ConsolePrint("Setting Lord Kyroo to "..msgVal[1])
	if msgVal[1] == "1" then
		Configs.LordKyroo = true
	else
		Configs.LordKyroo = false
	end
end

function ConfigTask:SetItemNotifs(msgVal)
	ConsolePrint("Setting Received Notifications to "..msgVal[1])
	Configs.LocalItemNotifs = tonumber(msgVal[1])
end

function ConfigTask:SetRemoteNotifs(msgVal)
	ConsolePrint("Setting Sent Notifications to "..msgVal[1])
	Configs.RemoteItemNotifs = tonumber(msgVal[1])
end

function ConfigTask:WriteExpTable()
	if self.State.ExpSet or ReadByte(MemoryAddresses.expTable[gameVer]) < 0x28 then
		return
	end
	local _realExpMult = 1/Configs.ExpMult
	for x=0, 98 do
		local _nextAddr = MemoryAddresses.expTable[gameVer]+(x*4)
		local _tableVal = ReadInt(_nextAddr)
		WriteInt(_nextAddr, math.floor(_tableVal*_realExpMult))
	end
	self.State.ExpSet = true
end

return ConfigTask