local function parseAnimals()
    local animals = {}

    for _, plot in ipairs(workspace.Plots:GetChildren()) do
        local animalPodiums = plot:FindFirstChild("AnimalPodiums")
        if animalPodiums then
            for _, podium in ipairs(animalPodiums:GetChildren()) do
                local podiumBase = podium:FindFirstChild("Base")
                if podiumBase then
                    local spawnPoint = podiumBase:FindFirstChild("Spawn")
                    if spawnPoint then
                        local attachment = spawnPoint:FindFirstChild("Attachment")
                        if attachment then
                            local overheadInfo = attachment:FindFirstChild("AnimalOverhead")
                            if overheadInfo then
                                local animal = {
                                    DisplayName = overheadInfo:FindFirstChild("DisplayName") and overheadInfo.DisplayName.Text or "Unknown",
                                    Generation  = overheadInfo:FindFirstChild("Generation")  and overheadInfo.Generation.Text  or "$0/s",
                                    Rarity      = overheadInfo:FindFirstChild("Rarity")      and overheadInfo.Rarity.Text      or "Common",
                                    Stolen      = overheadInfo:FindFirstChild("Stolen")      and overheadInfo.Stolen.Visible   or false,
                                }

                                table.insert(animals, animal)
                            end
                        end
                    end
                end
            end
        end
    end

    return animals
end