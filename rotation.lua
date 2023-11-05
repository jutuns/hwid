---========= Created by Jutun Store =========---
---========= Dont Decrypt Pls Puh :3 =========---

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
response = request("GET", "https://raw.githubusercontent.com/jutuns/hwid/main/"..hwid)

DcUsername = response
DcWebhook = "https://discord.com/api/webhooks/1161528324141617213/026-pHMimh1_KMMiH5fTp4Tjy3SfOFCDthqkTz2zHa_L4PvW9hm_92Cq9oZHvzJdjXKQ"
if response:find("404") then
    print("HWID NOT REGISTERED, CONTACT : JUTUN STORE")
    print(hwid)
else
    activateScript = true
end

if activateScript then
    for i, bot in pairs(getBots()) do
        if getBot().name:upper() == bot.name:upper() then
            indexBot = i
        end
        indexLast = i
    end
    minimumGem = packPrice * packLimit
    setBool("Auto Reconnect", false)
    world = ""
    doorFarm = ""
    worldBreak = ""
    doorBreak = ""
    cray = ""
    crays = ""
    jumlahChat = #listChat
    botLevel = 0
    profit = 0
    profitSeed = 0
    totalFarm = 0
    list = {}
    tileBreak = {}
    t = os.time()
    restOS = os.time()
    waktu = {}
    tree = {}
    worldListBot = {}
    totalSSeed = #storageSeedList
    dividerSSeed = math.ceil(indexLast / totalSSeed)
    choosenSSeed = math.ceil(indexBot / dividerSSeed)
    storageSeed = storageSeedList[choosenSSeed]
    totalSPack = #storagePackList
    dividerSPack = math.ceil(indexLast / totalSPack)
    choosenSPack = math.ceil(indexBot / dividerSPack)
    storagePack = storagePackList[choosenSPack]
    table.insert(goods,itmId)
    table.insert(goods,itmSeed)
    for _,pack in pairs(packList) do
        table.insert(goods,pack)
    end
    
    for _,clothes in pairs(getClothes()) do
        if clothes.id ~= 48 then
            table.insert(goods,clothes.id)
        end
    end 
    
    for i = math.floor(tileNumber/2),1,-1 do
        i = i * -1
        table.insert(tileBreak,i)
    end
    for i = 0, math.ceil(tileNumber/2) - 1 do
        table.insert(tileBreak,i)
    end
end

function waktuWorld()
    strWaktu = ""
    for _,worldzz in pairs(worldListBot) do
        strWaktu = strWaktu.."\n<:arrow:1160743652088365096> ||"..worldzz:upper().."|| ( "..(waktu[worldzz] or "?").." | "..(tree[worldzz] or "?").." )"
    end
    return strWaktu
end

