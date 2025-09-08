local Parser = {}

local Players = game:GetService("Players")

function Parser.isInside(part, point)
    if not part or not point then return false end
    local relativePos = part.CFrame:PointToObjectSpace(point)
    local size = part.Size / 2
    return math.abs(relativePos.X) <= size.X
       and math.abs(relativePos.Y) <= size.Y
       and math.abs(relativePos.Z) <= size.Z
end

function Parser.parseIncome(str)
    local num, suffix = str:match("%$(%d+%.?%d*)([KMBT]?)%/s")
    if not num then return nil end

    local multipliers = { K = 1e3, M = 1e6, B = 1e9, T = 1e12 }
    return tonumber(num) * (multipliers[suffix] or 1)
end

function Parser.parseBase()
    for _, plot in ipairs(workspace.Plots:GetChildren()) do
        local plotSign = plot:FindFirstChild("PlotSign")
        local yourBase = plotSign:FindFirstChild("YourBase")
        if yourBase then
            local textLabel = yourBase:FindFirstChild("TextLabel")
            if textLabel then
                if yourBase.Enabled then
                    local base = {
                        Part = plot,
                        UUID = plot.Name
                    }

                    return base
                end
            end
        end
    end

    return nil
end

function Parser.parseAnimals(exclude)
    local animals = {}

    for _, plot in ipairs(workspace.Plots:GetChildren()) do
        if plot.Name ~= exclude then
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
                                        Name        = overheadInfo:FindFirstChild("DisplayName")    and overheadInfo.DisplayName.Text                       or "Unknown",
                                        Income      = overheadInfo:FindFirstChild("Generation")     and Parser.parseIncome(overheadInfo.Generation.Text)    or 0,
                                        Generation  = overheadInfo:FindFirstChild("Generation")     and overheadInfo.Generation.Text                        or "$0/s",
                                        Rarity      = overheadInfo:FindFirstChild("Rarity")         and overheadInfo.Rarity.Text                            or "Common",
                                        Stolen      = overheadInfo:FindFirstChild("Stolen")         and overheadInfo.Stolen.Visible                         or false,
                                        Stand       = podiumBase:FindFirstChild("Decorations")      and podiumBase.Decorations                              or nil,
                                        Podium      = podium
                                    }

                                    table.insert(animals, animal)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return animals
end

function Parser.parseCurrentBase()
    local player = Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    for _, plot in ipairs(workspace.Plots:GetChildren()) do
        local stealHitbox = plot:FindFirstChild("StealHitbox")
        if stealHitbox and Parser.isInside(stealHitbox, root.Position) then
            return plot
        end
    end

    return nil
end

function Parser.parseNearestPodium(plot)
    if not plot then return nil end
    
    local player = Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local animalPodiums = plot:FindFirstChild("AnimalPodiums")
    if not animalPodiums then return nil end

    local nearestPodium = nil
    local nearestDist = math.huge

    for _, podium in ipairs(animalPodiums:GetChildren()) do
        local podiumBase = podium:FindFirstChild("Base")
        if podiumBase then
            local dist = (root.Position - podiumBase.Position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearestPodium = podium
            end
        end
    end

    return nearestPodium
end

return Parser