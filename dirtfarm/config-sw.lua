--====================================================--
--== CREATED BY JUTUN STORE, Dont Decrypt Please :) ==--
--====================================================--

activateScript = false
function get_hwid()
    local cmd = io.popen("wmic cpu get ProcessorId /format:list")
    if cmd then
        local output = cmd:read("*a")
        cmd:close()
        local hwid = output:match("ProcessorId=(%w+)")
        return hwid or "HWID not found"
    else
        return "Unable to execute the command"
    end
end
local hwid = get_hwid()
response = request("GET", "https://raw.githubusercontent.com/jutuns/hwid/main/dirtfarm/"..hwid)
if response:find("404") then
    print("HWID NOT REGISTERED, CONTACT : JUTUN STORE")
    print(hwid)
else
    activateScript = true
end

if activateScript then
    totalFarm = 0
    botLevel = 0
    strWaktu = "NONE"
    worldList = {}
    t = os.time()
    file = io.open(getBot().name..".txt", "w+")
    file:close()
    jmlBot = #getBots()
    for i, bot in pairs(getBots()) do
        if getBot().name:upper() == bot.name:upper() then
            indexBot = i - 1
        end
    end
end

function log(txt)
    file = io.open(getBot().name..".txt", "a")
    if file then
        file:write(txt.."\n")
        file:close()
    end
end

function warp(worldName)
    while getBot().world ~= worldName:upper() do
        sendPacket(3,"action|join_request\nname|"..worldName:upper().."\ninvitedWorld|0")
        sleep(5000)
    end
end

function join(worldName,id)
    while getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 do 
        sendPacket(3,"action|join_request\nname|"..worldName:upper().."|"..id:upper().."\ninvitedWorld|0")
        sleep(1000)
    end
end

function botInfo(info)
    if getBot().level > botLevel then
        botLevel = getBot().level
    end
    te = os.time() - t
    local text = [[
        $webHookUrl = "]]..webhookLinkDf..[[/messages/]]..messageIdDf..[["
        $thumbnailObject = @{
            url = "https://cdn.discordapp.com/attachments/1162923025881112757/1168917165223719023/JutunStore.png"
        }
        $footerObject = @{
            text = "]]..(os.date("!%a %b %d, %Y at %I:%M %p", os.time() + 7 * 60 * 60))..[["
        }
        $fieldArray = @(
            @{
                name = "Bot Info"
                value = "<:arrow:1160743652088365096> ]]..info..[["
                inline = "false"
            }
            @{
                name = "Bot Name"
                value = "<:arrow:1160743652088365096> ]]..getBot().name..[["
                inline = "true"
            }
            @{
                name = "Bot Status"
                value = "<:arrow:1160743652088365096> ]]..getBot().status..[["
                inline = "true"
            }
            @{
                name = "Bot Level"
                value = "<:arrow:1160743652088365096> ]]..botLevel..[["
                inline = "true"
            }
            @{
                name = "Bot Gems"
                value = "<:arrow:1160743652088365096> ]]..findItem(112)..[["
                inline = "true"
            }
            @{
                name = "Bot Slot"
                value = "<:arrow:1160743652088365096> ]]..getBot().slots..[["
                inline = "true"
            }
            @{
                name = "World Name"
                value = "<:arrow:1160743652088365096> ]]..getBot().world..[["
                inline = "true"
            }
            @{
                name = "World Info (]]..totalFarm..[[ World)"
                value = "]]..waktuWorld()..[["
                inline = "false"
            }
            @{
                name = "BOT UPTIME"
                value = "<:arrow:1160743652088365096> ]]..math.floor(te/86400)..[[ Days ]]..math.floor(te%86400/3600)..[[ Hours ]]..math.floor(te%86400%3600/60)..[[ Minutes"
                inline = "false"
            }
        )
        $embedObject = @{
            title = "<:globe:1011929997679796254> **AUTO FIND WORLD BY JUTUN STORE V1.1**"
            color = "16777215"
            thumbnail = $thumbnailObject
            footer = $footerObject
            fields = $fieldArray
        }
        $embedArray = @($embedObject)
        $payload = @{
            embeds = $embedArray
        }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Patch -ContentType 'application/json'
    ]]
    local file = io.popen("powershell -command -", "w")
    file:write(text)
    file:close()
end

