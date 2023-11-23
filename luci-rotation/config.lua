------------------ Dont Touch ------------------
activateScript = false

function HWID()
    local command = "C:\\Windows\\System32\\wbem\\wmic.exe csproduct get uuid"
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()

    local HWID = result:match("(%w+-%w+-%w+-%w+-%w+)")
    return HWID
end
hwid = HWID()

client = HttpClient.new()
client.url = "https://raw.githubusercontent.com/jutuns/hwid/main/luci-rotation/"..hwid
local response = client:request().body

if response:find("404") then
    print("HWID NOT REGISTERED, CONTACT : JUTUN STORE")
    print(hwid)
else
    activateScript = true
end

if activateScript then
    for i, botz in pairs(getBots()) do
        if botz.name:upper() == bot.name:upper() then
            indexBot = i
        end
        indexLast = i
    end
    bot.auto_reconnect = false
    bot.collect_range = 3
    
    minimumGem = packPrice * buyPackCount
    world = ""
    doorFarm = ""
    worldBreak = ""
    doorBreak = ""
    cray = ""
    crays = ""
    jumlahChat = #listChat
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
    fired = false
    nuked = false
    
    dividerSSeed = math.ceil(indexLast / #storageSeedList)
    choosenSSeed = math.ceil(indexBot / dividerSSeed)
    storageSeed = storageSeedList[choosenSSeed]
    
    dividerSPack = math.ceil(indexLast / #storagePackList)
    choosenSPack = math.ceil(indexBot / dividerSPack)
    storagePack = storagePackList[choosenSPack]
    
    for i = math.floor(tileNumber/2),1,-1 do
        i = i * -1
        table.insert(tileBreak,i)
    end
    
    for i = 0, math.ceil(tileNumber/2) - 1 do
        table.insert(tileBreak,i)
    end    
end

function punch(x,y)
    return bot:hit(bot.x+x,bot.y+y)
end

function findItem(id)
    return bot:getInventory():findItem(id)
end

function place(id,x,y)
    return bot:place(bot.x+x,bot.y+y,id)
end

function findPath(x,y)
    return bot:findPath(x,y)
end

function sendPacket(x,y)
    return bot:sendPacket(y,x)
end

function waktuWorld()
    strWaktu = ""
    if censoredWebhookFarm then
        for _,worldzz in pairs(worldListBot) do
            strWaktu = strWaktu.."\n<:arrow:1160743652088365096> ||"..worldzz:upper().."|| ( "..(waktu[worldzz] or "?").." | "..(tree[worldzz] or "?").." )"
        end
    else
        for _,worldzz in pairs(worldListBot) do
            strWaktu = strWaktu.."\n<:arrow:1160743652088365096> "..worldzz:upper().." ( "..(waktu[worldzz] or "?").." | "..(tree[worldzz] or "?").." )"
        end
    end
    return strWaktu
end

function round(n)
    return n % 1 > 0.5 and math.ceil(n) or math.floor(n)
end

function tileDrop1(x,y,num)
    local count = 0
    local stack = 0
    for _,obj in pairs(bot:getWorld():getObjects()) do
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

function autoTutorial()
    bot.auto_tutorial = true
    while bot:getWorld().name == "EXIT" or bot:getWorld().name:find("TUTORIAL") do
        sleep(5000)
    end
    bot.auto_tutorial = false
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

function botEvents(info)
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
            value = "<:arrow:1160743652088365096> Status : ]]..bot.status..[[ (]]..bot:getPing()..[[)]].."\n"..[[<:arrow:1160743652088365096> Name : ]]..bot.name..[[ (No.]]..indexBot..[[)]].."\n"..[[<:arrow:1160743652088365096> Level : ]]..bot.level.."\n"..[["
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

--================================================================================================--
--================================================================================================--
--================================================================================================--
--================================================================================================--
--================================================================================================--
--================================================================================================--

function buyClothes()
    currentClothes = {}
    for _,inventory in pairs(bot:getInventory():getItems()) do
        if getInfo(inventory.id).clothing_type ~= 0 then
            table.insert(currentClothes,inventory.id)
        end
    end
    sleep(100)
    jumlahClothes = #currentClothes
    if jumlahClothes < 5 then
        sendPacket("action|buy\nitem|clothes",2)
        sleep(100)
        sendPacket("action|buy\nitem|rare_clothes",2)
        sleep(100)
        for _,num in pairs(bot:getInventory():getItems()) do
            if getInfo(num.id).clothing_type ~= 0 then
                if num.id ~= 3934 and num.id ~= 3932 then
                    bot:wear(num.id)
                    sleep(1000)
                end
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
    for _,tile in pairs(bot:getWorld():getTiles()) do
        if tile.fg == 6 then
            doorX = tile.x
            doorY = tile.y
        end
    end
    if blacklistTile and bot:getWorld().name == world:upper() then
        for _,tile in pairs(blacklist) do
            table.insert(blist,{x = doorX + tile.x, y = doorY + tile.y})
        end
    end
end

function OnVariantList(variant, netid)
    if variant:get(0):getString() == "OnConsoleMessage" then
        if variant:get(1):getString():lower():find("inaccessible") or variant:get(1):getString():lower():find("level ") then
            nuked = true
        end
    end
end

function warp(world,id)
    cok = 0
    addEvent(Event.variantlist, OnVariantList)
    print("Warp to "..world)
    while not bot:isInWorld(world:upper()) and not nuked do
        while bot.status ~= BotStatus.online do
            bot:connect()
            sleep(8000)
            if bot.status == BotStatus.account_banned then
                bot.auto_reconnect = false
                stopScript()
            end
        end
        sendPacket("action|join_request\nname|"..world:upper().."|"..id:upper().."\ninvitedWorld|0",3)
        listenEvents(5)
        sleep(6000)
        if cok == 20 then
            sendPacket("action|join_request\nname|EXIT\ninvitedWorld|0",3)
            sleep(2000)
            botInfo(webhookOffline,bot.name.." ("..indexBot..")".." cannot join world ||"..world:upper().."||")
            sleep(100)
            botInfo(webhookOffline,bot.name.." ("..indexBot..")".." bot disconnect 5 minutes while server growtopia sucks @everyone")
            sleep(100)
            disconnect()
            sleep(5 * 60 * 1000)
            cok = 0
        else
            cok = cok + 1
        end
    end
    if id ~= "" and not nuked then
        print("Joining door")
        if getTile(bot.x,bot.y).fg == 6 and not nuked then
            while bot.status ~= BotStatus.online do
                bot:connect()
                sleep(8000)
                if bot.status == BotStatus.account_banned then
                    bot.auto_reconnect = false
                    stopScript()
                end
            end
            sendPacket("action|join_request\nname|"..world:upper().."|"..id:upper().."\ninvitedWorld|0",3)
            sleep(2000)
            if getTile(bot.x,bot.y).fg == 6 and not nuked then
                botInfo(webhookOffline,bot.name.." ("..indexBot..")".." cannot join door, world is "..world:upper().." @everyone")
                sleep(100)
                nuked = true
            end
        end
    end
    if nuked then
        nukeWorldInfo(webhookNuked,bot.name:upper() .. " world "..world.." is nuked. @everyone")
    end
    sleep(100)
    removeEvent(Event.variantlist)
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
                value = "]]..bot:getWorld().name..[["
                inline = "false"
            }
            @{
                name = "<:cid:1133695201156800582> Last Visit"
                value = "]]..bot.name.." (No."..indexBot..")"..[["
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
    if bot.status ~= BotStatus.online then
        botInfo(webhookOffline,":red_circle: "..bot.name.." ("..indexBot..")".." bot status is "..bot.status.." @everyone")
        while bot:isResting() do
            while disconnectBotWhileRest and bot.status == BotStatus.online do
                bot:disconnect()
                bot.auto_reconnect = false
            end
            sleep(2000)
        end
        while bot.status ~= BotStatus.online do
            bot:connect()
            sleep(8000)
            if bot.status == BotStatus.account_banned then
                botInfo(webhookOffline,":red_circle: "..bot.name.." ("..indexBot..") bot status is "..bot.status)
                bot.auto_reconnect = false
                stopScript()
            end
        end
        while not bot:isInWorld(world:upper()) or getTile(getBot().x,getBot().y).fg == 6 do
            bot:warp(world,id)
            sleep(delayWarp)
        end
        if x and y then
            bot:findPath(x,y)
            sleep(100)
        end
        botInfo(webhookOffline,":green_circle: "..bot.name.." ("..indexBot..")".." bot status is "..bot.status)
    end
end

function storePack()
    warp(storagePack,doorPack)
    sleep(100)
    if bot:getWorld().name == storagePack:upper() then
        for _,pack in pairs(packList) do
            for _,tile in pairs(bot:getWorld():getTiles()) do
                if tile.fg == patokanPack or tile.bg == patokanPack then
                    if tileDrop1(tile.x,tile.y,findItem(pack)) then
                        findPath(tile.x - 1,tile.y)
                        sleep(1000)
                        reconnect(storagePack,doorPack,tile.x - 1,tile.y)
                        if findItem(pack) > 0 and tileDrop1(tile.x,tile.y,findItem(pack)) then
                            sendPacket("action|drop\n|itemID|"..pack,2)
                            sleep(500)
                            sendPacket("action|dialog_return\ndialog_name|drop_item\nitemID|"..pack.."|\ncount|"..findItem(pack),2)
                            sleep(500)
                            reconnect(storagePack,doorPack,tile.x - 1,tile.y)
                        end
                    end
                end
                if findItem(pack) == 0 then
                    break
                end
            end
        end
    end
    sleep(100)
    packInfo(webhookLinkPack,messageIdPack,infoPack())
    sleep(100)
    if autoRemoveBotAfterStorePack then
        warp("EXIT")
        sleep(5000)
        botEvents("Bot removed after store pack.")
        removeBot(bot.name)
        bot:stopScript()
    end
end

function infoPack()
    local str = ""
    growscan = getBot():getWorld().growscan
    for id, count in pairs(growscan:getObjects()) do
        str = str.."\n"..getInfo(id).name..": x"..count
    end
    return str
end

function storeSeed(world)
    bot.auto_collect = false
    sleep(100)
    warp(storageSeed,doorSeed)
    sleep(100)
    ba = findItem(itmSeed)
    for _,tile in pairs(bot:getWorld():getTiles()) do
        if tile.fg == patokanSeed or tile.bg == patokanSeed then
            findPath(tile.x - 1,tile.y)
            sleep(100)
            if findItem(itmSeed) > 100 then
                sendPacket("action|drop\n|itemID|"..itmSeed,2)
                sleep(500)
                sendPacket("action|dialog_return\ndialog_name|drop_item\nitemID|"..itmSeed.."|\ncount|100",2)
                sleep(100)
                reconnect(storageSeed,doorSeed,tile.x - 1,tile.y)
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
    bot.auto_collect = true
end

function clear()
    for _,item in pairs(trashList) do
        if findItem(item) > 0 then
            sendPacket("action|trash\n|itemID|"..item,2)
            sleep(400)
            sendPacket("action|dialog_return\ndialog_name|trash_item\nitemID|"..item.."|\ncount|"..findItem(item),2) 
            sleep(400)
            reconnect(world,doorFarm,ex,ye)
        end
    end
end

function pnb(world)
    if differentWorldPNB then
        print("PNB")
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
        if not nuked then
            if randomChat then
                chatBot = listChat[math.random(1,jumlahChat)]
                bot:say(chatBot)
                sleep(1000)
            end
            if findItem(itmId) >= tileNumber and bot:getWorld().name == worldBreak:upper() then
                ex = bot.x
                ye = bot.y
                if findItem(98) > 0 then
                    bot:wear(98)
                end
                if findItem(98) > 0 then
                    bot:wear(98)
                end
                while findItem(itmId) > tileNumber and findItem(itmSeed) <= 190 and bot.x == ex and bot.y == ye do
                    if bot.level >= removeBotAfterLevel then
                        botEvents("Bot removed reach level "..bot.level)
                        removeBot()
                        bot:stopScript()
                    end
                    while tilePlace(ex,ye) do
                        for _,i in pairs(tileBreak) do
                            if getTile(ex - 1,ye + i).fg == 0 and getTile(ex - 1,ye + i).bg == 0 then
                                place(itmId,-1,i)
                                sleep(delayPlace)
                                reconnect(worldBreak,doorBreak,ex,ye)
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
        end
    else
        print("PNB")
        if randomChat then
            chatBot = listChat[math.random(1,jumlahChat)]
            bot:say(chatBot)
            sleep(1000)
        end
        if findItem(itmId) >= tileNumber and bot:getWorld().name == world:upper() then
            if not customTile then
                ex = 1
                ye = bot.y
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
            if findItem(98) > 0 then
                bot:wear(98)
            end
            while findItem(itmId) > tileNumber and findItem(itmSeed) <= 190 and bot.x == ex and bot.y == ye do
                if bot.level >= removeBotAfterLevel then
                    botEvents("Bot removed reach level "..bot.level)
                    removeBot(bot.name)
                    bot:stopScript()
                end
                while tilePlace(ex,ye) do
                    for _,i in pairs(tileBreak) do
                        if getTile(ex - 1,ye + i).fg == 0 and getTile(ex - 1,ye + i).bg == 0 then
                            place(itmId,-1,i)
                            sleep(delayPlace)
                            reconnect(world,doorFarm,ex,ye)
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
        if bot.gem_count >= 1000 then
            while bot:getInventory().slotcount < 36 do
                sendPacket("action|buy\nitem|upgrade_backpack",2)
                sleep(500)
            end
            buyClothes()
        end
    end
    if buyAfterPNB and bot.gem_count > minimumGem then
        while bot:getInventory().slotcount < 36 do
            sendPacket("action|buy\nitem|upgrade_backpack",2)
            sleep(500)
        end
        while bot.gem_count > packPrice do
            for i = 1, buyPackCount do
                if bot.gem_count > packPrice then
                    sendPacket("action|buy\nitem|"..packName,2)
                    profit = profit + 1
                    sleep(2000)
                else
                    break
                end
            end
        end
        bot.auto_collect = false
        sleep(100)
        storePack()
        sleep(100)
        warp(world,doorFarm)
        sleep(100)
        bot.auto_collect = true
        sleep(100)
    end
end

function isPlantable(tile)
    local tempTile = getTile(tile.x, tile.y + 1) -- get tile below
    if not tempTile.fg then 
        return false 
    end
    local collision = getInfo(tempTile.fg).collision_type
    return tempTile and ( collision == 1 or collision == 2 )-- 1 = solid, 2 = platforms
end

function plant(world)
    print("Planting")
    for _,tile in pairs(bot:getWorld():getTiles()) do
        if getTile(tile.x,tile.y - 1).fg == 0 and isPlantable(getTile(tile.x,tile.y - 1)) and findItem(itmSeed) > 0 and bot:getWorld().name == world:upper() then
            findPath(tile.x,tile.y - 1)
            while getTile(tile.x,tile.y - 1).fg == 0 do
                place(itmSeed,0,0)
                sleep(110)
                reconnect(world,doorFarm,tile.x,tile.y - 1)
            end
        end
    end
end

function takePickaxe()
    bot.auto_collect = false
    sleep(100)
    warp(worldPickaxe,doorPickaxe)
    sleep(100)
    while findItem(98) == 0 do
        for _,obj in pairs(bot:getWorld():getObjects()) do
            if obj.id == 98 then
                findPath(round(obj.x / 32),math.floor(obj.y / 32))
                sleep(100)
                bot:collect(3,200)
                sleep(100)
            end
            if findItem(98) > 0 then
                break
            end
        end
        sleep(500)
    end
    bot:moveTo(-1,0)
    sleep(100)
    bot:setDirection(false)
    sleep(100)
    while findItem(98) > 1 do
        sendPacket("action|drop\n|itemID|98",2)
        sleep(500)
        sendPacket("action|dialog_return\ndialog_name|drop_item\nitemID|98|\ncount|"..(findItem(98) - 1),2)
        sleep(500)
    end
    bot:wear(98)
    sleep(100)
end

function take(world)
    warp(storageSeed,doorSeed)
    sleep(100)
    while findItem(itmSeed) == 0 do
        for _,obj in pairs(bot:getWorld():getObjects()) do
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
    bot.auto_collect = true
    sleep(100)
    tiley = 0
    tree[world] = 0
    if dontPlant then
        for _,tile in pairs(bot:getWorld():getTiles()) do
            if tile:canHarvest() and bot:isInWorld(world:upper()) then
                if bot.level >= removeBotAfterLevel then
                    removeBot(bot.name)
                    bot:stopScript()
                end
                if not blacklistTile or check(tile.x,tile.y) then
                    tree[world] = tree[world] + 1
                    print("Harvesting"..tile.x..","..tile.y)
                    findPath(tile.x,tile.y)
                    if tiley ~= tile.y and indexBot <= maxBotEvents then
                        tiley = tile.y
                        sleep(100)
                        botEvents("Currently in row "..math.ceil(tiley/2).."/27")
                    end
                    while getTile(tile.x,tile.y).fg == itmSeed and getTile(tile.x,tile.y):canHarvest() and bot.x == tile.x and bot.y == tile.y and bot:getWorld().name == world:upper() do
                        punch(0,0)
                        sleep(delayHarvest)
                        reconnect(world,doorFarm,tile.x,tile.y - 1)
                    end
                end
            end
            if findItem(itmId) >= 190 and bot:getWorld().name == world:upper() then
                pnb(world)
                sleep(100)
                if findItem(itmSeed) > 150 then
                    storeSeed(world)
                end
            end
        end
    else
        for _,tile in pairs(bot:getWorld():getTiles()) do
            if tile:canHarvest() and bot:isInWorld(world:upper()) then
                if bot.level >= removeBotAfterLevel then
                    removeBot(bot.name)
                    bot:stopScript()
                end
                if not blacklistTile or check(tile.x,tile.y) then
                    tree[world] = tree[world] + 1
                    print("Harvesting"..tile.x..","..tile.y)
                    findPath(tile.x,tile.y)
                    if tiley ~= tile.y and indexBot <= maxBotEvents then
                        tiley = tile.y
                        sleep(100)
                        botEvents("Currently in row "..math.ceil(tiley/2).."/27")
                    end
                    while getTile(tile.x,tile.y).fg == itmSeed and getTile(tile.x,tile.y):canHarvest() and bot.x == tile.x and bot.y == tile.y and bot:getWorld().name == world:upper() do
                        punch(0,0)
                        sleep(delayHarvest)
                        reconnect(world,doorFarm,tile.x,tile.y - 1)
                    end
                    while findItem(itmSeed) > 0 and getTile(tile.x,tile.y).fg == 0 and bot.x == tile.x and bot.y == tile.y and bot:getWorld().name == world:upper() do
                        place(itmSeed,0,0)
                        sleep(delayPlant)
                        reconnect(world,doorFarm,tile.x,tile.y - 1)
                    end
                end
            end
            if findItem(itmId) >= 190 and bot:getWorld().name == world:upper() then
                pnb(world)
                sleep(100)
                if findItem(itmSeed) > 150 then
                    storeSeed(world)
                end
            end
        end
    end
    if bot.gem_count > minimumGem then
        while bot:getInventory().slotcount < 26 and bot.gem_count >= 400 do
            sendPacket("action|buy\nitem|upgrade_backpack",2)
            sleep(500)
        end
        while bot.gem_count > packPrice do
            for i = 1, buyPackCount do
                if bot.gem_count > packPrice then
                    sendPacket("action|buy\nitem|"..packName,2)
                    profit = profit + 1
                    sleep(2000)
                else
                    break
                end
            end
        end
        bot.auto_collect = false
        sleep(100)
        storePack()
        sleep(100)
        warp(world,doorFarm)
        sleep(100)
        bot.auto_collect = true
        sleep(100)
    end
end

function clearBlocks()
    print("Clearing Blocks")
    for _,tile in pairs(bot:getWorld():getTiles()) do
        if getTile(tile.x,tile.y).fg == itmId then
            findPath(tile.x,tile.y)
            while getTile(tile.x,tile.y).fg == itmId and bot.x == tile.x and bot.y == tile.y do
                punch(0,0)
                sleep(delayHarvest)
                reconnect(world,doorFarm,tile.x,tile.y)
            end
        end
    end
end

function join()
    for _,wurld in pairs(worldToJoin) do
        sendPacket("action|join_request\nname|"..wurld:upper().."\ninvitedWorld|0",3)
        sleep(joinDelay)
    end
end

function checkFire()
    for _,tile in pairs(bot:getWorld():getTiles()) do
        if tile:hasFlag(4096) then
            fired = true
            break
        end
    end
end

--======================== SCRIPT RUNNING ========================--

if activateScript then
    while bot.status ~= BotStatus.online do
        bot:connect()
        sleep(8000)
        if bot.status == BotStatus.account_banned then
            bot.auto_reconnect = false
            stopScript()
        end
    end
    
    if bot:getInventory():findItem(9640) == 0 then
        autoTutorial()
    end
    
    for i = indexBot, 1, -1 do
        sleep(500)
    end
    
    while bot.status ~= BotStatus.online do
        bot:connect()
        sleep(8000)
        if bot.status == BotStatus.account_banned then
            bot.auto_reconnect = false
            stopScript()
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
    
    if changeColorSkin then
        bot:setSkin(6)
    end
    
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
        totalFarm = totalFarm + 1
        if not nuked then
            checkFire()
            if not fired then
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
                nukeWorldInfo(webhookNuked,bot.name .. " world "..world.." is fired. @everyone")
            end
        else
            waktu[world] = "NUKED"
            tree[world] = "NUKED"
            sleep(100)
            nuked = false
            fired = false
            sleep(5000)
            if joinWorldAfterStore then
                join()
            end
        end
        if totalFarm >= removeBotAfterRotation then
            removeBot()
            bot:stopScript()
        end
    end
end
