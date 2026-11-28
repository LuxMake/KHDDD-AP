local TrapTask = {}

local _multOffset = 0x04

TRAPTYPES = {
	INSTANT_DROP = 1,
	ADD_MULT = 2
}

TrapTask.PendingMult = 0

function TrapTask:TrapReceived(id)
	if id == TRAPTYPES.INSTANT_DROP then
		self:InstantDrop()
	elseif id == TRAPTYPES.ADD_MULT then
		self:MultTrap(0.5)
	end
end

function TrapTask:MultTrap(mult)
	self.PendingMult = self.PendingMult + mult
end

function TrapTask:InstantDrop()
	holdDropTrap = true --Kicks off events needed for drop trap
end

function TrapTask:Update()
	--Multiplier trap
	if self.PendingMult > 0 then
		local _charState = ReadByte(GetPointer(MemoryAddresses.deathPtr[gameVer], MemoryAddresses.deathOffset), true)
		if _charState == 0x01 or _charState == 0x02 then --Can apply the trap
			local _bar = GetPointer(MemoryAddresses.dropPtr[gameVer], MemoryAddresses.dropOffset)
			local _currMult = ReadFloat(_bar+_multOffset, true)
			WriteFloat(_bar+_multOffset, _currMult+self.PendingMult, true)
			self.PendingMult = 0
		end
	end
end

return TrapTask