function reconnect(world,id,x,y)
    if getBot().status ~= "online" then
        sleep(100)
        while true do
            sleep(1000)
            if getBot().status == "suspended" or getBot().status == "banned" then
                removeBot(getBot().name)
            end
            while getBot().status == "online" and getBot().world ~= world:upper() do
                sendPacket(3,"action|join_request\nname|"..world:upper().."\ninvitedWorld|0")
                sleep(5000)
            end
            if getBot().status == "online" and getBot().world == world:upper() then
                if id ~= "" then
                    while getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 do
                        sendPacket(3,"action|join_request\nname|"..world:upper().."|"..id:upper().."\ninvitedWorld|0")
                        sleep(1000)
                    end
                end
                if x and y and getBot().status == "online" and getBot().world == world:upper() then
                    while math.floor(getBot().x / 32) ~= x or math.floor(getBot().y / 32) ~= y do
                        findPath(x,y)
                        sleep(100)
                    end
                end
                if getBot().status == "online" and getBot().world == world:upper() then
                    if x and y then
                        if getBot().status == "online" and math.floor(getBot().x / 32) == x and math.floor(getBot().y / 32) == y then
                            break
                        end
                    elseif getBot().status == "online" then
                        break
                    end
                end
            end
        end
    end
end

function edit(x,y,id)
    wrench(x,y)
    sleep(1000)
    sendPacket(2,"action|dialog_return\ndialog_name|door_edit\ntilex|"..(math.floor(getBot().x / 32) + x).."|\ntiley|"..(math.floor(getBot().y / 32) + y).."|\ndoor_name|\ndoor_target|\ndoor_id|"..id.."\ncheckbox_locked|1")
    sleep(1000)
end

function public(x,y)
    wrench(x,y)
    sleep(1000)
    sendPacket(2,"action|dialog_return\ndialog_name|lock_edit\ntilex|"..(math.floor(getBot().x / 32) + x).."|\ntiley|"..(math.floor(getBot().y / 32) + y).."|\ncheckbox_public|1\ncheckbox_disable_music|0\ntempo|100\ncheckbox_disable_music_render|0\ncheckbox_set_as_home_world|0\nminimum_entry_level|1")
    sleep(1000)
end

function reapply(x,y)
    wrench(x,y)
    sleep(1000)
    sendPacket(2,"action|dialog_return\ndialog_name|lock_edit\ntilex|"..(math.floor(getBot().x / 32) + x).."|\ntiley|"..(math.floor(getBot().y / 32) + y).."|\nbuttonClicked|recalcLock\n\ncheckbox_public|0\ncheckbox_ignore|1")
    sleep(1000)
end

function breakIt(x,y)
    while getTile(math.floor(getBot().x / 32) + x,math.floor(getBot().y / 32) + y).fg ~= 0 or getTile(math.floor(getBot().x / 32) + x,math.floor(getBot().y / 32) + y).bg ~= 0 do
        punch(x,y)
        sleep(160)
    end
end

function placeIt(x,y,id)
    while getTile(math.floor(getBot().x / 32) + x,math.floor(getBot().y / 32) + y).fg ~= id do
        place(id,x,y)
        sleep(160)
    end
end

