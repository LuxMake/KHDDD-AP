local Spirits = {}

--Stat lines pulled from KH Wiki
function Spirits:DefineSpiritStats()
SpiritStats = { --Base stats for Dream Eaters
	{hp=36, str=8.4, mag=11.1, def=6.6, 
		fireRes=105, iceRes=105, elecRes=105, waterRes=105, darkRes=105, lightRes=105}, --Meow Wow
	{hp=38.1, str=8.7, mag=10.6, def=7.5, 
		fireRes=120, iceRes=120, elecRes=120, waterRes=120, darkRes=120, lightRes=120}, --Tama Sheep
	{hp=41.3, str=9.5, mag=10.3, def=7.3, 
		fireRes=55, iceRes=135, elecRes=115, waterRes=165, darkRes=115, lightRes=115}, --Yoggy Ram
	{hp=32.7, str=8.2, mag=10.8, def=5.9, 
		fireRes=90, iceRes=90, elecRes=90, waterRes=90, darkRes=45, lightRes=140}, --Komory Bat
	{hp=37, str=9.7, mag=8.1, def=7.6, 
		fireRes=100, iceRes=100, elecRes=100, waterRes=100, darkRes=100, lightRes=100}, --Pricklemane
	{hp=34.9, str=9.5, mag=8.4, def=6.2, 
		fireRes=45, iceRes=110, elecRes=90, waterRes=140, darkRes=90, lightRes=90}, --Hebby Repp
	{hp=31.6, str=8.2, mag=10.3, def=6.9, 
		fireRes=95, iceRes=95, elecRes=145, waterRes=45, darkRes=95, lightRes=95}, --Sir Kyroo
	{hp=34.9, str=9.7, mag=8.1, def=6.6, 
		fireRes=90, iceRes=90, elecRes=90, waterRes=90, darkRes=45, lightRes=140}, --Toximander
	{hp=36, str=8.4, mag=8.4, def=7.1, 
		fireRes=100, iceRes=100, elecRes=150, waterRes=50, darkRes=100, lightRes=100}, --Fin Fatale
	{hp=33.8, str=8.7, mag=10.0, def=7.3, 
		fireRes=90, iceRes=90, elecRes=140, waterRes=45, darkRes=90, lightRes=90}, --Tatsu Steed
	{hp=38.1, str=9.2, mag=9.8, def=6.7, 
		fireRes=85, iceRes=85, elecRes=85, waterRes=85, darkRes=40, lightRes=135}, --Necho Cat
	{hp=45.7, str=10.2, mag=11.4, def=7.1, 
		fireRes=115, iceRes=165, elecRes=55, waterRes=115, darkRes=115, lightRes=115}, --Thunderaffe
	{hp=46.8, str=10.2, mag=7.9, def=6.9, 
		fireRes=105, iceRes=105, elecRes=105, waterRes=105, darkRes=105, lightRes=105}, --Kooma Panda
	{hp=45.7, str=10.5, mag=10.0, def=7.1, 
		fireRes=110, iceRes=110, elecRes=110, waterRes=110, darkRes=160, lightRes=55}, --Pegaslick
	{hp=38.1, str=9.2, mag=11.1, def=6.8, 
		fireRes=160, iceRes=55, elecRes=110, waterRes=100, darkRes=110, lightRes=110}, --Iceguin Ace
	{hp=36, str=8.4, mag=8.4, def=7.1, 
		fireRes=95, iceRes=95, elecRes=95, waterRes=95, darkRes=45, lightRes=145}, --Peepsta Hoo
	{hp=34.9, str=10.2, mag=10.3, def=7.2, 
		fireRes=110, iceRes=110, elecRes=110, waterRes=110, darkRes=110, lightRes=110}, --Escarglow
	{hp=37, str=9.7, mag=9.8, def=8.1, 
		fireRes=110, iceRes=110, elecRes=110, waterRes=110, darkRes=110, lightRes=110}, --KO Kabuto
	{hp=30.6, str=7.7, mag=10.8, def=5.9, 
		fireRes=130, iceRes=80, elecRes=80, waterRes=40, darkRes=80, lightRes=80}, --Wheeflower
	{hp=37, str=10, mag=9.5, def=6.2, 
		fireRes=90, iceRes=90, elecRes=90, waterRes=90, darkRes=45, lightRes=140}, --Ghostabocky
	{hp=47.8, str=10.5, mag=8.1, def=6.8, 
		fireRes=110, iceRes=110, elecRes=160, waterRes=55, darkRes=110, lightRes=110}, --Zolephant
	{hp=39.2, str=9.5, mag=9.5, def=6.9, 
		fireRes=160, iceRes=55, elecRes=110, waterRes=100, darkRes=110, lightRes=110}, --Juggle Pup
	{hp=43.5, str=10.7, mag=8.1, def=6.6, 
		fireRes=100, iceRes=100, elecRes=100, waterRes=100, darkRes=150, lightRes=50}, --Halbird
	{hp=38.1, str=9.5, mag=10.0, def=8.0, 
		fireRes=110, iceRes=110, elecRes=110, waterRes=110, darkRes=110, lightRes=110}, --Staggerceps
	{hp=32.7, str=8.7, mag=8.4, def=7.5, 
		fireRes=100, iceRes=100, elecRes=100, waterRes=100, darkRes=50, lightRes=150}, --Fishbone
	{hp=39.2, str=9.7, mag=11.7, def=7.2, 
		fireRes=100, iceRes=100, elecRes=100, waterRes=100, darkRes=150, lightRes=50}, --Flowbermeow
	{hp=42.4, str=10, mag=10.8, def=7.5, 
		fireRes=120, iceRes=170, elecRes=60, waterRes=120, darkRes=120, lightRes=120}, --Cyber Yog
	{hp=38.1, str=8.4, mag=10.8, def=6.9, 
		fireRes=55, iceRes=130, elecRes=110, waterRes=160, darkRes=110, lightRes=110}, --Chef Kyroo
	{hp=36, str=9.7, mag=10.6, def=7.3, 
		fireRes=100, iceRes=150, elecRes=50, waterRes=100, darkRes=100, lightRes=100}, --Lord Kyroo
	{hp=33.8, str=9, mag=10.3, def=6.4, 
		fireRes=45, iceRes=115, elecRes=95, waterRes=145, darkRes=95, lightRes=95}, --Tatsu Blaze
	{hp=46.8, str=10.2, mag=10.3, def=7.2, 
		fireRes=110, iceRes=160, elecRes=55, waterRes=110, darkRes=110, lightRes=110}, --Electricorn
	{hp=32.7, str=8.4, mag=11.4, def=6.2, 
		fireRes=130, iceRes=80, elecRes=30, waterRes=80, darkRes=40, lightRes=130}, --Woeflower
	{hp=37, str=10, mag=9.2, def=6.2, 
		fireRes=90, iceRes=140, elecRes=45, waterRes=90, darkRes=90, lightRes=90}, --Jestabocky
	{hp=43.5, str=10.5, mag=8.1, def=6.4, 
		fireRes=50, iceRes=120, elecRes=100, waterRes=150, darkRes=100, lightRes=100}, --Eaglider
	{hp=36, str=10.5, mag=8.4, def=6.7, 
		fireRes=90, iceRes=90, elecRes=90, waterRes=90, darkRes=90, lightRes=90}, --Me Me Bunny
	{hp=48.9, str=10.7, mag=7.6, def=7.1, 
		fireRes=110, iceRes=110, elecRes=110, waterRes=110, darkRes=110, lightRes=110}, --Drill Sye
	{hp=51.1, str=11.7, mag=9.0, def=7.2, 
		fireRes=55, iceRes=130, elecRes=110, waterRes=160, darkRes=110, lightRes=110}, --Tyranto Rex
	{hp=37, str=8.4, mag=11.1, def=6.8, 
		fireRes=90, iceRes=90, elecRes=90, waterRes=90, darkRes=45, lightRes=140}, --Majik Lapin
	{hp=50, str=11.2, mag=7.6, def=7.2, 
		fireRes=105, iceRes=105, elecRes=105, waterRes=105, darkRes=105, lightRes=105}, --Cera Terror
	{hp=50, str=12, mag=9, def=8.3, 
		fireRes=150, iceRes=50, elecRes=100, waterRes=90, darkRes=100, lightRes=100}, --Skelterwild
	{hp=34.9, str=7.9, mag=9.8, def=6.6, 
		fireRes=145, iceRes=45, elecRes=95, waterRes=85, darkRes=95, lightRes=95}, --Ducky Goose
	{hp=47.8, str=11, mag=10.8, def=7.6, 
		fireRes=115, iceRes=115, elecRes=115, waterRes=115, darkRes=165, lightRes=55}, --Aura Lion
	{hp=50, str=11.5, mag=9.2, def=7.7, 
		fireRes=55, iceRes=130, elecRes=110, waterRes=160, darkRes=110, lightRes=110}, --Ryu Dragon
	{hp=36, str=10, mag=8.2, def=6.7, 
		fireRes=45, iceRes=110, elecRes=90, waterRes=140, darkRes=90, lightRes=90}, --Drak Quack
	{hp=48.9, str=11.2, mag=10.3, def=7.7, 
		fireRes=115, iceRes=115, elecRes=115, waterRes=115, darkRes=55, lightRes=165}, --Keeba Tiger

	--Rare Spirits

	--Some Spirit data is incomplete; If so, they are copied from their counterparts where needed
	{hp=39.6, str=8.9, mag=11.7, def=6.6, 
		fireRes=105, iceRes=105, elecRes=105, waterRes=105, darkRes=105, lightRes=105}, --Meowjesty
	{hp=38.4, str=10, mag=8.9, def=6.2, 
		fireRes=155, iceRes=90, elecRes=100, waterRes=60, darkRes=110, lightRes=110}, --Sudo Neku
	{hp=41.9, str=9.7, mag=10.3, def=6.7, 
		fireRes=85, iceRes=85, elecRes=85, waterRes=85, darkRes=40, lightRes=135}, --Frootz Cat
	{hp=51.4, str=10.8, mag=8.3, def=6.9, 
		fireRes=95, iceRes=95, elecRes=95, waterRes=95, darkRes=95, lightRes=95}, --Ursa Circus
	{hp=40.7, str=10.2, mag=10.3, def=8.1, 
		fireRes=90, iceRes=90, elecRes=90, waterRes=90, darkRes=90, lightRes=90}, --Kab Kannon
	{hp=43.1, str=10, mag=10, def=6.9, 
		fireRes=40, iceRes=145, elecRes=90, waterRes=0, darkRes=90, lightRes=90}, --R & R Seal
	{hp=39.2, str=9.7, mag=11.7, def=7.2, 
		fireRes=100, iceRes=100, elecRes=60, waterRes=100, darkRes=115, lightRes=115}, --Catanuki; Phys Attributes copied from Flowbermeow
	{hp=47.8, str=10.5, mag=8.1, def=6.8, 
		fireRes=110, iceRes=110, elecRes=110, waterRes=50, darkRes=110, lightRes=110}, --Beatalike; Phys Attributes copied from Zolephant
	{hp=38.1, str=9.2, mag=11.1, def=6.8, 
		fireRes=70, iceRes=130, elecRes=150, waterRes=70, darkRes=100, lightRes=100}, --Tubguin Ace; Phys Attributes copied from Iceguin Ace

}
end

return Spirits