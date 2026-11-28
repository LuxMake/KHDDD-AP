local AsmEdits = {}

--Fills bytes[off+1..off+4] with the rel32 of a jmp/jcc: target minus the address of the next instruction, little-endian
local function putRel32(bytes, off, nextInstr, target)
  local d = (target - nextInstr) & 0xFFFFFFFF
  for i = 1, 4 do
    bytes[off + i] = (d >> (8 * (i - 1))) & 0xFF
  end
end

--Writes a 6-byte jcc (0F op rel32) at addr that goes to target
function AsmEdits:writeJcc(addr, op, target)
  local bytes = {0x0F, op, 0, 0, 0, 0}
  putRel32(bytes, 0x02, addr + 6, target)
  WriteArray(addr, bytes)
end

function AsmEdits:Init()
	self:OpenAllChests()
  self:MenuFix()
end

function AsmEdits:MenuFix()
  local _cmdMenuCheck = {0x239355, 0x2393C5} --Always reveals command menu regardless of TT progression
  WriteArray(_cmdMenuCheck[gameVer], {0x90, 0x90, 0x90}) --Nop the whole function
  local _spiritMenuCheckS = {0x2393DE, 0x23944E} --Always reveal spirit menu for Sora regardless of TT progression
  WriteArray(_spiritMenuCheckS[gameVer], {0xB8, 0x01, 0x00, 0x00, 0x00, 0x90}) --Always return true
  local _spiritMenuCheckR = {0x2393CA, 0x23943A} --Always reveal spirit menu for Riku regardless of TT progression
  WriteArray(_spiritMenuCheckR[gameVer], {0xB8, 0x01, 0x00, 0x00, 0x00, 0x90}) --Always return true
end

--Change/Nop functions that would prevent chests from opening
function AsmEdits:OpenAllChests()
	--Make ability chests open-able
	local _abFunc = {0x376EB5, 0x376D25} --TODO: EGS address was 0x376EA4; verify
    WriteArray(_abFunc[gameVer], {0x90, 0x90, 0x90, 0x90, 0x90})

    --Make world item chests open-able, even if the world item is already in inventory
    local _worldChest = {0x271A43, 0x2719E3} --TODO: EGS addess was 0x271A33; verify
    WriteArray(_worldChest[gameVer], {0x39, 0xC0, 0x90, 0x90, 0x90})

    local _abChest = {0x271956, 0x2718F6} --TODO: EGS address was 0x271946; verify
    WriteArray(_abChest[gameVer], {0xB0, 0x01})

    --Prevent battle levels from resetting from certain story events
    local _btlFunc = {0x23A980, 0x23A9F0} --TODO: EGS address was 0x23A970; verify
    WriteArray(_btlFunc[gameVer], {0x90, 0x90})
end

return AsmEdits