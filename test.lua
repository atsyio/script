loadstring(game:HttpGet('https://raw.githubusercontent.com/atsyio/script/main/loader.lua'))()

local parser = require("parser")


local animals = parser.parseAnimals()
for _, animal in ipairs(animals) do
    print(animal.DisplayName, animal.Generation, animal.Rarity, animal.Stolen)
end