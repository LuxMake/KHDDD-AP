--EnergyLinkTaskRewrite

EnergyLinkTask = {}

--Constants
EnergyLinkTask.MAX_ENERGY = 72000
EnergyLinkTask.POST_DROP_ENERGY = 24000 --How much drop gauge should player have with no banked energy

EnergyLinkTask.DROP_ME_NOT = 36000 --How much energy do the gauge refill items deposit; the game's 50% and 100%, as ItemUsed requests
EnergyLinkTask.DROP_ME_NEVER = 72000

--Variables
EnergyLinkTask.IsActive = false
EnergyLinkTask.EnergyInitialized = false --Has initial energy been logged

EnergyLinkTask.ActiveCharacter = 0

--Tracking
EnergyLinkTask.StoredGauge = EnergyLinkTask.MAX_ENERGY
EnergyLinkTask.LastGauge = 0
EnergyLinkTask.LastDP = 0
EnergyLinkTask.FieldGauge = 0 --Last gauge outside the world map, for world map drops
EnergyLinkTask.FromMap = false --On the world map, or loading out of it

--Death handling
EnergyLinkTask.EntryGauge = nil
EnergyLinkTask.EntryRoom = {}
EnergyLinkTask.Died = false
EnergyLinkTask.PostDrop = false --The entry gauge is taken once the stored gauge is written


EnergyLinkTask.AwaitingDrop = false
EnergyLinkTask.DropState = false
EnergyLinkTask.TrapDrop = false
EnergyLinkTask.AwaitingDraw = false --The client doesn't reply when the bank is empty
EnergyLinkTask.FloorGift = 0 --Part of the post-drop floor that the bank's reply pays back

EnergyLinkTask.BankedEnergy = 0

EnergyLinkTask.UsingItem = false

local _dp = {0xA98024} --TODO: EGS
local _bonusFlagByte = 0x1D --Flag word follows the dropPtr global
local _bonusFlag = 0x40

local function equippedItemBoosts()
	local _abl = ReadByte(MemoryAddresses.supportAbilities[gameVer]-0x42+getCharacter()) --Item Boost; one byte per character
	local _count = 0
	for i = 0, (_abl & 0x07)-1 do --Low 3 bits: copies owned; one equip bit per copy from bit 3
		if _abl & (0x08 << i) ~= 0 then
			_count = _count + 1
		end
	end
	return _count
end

function EnergyLinkTask:Init()
	--Nop drop me not restoration
	local _dropMeNop = {0x2DE409} --TODO: EGS

	--Prevent drop-me-nots/nevers from restoring drop gauge 
	WriteArray(_dropMeNop[gameVer], {0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x76, 0x08, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90})

	self.IsActive = true
	self.ActiveCharacter = getCharacter()
end

