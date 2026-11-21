--EnergyLinkTaskRewrite

EnergyLinkTask = {}

--Constants
EnergyLinkTask.MAX_ENERGY = 72000
EnergyLinkTask.POST_DROP_ENERGY = 24000 --How much drop gauge should player have with no banked energy

EnergyLinkTask.DROP_ME_NOT = 24000 --How much energy do the gauge refill items deposit/request
EnergyLinkTask.DROP_ME_NEVER = 48000

--Variables
EnergyLinkTask.IsActive = false
EnergyLinkTask.EnergyInitialized = false --Has initial energy been logged

EnergyLinkTask.ActiveCharacter = 0

EnergyLinkTask.StoredGauge = self.MAX_ENERGY
EnergyLinkTask.LastGauge = 0
EnergyLinkTask.LastDP = 0


EnergyLinkTask.AwaitingDrop = false

EnergyLinkTask.BankedEnergy = 0

EnergyLinkTask.UsingItem = false

local _dp = {0xA98024} --TODO: EGS

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


	if self:HasDropped() then --Character has changed
		if self.StoredGauge < 0 then --Player had a natural drop
			--Empty gauge since player has changed
			--WriteFloat(GetPointer(MemoryAddresses.dropPtr[gameVer], MemoryAddresses.dropOffset), self.POST_DROP_ENERGY, true)
			self.StoredGauge = self.POST_DROP_ENERGY

			self:SendEnergyToServer()

			--Send request to refill gauge
			self:RequestEnergy(self.MAX_ENERGY)
		end

		self.AwaitingDrop = false
	end

	if _charState == 0x04 then --Player is currently in dropped state
		if not self.AwaitingDrop then
			self.LastDP = ReadShort(_dp[gameVer])
			self:SendEnergyToServer()
		end
		self.AwaitingDrop = true
	end

	if not self.EnergyInitialized or _charState ~= 0x01 and _charState ~= 0x02 then --Player is not in a state where the drop gauge should be manipulated
		if self:IsPaused() then
			self.StoredGauge = self.LastGauge
		end
		return
	end

	if self:IsPaused() or ReadByte(MemoryAddresses.world[gameVer]) == 0x0B then --Log DP
		self.LastDP = ReadShort(_dp[gameVer])
	end

	self.LastGauge = self:GetCurrentEnergy()

	if self:IsPaused() and self.LastGauge > 0 then --If we have gauge we need to record it in case of manual drop
		self:StoreCurrentEnergy()
	elseif self.StoredGauge >= 0 and keepDropActive == -1 then --May need a timer to prevent this from triggering too soon
		self:UseStoredEnergy()
		self.StoredGauge = -1
	end


	--Check if drop-me-nop item used to request energy
	self:DropMeNopCheck()

	--Check if we need to consume banked energy received from server
	if self.BankedEnergy > 0 then
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
function EnergyLinkTask:GetCurrentEnergy()
	return ReadFloat(GetPointer(MemoryAddresses.dropPtr[gameVer], MemoryAddresses.dropOffset), true)
end

function EnergyLinkTask:UseStoredEnergy()
	WriteFloat(GetPointer(MemoryAddresses.dropPtr[gameVer], MemoryAddresses.dropOffset), self.StoredGauge, true)
	self.StoredGauge = -1
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

	--Send the request
	SendToApClient(MessageTypes.RequestingEnergy, {tostring(amt)})
end

function EnergyLinkTask:ReceivedBankEnergy(amt) --Energy received from server; renamed from gotenergy
	self.BankedEnergy = self.BankedEnergy + amt --Save to a banked energy var in case we can't instantly consume it
	ConsolePrint("Banking energy")
end

function EnergyLinkTask:ConsumeBankedEnergy()
	_barAddr = GetPointer(MemoryAddresses.dropPtr[gameVer], MemoryAddresses.dropOffset)
	local _currentEnergy = ReadFloat(_barAddr, true)
	local _amtToAdd = _currentEnergy + self.BankedEnergy
	if _amtToAdd > self.MAX_ENERGY then --More banked energy than we can otherwise have
		self.BankedEnergy = self.BankedEnergy - self.MAX_ENERGY
		_amtToAdd = self.MAX_ENERGY
	else
		self.BankedEnergy = 0
	end
	WriteFloat(_barAddr, _amtToAdd, true)
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
	local _requestAmts = {24000, 48000}
	local _energyToRequest = _requestAmts[itemId-0x79]
	self:RequestEnergy(_energyToRequest)
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

return EnergyLinkTask