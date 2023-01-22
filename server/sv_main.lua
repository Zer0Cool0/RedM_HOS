function DiscordWeb(color, name, footer)
    local embed = {{["color"] = color,["title"] = "",["description"] = "".. name .."",["footer"] = {["text"] = footer,},}}
    PerformHttpRequest(''..Config.Webhook..'', function(err, text, headers) end, 'POST', json.encode({username = "RedM Hall of Shame", embeds = embed}), { ['Content-Type'] = 'application/json' })
end

local function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = source

    local discordID
    local steamHex
    local license
    local fivem
    local xbl
    local live

    local found = false

    local isAllowed
    local res
    local identifiers = GetPlayerIdentifiers(player)
    deferrals.defer()

    Wait(0)

    deferrals.update(string.format("Hi there %s!, currently checking to see if you are banned by RHOS.", name))

    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
          steamHex = v
        end
        if string.find(v, "discord") then
          discordID = v
        end
        if string.find(v, "license") then
          license = v
        end
        if string.find(v, "fivem") then
          fivem = v
        end
        if string.find(v, "xbl") then
          xbl = v
        end
        if string.find(v, "live") then
          live = v
        end
    end

    if Config.RequireDiscord then
        if not discordID then
            deferrals.done("You must link your Discord account to RedM to join this server.")
        end
    end
    if Config.RequireSteam then
        if not steamHex then
            deferrals.done("You must link your Steam account to RedM to join this server.")
        end
    end

    Wait(600)

    local data = LoadResourceFile(GetCurrentResourceName(), "data/banlist.json")
    local json = json.decode(data)
    for k, v in pairs(json) do
        if v.steam == steamHex then
            found = true
        elseif v.discord == discordID then
            found = true
        elseif v.license == license then
            found = true
        elseif v.fivem == fivem then
            found = true
        elseif v.xbl == xbl then
            found = true
        elseif v.live == live then
            found = true
        end
    end

    Wait(600)

    if found then
        deferrals.done("You're banned from this server by RedM Hall of Shame.")
        if Config.Log then
            DiscordWeb(16711680, "Player blocked by RHOS from joining:\n\n**Display name:** `"..name.."`\n**Steam:** `"..steamHex.."`\n**Discord:** `"..discordID.."`\n**License:** `"..license.."`\n**FiveM:** `"..fivem.."`\n**XBL:** `"..xbl.."`\n**Live:** `"..live.."`", "RHOS | RedM Hall of Shame")
        end
    end

    Wait(300)

    deferrals.done()

end

AddEventHandler("playerConnecting", OnPlayerConnecting)