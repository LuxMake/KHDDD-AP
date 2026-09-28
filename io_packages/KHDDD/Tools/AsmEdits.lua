local AsmEdits = {}

--Fills bytes[off+1..off+4] with the rel32 of a jmp/jcc: target minus the address of the next instruction, little-endian
function AsmEdits:putRel32(bytes, off, nextInstr, target)
  local d = (target - nextInstr) & 0xFFFFFFFF
  for i = 1, 4 do
    bytes[off + i] = (d >> (8 * (i - 1))) & 0xFF
  end
end

function AsmEdits:Init()
	self:OpenAllChests()
	self:IconReplace()
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

--The following function contains ai-generated code; documentation included
function AsmEdits:IconReplace()
	--Item-get popup: give the AP dummy item (ItemOverwrite.dummyId, 0x0813) icon frame 5, which the shipped itemget_02_n.l2d
    --points at sheet cell (3,0). Rewrites the toy (0x08xx) case of the icon helper at {0x272560, 0x272500}; entry 7 of its jump
    --table at {0x272708, 0x2726A8} points here. In: esi = item id, dil = 0 when an item-get popup wants a frame (two menus pass 1
    --and get icon 0x73). Out: eax; the patch leaves its result in ebx and jumps to the shared epilogue at +0x2A, which does
    --mov eax, ebx and returns.
    --was: B8 04 00 00 00 40 84 FF BB 73 00 00 00 0F 44 D8 8B C3 48 8B 5C 24 30 48 8B 74 24 38 48 83 C4 20 5F C3
    --     mov eax, 4; test dil, dil; mov ebx, 0x73; cmove ebx, eax; mov eax, ebx; restore rbx and rsi; add rsp, 0x20; pop rdi; ret
    local _iconToyCase = {0x2726C9, 0x272669}
    WriteArray(_iconToyCase[gameVer], {
      0x81, 0xFE, 0x13, 0x08, 0x00, 0x00, --+0x00 cmp esi, 0x813
      0xB8, 0x04, 0x00, 0x00, 0x00,       --+0x06 mov eax, 4     other toys keep frame 4 (lollipop); mov leaves the flags alone
      0x75, 0x05,                         --+0x0B jne +0x12
      0xB8, 0x05, 0x00, 0x00, 0x00,       --+0x0D mov eax, 5
      0x40, 0x84, 0xFF,                   --+0x12 test dil, dil
      0xBB, 0x73, 0x00, 0x00, 0x00,       --+0x15 mov ebx, 0x73  menu icon, unchanged
      0x0F, 0x44, 0xD8,                   --+0x1A cmove ebx, eax
      0xEB, 0x0B,                         --+0x1D jmp +0x2A      shared epilogue, {0x2726F3, 0x272693}
      0x90, 0x90, 0x90})                  --+0x1F nop x3         pads to the original 34 bytes

    --Item image: the AP dummy item loads it0501.ctt instead of itxxxx.ctt, the fallback shared by every item without an image of
    --its own. The game ships it0501 and it0502 as solid black placeholders that nothing loads, so the mod's it0501.ctt/.dds
    --can hold the AP art.
    --The image name dispatcher at {0x26F770, 0x26F710} keeps the item id in edi and the name buffer in rbx. Its toy case
    --subtracts 0x800 from edi and jump-tables 0x800-0x80C; anything higher takes a ja to the default case, which copies
    --"itxxxx.ctt". That ja now goes to a stub written into 20 bytes of int3 padding (was: CC x20) after a library function.
    --was: 0F 87 F3 01 00 00  ja default {0x26FCCF, 0x26FC6F}
    local _toyImageJa = {0x26FAD6, 0x26FA76}
    local _imageDefault = {0x26FCCF, 0x26FC6F}
    local _imageSprintf = {0x26F857, 0x26F7F7} --the 0x06xx case: sprintf(rbx, "it%04x.ctt", edi), then return
    local _imageStub = {0x75267C, 0x7524BC}
    local _stub = _imageStub[gameVer]
    local _stubBytes = {
      0x83, 0xFF, 0x13,             --+0x00 cmp edi, 0x13      toy 0x813 once the toy case subtracted 0x800
      0x0F, 0x85, 0, 0, 0, 0,       --+0x03 jne default        other toys keep itxxxx.ctt
      0xBF, 0x01, 0x05, 0x00, 0x00, --+0x09 mov edi, 0x501
      0xE9, 0, 0, 0, 0}             --+0x0E jmp sprintf case   so the name becomes "it0501.ctt"
    putRel32(_stubBytes, 0x05, _stub + 0x09, _imageDefault[gameVer])
    putRel32(_stubBytes, 0x0F, _stub + 0x13, _imageSprintf[gameVer])
    WriteArray(_stub, _stubBytes)
    local _jaBytes = {0x0F, 0x87, 0, 0, 0, 0} --ja stub
    putRel32(_jaBytes, 0x02, _toyImageJa[gameVer] + 6, _stub)
    WriteArray(_toyImageJa[gameVer], _jaBytes)
end

return AsmEdits