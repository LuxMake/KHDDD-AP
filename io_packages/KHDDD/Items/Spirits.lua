local Spirits = {}

--Game's spirit exp table, scaled by each spirit's exp rate
local SpiritExp = {
	40, 250, 600, 1120, 1760, 2520, 3400, 4400, 5520, 6760,
	8154, 9671, 11351, 13157, 15135, 17242, 19530, 21950, 24560, 27305,
	30249, 33331, 36621, 40052, 43700, 47492, 51510, 55675, 60075, 64625,
	69325, 74175, 79175, 84325, 89625, 95075, 100675, 106425, 112325, 118375,
	125195, 132180, 139330, 146645, 154125, 161770, 169580, 177555, 185695, 194000,
	202470, 211105, 219905, 228870, 238000, 247295, 256755, 266380, 276170, 286125,
	296245, 306530, 316980, 327595, 338375, 349320, 360430, 371705, 383145, 394750,
	406520, 418455, 430555, 442820, 455250, 467845, 480605, 493530, 506620, 519875,
	533295, 546880, 560630, 574545, 588625, 602870, 617280, 631855, 646595, 661500,
	676570, 691805, 707205, 722770, 738500, 754395, 770455, 786680,
}

local RankMult = {-0.18, -0.12, -0.06, 0, 0.06, 0.12, 0.18}
local GrowthMult = {0, -0.01, 0.01}

