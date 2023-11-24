--================= DONT EDIT BELOW =================--
--============ JANGAN SENTUH DIBAWAH INI ============--
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
client.url = "https://raw.githubusercontent.com/jutuns/hwid/main/luci-pnb/"..hwid
local response = client:request().body

if response:find("404") then
    print("HWID NOT REGISTERED, CONTACT : JUTUN STORE")
    print(hwid)
else
    activateScript = true
end

if activateScript then
    itmSeed = itmId + 1
    minimumGem = packPrice * buyPackCount
    bot.collect_range = 3
    bot.legit_mode = false
    totalWorld = #worldList
    totalBot = #getBots()
    maxBot = totalBot / totalWorld
    indexBot = 0
    indexLast = 0
    botposX = 0
    botposY = 0
    gaiaX = 0
    gaiaY = 0
    utX = 0
    utY = 0
    totalGems = 0
    totalSeed = 0
    totalBlock = 0
    worldPNB = ""
    t = os.time()
    for _,pack in pairs(packList) do
        table.insert(goods,pack)
    end
    for i, botz in pairs(getBots()) do
        if botz.name:upper() == bot.name:upper() then
            indexBot = i
        end
        indexLast = i
    end
end

function iconOnOff(status)
    if status == BotStatus.online then
        return "<a:online2:1174926338164002818> "
    else
        return "<a:OFFLINE:1142826338307280997> "
    end
end

function checker()
    desc1 = ""
    desc2 = ""
    for i,bot in pairs(getBots()) do
        if i <= 10 then
            nama  = "<:cid:1164109977112301580> [ "..iconOnOff(bot.status) .."]".. " [ " .. bot.name .. " ] "
            level = "[ "..bot.level.." ]"
            desc1 = desc1 .. nama .. level .. "`n"
        end
        if i > 10 and i <= 20 then
            nama  = "<:cid:1164109977112301580> [ "..iconOnOff(bot.status) .."]".. " [ " .. bot.name .. " ] "
            level = "[ "..bot.level.." ]"
            desc2 = desc2 .. nama .. level .. "`n"
        end
    end
    return desc1, desc2
end

