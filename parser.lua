local Parser = {}

function Parser.parseIncome(str)
    local num, suffix = str:match("%$(%d+%.?%d*)([KMBT]?)%/s")
    if not num then return nil end

    local multipliers = { K = 1e3, M = 1e6, B = 1e9, T = 1e12 }
    return tonumber(num) * (multipliers[suffix] or 1)
end

function Parser.parseAnimals()
    local animals = {}

    for _, plot in ipairs(workspace.Plots:GetChildren()) do
        local animalPodiums = plot:FindFirstChild("AnimalPodiums")
        if not animalPodiums then goto continuePlot end

        for _, podium in ipairs(animalPodiums:GetChildren()) do
            local podiumBase = podium:FindFirstChild("Base")
            if not podiumBase then goto continuePodium end

            local spawnPoint = podiumBase:FindFirstChild("Spawn")
            if not spawnPoint then goto continuePodium end

            local attachment = spawnPoint:FindFirstChild("Attachment")
            if not attachment then goto continuePodium end

            local overheadInfo = attachment:FindFirstChild("AnimalOverhead")
            if not overheadInfo then goto continuePodium end

            local animal = {
                Name       = overheadInfo:FindFirstChild("DisplayName") and overheadInfo.DisplayName.Text or "Unknown",
                Generation = overheadInfo:FindFirstChild("Generation") and Parser.parseIncome(overheadInfo.Generation.Text) or 0,
                Rarity     = overheadInfo:FindFirstChild("Rarity") and overheadInfo.Rarity.Text or "Common",
                Stolen     = overheadInfo:FindFirstChild("Stolen") and overheadInfo.Stolen.Visible or false,
                Stand      = podiumBase:FindFirstChild("Decorations") or nil,
                Podium     = podium
            }

            table.insert(animals, animal)

            ::continuePodium::
        end

        ::continuePlot::
    end

    return animals
end

return Parser