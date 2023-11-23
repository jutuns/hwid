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
    totalFarm = 0
    botLevel = 0
    strWaktu = "NONE"
    worldList = {}
    t = os.time()
    file = io.open(getBot().name..".txt", "w+")
    file:close()
    jmlBot = #getBots()

    for i, botz in pairs(getBots()) do
        if botz.name:upper() == bot.name:upper() then
            indexBot = i - 1
        end
        indexLast = i
    end
end

function log(txt)
    file = io.open(getBot().name..".txt", "a")
    if file then
        file:write(txt.."\n")
        file:close()
    end
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

function botInfo(info)
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
                name = "BOT UPTIME"
                value = "<:arrow:1160743652088365096> ]]..math.floor(te/86400)..[[ Days ]]..math.floor(te%86400/3600)..[[ Hours ]]..math.floor(te%86400%3600/60)..[[ Minutes"
                inline = "false"
            }
        )
        $embedObject = @{
            title = "<:globe:1011929997679796254> **LUCIFER FIND WORLD BY JUTUN STORE**"
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

function checkLock()
    locks = {242,9640,202,204,206,1796,4994,7188,408,2950,4428,4802,5814,5260,5980,8470,10410,11550,11586}
    for _,tile in pairs(bot:getWorld():getTiles()) do
        if includesNumber(locks, tile.fg) then
            return false
        end
    end
    return true
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

function name(count)
    if withNumber then
        local str = ""
        local chars = "abcdefghijklmnopqrstuvwxyz0123456789"
        for i = 1, count do
            local randomIndex = math.random(1, #chars)
            str = str .. chars:sub(randomIndex, randomIndex)
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

function edit(x,y,id)
    bot:wrench(getBot().x + x,getBot().y + y)
    sleep(1000)
    bot:sendPacket(2,"action|dialog_return\ndialog_name|door_edit\ntilex|"..(getBot().x + x).."|\ntiley|"..(getBot().y + y).."|\ndoor_name|\ndoor_target|\ndoor_id|"..id.."\ncheckbox_locked|1")
    sleep(1000)
end

function public(x,y)
    bot:wrench(getBot().x + x,getBot().y + y)
    sleep(1000)
    bot:sendPacket(2,"action|dialog_return\ndialog_name|lock_edit\ntilex|"..(getBot().x + x).."|\ntiley|"..(getBot().y + y).."|\ncheckbox_public|1\ncheckbox_disable_music|0\ntempo|100\ncheckbox_disable_music_render|0\ncheckbox_set_as_home_world|0\nminimum_entry_level|1")
    sleep(1000)
end

function reapply(x,y)
    bot:wrench(getBot().x + x,getBot().y + y)
    sleep(1000)
    bot:sendPacket(2,"action|dialog_return\ndialog_name|lock_edit\ntilex|"..(getBot().x + x).."|\ntiley|"..(getBot().y + y).."|\nbuttonClicked|recalcLock\n\ncheckbox_public|0\ncheckbox_ignore|1")
    sleep(1000)
end

function breakIt(x,y)
    while getTile(getBot().x + x,getBot().y + y).fg ~= 0 or getTile(getBot().x + x,getBot().y + y).bg ~= 0 do
        bot:hit(getBot().x + x,getBot().y + y)
        sleep(160)
    end
end

function placeIt(x,y,id)
    while getTile(getBot().x + x,getBot().y + y).fg ~= id do
        bot:place(getBot().x + x,getBot().y + y,id)
        sleep(160)
    end
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
    bot.auto_collect = false
    sleep(100)
    warpz(storageWorld)
    sleep(100)
    join(storageWorld,doorStorage)
    sleep(100)
    for _,obj in pairs(bot:getWorld():getObjects()) do
        if obj.id == id then
            bot:findPath(round(obj.x/32),math.floor(obj.y/32))
            sleep(1000)
            bot:collect(2,200)
            sleep(1000)
            break
        end
    end
    if bot:getInventory():findItem(id) > 0 then
        bot:moveTo(-1,0)
        sleep(100)
        bot:setDirection(false)
    end
    if bot:getInventory():findItem(202) > farmCount then
        bot:sendPacket(2,"action|drop\n|itemID|202")
        bot:sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|202|\ncount|"..(bot:getInventory():findItem(202) - farmCount))
        sleep(500)
    end
    if bot:getInventory():findItem(242) > farmCount then
        bot:sendPacket(2,"action|drop\n|itemID|202")
        bot:sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|242|\ncount|"..(bot:getInventory():findItem(242) - farmCount))
        sleep(500)
    end
    if bot:getInventory():findItem(226) > farmCount then
        bot:sendPacket(2,"action|drop\n|itemID|226")
        bot:sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|226|\ncount|"..(bot:getInventory():findItem(226) - farmCount))
        sleep(500)
    end
    if bot:getInventory():findItem(doorId) > farmCount then
        bot:sendPacket(2,"action|drop\n|itemID|"..doorId)
        bot:sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|"..doorId.."|\ncount|"..(bot:getInventory():findItem(doorId) - farmCount))
        sleep(500)
    end
    if bot:getInventory():findItem(entrance) > farmCount * 2 then
        bot:sendPacket(2,"action|drop\n|itemID|"..entrance)
        bot:sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|"..entrance.."|\ncount|"..(bot:getInventory():findItem(entrance) - (farmCount * 2)))
        sleep(500)
    end
end

function countTile()
    countFg = 0
    countBg = 0
    for _,tile in pairs(bot:getWorld():getTiles()) do
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

function checkWorld()
    repeat
        world = name(letterCount)
        print("Going world "..world)
        warpz(world)
        sleep(100)
    until checkLock() and countTile()
    if useSignalJammer then
        placeIt(-1,-1,226)
        sleep(100)
        bot:hit(getBot().x - 1,getBot().y - 1)
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
    while getTile(getBot().x,getBot().y).fg == 6 do
        edit(1,-1,doorFarm)
        sleep(100)
        join(world,doorFarm)
        sleep(1000)
    end
    sleep(1000)
    bot:moveTo(-1,-1)
    sleep(1000)
    if mode == "BOTH" then
        bot:moveTo(-2,3)
        sleep(1000)
        breakIt(1,0)
        sleep(100)
        bot:collect(2,200)
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
    log('"'..world..'",')
    sleep(100)
end

function takeSupply()
    if mode == "SL" or mode == "BOTH" then  
        while bot:getInventory():findItem(202) == 0 do
            take(202)
            sleep(100)
        end
    end
    if mode == "WL" or mode == "BOTH" then  
        while bot:getInventory():findItem(242) == 0 do
            take(242)
            sleep(100)
        end
    end
    while bot:getInventory():findItem(entrance) < 2 do
        take(entrance)
        sleep(100)
    end
    while bot:getInventory():findItem(doorId) == 0 do
        take(doorId)
        sleep(100)
    end
    while bot:getInventory():findItem(226) == 0 and useSignalJammer do
        take(226)
        sleep(100)
    end
    while bot:getInventory():findItem(2) == 0 and not useSignalJammer do
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
        takeSupply()
        sleep(100)
        checkWorld()
    end
    botInfo("Finished, Removing Bot.")
    removeBot()
end
