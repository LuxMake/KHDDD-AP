local ConfigTask = {}

ConfigTask.State = {
	SavedKbStats = {}
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
  StatBoost = 8
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
					WriteArray(KeybladeStats.soraBase + (KeybladeStats.offset * (#self.State.SavedKbStats-1)), {_kbStr, _kbMag})
				else --Riku keyblade
					WriteArray(KeybladeStats.rikuBase + ((KeybladeStats.offset) * (#self.State.SavedKbStats-16)), {_kbStr, _kbMag})
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
	ConsolePrint("Setting Exp Mult to "..msgVal[1])
end

function ConfigTask:SetStatBoost(msgVal)
	Configs.StatBonus = tonumber(msgVal[1])
	ConsolePrint("Setting Stat Bonus to "..msgVal[1])
end

return ConfigTask