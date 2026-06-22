-- REUBZ HUB MASTER SINGLE-LINK COMBINER LOADER (RAW LINK SERVER FIX)
local baseUrl = "https://githubusercontent.com"

local function loadPart(fileName)
    local success, content = pcall(function()
        return game:HttpGet(baseUrl .. fileName)
    end)
    if success and content then
        return content
    else
        warn("[Reubz Hub] Failed to pull data package: " .. tostring(fileName))
        return ""
    end
end

-- Fetch and dynamically concatenate pieces safely at runtime
local fullScript = loadPart("p1.lua") .. "\n" .. loadPart("p2.lua") .. "\n" .. loadPart("p3.lua")

if #fullScript > 500 then
    local run, err = loadstring(fullScript)
    if run then 
        run() 
    else 
        warn("[Reubz Hub] Compilation Failure: " .. tostring(err)) 
    end
else
    warn("[Reubz Hub] File string payload too short. Check your GitHub repository file names.")
end
