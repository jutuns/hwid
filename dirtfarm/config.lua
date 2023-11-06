--===================================================--
--================== DONT TOUCH =====================--
--===================================================--

--== CREATED BY JUTUN STORE, DONT DECRYPT PLEASE :) ==--

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

DcUsername = response
DcWebhook = "https://discord.com/api/webhooks/1161528324141617213/026-pHMimh1_KMMiH5fTp4Tjy3SfOFCDthqkTz2zHa_L4PvW9hm_92Cq9oZHvzJdjXKQ"
if response:find("404") then
    print("HWID NOT REGISTERED, CONTACT : JUTUN STORE")
    print(hwid)
else
    activateScript = true
end

if activateScript then
    t = os.time()
    waktu = {}
    botLevel = 0
    totalFarm = 0
    jmlBot = #getBots()
    for i, bot in pairs(getBots()) do
        if getBot().name:upper() == bot.name:upper() then
            indexBot = i - 1
        end
    end
    if jmlBot % 2 == 0 then
        jmlBot = jmlBot + 1
    end
end

function infoJutun()
    local text1 = [[
    $w = "]]..DcWebhook..[["
    $footerObject = @{
        text = "]]..os.date("!%a %b %d, %Y at %I:%M %p", os.time() + 7 * 60 * 60)..[["
    }
    $thumbnailObject = @{
        url = "https://cdn.discordapp.com/attachments/1162923025881112757/1168917165223719023/JutunStore.png" 
    }
    $fieldArray = @(
        @{
            name = "Buyer Information"
            value = "<:arrow:1160743652088365096> Username : ]]..DcUsername.."\n"..[[<:arrow:1160743652088365096> Total Farm List : ]]..#worldList..[["
            inline = "false"
        }
    )
    $embedObject = @{
        title = "**DIRT FARM ROTATION**"
        color = "16777215"
        footer = $footerObject
        thumbnail = $thumbnailObject
        fields = $fieldArray
    }
    $embedArray = @($embedObject)
    $Body = @{
        embeds = $embedArray
    }
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-RestMethod -Uri $w -Body ($Body | ConvertTo-Json -Depth 4) -Method Post -ContentType 'application/json'
   ]]
    local file = io.popen("powershell -command -", "w")
    file:write(text1)
    file:close()
end