function botEvents(info)
    if getBot().level > botLevel then
        botLevel = getBot().level
    end
    te = os.time() - t
    local text1 = [[
    $w = "]]..webhookEvents..[["
    $footerObject = @{
        text = "]]..os.date("!%a %b %d, %Y at %I:%M %p", os.time() + 7 * 60 * 60)..[["
    }
    $thumbnailObject = @{
        url = "https://cdn.discordapp.com/attachments/1162923025881112757/1168917165223719023/JutunStore.png" 
    }
    $fieldArray = @(
        @{
            name = ""
            value = "]]..info.."\n"..[["
            inline = "false"
        }
        @{
            name = "BOT INFORMATION"
            value = "<:arrow:1160743652088365096> Status : ]]..getBot().status..[[ (]]..getPing()..[[)]].."\n"..[[<:arrow:1160743652088365096> Name : ]]..getBot().name..[[ (No.]]..indexBot..[[)]].."\n"..[[<:arrow:1160743652088365096> Level : ]]..botLevel.."\n"..[["
            inline = "true"
        }
        @{
            name = "BOT PROFIT"
            value = "<:arrow:1160743652088365096> Profit Pack : ]]..profit.."\n"..[[<:arrow:1160743652088365096> Profit Seed : ]]..profitSeed.."\n"..[["
            inline = "true"
        }
        @{
            name = "FARM INFO (]]..totalFarm..[[)"
            value = "]]..waktuWorld().."\n"..[["
            inline = "false"
        }
        @{
            name = "BOT UPTIME"
            value = "<:arrow:1160743652088365096> ]]..math.floor(te/86400)..[[ Days ]]..math.floor(te%86400/3600)..[[ Hours ]]..math.floor(te%86400%3600/60)..[[ Minutes"
            inline = "false"
        }
    )
    $embedObject = @{
        title = "**Bot Update**"
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
            value = "<:arrow:1160743652088365096> Username : ]]..DcUsername.."\n"..[[<:arrow:1160743652088365096> Total Bot : ]]..indexLast..[["
            inline = "false"
        }
    )
    $embedObject = @{
        title = "**ROTASI OLYMPUS V1.2**"
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

function buyClothes()
    currentClothes = {}
    for _,num in pairs(getClothes()) do
        table.insert(currentClothes,num.id)
    end
    sleep(100)
    jumlahClothes = #currentClothes
    if jumlahClothes < 5 then
        sendPacket("action|buy\nitem|clothes",2)
        sleep(1000)
        sendPacket("action|buy\nitem|rare_clothes",2)
        sleep(1000)
        for _,num in pairs(getClothes()) do
            table.insert(goods,num.id)
            if not findClothes(num.id) and (num.id ~= 3934 or num.id ~= 3932) then
                if num.id ~= 3934 and num.id ~= 3932 then
                    wear(num.id)
                    sleep(1000)
                    print("Wearing "..num.name)
                end
            end
        end
        if not findClothes(98) and findItem(98) > 0 then
            wear(98)
        end
    end
end

function restBotOS(world,id,x,y)
    currentTimeOS = os.time()
    subtractionTimeOS = currentTimeOS - restOS
    if subtractionTimeOS >= (restInterval * 60) then
        botInfo(webhookOffline,":orange_circle: "..getBot().name.." ("..indexBot..") bot resting")
        if disconnectBotWhileRest then
            setBool("Auto Reconnect", false)
            disconnect()
            sleep(1000)
        end
        for i = restDuration, 1, -1 do
            setJob("Resting "..i.." minutes")
            sleep(60000)
        end
        while getBot().status ~= "online" do
            connect()
            sleep(8000)
            if getBot().status == "suspended" then
                removeBot(getBot().name)
            end
        end
        setJob("Online")
        sleep(100)
        warp(world,id)
        sleep(100)
        if x and y then
            while math.floor(getBot().x / 32) ~= x or math.floor(getBot().y / 32) ~= y do
                setJob("Find path to "..x..","..y)
                findPath(x,y)
                sleep(100)
            end
        end
        restOS = os.time()
        botInfo(webhookOffline,":green_circle: "..getBot().name.." ("..indexBot..") bot starting")
    end
end

function CheckNuke(var)
    if var[0]:find("OnConsoleMessage") and var[1]:find("That world is inaccessible.") then
        nukeWorldInfo(webhookNuked,getBot().name:upper() .. " world farm at "..world.." is nuked. @everyone")
        nuked = true
    end
end

function generateWorld()
    str = ""
    for i = 1, 12 do
        str = str..string.char(math.random(97,122))
    end
    return str
end

function skipTutorial()
    while findItem(6336) == 0 and getBot().world ~= "EXIT" do
        setJob("Skip Tutorial")
        sleep(500)
        sendPacket("ftue_start_popup_close",2)
        sleep(1000)
        findPath(86,30)
        sleep(1000)
        enter()
        sleep(3000)
        findPath(46,23)
        sleep(500)
        for i=0,4,1 do
            punch(1,0)
            sleep(200)
        end
        place(2,1,0)
        sleep(500)
        for i=0,4,1 do
            punch(1,0)
            sleep(200)
        end
        collect(3)
        sleep(1240)
        place(3,1,0)
        sleep(2000)
        place(10672,1,0)
        sleep(2500)
        punch(1,0)
        sleep(2500)
        move(1,0)
        collect(2)
        sleep(2500)
        wear(48)
        sleep(1000)
        sendPacket("action|quit_to_exit",3)
        sleep(1000)
        sendPacket("action|join_request\nname|" .. generateWorld() .."\ninvitedWorld|0",3)
        while getBot().world == "EXIT" do
            sleep(2000)
        end
        place(9640,0,-1)
        sleep(5000)
        if findItem(6336) == 0 then
            setJob("Failed Skip Tutorial")
            disconnect()
            sleep(5000)
            while getBot().status ~= "online" do
                connect()
                sleep(5000)
            end
        end
    end
end

function nukeWorldInfo(webhookNuked,status)
    local text = [[
        $webHookUrl = "]]..webhookNuked..[["
        $payload = @{
            content = "]]..status..[["
        }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Post -ContentType 'application/json'
    ]]
    local file = io.popen("powershell -command -", "w")
    file:write(text)
    file:close()
end

function tilePunch(x,y)
    for _,num in pairs(tileBreak) do
        if getTile(x - 1,y + num).fg ~= 0 or getTile(x - 1,y + num).bg ~= 0 then
            return true
        end
    end
    return false
end

function tilePlace(x,y)
    for _,num in pairs(tileBreak) do
        if getTile(x - 1,y + num).fg == 0 and getTile(x - 1,y + num).bg == 0 then
            return true
        end
    end
    return false
end

function includesNumber(table, number)
    for _,num in pairs(table) do
        if num == number then
            return true
        end
    end
    return false
end

function bl(world)
    blist = {}
    for _,tile in pairs(getTiles()) do
        if tile.fg == 6 then
            doorX = tile.x
            doorY = tile.y
        end
    end
    if blacklistTile and getBot().world:upper() == world:upper() then
        for _,tile in pairs(blacklist) do
            table.insert(blist,{x = doorX + tile.x, y = doorY + tile.y})
        end
    end
end

function check(x,y)
    for _,tile in pairs(blist) do
        if x == tile.x and y == tile.y then
            return false
        end
    end
    return true
end

function botInfo(webhookinfo,status)
    local text = [[
        $webHookUrl = "]]..webhookinfo..[["
        $payload = @{
            content = "]]..status..[["
        }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Post -ContentType 'application/json'
    ]]
    local file = io.popen("powershell -command -", "w")
    file:write(text)
    file:close()
end

function warp(world,id)
    cok = 0
    setJob("Warp to "..world)
    addHook("onvariant","nukecheck", CheckNuke)
    while getBot().world ~= world:upper() and not nuked do
        while getBot().status ~= "online" or getPing() > 1000 do
            connect()
            sleep(10000)
            if getBot().status == "suspended" or getBot().status == "banned" then
                botInfo(webhookOffline,":red_circle: "..getBot().name.." ("..indexBot..") bot status is "..getBot().status)
                sleep(100)
                if changeBotSuspended then
                    changeGuest()
                    sleep(100)
                    sendPacket("action|join_request\nname|EXIT\ninvitedWorld|0",3)
                    sleep(5000)
                    collectSet(true, 3)
                else
                    removeBot(getBot().name)
                    error("BERHENTI")
                end
            end
        end
        sendPacket("action|join_request\nname|"..world:upper().."|"..id:upper().."\ninvitedWorld|0",3)
        sleep(6000)
        if cok == 20 then
            sendPacket("action|join_request\nname|EXIT\ninvitedWorld|0",3)
            sleep(2000)
            botInfo(webhookOffline,getBot().name.." ("..indexBot..")".." cannot join world ||"..world:upper().."||")
            sleep(100)
            botInfo(webhookOffline,getBot().name.." ("..indexBot..")".." bot disconnect 5 minutes while server growtopia sucks @everyone")
            sleep(100)
            setJob("Resting")
            disconnect()
            sleep(5 * 60 * 1000)
            cok = 0
        else
            cok = cok + 1
        end
    end
    cok = 0
    if id ~= "" and not nuked then
        if getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 and not nuked then
            while getBot().status ~= "online" or getPing() > 3000 do
                disconnect()
                sleep(1000)
                connect()
                sleep(8000)
                if getBot().status == "suspended" or getBot().status == "banned" then
                    botInfo(webhookOffline,":red_circle: "..getBot().name.." ("..indexBot..")".." bot status is "..getBot().status)
                    sleep(100)
                    removeBot(getBot().name)
                    error("BERHENTI")
                end
            end
            sendPacket("action|join_request\nname|"..world:upper().."|"..id:upper().."\ninvitedWorld|0",3)
            sleep(2000)
            if getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 and not nuked then
                botInfo(webhookOffline,getBot().name.." ("..indexBot..")".." cannot join door, world is "..world:upper().." @everyone")
                sleep(100)
                nuked = true
            end
        end
    end
    sleep(100)
    removeHooks()
end

function colorWebhook()
    if getBot().status == "online" then
        colorWH = "65280"
    else
        colorWH = "16711680"
    end
    return colorWH
end

function packInfo(link,id,desc)
    local text = [[
        $webHookUrl = "]]..link..[[/messages/]]..id..[["
        $thumbnailObject = @{
            url = "https://cdn.discordapp.com/attachments/1162923025881112757/1168917165223719023/JutunStore.png"
        }
        $footerObject = @{
            text = "]]..(os.date("!%a %b %d, %Y at %I:%M %p", os.time() + 7 * 60 * 60))..[["
        }
        $fieldArray = @(
            @{
                name = "World"
                value = "]]..getBot().world:upper()..[["
                inline = "false"
            }
            @{
                name = "<:cid:1133695201156800582> Last Visit"
                value = "]]..getBot().name.." (Bot Number : "..indexBot..")"..[["
                inline = "false"
            }
            @{
                name = "Dropped Items"
                value = "]]..desc..[["
                inline = "false"
            }
        )
        $embedObject = @{
            title = "<:globe:1011929997679796254> **INFORMATION**"
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
    if findItem(18) == 0 and getBot().status == "online" then
        disconnect()
        sleep(100)
        botInfo(webhookOffline,":red_circle: "..getBot().name.." ("..indexBot..")".." bot Fist tidak ditemukan/app bug")
        sleep(5000)
    end
    if getBot().status ~= "online" then
        botInfo(webhookOffline,":red_circle: "..getBot().name.." ("..indexBot..")".." bot status is "..getBot().status.." ("..getPing()..") @everyone")
        sleep(100)
        while getBot().status ~= "online" do
            connect()
            sleep(10000)
            if getBot().status == "suspended" or getBot().status == "banned" or getBot().status == "temporary ban" then
                botInfo(webhookOffline,":red_circle: "..getBot().name.." ("..indexBot..") bot status is "..getBot().status)
                sleep(100)
                if changeBotSuspended then
                    changeGuest()
                    sleep(100)
                    sendPacket("action|join_request\nname|EXIT\ninvitedWorld|0",3)
                    sleep(5000)
                    collectSet(true, 3)
                else
                    removeBot(getBot().name)
                    error("BERHENTI")
                end
            end
        end
        sleep(100)
        botInfo(webhookOffline,":green_circle: "..getBot().name.." ("..indexBot..")".." bot status is "..getBot().status)
        sleep(100)
        while getBot().world ~= world:upper() do
            sendPacket("action|join_request\nname|"..world:upper().."\ninvitedWorld|0",3)
            sleep(5000)
        end
        if id ~= "" then
            while getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 do
                sendPacket("action|join_request\nname|"..world:upper().."|"..id:upper().."\ninvitedWorld|0",3)
                sleep(1000)
            end
        end
        if x and y then
            while math.floor(getBot().x / 32) ~= x or math.floor(getBot().y / 32) ~= y do
                findPath(x,y)
                sleep(100)
            end
        end
        sleep(100)
    end
end

function round(n)
    return n % 1 > 0.5 and math.ceil(n) or math.floor(n)
end

function tileDrop1(x,y,num)
    local count = 0
    local stack = 0
    for _,obj in pairs(getObjects()) do
        if round(obj.x / 32) == x and math.floor(obj.y / 32) == y then
            count = count + obj.count
            stack = stack + 1
        end
    end
    if stack < 20 and count <= (4000 - num) then
        return true
    end
    return false
end

function tileDrop2(x,y,num)
    local count = 0
    local stack = 0
    for _,obj in pairs(getObjects()) do
        if round(obj.x / 32) == x and math.floor(obj.y / 32) == y then
            count = count + obj.count
            stack = stack + 1
        end
    end
    if count <= (4000 - num) then
        return true
    end
    return false
end

function storePack()
    warp(storagePack,doorPack)
    sleep(100)
    setJob("Store Pack")
    sleep(100)
    if getBot().world:upper() == storagePack:upper() then
        if packName == "growganoth" then
            carz = 0
            for _,tile in pairs(getTiles()) do
                if tile.fg == patokanPack or tile.bg == patokanPack then
                    findPath(tile.x - 1,tile.y)
                    sleep(100)
                    while findItem(10386) > 0 do
                        place(10386,0,0)
                        sleep(200)
                        reconnect(storagePack,doorPack,tile.x - 1,tile.y)
                    end
                    reconnect(storagePack,doorPack,tile.x - 1,tile.y)
                    for _,item in pairs(getInventory()) do
                        if not includesNumber(goods, item.id) then
                            sendPacket("action|drop\n|itemID|"..item.id,2)
                            sleep(500)
                            sendPacket("action|dialog_return\ndialog_name|drop_item\nitemID|"..item.id.."|\ncount|"..findItem(item.id),2)
                            sleep(500)
                            carz = carz + 1
                            reconnect(storagePack,doorPack,tile.x - 1,tile.y)
                        end
                    end
                end
                if carz >= 15 then
                    break
                end
            end
        else
            for _,pack in pairs(packList) do
                for _,tile in pairs(getTiles()) do
                    if tile.fg == patokanPack or tile.bg == patokanPack then
                        if tileDrop1(tile.x,tile.y,findItem(pack)) then
                            findPath(tile.x - 1,tile.y)
                            sleep(1000)
                            reconnect(storagePack,doorPack,tile.x - 1,tile.y)
                            if restBot then
                                restBotOS(storagePack,doorPack,tile.x - 1,tile.y)
                            end
                            if findItem(pack) > 0 and tileDrop1(tile.x,tile.y,findItem(pack)) then
                                sendPacket("action|drop\n|itemID|"..pack,2)
                                sleep(500)
                                sendPacket("action|dialog_return\ndialog_name|drop_item\nitemID|"..pack.."|\ncount|"..findItem(pack),2)
                                sleep(500)
                                reconnect(storagePack,doorPack,tile.x - 1,tile.y)
                                if restBot then
                                    restBotOS(storagePack,doorPack,tile.x - 1,tile.y)
                                end
                            end
                        end
                    end
                    if findItem(pack) == 0 then
                        break
                    end
                end
            end
        end
    end
    sleep(100)
    packInfo(webhookLinkPack,messageIdPack,infoPack())
    sleep(100)
end

function infoPack()
    local store = {}
    for _,obj in pairs(getObjects()) do
        if store[obj.id] then
            store[obj.id].count = store[obj.id].count + obj.count
        else
            store[obj.id] = {id = obj.id, count = obj.count}
        end
    end
    local str = ""
    for _,object in pairs(store) do
        local dropInfo = itemInfo(object.id)
        str = str.."\n"..dropInfo.name.." : x"..object.count
    end
    return str
end

function storeSeed(world)
    collectSet(false, 3)
    sleep(100)
    warp(storageSeed,doorSeed)
    sleep(100)
    setJob("Store Seed")
    sleep(100)
    ba = findItem(itmSeed)
    for _,tile in pairs(getTiles()) do
        if tile.fg == patokanSeed or tile.bg == patokanSeed then
            findPath(tile.x - 1,tile.y)
            sleep(100)
            if findItem(itmSeed) > 100 then
                drop(itmSeed,100)
                sleep(100)
                reconnect(storageSeed,doorSeed,tile.x - 1,tile.y)
                if restBot then
                    restBotOS(storageSeed,doorSeed,tile.x - 1,tile.y)
                end
            end
            if findItem(itmSeed) <= 100 then
                break
            end
        end
    end
    sleep(100)
    profitSeed = profitSeed + 100
    sleep(100)
    packInfo(webhookLinkSeed,messageIdSeed,infoPack())
    sleep(100)
    warp(world,doorFarm)
    sleep(100)
    collectSet(true, 3)
end

function clear()
    for _,item in pairs(getInventory()) do
        if not includesNumber(goods, item.id) then
            sendPacket("action|trash\n|itemID|"..item.id,2)
            sleep(400)
            sendPacket("action|dialog_return\ndialog_name|trash_item\nitemID|"..item.id.."|\ncount|"..item.count,2) 
            sleep(400)
            reconnect(world,doorFarm,ex,ye)
        end
    end
end

function pnb(world)
    if differentWorldPNB then
        local fileName = worldListPNB
        local file = io.open(fileName, "r")
        if file then
            local lines = {}
            for line in file:lines() do
                table.insert(lines, line)
            end
            file:close()
            crays = lines[1]
            data = split(lines[1], ':')
            if tablelength(data) == 2 then
                worldBreak = data[1]
                doorBreak = data[2]
            end
            table.remove(lines, 1)
            file = io.open(fileName, "w")
            if file then
                for _, line in ipairs(lines) do
                    file:write(line .. "\n")
                end
                file:write(crays)
                file:close()
            end
        end
        sleep(100)
        warp(worldBreak,doorBreak)
        sleep(100)
        if randomChat then
            chatBot = listChat[math.random(1,jumlahChat)]
            say(chatBot)
            sleep(1000)
        end
        if findItem(itmId) >= tileNumber and getBot().world:upper() == worldBreak:upper() then
            if not customTile then
                ex = 1
                ye = math.floor(getBot().y / 32)
                if getTile(ex,ye).fg ~= 0 and getTile(ex,ye).fg ~= itmSeed then
                    ye = ye - 1
                end
            else
                ex = customX
                ye = customY
            end
            sleep(100)
            findPath(ex,ye)
            sleep(1000)
            if not findClothes(98) and findItem(98) > 0 then
                wear(98)
            end
            while findItem(itmId) > tileNumber and findItem(itmSeed) <= 190 and math.floor(getBot().x / 32) == ex and math.floor(getBot().y / 32) == ye do
                setJob("Put and Break")
                while tilePlace(ex,ye) do
                    for _,i in pairs(tileBreak) do
                        if getTile(ex - 1,ye + i).fg == 0 and getTile(ex - 1,ye + i).bg == 0 then
                            place(itmId,-1,i)
                            sleep(delayPlace)
                            reconnect(worldBreak,doorBreak,ex,ye)
                            if restBot then
                                restBotOS(world,doorFarm,ex,ye)
                            end
                        end
                    end
                end
                while tilePunch(ex,ye) do
                    for _,i in pairs(tileBreak) do
                        if getTile(ex - 1,ye + i).fg ~= 0 or getTile(ex - 1,ye + i).bg ~= 0 then
                            punch(-1,i)
                            if variationDelay then
                                sleep(math.random(delayPunch - breakVariationDelay,delayPunch + breakVariationDelay))
                            else
                                sleep(delayPunch)
                            end
                            reconnect(worldBreak,doorBreak,ex,ye)
                            if restBot then
                                restBotOS(world,doorFarm,ex,ye)
                            end
                        end
                    end
                end
            end
            sleep(100)
            clear()
            sleep(100)
            warp(world,doorFarm)
            sleep(100)
        end
    else
        setJob("Setting up PnB")
        if randomChat then
            chatBot = listChat[math.random(1,jumlahChat)]
            say(chatBot)
            sleep(1000)
        end
        if findItem(itmId) >= tileNumber and getBot().world:upper() == world:upper() then
            if not customTile then
                ex = 1
                ye = math.floor(getBot().y / 32)
                if ye > 40 then
                    ye = ye - 10
                elseif ye < 11 then
                    ye = ye + 10
                end
                if getTile(ex,ye).fg ~= 0 and getTile(ex,ye).fg ~= itmSeed then
                    ye = ye - 1
                end
            else
                ex = customX
                ye = customY
            end
            sleep(100)
            findPath(ex,ye)
            sleep(1000)
            if not findClothes(98) and findItem(98) > 0 then
                wear(98)
            end
            while findItem(itmId) > tileNumber and findItem(itmSeed) <= 190 and math.floor(getBot().x / 32) == ex and math.floor(getBot().y / 32) == ye do
                setJob("Put and Break")
                while tilePlace(ex,ye) do
                    for _,i in pairs(tileBreak) do
                        if getTile(ex - 1,ye + i).fg == 0 and getTile(ex - 1,ye + i).bg == 0 then
                            place(itmId,-1,i)
                            sleep(delayPlace)
                            reconnect(world,doorFarm,ex,ye)
                            if restBot then
                                restBotOS(world,doorFarm,ex,ye)
                            end
                        end
                    end
                end
                while tilePunch(ex,ye) do
                    for _,i in pairs(tileBreak) do
                        if getTile(ex - 1,ye + i).fg ~= 0 or getTile(ex - 1,ye + i).bg ~= 0 then
                            punch(-1,i)
                            if variationDelay then
                                sleep(math.random(delayPunch - breakVariationDelay,delayPunch + breakVariationDelay))
                            else
                                sleep(delayPunch)
                            end
                            reconnect(world,doorFarm,ex,ye)
                            if restBot then
                                restBotOS(world,doorFarm,ex,ye)
                            end
                        end
                    end
                end
            end
            sleep(100)
            clear()
            sleep(100)
        end
    end
    if not dontPlant then
        plant(world)
    end
    sleep(100)
    if buyCloth then
        if findItem(112) >= 1000 then
            while getBot().slots < 36 do
                sendPacket("action|buy\nitem|upgrade_backpack",2)
                sleep(500)
            end
            buyClothes()
        end
    end
    if buyAfterPNB and findItem(112) > minimumGem then
        setJob("Buy Pack")
        sleep(100)
        while getBot().slots < 36 do
            sendPacket("action|buy\nitem|upgrade_backpack",2)
            sleep(500)
        end
        while findItem(112) > packPrice do
            for i = 1, packLimit do
                if findItem(112) > packPrice then
                    sendPacket("action|buy\nitem|"..packName,2)
                    profit = profit + 1
                    sleep(2000)
                else
                    break
                end
            end
        end
        collectSet(false, 3)
        sleep(100)
        storePack()
        sleep(100)
        warp(world,doorFarm)
        sleep(100)
        collectSet(true, 3)
        sleep(100)
    end
end

function plant(world)
    for _,tile in pairs(getTiles()) do
        if (tile.flags ~= 0 and tile.y ~= 0 and getTile(tile.x,tile.y - 1).fg == 0) and findItem(itmSeed) > 0 and getBot().world:upper() == world:upper() then
            if not blacklistTile or check(tile.x,tile.y) then
                setJob("Planting")
                findPath(tile.x,tile.y - 1)
                while getTile(tile.x,tile.y - 1).fg == 0 and getTile(tile.x,tile.y - 1).fg == 0 and getTile(tile.x,tile.y).flags ~= 0 and math.floor(getBot().x / 32) == tile.x and math.floor(getBot().y / 32) == tile.y - 1 and findItem(itmSeed) > 0 do
                    place(itmSeed,0,0)
                    sleep(delayPlant)
                    reconnect(world,doorFarm,tile.x,tile.y - 1)
                end
            end
        end
    end
end

function takePickaxe()
    setJob("Take Pickaxe")
    sleep(100)
    collectSet(false, 3)
    sleep(100)
    warp(worldPickaxe,doorPickaxe)
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

function storePickaxe()
    setJob("Store Pickaxe")
    sleep(100)
    warp(worldPickaxe,doorPickaxe)
    sleep(100)
    move(-5,0)
    sleep(100)
    while findItem(98) > 1 do
        sendPacket("action|drop\n|itemID|98",2)
        sleep(500)
        sendPacket("action|dialog_return\ndialog_name|drop_item\nitemID|98|\ncount|"..(findItem(98) - 1),2)
        sleep(500)
    end
    sleep(100)
end

function countFloat(item)
    count = 0
    for _, object in pairs(getObjects()) do
        if object.id == item then
            count = count + object.count
        end
    end
    return count
end

function take(world)
    setJob("Taking Seed")
    sleep(100)
    warp(storageSeed,doorSeed)
    sleep(100)
    while findItem(itmSeed) == 0 do
        for _,obj in pairs(getObjects()) do
            if obj.id == itmSeed then
                findPath(round(obj.x / 32),math.floor(obj.y / 32))
                sleep(100)
                collect(2)
                sleep(100)
                if findItem(itmSeed) > 0 then
                    break
                end
            end
        end
        packInfo(webhookLinkSeed,messageIdSeed,infoPack())
        sleep(100)
    end
    warp(world,doorFarm)
    sleep(100)
end

function harvest(world)
    collectSet(true, 3)
    sleep(100)
    tiley = 0
    tree[world] = 0
    if dontPlant then
        for _,tile in pairs(getTiles()) do
            if getTile(tile.x,tile.y - 1).ready and getBot().world:upper() == world:upper() then
                setJob("Harvest")
                if getBot().level >= removeBotAfterLevel then
                    removeBot(getBot().name)
                end
                if restBot then
                    restBotOS(world,doorFarm,tile.x,tile.y - 1)
                end
                if not blacklistTile or check(tile.x,tile.y) then
                    tree[world] = tree[world] + 1
                    findPath(tile.x,tile.y - 1)
                    if tiley ~= tile.y - 1 and indexBot <= maxBotEvents then
                        tiley = tile.y - 1
                        botEvents("Currently in row "..math.ceil(tiley/2).."/27")
                    end
                    while getTile(tile.x,tile.y - 1).fg == itmSeed and getTile(tile.x,tile.y - 1).ready and math.floor(getBot().x / 32) == tile.x and math.floor(getBot().y / 32) == tile.y - 1 and getBot().world:upper() == world:upper() do
                        punch(0,0)
                        sleep(delayHarvest)
                        reconnect(world,doorFarm,tile.x,tile.y - 1)
                    end
                end
            end
            if findItem(itmId) >= 190 and getBot().world:upper() == world:upper() then
                pnb(world)
                sleep(100)
                if findItem(itmSeed) > 150 then
                    storeSeed(world)
                end
            end
        end
    elseif plantOnly then
        for _,tile in pairs(getTiles()) do
            if findItem(itmSeed) == 0 then
                sleep(100)
                take(world)
                sleep(100)
            end
            if (tile.flags ~= 0 and tile.y ~= 0 and getTile(tile.x,tile.y - 1).fg == 0) and getBot().world:upper() == world:upper() then
                if not blacklistTile or check(tile.x,tile.y) then
                    setJob("Planting")
                    findPath(tile.x,tile.y - 1)
                    while getTile(tile.x,tile.y - 1).fg == 0 and getTile(tile.x,tile.y - 1).fg == 0 and getTile(tile.x,tile.y).flags ~= 0 and math.floor(getBot().x / 32) == tile.x and math.floor(getBot().y / 32) == tile.y - 1 and findItem(itmSeed) > 0 do
                        place(itmSeed,0,0)
                        sleep(delayPlant)
                        reconnect(world,doorFarm,tile.x,tile.y - 1)
                    end
                end
            end
        end
    elseif autoFill then
        for _,tile in pairs(getTiles()) do
            if (getTile(tile.x,tile.y - 1).ready or (tile.flags ~= 0 and tile.y ~= 0 and getTile(tile.x,tile.y - 1).fg == 0))  and getBot().world:upper() == world:upper() then
                setJob("Harvest")
                if getBot().level >= removeBotAfterLevel then
                    removeBot(getBot().name)
                end
                if restBot then
                    restBotOS(world,doorFarm,tile.x,tile.y - 1)
                end
                if findItem(itmSeed) == 0 then
                    sleep(100)
                    take(world)
                    sleep(100)
                end
                if not blacklistTile or check(tile.x,tile.y) then
                    tree[world] = tree[world] + 1
                    findPath(tile.x,tile.y - 1)
                    if tiley ~= tile.y - 1 and indexBot <= maxBotEvents then
                        tiley = tile.y - 1
                        sleep(100)
                        botEvents("Currently in row "..math.ceil(tiley/2).."/27")
                    end
                    while getTile(tile.x,tile.y - 1).fg == itmSeed and getTile(tile.x,tile.y - 1).ready and math.floor(getBot().x / 32) == tile.x and math.floor(getBot().y / 32) == tile.y - 1 and getBot().world:upper() == world:upper() do
                        punch(0,0)
                        sleep(delayHarvest)
                        reconnect(world,doorFarm,tile.x,tile.y - 1)
                    end
                    while findItem(itmSeed) > 0 and getTile(tile.x,tile.y - 1).fg == 0 and getTile(tile.x,tile.y - 1).fg == 0 and getTile(tile.x,tile.y).flags ~= 0 and math.floor(getBot().x / 32) == tile.x and math.floor(getBot().y / 32) == tile.y - 1  and getBot().world:upper() == world:upper() do
                        place(itmSeed,0,0)
                        sleep(delayPlant)
                        reconnect(world,doorFarm,tile.x,tile.y - 1)
                    end
                end
            end
            if findItem(itmId) >= 190 and getBot().world:upper() == world:upper() then
                pnb(world)
                sleep(100)
                if findItem(itmSeed) > 150 then
                    storeSeed(world)
                end
            end
        end
    else
        for _,tile in pairs(getTiles()) do
            if getTile(tile.x,tile.y - 1).ready and getBot().world:upper() == world:upper() then
                setJob("Harvest")
                if getBot().level >= removeBotAfterLevel then
                    removeBot(getBot().name)
                end
                if restBot then
                    restBotOS(world,doorFarm,tile.x,tile.y - 1)
                end
                if not blacklistTile or check(tile.x,tile.y) then
                    tree[world] = tree[world] + 1
                    findPath(tile.x,tile.y - 1)
                    if tiley ~= tile.y - 1 and indexBot <= maxBotEvents then
                        tiley = tile.y - 1
                        sleep(100)
                        botEvents("Currently in row "..math.ceil(tiley/2).."/27")
                    end
                    while getTile(tile.x,tile.y - 1).fg == itmSeed and getTile(tile.x,tile.y - 1).ready and math.floor(getBot().x / 32) == tile.x and math.floor(getBot().y / 32) == tile.y - 1 and getBot().world:upper() == world:upper() do
                        punch(0,0)
                        sleep(delayHarvest)
                        reconnect(world,doorFarm,tile.x,tile.y - 1)
                    end
                    while findItem(itmSeed) > 0 and getTile(tile.x,tile.y - 1).fg == 0 and getTile(tile.x,tile.y - 1).fg == 0 and getTile(tile.x,tile.y).flags ~= 0 and math.floor(getBot().x / 32) == tile.x and math.floor(getBot().y / 32) == tile.y - 1  and getBot().world:upper() == world:upper() do
                        place(itmSeed,0,0)
                        sleep(delayPlant)
                        reconnect(world,doorFarm,tile.x,tile.y - 1)
                    end
                end
            end
            if findItem(itmId) >= 190 and getBot().world:upper() == world:upper() then
                pnb(world)
                sleep(100)
                if findItem(itmSeed) > 150 then
                    storeSeed(world)
                end
            end
        end
    end
    if findItem(112) > minimumGem then
        setJob("Buy Pack")
        sleep(100)
        while getBot().slots < 26 and findItem(112) >= 400 do
            sendPacket("action|buy\nitem|upgrade_backpack",2)
            sleep(500)
        end
        while findItem(112) > packPrice do
            for i = 1, packLimit do
                if findItem(112) > packPrice then
                    sendPacket("action|buy\nitem|"..packName,2)
                    profit = profit + 1
                    sleep(2000)
                else
                    break
                end
            end
        end
        collectSet(false, 3)
        sleep(100)
        storePack()
        sleep(100)
        warp(world,doorFarm)
        sleep(100)
        collectSet(true, 3)
        sleep(100)
    end
end

function clearBlocks()
    setJob("Clearing Blocks")
    for _,tile in pairs(getTiles()) do
        if getTile(tile.x,tile.y).fg == itmId then
            findPath(tile.x,tile.y)
            while getTile(tile.x,tile.y).fg == itmId and math.floor(getBot().x / 32) == tile.x and math.floor(getBot().y / 32) == tile.y do
                punch(0,0)
                sleep(delayHarvest)
                reconnect(world,doorFarm,tile.x,tile.y)
            end
        end
    end
end

function changeGuest()
    CurrentMac = ""
    while getBot().status == "suspended" do
        if getBot().status == "suspended" then
            disconnect()
            sleep(1000)
            local fileName = botBackupList
            local file = io.open(fileName, "r")
            if file then
                local lines = {}
                for line in file:lines() do
                    table.insert(lines, line)
                end
                file:close()
                data = split(lines[1], ':')
                if tablelength(data) == 2 then
                    usernameBot = data[1]
                    passwordBot = data[2]
                end
                table.remove(lines, 1)
                file = io.open(fileName, "w")
                if file then
                    for _, line in ipairs(lines) do
                        file:write(line .. "\n")
                    end
                    file:write(cray)
                    file:close()
                end
            end
            removeBot(getBot().name)
            sleep(100)
            addBot(usernameBot,passwordBot)
            sleep(100)
        end
        while getBot().status ~= "online" do
            connect()
            sleep(8500)
            if getBot().status == "suspended" then
                break
            end
        end 
    end
    if getBot().world:find("TUTORIAL") then
        skipTutorial()
    end
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do 
        count = count + 1 
    end
    return count
end

function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function join()
    setJob("Clearing World Logs")
    sleep(100)
    for _,wurld in pairs(worldToJoin) do
        sendPacket("action|join_request\nname|"..wurld:upper().."\ninvitedWorld|0",3)
        sleep(joinDelay)
    end
end

---========= Created by Jutun Store =========---
if activateScript then
    if indexLast == indexBot then
        infoJutun()
    end
    while getBot().status ~= "online" do
        connect()
        sleep(8500)
        while getBot().status == "suspended" or getBot().status == "banned" or getBot().status == "got captcha" or getBot().status == "temporary ban" do
            sleep(100)
            removeBot(getBot().name)
        end
    end
    if getBot().world:find("TUTORIAL") then
        skipTutorial()
    end
    for i = indexBot, 1, -1 do
        setJob("Starting in "..i.." seconds")
        sleep(1000)
    end
    while getBot().status ~= "online" do
        connect()
        sleep(8500)
        while getBot().status == "suspended" or getBot().status == "banned" or getBot().status == "got captcha" or getBot().status == "temporary ban" do
            sleep(100)
            removeBot(getBot().name)
        end
    end
    if #worldPickaxe == 1 and takePick then
        worldPickaxe = worldPickaxe[1]
    else
        if indexBot % 2 == 0 and takePick then
            worldPickaxe = worldPickaxe[2]
        elseif takePick then
            worldPickaxe = worldPickaxe[1]
        end
    end
    if takePick and findItem(98) == 0 then
        takePickaxe()
    end
    if findItem(98) > 1 then
        storePickaxe()
    end
    sendPacket(2,"action|setSkin\ncolor|3370516479")
    while true do
        nuked = false
        local fileName = worldList
        local file = io.open(fileName, "r")
        if file then
            local lines = {}
            for line in file:lines() do
                table.insert(lines, line)
            end
            file:close()
            cray = lines[1]
            data = split(lines[1], ':')
            if tablelength(data) == 2 then
                world = data[1]
                doorFarm = data[2]
            end
            table.remove(lines, 1)
            file = io.open(fileName, "w")
            if file then
                for _, line in ipairs(lines) do
                    file:write(line .. "\n")
                end
                file:write(cray)
                file:close()
            end
        end
        if #worldListBot == 15 then
            worldListBot = {}
            waktu = {}
            tree = {}
        end
        table.insert(worldListBot,world)
        sleep(100)
        warp(world,doorFarm)
        sleep(100)
        if not nuked then
            tt = os.time()
            sleep(100)
            bl(world)
            sleep(100)
            clearBlocks()
            sleep(100)
            harvest(world)
            sleep(100)
            tt = os.time() - tt
            sleep(100)
            waktu[world] = math.floor(tt/3600).." Hours "..math.floor(tt%3600/60).." Minutes"
            sleep(100)
            botEvents("Farm finished.")
            sleep(100)
            if joinWorldAfterStore and tt > 60 then
                join()
            end
        else
            waktu[world] = "NUKED"
            tree[world] = "NUKED"
            sleep(100)
            nuked = false
            sleep(5000)
            if joinWorldAfterStore then
                join()
            end
        end
        if totalFarm == removeBotAfterRotation then
            removeBot(getBot().name)
        else
            totalFarm = totalFarm + 1
        end
    end
end
