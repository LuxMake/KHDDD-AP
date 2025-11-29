local LocationDefs = {}

function LocationDefs:DefineWorldEvents()
  worldEvents = { --char is 0 for sora; 1 for riku
  --Sora DI World no 01
  --Combat basics: 300
  --Ursula Bonus: 1F00
  --Flashback: Mark of Mastery
    --Glossary: Keyblades
    --Glossary: Keyblade Masters
    --Glossary: Master Xehanort

    --Sora TT
    --Flowmotion Basics: 311
    --Reality Shift: 711
    --Flowmotion Combat: 1F11
    --Flashback Dreameaters: 7F11
    --Glossary: Heartless: 7F11
    --Meow Wow Recipe: FF11
    --Post Dream Eater Tutorial: 1FF11
    --Post Riku Drop: 7FF11
    {ID=2670201, StoryBit = {0x1F, 0x1F, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x01, char=0, sent = false}, --Ursula Slot
    {ID=2670202, StoryBit = {0x1F, 0x1F, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x01, char=0, sent = false}, --Keyblades
    {ID=2670203, StoryBit = {0x1F, 0x1F, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x01, char=0, sent = false}, --Keyblade Masters
    {ID=2670204, StoryBit = {0x1F, 0x1F, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x01, char=0, sent = false}, --Master Xehanort
    {ID=2670205, StoryBit = {0x1F, 0x1F, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x01, char=0, sent = false}, --Flashback Mark of Mastery
    
    {ID=2670206, StoryBit = {0x11, 0x7F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x03, char=0, sent = false}, --Flashback: Dream Eaters
    {ID=2670207, StoryBit = {0x11, 0x7F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x03, char=0, sent = false}, --Glossary: Heartless
    {ID=2670248, StoryBit = {0x11, 0x7F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x03, char=0, sent = false}, --Meow Wow Recipe Reward
    
    
    {ID=2670211, StoryBit = {0x11, 0xFF, 0x7F, 0x02, 0x00, 0x00, 0x00, 0x00}, LookAt=0x04, Popup=true, worldNo=0x03, char=0, sent = false}, --Hockomonkey Slot 1 [Sora]
    {ID=2670212, StoryBit = {0x11, 0xFF, 0x7F, 0x02, 0x00, 0x00, 0x00, 0x00}, LookAt=0x04, Popup=true, worldNo=0x03, char=0, sent = false}, --Hockomonkey Slot 2 [Sora]
    {ID=2670213, StoryBit = {0x11, 0xFF, 0x7F, 0x11, 0x00, 0x00, 0x00, 0x00}, LookAt=0x04, Popup=false, worldNo=0x03, char=0, sent = false}, --Skull Noise [Sora]
  
    --Sora LCdC
    {ID=2670214, StoryBit = {0x01, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x08, char=0, sent = false}, --Zolephant Recipe [Sora]
    {ID=2670215, StoryBit = {0x01, 0x7F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x08, char=0, sent = false}, --Flashback [Sora]
    {ID=2670216, StoryBit = {0x01, 0xFF, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=true, worldNo=0x08, char=0, sent = false}, --Flower HP Increase [Sora]
    {ID=2670217, StoryBit = {0x01, 0xFF, 0x7F, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=true, worldNo=0x08, char=0, sent = false}, --Deck Cap Increase [Sora]
    {ID=2670218, StoryBit = {0x11, 0xFF, 0xFF, 0x01, 0x00, 0x00, 0x00, 0x00}, LookAt=0x04, Popup=false, worldNo=0x08, char=0, sent = false}, --Chronicle BBS & Guardian Bell [Sora]
    {ID=2670219, StoryBit = {0x11, 0xFF, 0xFF, 0x01, 0x00, 0x00, 0x00, 0x00}, LookAt=0x04, Popup=false, worldNo=0x08, char=0, sent = false},
  
    --Sora TG
    {ID=2670220, StoryBit = {0x01, 0x3F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x09, char=0, sent = false}, --Counter Rush [Sora]
    {ID=2670221, StoryBit = {0x01, 0xFF, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x09, char=0, sent = false}, --Rinzler fight slot 1
    {ID=2670222, StoryBit = {0x01, 0xFF, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x09, char=0, sent = false}, --Rinzler fight slot 2
    {ID=2670223, StoryBit = {0x01, 0xFF, 0x3F, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x09, char=0, sent = false}, --Dual Disc

    --Sora PP
    {ID=2670224, StoryBit = {0x01, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x06, char=0, sent = false}, --Flashback When World's Dream
    {ID=2670225, StoryBit = {0x01, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x06, char=0, sent = false}, --Flashback Pinnochio
    {ID=2670226, StoryBit = {0x01, 0x7F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x06, char=0, sent = false}, --Max HP Increase
    {ID=2670227, StoryBit = {0x01, 0x7F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x06, char=0, sent = false}, --Jestabocky Recipe
    {ID=2670228, StoryBit = {0x01, 0xFF, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x06, char=0, sent = false}, --High Jump
    {ID=2670229, StoryBit = {0x01, 0xFF, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x06, char=0, sent = false}, --Glossary Nobodies
    {ID=2670230, StoryBit = {0x01, 0xFF, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x06, char=0, sent = false}, --Glossary Org XIII
    {ID=2670231, StoryBit = {0x01, 0xFF, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x06, char=0, sent = false}, --Chronicle KH2
    {ID=2670232, StoryBit = {0x01, 0xFF, 0x7F, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x06, char=0, sent = false}, --Flashback Monstro
    {ID=2670233, StoryBit = {0x01, 0xFF, 0xFF, 0x0F, 0x00, 0x00, 0x00, 0x00}, LookAt=0x04, Popup=false, worldNo=0x06, char=0, sent = false}, --Lobster Bonus Slot 1
    {ID=2670234, StoryBit = {0x11, 0xFF, 0xFF, 0x3F, 0x00, 0x00, 0x00, 0x00}, LookAt=0x04, Popup=false, worldNo=0x06, char=0, sent = false}, --Ferris Gear

    --Sora CotM
    {ID=2670235, StoryBit = {0x01, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x04, char=0, sent = false}, --Flashback Overnight Musketeers
    {ID=2670236, StoryBit = {0x01, 0x7F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x04, char=0, sent = false}, --Tyranto Rex Recipe
    {ID=2670237, StoryBit = {0x01, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x04, char=0, sent = false}, --Slide Roll
    {ID=2670238, StoryBit = {0x11, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00}, LookAt=0x04, Popup=false, worldNo=0x04, char=0, sent = false}, --Pete Fight Bonus Slot
    {ID=2670239, StoryBit = {0x11, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00}, LookAt=0x04, Popup=false, worldNo=0x04, char=0, sent = false}, --All for One

    --Sora SoS
    {ID=2670240, StoryBit = {0x01, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x05, char=0, sent = false}, --Flashback Sorcerer's Apprentice
    {ID=2670241, StoryBit = {0x01, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x05, char=0, sent = false}, --Double Impact Reward
    {ID=2670242, StoryBit = {0x01, 0xFF, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x05, char=0, sent = false}, --Spellican Bonus Slot 1
    {ID=2670243, StoryBit = {0x01, 0xFF, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x05, char=0, sent = false}, --Spellican Bonus Slot 2
    {ID=2670244, StoryBit = {0x11, 0xFF, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x05, char=0, sent = false}, --Counterpoint

    --Sora TWTNW
    {ID=2670245, StoryBit = {0x01, 0xFF, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x0A, char=0, sent = false}, --Xemnas Bonus Slot
    {ID=2670246, StoryBit = {0x01, 0xFF, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x0A, char=0, sent = false}, --Glossary: Recusant Sigil
    {ID=2670247, StoryBit = {0x11, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x0A, char=0, sent = false}, --Glossary: Hearts Tied to Sora/Goal

    --Riku TT
    --Meow Wow Event Reward is 248
    {ID=2670249, StoryBit = {0x11, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x03, char=1, sent = false}, --Komory Bat Recipe
    {ID=2670250, StoryBit = {0x11, 0x77, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x03, char=1, sent = false}, --Flashback: Keyblade War
    {ID=2670251, StoryBit = {0x11, 0x77, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x03, char=1, sent = false}, --Glossary: Keyblade War
    {ID=2670252, StoryBit = {0x11, 0x77, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x03, char=1, sent = false}, --Glossary: Kingdom Hearts
    {ID=2670253, StoryBit = {0x11, 0x77, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x03, char=1, sent = false}, --Glossary: X-Blade
    {ID=2670254, StoryBit = {0x11, 0xFF, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x03, char=1, sent = false}, --Save Shiki Bonus Slot
    {ID=2670255, StoryBit = {0x11, 0xFF, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x03, char=1, sent = false}, --Hockomonkey Bonus Slot 1
    {ID=2670256, StoryBit = {0x11, 0xFF, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x03, char=1, sent = false}, --Hockomonkey Bonus Slot 2
    {ID=2670257, StoryBit = {0x11, 0xFF, 0x7F, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x03, char=1, sent = false}, --Skull Noise Reward

    --Riku LCdC
    {ID=2670258, StoryBit = {0x01, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x08, char=1, sent = false}, --Flashback: Dark Obsession Reward
    {ID=2670259, StoryBit = {0x01, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x08, char=1, sent = false}, --Sonic Impact
    {ID=2670260, StoryBit = {0x01, 0xFF, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x08, char=1, sent = false}, --Wargoyle Bonus Slot 1
    {ID=2670261, StoryBit = {0x01, 0xFF, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x08, char=1, sent = false}, --Wargoyle Bonus Slot 2
    {ID=2670262, StoryBit = {0x01, 0xFF, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x08, char=1, sent = false}, --Chronicle: Kingdom Hearts
    {ID=2670263, StoryBit = {0x11, 0xFF, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x08, char=1, sent = false}, --Guardian Bell Reward

    --Riku TG
    {ID=2670264, StoryBit = {0x01, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x09, char=1, sent = false}, --Light Cycle Minigame Bonus Slot
    {ID=2670265, StoryBit = {0x01, 0x3F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x09, char=1, sent = false}, --Flashback: Father and Son
    {ID=2670266, StoryBit = {0x01, 0xFF, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x09, char=1, sent = false}, --City Dream Eater Fight Bonus Slot
    {ID=2670267, StoryBit = {0x01, 0xFF, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x09, char=1, sent = false}, --Flashback: Stolen Disk Reward
    {ID=2670268, StoryBit = {0x01, 0xFF, 0xFF, 0x0F, 0x00, 0x00, 0x00, 0x00}, LookAt=0x04, Popup=false, worldNo=0x09, char=1, sent = false}, --Commantis Bonus Slot
    {ID=2670269, StoryBit = {0x11, 0xFF, 0xFF, 0x1F, 0x00, 0x00, 0x00, 0x00}, LookAt=0x04, Popup=false, worldNo=0x09, char=1, sent = false}, --Dual Disc Reward

    --Riku PP
    {ID=2670270, StoryBit = {0x01, 0x3F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x06, char=1, sent = false}, --Chronicle: Chain of Memories
    {ID=2670271, StoryBit = {0x01, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x06, char=1, sent = false}, --Char Clobster Bonus Slot 1
    {ID=2670272, StoryBit = {0x01, 0xFF, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x06, char=1, sent = false}, --Ocean's Rage Reward

    --Riku CotM
    {ID=2670273, StoryBit = {0x01, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x04, char=1, sent = false}, --Flashback: Bon Journey
    {ID=2670274, StoryBit = {0x01, 0x3F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x04, char=1, sent = false}, --Stage Gadget
    {ID=2670275, StoryBit = {0x01, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x04, char=1, sent = false}, --Holey Moley Bonus Slot 1
    {ID=2670276, StoryBit = {0x01, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x04, char=1, sent = false}, --Shadow Slide Reward
    {ID=2670277, StoryBit = {0x01, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x04, char=1, sent = false}, --Shadow Strike Reward
    {ID=2670278, StoryBit = {0x11, 0xFF, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x04, char=1, sent = false}, --All for One Reward

    --Riku SoS
    {ID=2670279, StoryBit = {0x01, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x02, Popup=false, worldNo=0x05, char=1, sent = false}, --Flashback: A Magical Mishap
    {ID=2670280, StoryBit = {0x01, 0xFF, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x05, char=1, sent = false}, --Chernobog Bonus Slot 1
    {ID=2670281, StoryBit = {0x01, 0xFF, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x05, char=1, sent = false}, --Chernobog Bonus Slot 2
    {ID=2670282, StoryBit = {0x11, 0xFF, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x05, char=1, sent = false}, --Counterpoint Reward

    --Riku TWTNW
    {ID=2670283, StoryBit = {0x01, 0xFF, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x0A, char=1, sent = false}, --Ansem Boss Gauntlet Bonus Slot
    {ID=2670284, StoryBit = {0x11, 0xFF, 0x7F, 0x00, 0x1F, 0x00, 0x00, 0x00}, LookAt=0x05, Popup=false, worldNo=0x0A, char=1, sent = false}, --Young Xehanort Defeated/Goal Riku

    --AVN
    {ID=2670295, StoryBit = {0xFF, 0xEF, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00}, LookAt=0x03, Popup=false, worldNo=0x02, char=1, sent = false}, --Armored Ventus Nightmare

    --Sora TT2
    {ID=2670285, StoryBit = {0x11, 0xFF, 0x7F, 0x91, 0x03}, LookAt=0x05, Popup=false, worldNo=0x03, char=0, sent = false}, --Sliding Sidewinder
    {ID=2670286, StoryBit = {0x11, 0xFF, 0x7F, 0x91, 0x3F}, LookAt=0x05, Popup=false, worldNo=0x03, char=0, sent = false}, --Knockout Punch Reward
    {ID=2670287, StoryBit = {0x11, 0xFF, 0x7F, 0x91, 0x3F}, LookAt=0x05, Popup=false, worldNo=0x03, char=0, sent = false}, --Boss Gauntlet Bonus

    --Riku TT2
    {ID=2670288, StoryBit = {0x31, 0xFF, 0xFF, 0x7F}, LookAt=0x04, Popup=false, worldNo=0x03, char=1, sent = false}, --Cera Terror Bonus Slot 1
    {ID=2670289, StoryBit = {0x31, 0xFF, 0xFF, 0x7F}, LookAt=0x04, Popup=false, worldNo=0x03, char=1, sent = false}, --Cera Terror Bonus Slot 2
    {ID=2670290, StoryBit = {0x31, 0xFF, 0xFF, 0x7F}, LookAt=0x04, Popup=false, worldNo=0x03, char=1, sent = false}, --Cera Terror Recipe
    {ID=2670291, StoryBit = {0x31, 0xFF, 0xFF, 0xFF, 0x01}, LookAt=0x05, Popup=false, worldNo=0x03, char=1, sent = false}, --Knockout Punch Reward

    --Julius
    {ID=2670292, StoryBit = {0x31, 0xFF, 0xFF, 0xFF, 0xFF, 0x0F}, LookAt=0x06, Popup=false, worldNo=0x03, char=0, sent = false}, --Ultima Weapon Reward [Sora]
    {ID=2670293, StoryBit = {0x31, 0xFF, 0xFF, 0xFF, 0x7F}, LookAt=0x05, Popup=false, worldNo=0x03, char=1, sent = false}, --Ultima Weapon Reward [Riku]
    {ID=2670294, StoryBit = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF}, LookAt=0x08, Popup=false, worldNo=0x03, char=0, sent=false} --All superbosses reward
}

  --Traverse Town--
  --Base: 0x0000000000000000

  --The Grid--
  --Counter Rush: 0x0000000000003F01
  --Rinzler Fight Start: 0x00000000000FFF01
  --HP and Drop Bonus: 0x00000000001FFF01
  --Dual Disc: 0x00000000003FFF01

  --Prankster's Paradise--
  --Flashback Pinnochio's Lies & When World's Dream: 0x0000000000000701 (or F01)
  --Max HP Increase & Jestabocky Recipe: 0x0000000000007F01
  --High Jump: 0x00000000000FFF01
  --Glossary Nobodies & Glossary Org XIII & Chronicle KH2: 0x00000000001FFF01
  --Flashback Search for Monstro: 0x00000000007FFF01
  --Lobster Fight Start: 0x0000000003FFFF01
  --Deck Capacity Increase: 0x0000000007FFFF01 (or 1FFFFF01)
  --Ferris Gear: 0x000000003FFFFF11

  --CotM-- (uses 101 instead of 301 after dive)
  -- Flashback or chronicle idk i missed it (Overnight Musketeers?): 0x0000000000000701
  -- Tyranto Rex Recipe: 0x0000000000007F01
  -- Slide Roll: 0x0000000000FFFF01
  -- Deck Cap Increase & All For One: 0x00000000FFFFFF11

  --SoS--
  -- A-Rank Dive Addr: 0xA42EEC
  -- Double Impact: 0x000000000000FF01
  -- Spellican Fight Start: 0x000000000007FF01
  -- Max HP and Drop Bonus: 0x00000000000FFF01
  -- Counterpoint: 0x00000000001FFF11

  --TWTNW--
  -- Drop Point 1: 0x0000000000001F01
  -- Playable: 0x0000000000003F01
  -- Xemnas Fight Start: 0x00000000000FFF01
  -- Max HP/Glossary Recusant Sigil/Sora Goal 0x00000000001FFF01
  -- Glossary Hearts Tied to Sora 0x0000000000FFFF11 (Likely need to do this for Riku to progress TWTNW)

  --Disable drop to Sora: C004

  --AVN:
  --Post Drop [Cutscene before fight start]: 3EFFF (1EFFF when drop starts)
  --AVN World/Room: 0x02/0x04
  --AVN Cutscene Map/Btl/Evt: 0x0001/0x0001/0x0002
  --If 5th digit is greater than 3 then fight is won


  return worldEvents
end

function LocationDefs:DefinePortals()
  portalDigits = {
  traverseTown = {
    worldNo = 0x03,
    sora = {
      bossRoom = 0x0A,
      evt = 0x3F,
      portalId = 2680201,
      saveAddr = WorldFlags.traverseTown.sora.story+0x07
    },
    riku = {
      bossRoom = 0x0B,
      evt = 0x48,
      portalId = 2680202,
      saveAddr = WorldFlags.traverseTown.riku.story+0x07
    }
  },
  laCiteDesCloches = {
    worldNo = 0x08,
    sora = {
      bossRoom = 0x13,
      evt = 0x37,
      portalId = 2680203,
      saveAddr = WorldFlags.laCiteDesCloches.sora.story+0x07
    },
    riku = {
      bossRoom = 0x0E,
      evt = 0x3C,
      portalId = 2680204,
      saveAddr = WorldFlags.laCiteDesCloches.riku.story+0x07
    }
  },
  theGrid = {
    worldNo = 0x09,
    sora = {
      bossRoom = 0x0C,
      evt = 0x35,
      portalId = 2680205,
      saveAddr = WorldFlags.theGrid.sora.story+0x07
    },
    riku = {
      bossRoom = 0x01,
      evt = 0x3D,
      portalId = 2680206,
      saveAddr = WorldFlags.theGrid.riku.story+0x07
    }
  },
  prankstersParadise = {
    worldNo = 0x06,
    sora = {
      bossRoom = 0x05,
      evt = 0x38,
      portalId = 2680207,
      saveAddr = WorldFlags.prankstersParadise.sora.story+0x07
    },
    riku = {
      bossRoom = 0x0A,
      evt = 0x3C,
      portalId = 2680208,
      saveAddr = WorldFlags.prankstersParadise.riku.story+0x07
    }
  },
  countryOfMusketeers = {
    worldNo = 0x04,
    sora = {
      bossRoom = 0x03,
      evt = 0x39,
      portalId = 2680209,
      saveAddr = WorldFlags.countryOfMusketeers.sora.story+0x07
    },
    riku = {
      bossRoom = 0x0C,
      evt = 0x3C,
      portalId = 2680210,
      saveAddr = WorldFlags.countryOfMusketeers.riku.story+0x07
    }
  },
  symphonyOfSorcery = {
    sora = {
      bossRoom = 0x0B,
      evt = 0x35,
      portalId = 2680211,
      saveAddr = WorldFlags.symphonyOfSorcery.sora.story+0x07
    }
  }
}
end

function LocationDefs:DefineChests()
  chests = {
    sora = {
    { --Sora chests 1-8 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset=0x00,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650211,
    },
    { --Sora chests 9-16 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x01,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650219
    },
    { --Sora chests 17-23 [Set of 7]
      bitFlags = {0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x02,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650227
    },
    { --Sora chests 24-31 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x03,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650234
    },
    { --Sora chests 32-39 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x04,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650242
    },
    { --Sora chests 40-47 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x05,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650250
    },
    { --Sora chests 48-55 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x06,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650258
    },
    { --Sora chests 56-63 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x07,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650266
    },
    { --Sora chests 64-71 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x08,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650274
    },
    { --Sora chests 72-79 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x09,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650282
    },
    { --Sora chests 80-87 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x0A,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650290
    },
    { --Sora chests 88-95 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x0B,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650298
    },
    { --Sora chests 96-103 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x0C,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650306
    },
    { --Sora chests 104-109 [Set of 6]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20},
      offset = 0x0D,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650314
    },
    { --Sora chests 110-117 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x20,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650320
    },
    { --Sora chests 118-125 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x21,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650328
    },
    { --Sora chests 126-133 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x22,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650336
    },
    { --Sora chests 134-141 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x23,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650344
    },
    { --Sora chests 142-149 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x24,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650352
    },
    { --Sora chests 150-157 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x25,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650360
    },
    { --Sora chests 158-165 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x26,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650368
    },
    { --Sora chests 166-173 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x27,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650376
    },
    { --Sora chests 174-181 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x28,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650384
    },
    { --Sora chests 182-189 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x29,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650392
    },
    { --Sora chests 190-197 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x2A,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650400
    },
    { --Sora chests 198-205 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x2B,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650408
    },
    { --Sora chests 206-213 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x2C,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650416
    },
    { --Sora chests 214-221 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x2D,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650424
    },
    { --Sora chests 222-225 [Set of 4]
      bitFlags = {0x01, 0x02, 0x04, 0x08},
      offset = 0x2E,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650432
    }
  },
  riku = {
    { --Riku chests 1-8 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x00,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650436
    },
    { --Riku chests 9-14 [Set of 6]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20},
      offset = 0x01,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650444
    },
    { --Riku chests 15-21 [Set of 7]
      bitFlags = {0x01, 0x02, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x02,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650450
    },
    { --Riku chests 22-29 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x03,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650457
    },
    { --Riku chests 30-37 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x04,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650465
    },
    { --Riku chests 38-45 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x05,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650473
    },
    { --Riku chests 46-53 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x06,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650481
    },
    { --Riku chests 54-61 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x07,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650489
    },
    { --Riku chests 62-69 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x08,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650497
    },
    { --Riku chests 70-77 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x09,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650505
    },
    { --Riku chests 78-85 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x0A,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650513
    },
    { --Riku chests 86-93 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x0B,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650521
    },
    { --Riku chests 94-101 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x0C,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650529
    },
    { --Riku chests 102-109 [Set of 6]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20},
      offset = 0x0D,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650537
    },
    { --Riku chests 110-117 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x20,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650543
    },
    { --Riku chests 118-126 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x21,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650551
    },
    { --Riku chests 127-134 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x22,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650559
    },
    { --Riku chests 128-135 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x23,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650567
    },
    { --Riku chests 136-143 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x24,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650575
    },
    { --Riku chests 144-151 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x25,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650583
    },
    { --Riku chests 152-159 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x26,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650591
    },
    { --Riku chests 160-167 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x27,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650599
    },
    { --Riku chests 168-175 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x28,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650607
    },
    { --Riku chests 176-183 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x29,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650615
    },
    { --Riku chests 184-191 [Set of 8]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x2A,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650623
    },
    { --Riku chests 192-198 [Set of 7]
      bitFlags = {0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80},
      offset = 0x2B,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650631
    },
    { --Riku chests 199-204 [Set of 6]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x40, 0x80},
      offset = 0x2C,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650638
    },
    { --Riku chests 205-209 [Set of 5]
      bitFlags = {0x01, 0x02, 0x04, 0x08, 0x10},
      offset = 0x2D,
      foundChests = {false, false, false, false, false, false, false, false},
      locationIDStart = 2650644
    },

    --It's possible I miscounted somewhere. There should be 213 chests for Riku?
  }

  }
end

return LocationDefs