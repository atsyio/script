local Inventory = {}

function Inventory.selectSlot(input)
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local backpack = player:WaitForChild("Backpack")
    local items = backpack:GetChildren()

    if typeof(input) == "number" then
        local tool = items[input]
        if tool then
            humanoid:EquipTool(tool)
            return tool
        end

    elseif typeof(input) == "string" then
        local lowerInput = string.lower(input)
        for _, tool in ipairs(items) do
            if string.lower(tool.Name) == lowerInput then
                humanoid:EquipTool(tool)
                return tool
            end
        end
    end

    return nil
end

function Inventory.getCurrentSlot()
    local char = player.Character or player.CharacterAdded:Wait()
    local backpack = player:WaitForChild("Backpack")

    local currentTool = char:FindFirstChildOfClass("Tool")
    if not currentTool then
        return nil
    end

    local items = backpack:GetChildren()
    for i, tool in ipairs(items) do
        if tool == currentTool then
            return i -- возвращаем номер слота
        end
    end

    return nil
end

function Inventory.doWithSlot(slot, func, delay, initial_delay)
    local player = game.Players.LocalPlayer
    initial_delay = initial_delay or 0

    local currentSlot = Inventory.getCurrentSlot()

    task.delay(initial_delay, function()
        Inventory.selectSlot(slot)

        if func then func() end

        if delay and currentSlot then
            task.delay(delay, function()
                Inventory.selectSlot(currentSlot)
            end)
        elseif delay then
            task.delay(delay, function()
                local char = player.Character or player.CharacterAdded:Wait()
                local humanoid = char:WaitForChild("Humanoid")
                humanoid:UnequipTools()
            end)
        end
    end)
end

return Inventory