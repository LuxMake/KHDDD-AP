--Various cheat functions for playing the game faster

CheatTask = {}

CheatTask.LastExp = 0
CheatTask.Mult = 0
CheatTask.IsInit = false

function CheatTask:Init()
	self.LastExp = ReadInt(MemoryAddresses.soraExp)
end

function CheatTask:ExpMult()
	--local nextAddr = 0xA9801C

	local _currExp = ReadInt(MemoryAddresses.soraExp)

	if ReadByte(MemoryAddresses.enablePause) ~= 0x00 then --Player should not be able to receive xp
		self.LastExp = _currExp
		return
	end

	if _currExp < self.LastExp then --Character switch
		self.LastExp = _currExp
		return
	end

	if _currExp == self.LastExp then
		return
	end

	if self.LastExp == nil or self.LastExp == 0 then
		self.LastExp = _currExp
		return
	end

	if _currExp > self.LastExp then
		local _diff = _currExp - self.LastExp
		local _newExp = self.LastExp+_diff*Configs.ExpMult
		WriteInt(MemoryAddresses.soraExp, _newExp)
		self.LastExp = _newExp
	end
end

return CheatTask