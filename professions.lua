module 'CanIHazLink.professions'

do
local names = {}

names['Alchemy']        = 'Alchemy'
names['Blacksmithing']  = 'Blacksmithing'
names['Enchanting']     = 'Enchanting'
names['Engineering']    = 'Engineering'
names['Leatherworking'] = 'Leatherworking'
names['Tailoring']      = 'Tailoring'
names['Jewelcrafting']  = 'Jewelcrafting'
names['Inscription']    = 'Inscription'

names['Mooncloth Tailoring']    = 'Mooncloth Tailoring'
names['Shadoweave Tailoring']   = 'Shadoweave Tailoring'
names['Spellfire Tailoring']    = 'Spellfire Tailoring'

names['Armorsmith']         = 'Armorsmith'
names['Master Axesmith']    = 'Master Axesmith'
names['Master Hammersmith'] = 'Master Hammersmith'
names['Master Swordsmith']  = 'Master Swordsmith'
names['Weaponsmith']        = 'Weaponsmith'

names['Gnomish Engineer']   = 'Gnomish Engineer'
names['Goblin Engineer']    = 'Goblin Engineer'

names['Dragonscale Leatherworking'] = 'Dragonscale Leatherworking'
names['Elemental Leatherworking']   = 'Elemental Leatherworking'
names['Tribal Leatherworking']      = 'Tribal Leatherworking'

names['Elixir Master']          = 'Elixir Master'
names['Potion Master']          = 'Potion Master'
names['Transmutation Master']   = 'Transmutation Master'

local spellid = {
    [2259] = names['Alchemy'], -- Apprentice / 75
    [3101] = names['Alchemy'], -- Journeyman / 150
    [3464] = names['Alchemy'], -- Expert / 225
    [11611] = names['Alchemy'], -- Artisan / 300
    [28596] = names['Alchemy'], -- Master / 375
    [51304] = names['Alchemy'], -- Grand Master / 450
    [28677] = names['Elixir Master'],
    [28675] = names['Potion Master'],
    [28672] = names['Transmutation Master'],
    
    [2108] = names['Leatherworking'], -- Apprentice / 75
    [3104] = names['Leatherworking'], -- Journeyman / 150
    [3811] = names['Leatherworking'], -- Expert / 225
    [10662] = names['Leatherworking'], -- Artisan / 300
    [32549] = names['Leatherworking'], -- Master / 375
    [51302] = names['Leatherworking'], -- Grand Master / 450
    [10656] = names['Dragonscale Leatherworking'],
    [10658] = names['Elemental Leatherworking'],
    [10660] = names['Tribal Leatherworking'],
    
    [25229] = names['Jewelcrafting'], -- Apprentice / 75
    [25230] = names['Jewelcrafting'], -- Journeyman / 150
    [28894] = names['Jewelcrafting'], -- Expert / 225
    [28895] = names['Jewelcrafting'], -- Artisan / 300
    [28897] = names['Jewelcrafting'], -- Master / 375
    [51311] = names['Jewelcrafting'], -- Grand Master / 450
    
    [45357] = names['Inscription'], -- Apprentice / 75
    [45358] = names['Inscription'], -- Journeyman / 150
    [45359] = names['Inscription'], -- Expert / 225
    [45360] = names['Inscription'], -- Artisan / 300
    [45361] = names['Inscription'], -- Master / 375
    [45363] = names['Inscription'], -- Grand Master / 450
    
    [4036] = names['Engineering'], -- Apprentice / 75
    [4037] = names['Engineering'], -- Journeyman / 150
    [4038] = names['Engineering'], -- Expert / 225
    [12656] = names['Engineering'], -- Artisan / 300
    [30350] = names['Engineering'], -- Master / 375
    [51306] = names['Engineering'], -- Grand Master / 450
    [20219] = names['Gnomish Engineer'],
    [20222] = names['Goblin Engineer'],
    
    [7411] = names['Enchanting'], -- Apprentice / 75
    [7412] = names['Enchanting'], -- Journeyman / 150
    [7413] = names['Enchanting'], -- Expert / 225
    [13920] = names['Enchanting'], -- Artisan / 300
    [28029] = names['Enchanting'], -- Master / 375
    [51313] = names['Enchanting'], -- Grand Master / 450
    
    [3908] = names['Tailoring'], -- Apprentice / 75
    [3909] = names['Tailoring'], -- Journeyman / 150
    [3910] = names['Tailoring'], -- Expert / 225
    [12180] = names['Tailoring'], -- Artisan / 300
    [26790] = names['Tailoring'], -- Master / 375
    [51309] = names['Tailoring'], -- Grand Master / 450
    [26798] = names['Mooncloth Tailoring'],
    [26801] = names['Shadoweave Tailoring'],
    [26797] = names['Spellfire Tailoring'],
    
    [2018] = names['Blacksmithing'], -- Apprentice / 75
    [3100] = names['Blacksmithing'], -- Journeyman / 150
    [3538] = names['Blacksmithing'], -- Expert / 225
    [9785] = names['Blacksmithing'], -- Artisan / 300
    [29844] = names['Blacksmithing'], -- Master / 375
    [51300] = names['Blacksmithing'], -- Grand Master / 450
    [9788] = names['Armorsmith'],
    [17041] = names['Master Axesmith'],
    [17040] = names['Master Hammersmith'],
    [17039] = names['Master Swordsmith'],
    [9787] = names['Weaponsmith']
}

