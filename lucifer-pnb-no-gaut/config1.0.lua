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
client.url = "https://raw.githubusercontent.com/jutuns/hwid/main/lucifer-pnb-no-gaut/"..hwid
local response = client:request().body

if response:find("404") then
    print("HWID NOT REGISTERED, CONTACT : JUTUN STORE")
    print(hwid)
else
    activateScript = true
end

if activateScript then
    for _,pack in pairs(packList) do
        table.insert(goods,pack)
    end
    minimumGem = packPrice * buyPackCount
    totalWorld = #worldList
    totalBot = #getBots()
    maxBot = totalBot / totalWorld
    bot.legit_mode = false
    bot.collect_range = 3
    indexBot = 0
    indexLast = 0
    botposX = 0
    botposY = 0
    worldPNB = ""
    t = os.time()
    for i, botz in pairs(getBots()) do
        if botz.name:upper() == bot.name:upper() then
            indexBot = i
        end
        indexLast = i
    end
end

function infoPack()
    growscan = getBot():getWorld().growscan
    local str = ""
    for id, count in pairs(growscan:getObjects()) do
        str = str.."\n"..getInfo(id).name..": x"..count
    end
    return str
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
                value = "]]..bot:getWorld().name:upper()..[["
                inline = "false"
            }
            @{
                name = "<:cid:1133695201156800582> Last Visit"
                value = "]]..bot.name:upper()..[["
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

function round(n)
    return n % 1 > 0.5 and math.ceil(n) or math.floor(n)
end

function includesNumber(table, number)
    for _,num in pairs(table) do
        if num == number then
            return true
        end
    end
    return false
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
    if count <= (4000 - num) and stack < 15 then
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
    if bot:getInventory():findItem(6336) == 0 then
        autoTutorial()
    end
    otw(storageBlock,doorBlock)
    while bot:getInventory():findItem(itmId) == 0 do
        countBlock = countItem()
        if countItem() > 0 then
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
            removeBot()
        end
    end
    otw(worldPNB,doorPNB)
end

function countItem()
    itemC = 0
    for _, obj in pairs(bot:getWorld():getObjects()) do
        if obj.id == itmId then
            itemC = itemC + obj.count
        end
    end
    return itemC
end

function pnb()
    bot.auto_collect = true
    if bot:getInventory():findItem(6336) == 0 then
        autoTutorial()
    end
    checkz = 0
    if bot:getInventory():findItem(itmId) == 0 then
        takeBlock()
    end
    bot:findPath(botposX,botposY)
    while bot:getInventory():findItem(itmId) > 0 and bot:isInWorld(worldPNB:upper()) and bot:isInTile(botposX,botposY) do
        if bot:getInventory():findItem(6336) == 0 then
            autoTutorial()
            sleep(100)
            otw(worldPNB,doorPNB)
        end
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
            for i = 1, packBuyCount do
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
    if bot:getInventory():findItem(itmSeed) == 200 then
        bot.auto_collect = false
        sleep(100)
        storeSeed()
        sleep(100)
        otw(worldPNB,doorPNB)
        sleep(100)
        bot.auto_collect = true
    end
end

function storeSeed()
    otw(storageSeed,doorSeed)
    for _, tile in pairs(bot:getWorld():getTiles()) do
        if tile.fg == patokanSeed or tile.bg == patokanSeed then
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
    packInfo(webhookLinkSeed,messageIdSeed,infoPack())
    sleep(100)
end

function clear()
    for _,item in pairs(bot:getInventory():getItems()) do
        if not includesNumber(goods, item.id) then
            bot:sendPacket(2,"action|trash\n|itemID|"..item.id)
            sleep(400)
            bot:sendPacket(2,"action|dialog_return\ndialog_name|trash_item\nitemID|"..item.id.."|\ncount|"..item.count) 
            sleep(400)
            reconnect(worldPNB,doorPNB,botposX,botposY)
        end
    end
end


function storePack()
    otw(storagePack,doorPack)
    if bot:getWorld().name == storagePack:upper() then
        for _,pack in pairs(packList) do
            for _,tile in pairs(bot:getWorld():getTiles()) do
                if tile.fg == patokanPack or tile.bg == patokanPack then
                    if tileDrop(tile.x,tile.y,findItem(pack)) then
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
    sleep(100)
    packInfo(webhookLinkPack,messageIdPack,infoPack())
    sleep(100)
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

function autoTutorial()
    bot.auto_tutorial = true
    while bot:getWorld().name == "EXIT" or bot:getWorld().name:find("TUTORIAL") do
        sleep(5000)
    end
    bot.auto_tutorial = false
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
    if bot:getInventory():findItem(6336) == 0 then
        autoTutorial()
    end
    if takePick and bot:getInventory():findItem(98) == 0 then
        takePickaxe()
    end
    if autoChangeSkin then
        bot:setSkin(6)
    end
    sleep(100)
    worldPNB = worldList[math.ceil(indexBot/maxBot)]
    sleep(100)
    otw(worldPNB,doorPNB)
    sleep(100)
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
        pnb()
    end
end