function EnergyLinkTask:Update()
	if not self.IsActive then
		return
	end

	local _charState = ReadByte(GetPointer(MemoryAddresses.deathPtr[gameVer], MemoryAddresses.deathOffset), true)

	if not self.EnergyInitialized then
		if _charState == 0x01 or _charState == 0x02 then
			self.StoredGauge = self:GetCurrentEnergy()
			self.EnergyInitialized = true
		end
	end

	if self.EntryGauge then
		self:KeepEntryGauge(_charState)
	end


	if roomInfo[1] == 0x0B then
		self.FromMap = true
	end

	if self:HasDropped() then --Character has changed
		if self.FromMap then --A world map drop never enters the drop state; main() moves roomInfo in the same pass
			self.StoredGauge = self.FieldGauge
		end
		if self.StoredGauge < 0 then --Player had a natural drop
			--Empty gauge since player has changed
			--WriteFloat(GetPointer(MemoryAddresses.dropPtr[gameVer], MemoryAddresses.dropOffset), self.POST_DROP_ENERGY, true)
			self.StoredGauge = 0
		end

		self:SendEnergyToServer()

		if not self.TrapDrop then --An Instant Drop trap only swaps the gauge
			--Send request to refill gauge
			self:RequestDropEnergy()
		end
		self.TrapDrop = false

		--Death tracking restarts in UseStoredEnergy, once the post-drop gauge is written
		self.EntryGauge = nil
		self.PostDrop = true

		self.AwaitingDrop = false
	end

	if _charState == 0x04 and not self.DropState then --First frame of the drop state; HasDropped can clear AwaitingDrop before it ends
		self.LastDP = ReadShort(_dp[gameVer])
		self:SendEnergyToServer()
		self.TrapDrop = holdDropTrap == true --DeliverDrop clears holdDropTrap after this frame
		self.AwaitingDrop = true
	end
	self.DropState = _charState == 0x04

	if _charState ~= 0x04 and ReadByte(MemoryAddresses.enablePause[gameVer]) == 0x00 and roomInfo[1] ~= 0x0B then
		self.FromMap = false
	end

	if not self.EnergyInitialized or _charState ~= 0x01 and _charState ~= 0x02 then --Player is not in a state where the drop gauge should be manipulated
		if self:IsPaused() and not self.PostDrop then --Keep the drop's gauge until UseStoredEnergy writes it
			self.StoredGauge = self.LastGauge
		end
		return
	end

	if self:IsPaused() or ReadByte(MemoryAddresses.world[gameVer]) == 0x0B then --Log DP
		self.LastDP = ReadShort(_dp[gameVer])
	end

	self.LastGauge = self:GetCurrentEnergy()
	if roomInfo[1] ~= 0x0B and not self.PostDrop then
		self.FieldGauge = self.LastGauge
	end

	if self:IsPaused() and self.LastGauge > 0 and not self.PostDrop then --If we have gauge we need to record it in case of manual drop
		self:StoreCurrentEnergy()
	elseif self.StoredGauge >= 0 and keepDropActive == -1 and not self.FromMap and not self.AwaitingDrop then --May need a timer to prevent this from triggering too soon
		self:UseStoredEnergy()
		self.StoredGauge = -1
	end


	--Check if drop-me-nop item used to request energy
	self:DropMeNopCheck()

	--Check if we need to consume banked energy received from server
	if self.BankedEnergy > 0 and self.StoredGauge < 0 then --UseStoredEnergy would overwrite it
		self:ConsumeBankedEnergy()
	end

end

function EnergyLinkTask:IsPaused()
	if ReadByte(MemoryAddresses.pauseType[gameVer]) > 0x00 then
		return true
	end
	return false
end

function EnergyLinkTask:HasDropped()
	local _char = getCharacter()
	if getCharacter() ~= self.ActiveCharacter then --Player has changed characters
		self.ActiveCharacter = getCharacter()
		return true
	end
	return false
end

--Energy manip functions
function EnergyLinkTask:SetGauge(amt)
	local _bar = GetPointer(MemoryAddresses.dropPtr[gameVer], MemoryAddresses.dropOffset)
	local _flags = MemoryAddresses.dropPtr[gameVer]+_bonusFlagByte
	WriteFloat(_bar, math.max(0, math.min(amt, 72000)), true)
	WriteFloat(_bar+0x08, 1920, true) --Bonus time in frames
	WriteInt(_bar+0x0C, 32, true) --Bonus time in seconds
	WriteByte(_flags, ReadByte(_flags) & ~_bonusFlag)
end

function EnergyLinkTask:GetCurrentEnergy()
	return ReadFloat(GetPointer(MemoryAddresses.dropPtr[gameVer], MemoryAddresses.dropOffset), true)
end

function EnergyLinkTask:UseStoredEnergy()
	--WriteFloat(GetPointer(MemoryAddresses.dropPtr[gameVer], MemoryAddresses.dropOffset), self.StoredGauge, true)
	self:SetGauge(self.StoredGauge)
	self.StoredGauge = -1
	if self.PostDrop then
		self.EntryGauge = self:GetCurrentEnergy()
		self.EntryRoom = {roomInfo[1], roomInfo[2]}
		self.Died = false
		self.PostDrop = false
	end
end

function EnergyLinkTask:StoreCurrentEnergy()
	self.StoredGauge = self:GetCurrentEnergy()
end

function EnergyLinkTask:RequestEnergy(amt)
	local _currEnergy = self:GetCurrentEnergy()
	if amt + _currEnergy > self.MAX_ENERGY then --Should not request more than maximum
		local _amtOver = (amt + _currEnergy) - self.MAX_ENERGY
		amt = amt - _amtOver
	end
	if amt <= 0 then --Full gauge
		return
	end

	--Replies come in order, so a drop request still unanswered found the bank empty
	self.AwaitingDraw = false

	--Send the request
	SendToApClient(MessageTypes.RequestingEnergy, {tostring(amt)})
