local Math = {}

function Math.maxBy(list, fn)
    local bestEntry = nil
    local bestValue = -math.huge
    for _, entry in ipairs(list) do
        local value = fn(entry)
        if value > bestValue then
            bestValue = value
            bestEntry = entry
        end
    end
    return bestEntry
end


return Math