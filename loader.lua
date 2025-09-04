local prefix = "https://raw.githubusercontent.com/atsyio/script/main/"
local __modules = {}

function require(name)
    if __modules[name] then
        return __modules[name]
    end

    local url = prefix .. name .. ".lua"
    local success, code = pcall(game.HttpGet, game, url)
    if not success then
        error("Failed to load module: " .. name)
    end

    local func, err = loadstring(code)
    if not func then
        error("Failed to compile module: " .. name .. ", error: " .. err)
    end

    local module = func()
    __modules[name] = module
    return module
end