local shortNames = {
    ['alch']   = names['Alchemy']
    ['engi']   = names['Engineering']
    ['bs']     = names['Blacksmithing']
    ['ench']   = names['Enchanting']
    ['scribe'] = names['Inscription']
    ['insc']   = names['Inscription']
    ['jc']     = names['Jewelcrafting']
    ['jwc']    = names['Jewelcrafting']
    ['lw']     = names['Leatherworking']
    ['tailo']  = names['Tailoring']
}

function M.getname(name) 
    local t = names
    t.__index = shortNames
    
    return t[name]
end

function M.spellname(id)
    local spellid = spellid
    return spellid[id]
end
end

M.id = {
    ['Alchemy'] = 1,
    ['Blacksmithing'] = 2,
    ['Enchanting'] = 3, 
    ['Engineering'] = 4,
    ['Leatherworking'] = 5,
    ['Tailoring'] = 6,
    ['Jewelcrafting'] = 7,
    ['Inscription'] = 8
}

M.name = {
    id['Alchemy'] = 'Alchemy',
    id['Blacksmithing'] = 'Blacksmithing',
    id['Enchanting'] = 'Enchanting',
    id['Engineering'] = 'Engineering',
    id['Leatherworking'] = 'Leatherworking',
    id['Tailoring'] = 'Tailoring',
    id['Jewelcrafting'] = 'Jewelcrafting',
    id['Inscription'] = 'Inscription',
}

M.categories = {
    id['Alchemy']           = {2259, 3101, 3464, 11611, 28596, 51304, 28677, 28675, 28672},
    id['Blacksmithing']     = {2018, 3100, 3538, 9785, 29844, 51300, 9788, 17041, 17040, 17039, 9787},
    id['Enchanting']        = {7411, 7412, 7413, 13920, 28029, 51313},
    id['Engineering']       = {4036, 4037, 4038, 12656, 30350, 51306, 20219, 20222},
    id['Leatherworking']    = {2108, 3104, 3811, 10662, 32549, 51302, 10656, 10658, 10660},
    id['Tailoring']         = {3908, 3909, 3910, 12180, 26790, 51309, 26798, 26801, 26797},
    id['Jewelcrafting']     = {25229, 25230, 28894, 28895, 28897, 51311},
    id['Inscription']       = {45357, 45358, 45359, 45360, 45361, 45363}
}