--m_deXX0 records from btlparam.bin; hp/str/mag/def are x10, exp is a percent of SpiritExp
function Spirits:DefineSpiritStats()
SpiritStats = { --Base stats for Dream Eaters
	{hp=360, str=84, mag=111, def=66, exp=90,
		fireRes=105, iceRes=105, elecRes=105, waterRes=105, darkRes=105, lightRes=105}, --Meow Wow
	{hp=381, str=87, mag=106, def=75, exp=93,
		fireRes=120, iceRes=120, elecRes=120, waterRes=120, darkRes=120, lightRes=120}, --Tama Sheep
	{hp=413, str=95, mag=103, def=73, exp=101,
		fireRes=55, iceRes=135, elecRes=115, waterRes=165, darkRes=115, lightRes=115}, --Yoggy Ram
	{hp=327, str=82, mag=108, def=59, exp=90,
		fireRes=90, iceRes=90, elecRes=90, waterRes=90, darkRes=45, lightRes=140}, --Komory Bat
	{hp=370, str=97, mag=81, def=76, exp=99,
		fireRes=100, iceRes=100, elecRes=100, waterRes=100, darkRes=100, lightRes=100}, --Pricklemane
	{hp=349, str=95, mag=84, def=62, exp=86,
		fireRes=45, iceRes=110, elecRes=90, waterRes=140, darkRes=90, lightRes=90}, --Hebby Repp
	{hp=316, str=82, mag=103, def=69, exp=91,
		fireRes=95, iceRes=95, elecRes=145, waterRes=45, darkRes=95, lightRes=95}, --Sir Kyroo
	{hp=349, str=97, mag=81, def=66, exp=91,
		fireRes=90, iceRes=90, elecRes=90, waterRes=90, darkRes=45, lightRes=140}, --Toximander
	{hp=360, str=84, mag=84, def=71, exp=87,
		fireRes=100, iceRes=100, elecRes=150, waterRes=50, darkRes=100, lightRes=100}, --Fin Fatale
	{hp=338, str=87, mag=100, def=73, exp=104,
		fireRes=90, iceRes=90, elecRes=140, waterRes=45, darkRes=90, lightRes=90}, --Tatsu Steed
	{hp=381, str=92, mag=98, def=67, exp=109,
		fireRes=85, iceRes=85, elecRes=85, waterRes=85, darkRes=40, lightRes=135}, --Necho Cat
	{hp=457, str=102, mag=114, def=71, exp=118,
		fireRes=115, iceRes=165, elecRes=55, waterRes=115, darkRes=115, lightRes=115}, --Thunderaffe
	{hp=468, str=102, mag=79, def=69, exp=103,
		fireRes=105, iceRes=105, elecRes=105, waterRes=105, darkRes=105, lightRes=105}, --Kooma Panda
	{hp=457, str=105, mag=100, def=71, exp=114,
		fireRes=110, iceRes=110, elecRes=110, waterRes=110, darkRes=160, lightRes=55}, --Pegaslick
	{hp=381, str=92, mag=111, def=68, exp=106,
		fireRes=160, iceRes=55, elecRes=110, waterRes=100, darkRes=110, lightRes=110}, --Iceguin Ace
	{hp=316, str=79, mag=127, def=62, exp=93,
		fireRes=95, iceRes=95, elecRes=95, waterRes=95, darkRes=45, lightRes=145}, --Peepsta Hoo
	{hp=349, str=77, mag=111, def=79, exp=97,
		fireRes=110, iceRes=110, elecRes=110, waterRes=110, darkRes=110, lightRes=110}, --Escarglow
	{hp=370, str=97, mag=98, def=81, exp=107,
		fireRes=110, iceRes=110, elecRes=110, waterRes=110, darkRes=110, lightRes=110}, --KO Kabuto
	{hp=306, str=77, mag=108, def=59, exp=87,
		fireRes=130, iceRes=80, elecRes=80, waterRes=40, darkRes=80, lightRes=80}, --Wheeflower
	{hp=370, str=100, mag=95, def=62, exp=101,
		fireRes=90, iceRes=90, elecRes=90, waterRes=90, darkRes=45, lightRes=140}, --Ghostabocky
	{hp=478, str=105, mag=81, def=68, exp=105,
		fireRes=110, iceRes=110, elecRes=160, waterRes=55, darkRes=110, lightRes=110}, --Zolephant
	{hp=392, str=95, mag=95, def=69, exp=96,
		fireRes=160, iceRes=55, elecRes=110, waterRes=100, darkRes=110, lightRes=110}, --Juggle Pup
	{hp=435, str=107, mag=81, def=66, exp=111,
		fireRes=100, iceRes=100, elecRes=100, waterRes=100, darkRes=150, lightRes=50}, --Halbird
	{hp=381, str=95, mag=100, def=80, exp=110,
		fireRes=110, iceRes=110, elecRes=110, waterRes=110, darkRes=110, lightRes=110}, --Staggerceps
	{hp=327, str=87, mag=84, def=75, exp=88,
		fireRes=100, iceRes=100, elecRes=100, waterRes=100, darkRes=50, lightRes=150}, --Fishbone
	{hp=392, str=97, mag=117, def=72, exp=116,
		fireRes=100, iceRes=100, elecRes=100, waterRes=100, darkRes=150, lightRes=50}, --Flowbermeow
	{hp=424, str=100, mag=108, def=75, exp=111,
		fireRes=120, iceRes=170, elecRes=60, waterRes=120, darkRes=120, lightRes=120}, --Cyber Yog
	{hp=381, str=84, mag=108, def=69, exp=94,
		fireRes=55, iceRes=130, elecRes=110, waterRes=160, darkRes=110, lightRes=110}, --Chef Kyroo
	{hp=360, str=97, mag=106, def=73, exp=113,
		fireRes=100, iceRes=150, elecRes=50, waterRes=100, darkRes=100, lightRes=100}, --Lord Kyroo
	{hp=338, str=90, mag=103, def=64, exp=94,
		fireRes=45, iceRes=115, elecRes=95, waterRes=145, darkRes=95, lightRes=95}, --Tatsu Blaze
	{hp=468, str=102, mag=103, def=72, exp=118,
		fireRes=110, iceRes=160, elecRes=55, waterRes=110, darkRes=110, lightRes=110}, --Electricorn
	{hp=327, str=84, mag=114, def=62, exp=104,
		fireRes=130, iceRes=80, elecRes=30, waterRes=80, darkRes=40, lightRes=130}, --Woeflower
	{hp=370, str=100, mag=92, def=62, exp=99,
		fireRes=90, iceRes=140, elecRes=45, waterRes=90, darkRes=90, lightRes=90}, --Jestabocky
	{hp=435, str=105, mag=81, def=64, exp=107,
		fireRes=50, iceRes=120, elecRes=100, waterRes=150, darkRes=100, lightRes=100}, --Eaglider
	{hp=360, str=105, mag=84, def=67, exp=95,
		fireRes=90, iceRes=90, elecRes=90, waterRes=90, darkRes=90, lightRes=90}, --Me Me Bunny
	{hp=489, str=107, mag=76, def=71, exp=109,
		fireRes=110, iceRes=110, elecRes=110, waterRes=110, darkRes=110, lightRes=110}, --Drill Sye
	{hp=511, str=117, mag=90, def=72, exp=120,
		fireRes=55, iceRes=130, elecRes=110, waterRes=160, darkRes=110, lightRes=110}, --Tyranto Rex
	{hp=370, str=84, mag=111, def=68, exp=102,
		fireRes=90, iceRes=90, elecRes=90, waterRes=90, darkRes=45, lightRes=140}, --Majik Lapin
	{hp=500, str=112, mag=76, def=72, exp=115,
		fireRes=105, iceRes=105, elecRes=105, waterRes=105, darkRes=105, lightRes=105}, --Cera Terror
	{hp=500, str=120, mag=90, def=83, exp=125,
		fireRes=150, iceRes=50, elecRes=100, waterRes=90, darkRes=100, lightRes=100}, --Skelterwild
	{hp=349, str=79, mag=98, def=66, exp=92,
		fireRes=145, iceRes=45, elecRes=95, waterRes=85, darkRes=95, lightRes=95}, --Ducky Goose
	{hp=478, str=110, mag=108, def=76, exp=121,
		fireRes=115, iceRes=115, elecRes=115, waterRes=115, darkRes=165, lightRes=55}, --Aura Lion
	{hp=500, str=115, mag=92, def=77, exp=123,
		fireRes=55, iceRes=130, elecRes=110, waterRes=160, darkRes=110, lightRes=110}, --Ryu Dragon
	{hp=360, str=82, mag=100, def=67, exp=100,
		fireRes=45, iceRes=110, elecRes=90, waterRes=140, darkRes=90, lightRes=90}, --Drak Quack
	{hp=489, str=112, mag=103, def=77, exp=122,
		fireRes=115, iceRes=115, elecRes=115, waterRes=115, darkRes=55, lightRes=165}, --Keeba Tiger

	--Rare Spirits
	{hp=396, str=89, mag=117, def=66, exp=108,
		fireRes=105, iceRes=105, elecRes=105, waterRes=105, darkRes=105, lightRes=105}, --Meowjesty
	{hp=384, str=100, mag=89, def=62, exp=103,
		fireRes=45, iceRes=110, elecRes=90, waterRes=140, darkRes=90, lightRes=90}, --Sudo Neku
	{hp=419, str=97, mag=103, def=67, exp=130,
		fireRes=85, iceRes=85, elecRes=85, waterRes=85, darkRes=40, lightRes=135}, --Frootz Cat
	{hp=514, str=108, mag=83, def=69, exp=123,
		fireRes=105, iceRes=105, elecRes=105, waterRes=105, darkRes=105, lightRes=105}, --Ursa Circus
	{hp=407, str=102, mag=103, def=81, exp=128,
		fireRes=110, iceRes=110, elecRes=110, waterRes=110, darkRes=110, lightRes=110}, --Kab Kannon
	{hp=431, str=100, mag=100, def=69, exp=115,
		fireRes=160, iceRes=55, elecRes=110, waterRes=100, darkRes=110, lightRes=110}, --R & R Seal
	{hp=455, str=110, mag=109, def=71, exp=117,
		fireRes=100, iceRes=100, elecRes=60, waterRes=100, darkRes=115, lightRes=115}, --Catanuki
	{hp=538, str=118, mag=92, def=77, exp=121,
		fireRes=110, iceRes=110, elecRes=110, waterRes=50, darkRes=110, lightRes=110}, --Beatalike
	{hp=419, str=100, mag=117, def=66, exp=98,
		fireRes=70, iceRes=130, elecRes=150, waterRes=70, darkRes=100, lightRes=100}, --Tubguin Ace

}
end

local function f32(x)
	return (string.unpack("f", string.pack("f", x)))
end

--Matches the game's level-up recalculation, including its float32 rounding.
--rank is 0-6; growth packs 2-bit str, mag, def, hp modifiers from the low bits up.
function Spirits:GetStats(id, level, rank, growth)
	local _base = SpiritStats[id]
	local _level = level <= 50 and level+10 or (level-50)*0.5+60
	local _rank = f32(RankMult[rank+1])
	local _rankTenth = f32(_rank*f32(0.1))
	local _rankOne = f32(_rank+1)
	local function stat(base, shift)
		local _mult = f32(f32(_rankTenth+f32(GrowthMult[(growth >> shift & 3)+1]))+_rankOne)
		return math.floor(f32(f32(f32(_mult*base)*_level)/100))
	end
	return {hp=stat(_base.hp, 6), str=stat(_base.str, 0), mag=stat(_base.mag, 2), def=stat(_base.def, 4)}
end

--Exp at the start of level, as the game sets it when it creates a spirit
function Spirits:GetExp(id, level)
	if level <= 1 then
		return 0
	end
	return SpiritExp[level-1]*SpiritStats[id].exp // 100
end

return Spirits