function webhookLog(status)
    local text = [[
        $webHookUrl = "]]..webhookEvents..[["
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

function webhookInfo()
    desc1, desc2 = checker()
    te = os.time() - t
    local text = [[
        $webHookUrl = "]]..webhookEvents..[[/messages/]]..messageIdEvents..[["
        $thumbnailObject = @{
            url = "https://cdn.discordapp.com/attachments/1162923025881112757/1168917165223719023/JutunStore.png"
        }
        $footerObject = @{
            text = "]]..(os.date("!%a %b %d, %Y at %I:%M %p", os.time() + 7 * 60 * 60))..[["
        }
        $fieldArray = @(
            @{
                name = ">> MODE PNB <<"
                value = "]]..mode..[["
                inline = "false"
            }
            @{
                name = ""
                value = "]]..desc1..[["
                inline = "false"
            }
            @{
                name = ""
                value = "]]..desc2..[["
                inline = "false"
            }
            @{
                name = ""
                value = "Created by [Jutun Script](https://discord.gg/QnfDzwf5SG) Made with Love <a:pikaa:1144605987416854608>"
                inline = "false"
            }
            @{
                name = ">> GEMS IN WORLD <<"
                value = "]]..totalGems..[["
                inline = "false"
            }
            @{
                name = ">> TOTAL SEED <<"
                value = "]]..totalSeed..[["
                inline = "true"
            }
            @{
                name = ">> TOTAL BLOCK <<"
                value = "]]..totalBlock..[["
                inline = "true"
            }
            @{
                name = ">> UPTIME SCRIPT <<"
                value = "]]..math.floor(te/86400).." Days "..math.floor(te%86400/3600).." Hours "..math.floor(te%86400%3600/60).." Minutes"..[["
                inline = "false"
            }
        )
        $embedObject = @{
            title = "**SCRIPT PNB V1.2 BY JUTUN STORE**"
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

function round(n)
    return n % 1 > 0.5 and math.ceil(n) or math.floor(n)
end

function tileDrop(x,y,num)
    local count = 0
    local stack = 0
    for _,obj in pairs(bot:getWorld():getObjects()) do
        if round(obj.x / 32) == x and math.floor(obj.y / 32) == y then
            count = count + obj.count
            stack = stack + 1
        end
    end
    if count <= (4000 - num) and stack < 20 then
        return true
    end
    return false
end

function reconnect(world,id,x,y)
    while (not bot:isInWorld(world:upper()) or getTile(getBot().x,getBot().y).fg == 6) and bot.status == BotStatus.online do
        while bot:isResting() do
            sleep(2000)
        end
        bot:warp(world,id)
        sleep(delayWarp)
    end
    if bot.status ~= BotStatus.online then
        while bot:isResting() do
            sleep(2000)
        end
        while bot.status ~= BotStatus.online do
            bot:connect()
            sleep(8000)
            if bot.status == BotStatus.account_banned then
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
    end
end

function takeBlock()
    otw(storageBlock,doorBlock)
    while bot:getInventory():findItem(itmId) == 0 do
        totalBlock = countItem(itmId)
        if totalBlock > 0 then
            for _, obj in pairs(bot:getWorld():getObjects()) do
                if obj.id == itmId then
                    bot:findPath(math.floor(obj.x/32),math.floor(obj.y/32))
                    sleep(100)
                    bot:collect(2)
                    sleep(100)
                    reconnect(storageBlock,doorBlock,math.floor(obj.x/32),math.floor(obj.y/32))
                    if bot:getInventory():findItem(itmId) > 0 then
                        break
                    end
                end
            end
        else
            bot:disconnect()
            bot.auto_reconnect = false
            webhookLog(bot.name.." disconnected storage block empty")
            bot:stopScript()
        end
    end
    otw(worldPNB,doorPNB)
end

function countGems()
    gmzz = 0
    for _, obj in pairs(bot:getWorld():getObjects()) do
        if obj.id == 112 then
            gmzz = gmzz + obj.count
        end
    end
    return gmzz
end

function countItem(id)
    itemC = 0
    for _, obj in pairs(bot:getWorld():getObjects()) do
        if obj.id == id then
            itemC = itemC + obj.count
        end
    end
    return itemC
end

function checkGems()
    gmz = 0
    for _, obj in pairs(bot:getWorld():getObjects()) do
        if obj.id == 112 then
            gmz = gmz + obj.count
        end
    end
    if gmz >= targetGems then
        bot:say("Reached target gems!")
        sleep(100)
        storeBlock()
        sleep(100)
        removeBot()
        sleep(100)
        bot:stopScript()
    end
end

function pnb()
    if mode:upper() == "GAUT" then
        checkz = 0
        if bot:getInventory():findItem(itmId) == 0 then
            takeBlock()
        end
        otw(worldPNB,doorPNB)
        bot:findPath(botposX,botposY)
        while bot:getInventory():findItem(itmId) > 0 and bot:isInWorld(worldPNB:upper()) and bot:isInTile(botposX,botposY) do
            while getTile(botposX,botposY+posYBreak).fg == 0 and getTile(botposX,botposY+posYBreak).bg == 0 and bot:isInTile(botposX,botposY) do
                bot:place(botposX,botposY+posYBreak,itmId)
                sleep(delayPlace)
                reconnect(worldPNB,doorPNB,botposX,botposY)
            end
            while getTile(botposX,botposY+posYBreak).fg ~= 0 or getTile(botposX,botposY+posYBreak).bg ~= 0 and bot:isInTile(botposX,botposY) do
                bot:hit(botposX,botposY+posYBreak)
                sleep(delayPunch)
                reconnect(worldPNB,doorPNB,botposX,botposY)
            end
            if removeBotReachTargetGems then
                if checkz == 10 then
                    checkGems()
                    checkz = 0
                    reconnect(worldPNB,doorPNB,botposX,botposY)
                else
                    checkz = checkz + 1
                end
            end
        end
    else
        if bot:getInventory():findItem(itmId) == 0 then
            takeBlock()
        end
        otw(worldPNB,doorPNB)
        bot.auto_collect = true
        checkz = 0
        bot:findPath(botposX,botposY)
        while bot:getInventory():findItem(itmId) > 0 and bot:getInventory():findItem(itmSeed) < dropSeedCount and bot.gem_count <= minimumGem and bot:isInWorld(worldPNB:upper()) and bot:isInTile(botposX,botposY) do
            if takePick and bot:getInventory():findItem(98) == 0 then
                takePickaxe()
                sleep(100)
                otw(worldPNB,doorPNB)
            end
            while getTile(botposX,botposY+posYBreak).fg == 0 and getTile(botposX,botposY+posYBreak).bg == 0 and bot:isInTile(botposX,botposY) do
                bot:place(botposX,botposY+posYBreak,itmId)
                sleep(delayPlace)
                reconnect(worldPNB,doorPNB,botposX,botposY)
            end
            while getTile(botposX,botposY+posYBreak).fg ~= 0 or getTile(botposX,botposY+posYBreak).bg ~= 0 and bot:isInTile(botposX,botposY) do
                bot:hit(botposX,botposY+posYBreak)
                sleep(delayPunch)
                reconnect(worldPNB,doorPNB,botposX,botposY)
            end
        end
        if bot.gem_count > minimumGem then
            while bot:getInventory().slotcount < 36 do
                bot:sendPacket(2,"action|buy\nitem|upgrade_backpack")
                sleep(500)
            end
            while bot.gem_count > packPrice do
                for i = 1, buyPackCount do
                    if bot.gem_count > packPrice then
                        bot:sendPacket(2,"action|buy\nitem|"..packName)
                        sleep(1000)
                    else
                        break
                    end
                end
            end
            bot.auto_collect = false
            sleep(100)
            storePack()
            sleep(100)
            otw(worldPNB,doorPNB)
            sleep(100)
            bot.auto_collect = true
            sleep(100)
        end
        if bot:getInventory():findItem(itmSeed) >= dropSeedCount then
            bot.auto_collect = false
            sleep(100)
            storeSeed()
            sleep(100)
            otw(worldPNB,doorPNB)
            sleep(100)
            bot.auto_collect = true
        end
    end
end

function storePack()
    otw(storagePack,doorPack)
    if bot:getWorld().name == storagePack:upper() then
        for _,pack in pairs(packList) do
            for _,tile in pairs(bot:getWorld():getTiles()) do
                if tile.fg == bgIdDropPack or tile.bg == bgIdDropPack then
                    if tileDrop(tile.x,tile.y,bot:getInventory():findItem(pack)) then
                        bot:findPath(tile.x - 1,tile.y)
                        sleep(100)
                        reconnect(storagePack,doorPack,tile.x - 1,tile.y)
                        if bot:getInventory():findItem(pack) > 0 then
                            bot:sendPacket(2,"action|drop\n|itemID|"..pack)
                            sleep(100)
                            bot:sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|"..pack.."|\ncount|"..bot:getInventory():findItem(pack))
                            sleep(100)
                            reconnect(storagePack,doorPack,tile.x - 1,tile.y)
                        end
                    end
                end
                if bot:getInventory():findItem(pack) == 0 then
                    break
                end
            end
        end
    end
end

function storeSeed()
    otw(storageSeed,doorSeed)
    totalSeed = countItem(itmSeed)
    for _, tile in pairs(bot:getWorld():getTiles()) do
        if tile.fg == bgIdDropSeed or tile.bg == bgIdDropSeed then
            if tileDrop(tile.x,tile.y,200) then
                bot:findPath(tile.x - 1,tile.y)
                bot:setDirection(false)
                sleep(100)
                bot:drop(itmSeed,bot:getInventory():findItem(itmSeed))
                sleep(100)
                if bot:getInventory():findItem(itmSeed) == 0 then
                    break
                end
            end
        end
    end
    sleep(100)
end

function storeBlock()
    otw(storageBlock,doorBlock)
    totalBlock = countItem(itmId)
    for _, tile in pairs(bot:getWorld():getTiles()) do
        if tile.fg == bgIdDropBlock or tile.bg == bgIdDropBlock then
            if tileDrop(tile.x,tile.y,200) then
                bot:findPath(tile.x - 1,tile.y)
                bot:setDirection(false)
                sleep(100)
                bot:drop(itmId,bot:getInventory():findItem(itmId))
                sleep(100)
                if bot:getInventory():findItem(itmId) == 0 then
                    break
                end
            end
        end
    end
    sleep(100)
end

function takeGaia()
    if bot:getInventory():findItem(itmSeed) < 200 then
        amount = bot:getWorld():getTile(gaiaX,gaiaY):getExtra().item_count
        sleep(100)
        if amount > 200 then
            bot:findPath(gaiaX,gaiaY-1)
            sleep(1000)
            bot:wrench(gaiaX,gaiaY)
            sleep(1500)
            bot:sendPacket(2,"action|dialog_return\ndialog_name|itemsucker_seed\ntilex|"..gaiaX.."|\ntiley|"..gaiaY.."|\nbuttonClicked|retrieveitem\n\nchk_enablesucking|1")
            sleep(1500)
            bot:sendPacket(2,"action|dialog_return\ndialog_name|itemremovedfromsucker\ntilex|"..gaiaX.."|\ntiley|"..gaiaY.."|\nitemtoremove|200")
            sleep(1500)
            reconnect(worldPNB,doorPNB,gaiaX,gaiaY-1)
            sleep(100)
        end
        reconnect(worldPNB,doorPNB,gaiaX,gaiaY-1)
        sleep(100)
    end
end

function takeUT()
    if bot:getInventory():findItem(itmId) < 200 then
        amount = getBot():getWorld():getTile(utX,utY):getExtra().item_count
        sleep(100)
        if amount >= 200 then
            bot:findPath(utX,utY-1)
            sleep(1500)
            bot:wrench(utX,utY)
            sleep(1500)
            bot:sendPacket(2,"action|dialog_return\ndialog_name|itemsucker_block\ntilex|"..utX.."|\ntiley|"..utY.."|\nbuttonClicked|retrieveitem\n\nchk_enablesucking|1")
            sleep(1500)
            bot:sendPacket(2,"action|dialog_return\ndialog_name|itemremovedfromsucker\ntilex|"..utX.."|\ntiley|"..utY.."|\nitemtoremove|200")
            sleep(1500)
            reconnect(worldPNB,doorPNB,utX,utY-1)
            sleep(100)
        end
    end
end

function otw(worldz,id)
    while not bot:isInWorld(worldz:upper()) or getTile(getBot().x,getBot().y).fg == 6 do
        while bot:isResting() do
            sleep(2000)
        end
        bot:warp(worldz,id)
        sleep(delayWarp)
    end
end

function takePickaxe()
    bot.auto_collect = false
    otw(storagePickaxe,doorPickaxe)
    sleep(100)
    while bot:getInventory():findItem(98) == 0 do
        for _,obj in pairs(bot:getWorld():getObjects()) do
            if obj.id == 98 then
                bot:findPath(round(obj.x / 32),math.floor(obj.y / 32))
                sleep(100)
                bot:collect(3)
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
    bot:setDirection(false)
    sleep(100)
    while bot:getInventory():findItem(98) > 1 do
        bot:sendPacket(2,"action|drop\n|itemID|98")
        sleep(500)
        bot:sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|98|\ncount|"..(bot:getInventory():findItem(98) - 1))
        sleep(500)
    end
    bot:wear(98)
    sleep(100)
end

if activateScript then
    if takePick and bot:getInventory():findItem(98) == 0 then
        takePickaxe()
    end
    worldPNB = worldList[math.ceil(indexBot/maxBot)]
    if mode:upper() == "GAUT" then
        if indexBot % maxBot == 0 then
            otw(worldPNB,doorPNB)
            if autoChangeSkin then
                bot:setSkin(6)
            end
            for _, tile in pairs(bot:getWorld():getTiles()) do
                if tile.fg == 6946 then
                    gaiaX = tile.x
                    gaiaY = tile.y
                end
            end
            for _, tile in pairs(bot:getWorld():getTiles()) do
                if tile.fg == 6948 then
                    utX = tile.x
                    utY = tile.y
                end
            end
            while true do
                sleep(restTake)
                countBots = #getBots()
                if countBots == totalWorld then
                    removeBot()
                end
                takeGaia()
                sleep(100)
                takeUT()
                sleep(100)
                if bot:getInventory():findItem(itmId) > 0 then
                    storeBlock()
                end
                if bot:getInventory():findItem(itmSeed) > 0 then
                    storeSeed()
                end
                otw(worldPNB,doorPNB)
                sleep(100)
                totalGems = countItem(112)
                webhookInfo()
            end
        else
            otw(worldPNB,doorPNB)
            if autoChangeSkin then
                bot:setSkin(6)
            end
            for _, tile in pairs(bot:getWorld():getTiles()) do
                if tile.fg == patokanPNB or tile.bg == patokanPNB then
                    botposX = tile.x - 1
                    botposY = tile.y
                    break
                end
            end
            while indexBot > maxBot do
                indexBot = indexBot - maxBot
            end
            botposX = botposX + indexBot
            sleep(100)
            while true do
                pnb()
            end
        end
    elseif mode:upper() == "NOGAUT" then
        sleep(100)
        otw(worldPNB,doorPNB)
        if autoChangeSkin then
            bot:setSkin(6)
        end
        bot.auto_collect = true
        for _, tile in pairs(bot:getWorld():getTiles()) do
            if tile.fg == patokanPNB or tile.bg == patokanPNB then
                botposX = tile.x - 1
                botposY = tile.y
                break
            end
        end
        while indexBot > maxBot do
            indexBot = indexBot - maxBot
        end
        botposX = botposX + indexBot
        sleep(100)
        while true do
            if indexBot % maxBot == 0 then
                webhookInfo()
            end
            pnb()
        end
    else
        print("ERROR MODE NOT SELECTED")
    end
end