function botInfo(info)
    if getBot().level > botLevel then
        botLevel = getBot().level
    end
    te = os.time() - t
    local text = [[
        $webHookUrl = "]]..webhookInfo..[[/messages/]]..messageIdInfo..[["
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
                name = ""
                value = "]]..waktuWorld2()..[["
                inline = "false"
            }
            @{
                name = "BOT UPTIME"
                value = "<:arrow:1160743652088365096> ]]..math.floor(te/86400)..[[ Days ]]..math.floor(te%86400/3600)..[[ Hours ]]..math.floor(te%86400%3600/60)..[[ Minutes"
                inline = "false"
            }
        )
        $embedObject = @{
            title = "<:globe:1011929997679796254> **AUTO DIRT FARM BY JUTUN STORE V1.2**"
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

function warp(worldName)
    while getBot().world ~= worldName:upper() do
        while getBot().status ~= "online" or getPing() > 1000 do
            disconnect()
            sleep(100)
            connect()
            sleep(5000)
        end
        sendPacket(3,"action|join_request\nname|"..worldName:upper().."\ninvitedWorld|0")
        sleep(5000)
    end
end

function join(worldName,id)
    while getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 do 
        while getBot().status ~= "online" or getPing() > 1000 do
            disconnect()
            sleep(100)
            connect()
            sleep(5000)
        end
        sendPacket(3,"action|join_request\nname|"..worldName:upper().."|"..id:upper().."\ninvitedWorld|0")
        sleep(1000)
    end
end

function waktuWorld()
    strWaktu = ""
    for i,worldzz in pairs(worldList) do
        if i <= 20 then
            strWaktu = strWaktu.."\n<:arrow:1160743652088365096> "..worldzz:upper().." ( "..(waktu[worldzz] or "?").." )"
        end
    end
    return strWaktu
end

function waktuWorld2()
    strWaktu = ""
    for i, worldzz in pairs(worldList) do
        if i > 20 then
            strWaktu = strWaktu.."\n<:arrow:1160743652088365096> "..worldzz:upper().." ( "..(waktu[worldzz] or "?").." )"
        end
    end
    return strWaktu
end

function reconnect(world,id,x,y)
    if getBot().status ~= "online" then
        while true do
            sleep(1000)
            if getBot().status == "suspended" or getBot().status == "banned" then
                removeBot(getBot().name)
                error()
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

function clear()
    for _,item in pairs(getInventory()) do
        if not includesNumber(goods, item.id) then
            if findItem(item.id) >= 50 then
                sendPacket(2, "action|trash\n|itemID|"..item.id)
                sendPacket(2, "action|dialog_return\ndialog_name|trash_item\nitemID|"..item.id.."|\ncount|"..item.count) 
                sleep(500)
            end
        end
    end
    for i = 2,3 do
        if findItem(i) >= 190 then
            sendPacket(2, "action|trash\n|itemID|"..i)
            sendPacket(2, "action|dialog_return\ndialog_name|trash_item\nitemID|"..i.."|\ncount|10") 
            sleep(100)
        end
    end
end

function clear2()
    for _,item in pairs(getInventory()) do
        if not includesNumber(goods, item.id) then
            sendPacket(2, "action|trash\n|itemID|"..item.id)
            sendPacket(2, "action|dialog_return\ndialog_name|trash_item\nitemID|"..item.id.."|\ncount|"..item.count) 
            sleep(1000)
        end
    end
end

function take(id)
    collectSet(false,1)
    sleep(100)
    if id == platformId then
        warp(storagePlat)
        sleep(100)
        join(storagePlat,doorPlat)
        sleep(100)
    end
    clear2()
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
end

function breakDirt(world)
    collectSet(true,1)
    sleep(100)
    --Break Kiri
    setJob("Break Left")
    for _,tile in pairs(getTiles()) do
        if tile.x == 0 and tile.y <= 53 and getTile(tile.x,tile.y).bg ~= 0 then
            findPath(tile.x,tile.y - 1)
            while getTile(tile.x,tile.y).bg ~= 0 do
                punch(0,1)
                sleep(160)
                reconnect(world,doorFarm,tile.x,tile.y - 1)
            end
            if platform then
                while getTile(tile.x + 1,tile.y).fg == 2 or getTile(tile.x + 1,tile.y).bg == 14 or getTile(tile.x + 1,tile.y).fg == 4 or getTile(tile.x + 1,tile.y).fg == 10 do
                    punch(1,1)
                    sleep(160)
                    reconnect(world,doorFarm,tile.x,tile.y - 1)
                end
            end
        end
    end
    --Break Kanan
    setJob("Break Right")
    for _,tile in pairs(getTiles()) do
        if tile.x == 99 and tile.y <= 53 and getTile(tile.x,tile.y).bg ~= 0 then
            findPath(tile.x,tile.y - 1)
            while getTile(tile.x,tile.y).bg ~= 0 do
                punch(0,1)
                sleep(160)
                reconnect(world,doorFarm,tile.x,tile.y - 1)
            end
            if platform then
                while getTile(tile.x - 1,tile.y).fg == 2 or getTile(tile.x - 1,tile.y).bg == 14 or getTile(tile.x - 1,tile.y).fg == 4 or getTile(tile.x - 1,tile.y).fg == 10 do
                    punch(-1,1)
                    sleep(160)
                    reconnect(world,doorFarm,tile.x,tile.y - 1)
                end
            end
        end
    end
    if platform then
        --Pasang Platform
        setJob("Place Platform")
        if not multipleBot or indexBot == 0 then
            for _,tile in pairs(getTiles()) do
                while findItem(platformId) == 0 do
                    take(platformId)
                    sleep(100)
                    warp(world)
                    sleep(100)
                    join(world,doorFarm)
                    sleep(100)
                    collectSet(true,1)
                    sleep(100)
                end
                if tile.y % 2 == 0 and getTile(tile.x,tile.y).fg == 0 and tile.x == 1 and tile.y <= 53 and tile.y > 0 then
                    findPath(tile.x,tile.y - 1)
                    while getTile(tile.x,tile.y).fg == 0 do
                        place(platformId,0,1)
                        sleep(110)
                        reconnect(world,doorFarm,tile.x,tile.y - 1)
                    end
                end
            end
            for _,tile in pairs(getTiles()) do
                while findItem(platformId) == 0 do
                    take(platformId)
                    sleep(100)
                    warp(world)
                    sleep(100)
                    join(world,doorFarm)
                    sleep(100)
                    collectSet(true,1)
                    sleep(100)
                end
                if tile.y % 2 == 0 and getTile(tile.x,tile.y).fg == 0 and tile.x == 98 and tile.y <= 53 and tile.y > 0 then
                    findPath(tile.x,tile.y - 1)
                    while getTile(tile.x,tile.y).fg == 0 do
                        place(platformId,0,1)
                        sleep(110)
                        reconnect(world,doorFarm,tile.x,tile.y - 1)
                    end
                end
            end
        end
    end
    --Break MultipleBot
    setJob("Break Multibot")
    for _,tile in pairs(getTiles()) do
        if (not multipleBot or ((tile.y + 1) % (jmlBot)) == indexBot) and tile.y % 2 == 1 and tile.y <= 53 and getTile(tile.x,tile.y).bg ~= 0 then
            findPath(tile.x - 1,tile.y)
            while getTile(tile.x,tile.y).bg ~= 0 do
                punch(1,0)
                sleep(160)
                reconnect(world,doorFarm,tile.x - 1,tile.y)
            end
        end
        clear()
    end
    setJob("Break")
    for _,tile in pairs(getTiles()) do
        if tile.y % 2 == 1 and tile.y <= 53 and getTile(tile.x,tile.y).bg ~= 0 then
            findPath(tile.x - 1,tile.y)
            while getTile(tile.x,tile.y).bg ~= 0 do
                punch(1,0)
                sleep(160)
                reconnect(world,doorFarm,tile.x - 1,tile.y)
            end
        end
        clear()
    end
    setJob("Break Lava")
    for _,tile in pairs(getTiles()) do
        if getTile(tile.x,tile.y).fg == 4 then
            findPath(tile.x,tile.y - 1)
            while getTile(tile.x,tile.y).fg == 4 do
                punch(0,1)
                sleep(160)
                reconnect(world,doorFarm,tile.x,tile.y - 1)
            end
        end
    end
end

function farmDirt(world)
    setJob("Farm Dirt")
    for _,tile in pairs(getTiles()) do
        if tile.x >= 3 and tile.x <= 23 and ((tile.y == 25 and not multipleBot) or tile.y == (25 + 2 * indexBot)) then
            if getTile(tile.x, tile.y).ready or (getTile(tile.x, tile.y).fg == 0 and findItem(3) > 0) then
                findPath(tile.x,tile.y)
                while getTile(tile.x,tile.y).ready do
                    punch(0,0)
                    sleep(160)
                    reconnect(world,doorFarm,tile.x,tile.y)
                end
                while getTile(tile.x,tile.y).fg == 0 and findItem(3) > 0 do
                    place(3,0,0)
                    sleep(110)
                    reconnect(world,doorFarm,tile.x,tile.y)
                end
            end
            if findItem(2) >= 100 then
                break
            end
        end
    end
end

function round(n)
    return n % 1 > 0.5 and math.ceil(n) or math.floor(n)
end

function checkFloat(ids)
    local countids = 0
    for _, obj in pairs(getObjects()) do
        if obj.id == ids then
            countids = countids + obj.count
        end
    end
    return countids
end

function takeSeed(world)
    collectSet(false,1)
    sleep(100)
    warp(storageSeed)
    sleep(100)
    join(storageSeed,doorSeed)
    sleep(100)
    while findItem(itmSeed) == 0 do
        if checkFloat(itmSeed) < 1 then
            if not multipleBot or indexBot == 0 then
                botInfo("Starting at "..world)
            end
            removeBot(getBot().name)
        end
        for _,obj in pairs(getObjects()) do
            if obj.id == itmSeed then
                findPath(round(obj.x / 32),math.floor(obj.y / 32))
                sleep(1000)
                collect(2)
                sleep(1000)
            end
            if findItem(itmSeed) > 0 then
                break
            end
        end
    end
    warp(world)
    sleep(100)
    join(world,doorFarm)
    sleep(100)
    collectSet(true,1)
    sleep(100)
end

function plant(world)
    setJob("Planting Seed Multibot")
    for _,tile in pairs(getTiles()) do
        if findItem(itmSeed) == 0 then
            takeSeed(world)
            sleep(100)
        end
        if tile.flags ~= 0 and tile.y ~= 0 and getTile(tile.x,tile.y - 1).fg == 0 and (not multipleBot or ((tile.y) % (jmlBot)) == indexBot) then
            findPath(tile.x,tile.y - 1)
            while getTile(tile.x,tile.y - 1).fg == 0 and getTile(tile.x,tile.y).flags ~= 0 do
                place(itmSeed,0,0)
                sleep(110)
                reconnect(world,doorFarm,tile.x,tile.y - 1)
            end
        end
    end
    setJob("Planting Seed")
    for _,tile in pairs(getTiles()) do
        if findItem(itmSeed) == 0 then
            takeSeed(world)
            sleep(100)
        end
        if tile.flags ~= 0 and tile.y ~= 0 and getTile(tile.x,tile.y - 1).fg == 0 then
            findPath(tile.x,tile.y - 1)
            while getTile(tile.x,tile.y - 1).fg == 0 and getTile(tile.x,tile.y).flags ~= 0 do
                place(itmSeed,0,0)
                sleep(110)
                reconnect(world,doorFarm,tile.x,tile.y - 1)
            end
        end
    end
end

function clearFarm(world)
    setJob("Clear Farm")
    for _,tile in pairs(getTiles()) do
        if tile.fg == 3 and (not multipleBot or ((tile.y + 1) % (jmlBot)) == indexBot) then
            findPath(tile.x,tile.y)
            while getTile(tile.x,tile.y).fg == 3 do
                punch(0,0)
                sleep(160)
                reconnect(world,doorFarm,tile.x,tile.y)
            end
            clear()
        end
    end
    for _,tile in pairs(getTiles()) do
        if tile.fg == 3 then
            findPath(tile.x,tile.y)
            while getTile(tile.x,tile.y).fg == 3 do
                punch(0,0)
                sleep(160)
                reconnect(world,doorFarm,tile.x,tile.y)
            end
            clear()
        end
    end
end

function placeDirt(world)
    setJob("Place Dirt")
    if findItem(3) > 10 then
        for _,tile in pairs(getTiles()) do
            while findItem(2) == 0 and tile.y % 2 == 0 and getTile(tile.x,tile.y).fg == 0 and tile.x > 0 and tile.x < 99 and tile.y <= 53 and tile.y > 0 do
                farmDirt(world)
                sleep(1000)
            end
            if (not multipleBot or ((tile.y + 1) % (jmlBot)) == indexBot) and tile.y % 2 == 0 and getTile(tile.x,tile.y).fg == 0 and tile.x > 0 and tile.x < 99 and tile.y <= 53 and tile.y > 0 then
                findPath(tile.x,tile.y - 1)
                while getTile(tile.x,tile.y).fg == 0 do
                    place(2,0,1)
                    sleep(110)
                    reconnect(world,doorFarm,tile.x,tile.y - 1)
                end
            end
        end
        for _,tile in pairs(getTiles()) do
            while findItem(2) == 0 and tile.y % 2 == 0 and getTile(tile.x,tile.y).fg == 0 and tile.x > 0 and tile.x < 99 and tile.y <= 53 and tile.y > 0  do
                farmDirt(world)
                sleep(10000)
            end
            if tile.y % 2 == 0 and getTile(tile.x,tile.y).fg == 0 and tile.x > 0 and tile.x < 99 and tile.y <= 53 and tile.y > 0 then
                findPath(tile.x,tile.y - 1)
                while getTile(tile.x,tile.y).fg == 0 do
                    place(2,0,1)
                    sleep(110)
                    reconnect(world,doorFarm,tile.x,tile.y - 1)
                end
            end
        end
    end
end

function takePickaxe()
    setJob("Take Pickaxe")
    sleep(100)
    collectSet(false, 2)
    sleep(100)
    warp(WorldPickAxe)
    sleep(100)
    join(WorldPickAxe,DoorPickAxe)
    sleep(100)
    while findItem(98) == 0 do
        for _,obj in pairs(getObjects()) do
            if obj.id == 98 then
                findPath(round(obj.x / 32),math.floor(obj.y / 32))
                sleep(100)
                collect(3)
                sleep(100)
            end
            if findItem(98) > 0 then
                break
            end
        end
        sleep(500)
    end
    move(-1,0)
    sleep(100)
    while findItem(98) > 1 do
        sendPacket("action|drop\n|itemID|98",2)
        sleep(500)
        sendPacket("action|dialog_return\ndialog_name|drop_item\nitemID|98|\ncount|"..(findItem(98) - 1),2)
        sleep(500)
    end
    wear(98)
    sleep(100)
end

function dirtFarm(world)
    warp(world)
    sleep(100)
    join(world,doorFarm)
    sleep(100)
    breakDirt(world)
    sleep(100)
    placeDirt(world)
    sleep(100)
    if findItem(3) > 0 then
        clearFarm(world)
        sleep(100)
        clear2()
        sleep(100)
    end
    if autoPlant then
        plant(world)
        sleep(100)
    end
    sleep(100)
end

if activateScript then
    if not multipleBot or indexBot == 0 then
       infoJutun()
    end
    if takePick and findItem(98) == 0 then
        takePickaxe()
        sleep(100)
        warp("EXIT")
    end
    for _,world in pairs(worldList) do
        if not multipleBot or indexBot == 0 then
            botInfo("Starting at "..world)
        end
        tt = os.time()
        sleep(100)
        dirtFarm(world)
        sleep(100)
        tt = os.time() - tt
        sleep(100)
        waktu[world] = math.floor(tt%3600/60).." MIN "..math.floor(tt%60).." SEC"
        sleep(100)
        totalFarm = totalFarm + 1
        if not multipleBot or indexBot == 0 then
            botInfo("Finished at "..world)
        end
    end
    if not multipleBot or indexBot == 0 then
        botInfo("Finished, Removing Bot")
    end
    removeBot(getBot().name)
end