function name(count)
    if withNumber then
        local str = ""
        local chars = "abcdefghijklmnopqrstuvwxyz0123456789" -- Huruf dan angka yang diizinkan
        for i = 1, count do
            local randomIndex = math.random(1, #chars) -- Pilih indeks acak dari string `chars`
            str = str .. chars:sub(randomIndex, randomIndex) -- Tambahkan karakter yang dipilih ke dalam string `str`
        end
        return str:upper()
    else
        local str = ""
        for i = 1, count do
            str = str..string.char(math.random(97,122))
        end
        return str:upper()
    end
end

function round(n)
    return n % 1 > 0.5 and math.ceil(n) or math.floor(n)
end

function includesNumber(table, num)
    for _,n in pairs(table) do
        if n == num then
            return true
        end
    end
    return false
end

function take(id)
    collectSet(false,2)
    sleep(100)
    warp(storageWorld)
    sleep(100)
    join(storageWorld,doorStorage)
    sleep(100)
    for _,obj in pairs(getObjects()) do
        if obj.id == id then
            findPath(round(obj.x/32),math.floor(obj.y/32))
            sleep(1000)
            collect(2)
            sleep(1000)
            break
        end
    end
    if findItem(id) > 0 then
        move(-1,0)
        sleep(100)
    end
    if findItem(202) > farmCount then
        sendPacket(2,"action|drop\n|itemID|202")
        sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|202|\ncount|"..(findItem(202) - farmCount))
        sleep(500)
    end
    if findItem(242) > farmCount then
        sendPacket(2,"action|drop\n|itemID|202")
        sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|242|\ncount|"..(findItem(242) - farmCount))
        sleep(500)
    end
    if findItem(226) > farmCount then
        sendPacket(2,"action|drop\n|itemID|226")
        sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|226|\ncount|"..(findItem(226) - farmCount))
        sleep(500)
    end
    if findItem(doorId) > farmCount then
        sendPacket(2,"action|drop\n|itemID|"..doorId)
        sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|"..doorId.."|\ncount|"..(findItem(doorId) - farmCount))
        sleep(500)
    end
    if findItem(entrance) > farmCount * 2 then
        sendPacket(2,"action|drop\n|itemID|"..entrance)
        sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|"..entrance.."|\ncount|"..(findItem(entrance) - (farmCount * 2)))
        sleep(500)
    end
end

function round(n)
    return n % 1 > 0.5 and math.ceil(n) or math.floor(n)
end

function countTile()
    countFg = 0
    countBg = 0
    for _,tile in pairs(getTiles()) do
        if tile.fg ~= 0 then
            countFg = countFg + 1
        end
        if tile.bg ~= 0 then
            countBg = countBg + 1
        end
    end
    if countBg == 3600 and countFg == 3601 then
        return true
    end
    return false
end

function checkLock()
    locks = {242,9640,202,204,206,1796,4994,7188,408,2950,4428,4802 ,5814,5260,5980,8470,10410,11550,11586}
    for _,tile in pairs(getTiles()) do
        if includesNumber(locks, tile.fg) then
            return false
        end
    end
    return true
end

function checkWorld()
    repeat
        world = name(letterCount)
        setJob("Going to "..world)
        sleep(100)
        warp(world)
        sleep(100)
    until checkLock() and countTile()
    if useSignalJammer then
        placeIt(-1,-1,226)
        sleep(100)
        punch(-1,-1)
        sleep(160)
    else
        placeIt(-1,-1,2)
        sleep(160)
    end
    placeIt(1,0,entrance)
    sleep(100)
    placeIt(-1,0,entrance)
    sleep(100)
    placeIt(1,-1,doorId)
    sleep(100)
    breakIt(-2,1)
    sleep(100)
    breakIt(-1,2)
    sleep(100)
    breakIt(1,2)
    sleep(100)
    breakIt(2,1)
    sleep(100)
    breakIt(0,-1)
    sleep(100)
    if mode == "SL" or mode == "BOTH" then
        placeIt(0,-1,202)
        sleep(100)
        for i = 1,2 do
            reapply(0,-1)
            sleep(100)
        end
    elseif mode == "WL" then
        placeIt(0,-1,242)
        sleep(100)
    end
    while getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 do
        edit(1,-1,doorFarm)
        sleep(100)
        join(world,doorFarm)
        sleep(1000)
    end
    sleep(1000)
    move(-1,-1)
    sleep(1000)
    if mode == "BOTH" then
        move(-2,3)
        sleep(1000)
        breakIt(1,0)
        sleep(100)
        collect(2)
        sleep(100)
        placeIt(1,0,242)
        sleep(100)
        for i = 1,2 do
            public(1,0)
            sleep(100)
        end
    end
    table.insert(worldList,world)
    sleep(100)
    totalFarm = totalFarm + 1
    sleep(100)
    botInfo("Searching World")
    sleep(100)
    log(world)
    sleep(100)
end

function takeSupply()
    if mode == "SL" or mode == "BOTH" then  
        while findItem(202) == 0 do
            take(202)
            sleep(100)
        end
    end
    if mode == "WL" or mode == "BOTH" then  
        while findItem(242) == 0 do
            take(242)
            sleep(100)
        end
    end
    while findItem(entrance) < 2 do
        setJob("Taking Entrance")
        take(entrance)
        sleep(100)
    end
    while findItem(doorId) == 0 do
        setJob("Taking Door")
        take(doorId)
        sleep(100)
    end
    while findItem(226) == 0 and useSignalJammer do
        setJob("Taking Signal Jammer")
        take(226)
        sleep(100)
    end
    while findItem(2) == 0 and not useSignalJammer do
        setJob("Taking Dirt")
        take(2)
        sleep(100)
    end
end

function waktuWorld()
    strWaktu = ""
    for _,worldzz in pairs(worldList) do
        strWaktu = strWaktu.."\n<:arrow:1160743652088365096> "..worldzz:upper()
    end
    return strWaktu
end

if activateScript then
    botInfo("Starting")
    for i = 1,farmCount do
        setJob("Taking Supply")
        takeSupply()
        sleep(100)
        setJob("Searching World")
        checkWorld()
    end
    botInfo("Finished, Removing Bot.")
    removeBot(getBot().name)
end