end

--The game covers what the bank can't, up to POST_DROP_ENERGY
function EnergyLinkTask:RequestDropEnergy()
	local _carried = self.StoredGauge
	self.FloorGift = math.max(self.POST_DROP_ENERGY - _carried, 0)
	self.StoredGauge = _carried + self.FloorGift
	if _carried >= self.MAX_ENERGY then
		return
	end

	--Not RequestEnergy: it clamps against the game's post-drop refill
	self.AwaitingDraw = true
	SendToApClient(MessageTypes.RequestingEnergy, {tostring(self.MAX_ENERGY - _carried)})
end

function EnergyLinkTask:ReceivedBankEnergy(amt) --Energy received from server; renamed from gotenergy
	if self.AwaitingDraw then --A drop's top-off; the floor already paid FloorGift of it
		self.AwaitingDraw = false
		amt = amt - self.FloorGift
		self.FloorGift = 0
		if amt <= 0 then
			return
		end
	end
	self.BankedEnergy = self.BankedEnergy + amt --Save to a banked energy var in case we can't instantly consume it
	ConsolePrint("Banking energy")
end

function EnergyLinkTask:ConsumeBankedEnergy()
	local _currentEnergy = self:GetCurrentEnergy()
	local _room = self.MAX_ENERGY - _currentEnergy
	if _room <= 0 then --Full gauge; the rest stays banked until there is room
		return
	end
	local _amtToAdd = math.min(self.BankedEnergy, _room)
	self.BankedEnergy = self.BankedEnergy - _amtToAdd
	self:SetGauge(_currentEnergy + _amtToAdd) --Stops bonus time, as the game's own refill does
	if self.EntryGauge then --A death reload must not lose what the bank paid in
		self.EntryGauge = math.min(self.EntryGauge + _amtToAdd, self.MAX_ENERGY)
	end
end

function EnergyLinkTask:SendEnergyToServer()
	if self.LastDP == 0 then
		return
	end
	ConsolePrint("Sending energy to server")
	SendToApClient(MessageTypes.SendingEnergy, {tostring(self.LastDP)})
	self.LastDP = 0
end

function EnergyLinkTask:DirectDeposit(amt)
	--Send energy to server; bypassing dp conversion
	SendToApClient(MessageTypes.DepositingEnergy, {tostring(amt)})
end

--Drop-Me-Nop used
function EnergyLinkTask:ItemUsed(itemId)
	local _itemPercent = {[0x7A] = 50, [0x7B] = 100} --Same as the game's Drop-Me-Not code at 0x2DE360
	local _currentEnergy = self:GetCurrentEnergy()

	local _percent = _itemPercent[itemId] * (100 + 10*equippedItemBoosts()) // 100 --Each Item Boost adds 10% of the base
	local _requestedEnergy = _percent * 0.01 * self.MAX_ENERGY

	self:RequestEnergy(_requestedEnergy)
end

function EnergyLinkTask:DropMeNopCheck()
	local _animPtr = {0xA37DB8} --TODO: EGS
	local _animQueueVal = ReadByte(GetPointer(_animPtr[gameVer], 0x570)+0x142, true)
	if not self.UsingItem then
		if _animQueueVal == 0x7A or _animQueueVal == 0x7B then
			--Player has used a drop-me-not
			--self:RequestEnergy(_animQueueVal)
			self:ItemUsed(_animQueueVal)
			self.UsingItem = true
		end
	else
		if _animQueueVal ~= 0x7B and _animQueueVal ~= 0x7A then --Animation ended
			self.UsingItem = false
		end
	end
end

--Death handling
function EnergyLinkTask:KeepEntryGauge(charState)
	if charState == 0x03 then
		self.Died = true
	elseif self.Died then
		if (charState == 0x01 or charState == 0x02) and ReadByte(MemoryAddresses.enablePause[gameVer]) == 0x00 then
			self:SetGauge(self.EntryGauge)
			self.Died = false
			ConsolePrint("Restored post-drop gauge after death")
		end
	elseif roomInfo[1] ~= self.EntryRoom[1] or roomInfo[2] ~= self.EntryRoom[2] then
		self.EntryGauge = nil
	end
end

return EnergyLinkTask