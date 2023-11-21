--===================================================--
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
hwid = get_hwid()

client = HttpClient.new()
client.url = "https://raw.githubusercontent.com/jutuns/hwid/main/lucifer-df/"..hwid
local response = client:request().body

if response:find("404") then
    print("HWID NOT REGISTERED, CONTACT : JUTUN STORE")
    print(hwid)
else
    activateScript = true
end

if activateScript then
    bot = getBot()
    bot.legit_mode = false
    bot.collect_interval = 50
    t = os.time()
    waktu = {}
    botLevel = 0
    totalFarm = 0
    jmlBot = #getBots()
    for i, botz in pairs(getBots()) do
        if botz.name:upper() == bot.name:upper() then
            indexBot = i - 1
        end
    end
    if jmlBot % 2 == 0 then
        jmlBot = jmlBot + 1
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

function botInfo(info)
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
                value = "<:arrow:1160743652088365096> ]]..bot.name..[["
                inline = "true"
            }
            @{
                name = "Bot Status"
                value = "<:arrow:1160743652088365096> ]]..bot.status..[["
                inline = "true"
            }
            @{
                name = "Bot Level"
                value = "<:arrow:1160743652088365096> ]]..bot.level..[["
                inline = "true"
            }
            @{
                name = "Bot Gems"
                value = "<:arrow:1160743652088365096> ]]..bot.gem_count..[["
                inline = "true"
            }
            @{
                name = "World Name"
                value = "<:arrow:1160743652088365096> ]]..bot:getWorld().name..[["
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
            title = "<:globe:1011929997679796254> **LUCIFER DIRT FARM BY JUTUN STORE**"
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

function warpz(worldName)
    while not bot:isInWorld(worldName:upper()) do
        bot:sendPacket(3,"action|join_request\nname|"..worldName:upper().."\ninvitedWorld|0")
        sleep(5000)
    end
end

function join(worldName,id)
    while getTile(bot.x,bot.y).fg == 6 do 
        bot:sendPacket(3,"action|join_request\nname|"..worldName:upper().."|"..id:upper().."\ninvitedWorld|0")
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
    if bot.status ~= BotStatus.online then
        while bot.status ~= BotStatus.online do
            bot:connect()
            sleep(8000)
            if bot.status == BotStatus.account_banned then
                bot.auto_reconnect = false
                stopScript()
            end
        end
        while not bot:isInWorld(world:upper()) do
            bot:warp(world)
            sleep(5000)
        end
        if id then
            while getTile(getBot().x,getBot().y).fg == 6 do
                bot:warp(world,id)
                sleep(5000)
            end
        end
        if x and y then
            bot:findPath(x,y)
            sleep(100)
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
    for _,item in pairs(bot:getInventory():getItems()) do
        if not includesNumber(goods, item.id) then
            if findItem(item.id) >= 50 then
                bot:sendPacket(2,"action|trash\n|itemID|"..item.id)
                bot:sendPacket(2,"action|dialog_return\ndialog_name|trash_item\nitemID|"..item.id.."|\ncount|"..item.count) 
                sleep(500)
            end
        end
    end
    for i = 2,3 do
        if bot:getInventory():findItem(i) >= 190 then
            bot:sendPacket(2, "action|trash\n|itemID|"..i)
            bot:sendPacket(2, "action|dialog_return\ndialog_name|trash_item\nitemID|"..i.."|\ncount|10") 
            sleep(100)
        end
    end
end

function clear2()
    for _,item in pairs(bot:getInventory():getItems()) do
        if not includesNumber(goods, item.id) then
            bot:sendPacket(2,"action|trash\n|itemID|"..item.id)
            bot:sendPacket(2,"action|dialog_return\ndialog_name|trash_item\nitemID|"..item.id.."|\ncount|"..item.count) 
            sleep(1000)
        end
    end
end

function take(id)
    bot.auto_collect = false
    sleep(100)
    if id == platformId then
        warpz(storagePlat)
        sleep(100)
        join(storagePlat,doorPlat)
        sleep(100)
    end
    clear2()
    sleep(100)
    for _,obj in pairs(bot:getWorld():getObjects()) do
        if obj.id == id then
            bot:findPath(round(obj.x/32),math.floor(obj.y/32))
            sleep(1000)
            bot:collect(2,100)
            sleep(1000)
            break
        end
    end
end

function takePickaxe()
    bot.auto_collect = false
    sleep(100)
    warpz(WorldPickAxe)
    sleep(100)
    join(WorldPickAxe,DoorPickAxe)
    sleep(100)
    while bot:getInventory():findItem(98) == 0 do
        for _,obj in pairs(bot:getWorld():getObjects()) do
            if obj.id == 98 then
                bot:findPath(round(obj.x / 32),math.floor(obj.y / 32))
                sleep(100)
                bot:collect(3,200)
                sleep(100)
            end
            if bot:getInventory():findItem(98) > 0 then
                break
            end
        end
        sleep(500)
    end
    bot:moveTo(-1,0)
    sleep(100)
    while bot:getInventory():findItem(98) > 1 do
        bot:setDirection(false)
        bot:sendPacket(2,"action|drop\n|itemID|98")
        sleep(500)
        bot:sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|98|\ncount|"..(bot:getInventory():findItem(98) - 1))
        sleep(500)
    end
    bot:wear(98)
    sleep(100)
end

function dirtFarm(world)
    warpz(world)
    sleep(100)
    join(world,doorFarm)
    sleep(100)
    breakDirt(world)
    sleep(100)
    placeDirt(world)
    sleep(100)
    if bot:getInventory():findItem(3) > 0 then
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

--=======================================================---=======================================================-
--=======================================================---=======================================================-
--=======================================================---=======================================================-
--=======================================================---=======================================================-

function breakDirt(world)
    bot.auto_collect = true
    bot.collect_range = 2
    --Break Kiri
    for _,tile in pairs(bot:getWorld():getTiles()) do
        if tile.x == 0 and tile.y <= 53 and getTile(tile.x,tile.y).bg ~= 0 then
            bot:findPath(tile.x,tile.y - 1)
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
    for _,tile in pairs(bot:getWorld():getTiles()) do
        if tile.x == 99 and tile.y <= 53 and getTile(tile.x,tile.y).bg ~= 0 then
            bot:findPath(tile.x,tile.y - 1)
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
        if not multipleBot or indexBot == 0 then
            for _,tile in pairs(bot:getWorld():getTiles()) do
                while findItem(platformId) == 0 do
                    take(platformId)
                    sleep(100)
                    warpz(world)
                    sleep(100)
                    join(world,doorFarm)
                    sleep(100)
                    bot.auto_collect = true
                    bot.collect_range = 2
                    sleep(100)
                end
                if tile.y % 2 == 0 and getTile(tile.x,tile.y).fg == 0 and tile.x == 1 and tile.y <= 53 and tile.y > 0 then
                    bot:findPath(tile.x,tile.y - 1)
                    while getTile(tile.x,tile.y).fg == 0 do
                        place(platformId,0,1)
                        sleep(110)
                        reconnect(world,doorFarm,tile.x,tile.y - 1)
                    end
                end
            end
            for _,tile in pairs(bot:getWorld():getTiles()) do
                while findItem(platformId) == 0 do
                    take(platformId)
                    sleep(100)
                    warpz(world)
                    sleep(100)
                    join(world,doorFarm)
                    sleep(100)
                    bot.auto_collect = true
                    bot.collect_range = 2
                    sleep(100)
                end
                if tile.y % 2 == 0 and getTile(tile.x,tile.y).fg == 0 and tile.x == 98 and tile.y <= 53 and tile.y > 0 then
                    bot:findPath(tile.x,tile.y - 1)
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
    for _,tile in pairs(bot:getWorld():getTiles()) do
        if (not multipleBot or ((tile.y + 1) % (jmlBot)) == indexBot) and tile.y % 2 == 1 and tile.y <= 53 and getTile(tile.x,tile.y).bg ~= 0 then
            bot:findPath(tile.x - 1,tile.y)
            while getTile(tile.x,tile.y).bg ~= 0 do
                punch(1,0)
                sleep(160)
                reconnect(world,doorFarm,tile.x - 1,tile.y)
            end
        end
        clear()
    end
    for _,tile in pairs(bot:getWorld():getTiles()) do
        if tile.y % 2 == 1 and tile.y <= 53 and getTile(tile.x,tile.y).bg ~= 0 then
            bot:findPath(tile.x - 1,tile.y)
            while getTile(tile.x,tile.y).bg ~= 0 do
                punch(1,0)
                sleep(160)
                reconnect(world,doorFarm,tile.x - 1,tile.y)
            end
        end
        clear()
    end
    for _,tile in pairs(bot:getWorld():getTiles()) do
        if getTile(tile.x,tile.y).fg == 4 then
            bot:findPath(tile.x,tile.y - 1)
            while getTile(tile.x,tile.y).fg == 4 do
                punch(0,1)
                sleep(160)
                reconnect(world,doorFarm,tile.x,tile.y - 1)
            end
        end
    end
end

function farmDirt(world)
    for _,tile in pairs(bot:getWorld():getTiles()) do
        if tile.x >= 3 and tile.x <= 23 and ((tile.y == 25 and not multipleBot) or tile.y == (25 + 2 * indexBot)) then
            if getTile(tile.x, tile.y):canHarvest() or (getTile(tile.x, tile.y).fg == 0 and findItem(3) > 0) then
                bot:findPath(tile.x,tile.y)
                while getTile(tile.x,tile.y):canHarvest() do
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

function checkFloat(ids)
    local countids = 0
    for _, obj in pairs(bot:getWorld():getObjects()) do
        if obj.id == ids then
            countids = countids + obj.count
        end
    end
    return countids
end

function takeSeed(world)
    bot.auto_collect = false
    sleep(100)
    warpz(storageSeed)
    sleep(100)
    join(storageSeed,doorSeed)
    sleep(100)
    while findItem(itmSeed) == 0 do
        if checkFloat(itmSeed) < 1 then
            if not multipleBot or indexBot == 0 then
                botInfo("Seed not found")
            end
            removeBot(getBot().name)
        end
        for _,obj in pairs(bot:getWorld():getObjects()) do
            if obj.id == itmSeed then
                bot:findPath(round(obj.x / 32),math.floor(obj.y / 32))
                sleep(1000)
                bot:collect(2,100)
                sleep(1000)
            end
            if findItem(itmSeed) > 0 then
                break
            end
        end
    end
    warpz(world)
    sleep(100)
    join(world,doorFarm)
    sleep(100)
    bot.auto_collect = true
    bot.collect_range = 2
    sleep(100)
end

function plant(world)
    for _,tile in pairs(bot:getWorld():getTiles()) do
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
    for _,tile in pairs(bot:getWorld():getTiles()) do
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
    for _,tile in pairs(bot:getWorld():getTiles()) do
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
    for _,tile in pairs(bot:getWorld():getTiles()) do
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
    if bot:getInventory():findItem(3) > 0 then
        for _,tile in pairs(bot:getWorld():getTiles()) do
            while bot:getInventory():findItem(2) == 0 and tile.y % 2 == 0 and getTile(tile.x,tile.y).fg == 0 and tile.x > 0 and tile.x < 99 and tile.y <= 53 and tile.y > 0 do
                farmDirt(world)
                sleep(1000)
            end
            if (not multipleBot or ((tile.y + 1) % (jmlBot)) == indexBot) and tile.y % 2 == 0 and getTile(tile.x,tile.y).fg == 0 and tile.x > 0 and tile.x < 99 and tile.y <= 53 and tile.y > 0 then
                bot:findPath(tile.x,tile.y - 1)
                while getTile(tile.x,tile.y).fg == 0 do
                    place(2,0,1)
                    sleep(110)
                    reconnect(world,doorFarm,tile.x,tile.y - 1)
                end
            end
        end
        for _,tile in pairs(bot:getWorld():getTiles()) do
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

if activateScript then
    if takePick and findItem(98) == 0 then
        takePickaxe()
        sleep(100)
        warpz("EXIT")
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
