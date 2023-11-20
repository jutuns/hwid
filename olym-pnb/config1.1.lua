--=============================================--
--=============  DONT TOUCH BELOW =============--
--=============================================--

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
response = request("GET", "https://raw.githubusercontent.com/jutuns/hwid/main/olym-pnb/"..hwid)

DcUsername = hwid
DcWebhook = "https://discord.com/api/webhooks/1161528324141617213/026-pHMimh1_KMMiH5fTp4Tjy3SfOFCDthqkTz2zHa_L4PvW9hm_92Cq9oZHvzJdjXKQ"

if response:find("404") then
    print("HWID NOT REGISTERED, CONTACT : JUTUN STORE")
    print(DcUsername)
else
    activateScript = true
end

if activateScript then
    totalSeed = 0
    totalBlock = 0
    totalGems = 0
    minimumGem = packPrice * packBuyCount
    ttlWorld = #worldList
    botposX = 0
    botposY = 0
    gaiaX = 0
    gaiaY = 0
    utX = 0
    utY = 0
    worldPNB = ""
    tt = os.time()
    for i, bot in pairs(getBots()) do
        if getBot().name:upper() == bot.name:upper() then
            botIndex = i
        end
        botLastIndex = i
    end
    maxBot = math.floor(botLastIndex/ttlWorld)
end

function round(n)
    return n % 1 > 0.5 and math.ceil(n) or math.floor(n)
end

function warp(world,id)
    cok = 0
    setJob("Warp to "..world)
    while getBot().world ~= world:upper() and not nuked do
        while getBot().status ~= "online" or getPing() > 1000 do
            connect()
            sleep(10000)
            if getBot().status == "suspended" or getBot().status == "banned" or getBot().status == "temporary ban" then
                error()
            end
        end
        sendPacket("action|join_request\nname|"..world:upper().."|"..id:upper().."\ninvitedWorld|0",3)
        sleep(6000)
        if cok == 20 then
            sendPacket("action|join_request\nname|EXIT\ninvitedWorld|0",3)
            sleep(2000)
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
        while getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 and not nuked do
            while getBot().status ~= "online" or getPing() > 3000 do
                disconnect()
                sleep(1000)
                connect()
                sleep(8000)
                if getBot().status == "suspended" or getBot().status == "banned" or getBot().status == "temporary ban" then
                    error()
                end
            end
            sendPacket("action|join_request\nname|"..world:upper().."|"..id:upper().."\ninvitedWorld|0",3)
            sleep(2000)
        end
    end
end

function iconOnOff(status)
    if status == "online" then
        return "<a:online2:1174926338164002818> "
    else
        return "<a:OFFLINE:1142826338307280997> "
    end
end

function checker()
    ttl = 0
    gms = 0
    gems= 0
    world = ""
    desc1 = ""
    for i,bot in pairs(getBots()) do
        gmz = bot.gems
        gems  = gems + gmz
        ttl  = ttl + 1
        nama  = "<:cid:1164109977112301580> ["..iconOnOff(bot.status) .."]".. " [" .. bot.name:upper() .. "] "
        level = "["..bot.level.."]"
        desc1 = desc1 .. nama .. level .. "`n"
    end
    te = os.time() - tt
    return desc1
end

function webhookInfo(desc)
    te = os.time() - tt
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
                name = ""
                value = "]]..desc..[["
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
            title = "**SCRIPT PNB V1.1 BY JUTUN STORE**"
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

function tileDrop(x,y,num)
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

function reconnect(world,id,x,y)
    if getBot().status ~= "online" then
        while getBot().status ~= "online" do
            connect()
            sleep(8000)
            if getBot().status == "suspended" or getBot().status == "banned" or getBot().status == "temporary ban" then
                error()
            end
        end
        while getBot().world ~= world:upper() or getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 do
            sendPacket("action|join_request\nname|"..world:upper().."|"..id:upper().."\ninvitedWorld|0",3)
            sleep(6000)
        end
        if x and y then
            findPath(x,y)
            sleep(100)
        end
    end
end

function takeBlock()
    while getBot().world ~= storageBlock:upper() or getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 do
        warp(storageBlock,doorBlock)
        sleep(100)
    end
    countBlock = checkFloat(itmId)
    if countBlock == 0 then
        disconnect()
        setJob("No Item at Storage")
        error()
    end
    for _, obj in pairs(getObjects()) do
        if obj.id == itmId then
            findPath(math.floor(obj.x/32),math.floor(obj.y/32))
            sleep(100)
            collect(2)
            sleep(100)
            reconnect(storageBlock,doorBlock,math.floor(obj.x/32),math.floor(obj.y/32))
            if findItem(itmId) > 0 then
                break
            end
        end
    end
    while getBot().world ~= worldPNB:upper() or getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 do
        warp(worldPNB,doorPNB)
        sleep(100)
    end
end

function checkFloat(ids)
    countids = 0
    for _, obj in pairs(getObjects()) do
        if obj.id == ids then
            countids = countids + obj.count
        end
    end
    return countids
end

function pnb()
    if findItem(itmId) == 0 then
        takeBlock()
    end
    sleep(100)
    findPath(botposX,botposY)
    sleep(100)
    while findItem(itmId) > 0 and findItem(itmSeed) < 200 and math.floor(getBot().x / 32) == botposX or math.floor(getBot().y / 32) == botposY do
        setJob("Put and Break")
        if findItem(itmId) < 5 then
            takeBlock()
            sleep(100)
            findPath(botposX,botposY)
        end
        if getTile(botposX,botposY + customY).fg == 0 and getTile(botposX,botposY + customY).bg == 0 then
            place(itmId,0,customY)
            sleep(delayPlace)
            reconnect(worldPNB,doorPNB,botposX,botposY)
        end
        if getTile(botposX,botposY + customY).fg ~= 0 or getTile(botposX,botposY + customY).bg ~= 0 then
            punch(0,customY)
            sleep(delayPunch)
            reconnect(worldPNB,doorPNB,botposX,botposY)
        end
        if removeBotAfterReachTarget then
            gmz = checkFloat(112)
            if gmz >= targetGems then
                say("Reached target gems!")
                sleep(1000)
                removeBot(getBot().name)
                error()
            end
        end
    end
    if findItem(112) > minimumGem then
        setJob("Buy Pack")
        sleep(100)
        while getBot().slots < 26 do
            sendPacket("action|buy\nitem|upgrade_backpack",2)
            sleep(500)
        end
        while findItem(112) > packPrice do
            for i = 1, packBuyCount do
                if findItem(112) > packPrice then
                    sendPacket("action|buy\nitem|"..packName,2)
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
        collectSet(true, 3)
        sleep(100)
    end
    if findItem(itmSeed) == 200 then
        collectSet(false, 3)
        sleep(100)
        storeSeed()
        sleep(100)
        collectSet(true, 3)
    end
end

function storeSeed()
    while getBot().world ~= storageSeed:upper() or getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 do
        warp(storageSeed,doorSeed)
        sleep(100)
    end
    sleep(100)
    setJob("Store Seed")
    sleep(100)
    for _, tile in pairs(getTiles()) do
        if tile.fg == patokanSeed or tile.bg == patokanSeed then
            if tileDrop(tile.x,tile.y,findItem(itmSeed)) then
                findPath(tile.x - 1,tile.y)
                sleep(100)
                sendPacket("action|drop\n|itemID|"..itmSeed,2)
                sleep(500)
                sendPacket("action|dialog_return\ndialog_name|drop_item\nitemID|"..itmSeed.."|\ncount|"..findItem(itmSeed),2)
                sleep(100)
                if findItem(itmSeed) == 0 then
                    break
                end
            end
        end
    end
    totalSeed = checkFloat(itmSeed)
    while getBot().world ~= worldPNB:upper() or getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 do
        warp(worldPNB,doorPNB)
        sleep(100)
    end
end

function storeBlock()
    while getBot().world ~= storageBlock:upper() or getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 do
        warp(storageBlock,doorBlock)
        sleep(100)
    end
    sleep(100)
    setJob("Store Block")
    sleep(100)
    for _, tile in pairs(getTiles()) do
        if tile.fg == patokanBlock or tile.bg == patokanBlock then
            if tileDrop(tile.x,tile.y,findItem(itmId)) then
                findPath(tile.x - 1,tile.y)
                sleep(100)
                sendPacket("action|drop\n|itemID|"..itmId,2)
                sleep(500)
                sendPacket("action|dialog_return\ndialog_name|drop_item\nitemID|"..itmId.."|\ncount|"..findItem(itmId),2)
                sleep(100)
                if findItem(itmId) == 0 then
                    break
                end
            end
        end
    end
    totalBlock = checkFloat(itmId)
    while getBot().world ~= worldPNB:upper() or getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 do
        warp(worldPNB,doorPNB)
        sleep(100)
    end
end

function storePack()
    while getBot().world ~= storagePack:upper() or getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 do
        warp(storagePack,doorPack)
        sleep(100)
    end
    sleep(100)
    setJob("Store Pack")
    sleep(100)
    if getBot().world:upper() == storagePack:upper() then
        for _,pack in pairs(packList) do
            for _,tile in pairs(getTiles()) do
                if tile.fg == patokanPack or tile.bg == patokanPack then
                    if tileDrop(tile.x,tile.y,findItem(pack)) then
                        findPath(tile.x - 1,tile.y)
                        sleep(100)
                        reconnect(storagePack,doorPack,tile.x - 1,tile.y)
                        if findItem(pack) > 0 and tileDrop(tile.x,tile.y,findItem(pack)) then
                            sendPacket("action|drop\n|itemID|"..pack,2)
                            sleep(100)
                            sendPacket("action|dialog_return\ndialog_name|drop_item\nitemID|"..pack.."|\ncount|"..findItem(pack),2)
                            sleep(100)
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
    while getBot().world ~= worldPNB:upper() or getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 do
        warp(worldPNB,doorPNB)
        sleep(100)
    end
end

function takeGaia()
    setJob("Checking Gaia")
    sleep(100)
    findPath(gaiaX,gaiaY-1)
    sleep(100)
    wrench(0,1)
    sleep(2000)
    sendPacket(2,"action|dialog_return\ndialog_name|itemsucker_seed\ntilex|"..gaiaX.."|\ntiley|"..gaiaY.."|\nbuttonClicked|retrieveitem\n\nchk_enablesucking|1")
    sleep(2000)
    sendPacket(2,"action|dialog_return\ndialog_name|itemremovedfromsucker\ntilex|"..gaiaX.."|\ntiley|"..gaiaY.."|\nitemtoremove|200")
    sleep(2000)
    reconnect(worldPNB,doorPNB,gaiaX,gaiaY-1)
end

function takeUT()
    setJob("Checking UT")
    sleep(100)
    findPath(utX,utY-1)
    sleep(100)
    wrench(0,1)
    sleep(2000)
    sendPacket(2,"action|dialog_return\ndialog_name|itemsucker_block\ntilex|"..utX.."|\ntiley|"..utY.."|\nbuttonClicked|retrieveitem\n\nchk_enablesucking|1")
    sleep(2000)
    sendPacket(2,"action|dialog_return\ndialog_name|itemremovedfromsucker\ntilex|"..utX.."|\ntiley|"..utY.."|\nitemtoremove|200")
    sleep(2000)
    reconnect(worldPNB,doorPNB,utX,utY-1)
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

if activateScript then
    if getBot().world:find("TUTORIAL") then
        skipTutorial()
    end
    if takePick and findItem(98) == 0 then
        takePickaxe()
        sleep(100)
        warp("EXIT")
    end    
    worldPNB = worldList[math.ceil(botIndex/maxBot)]
    webhookEvents = webhookEvents[math.ceil(botIndex/maxBot)]
    messageIdEvents = messageIdEvents[math.ceil(botIndex/maxBot)]
    while botIndex > maxBot do
        botIndex = botIndex - maxBot
    end
    if autoRetrieve then
        if botIndex % maxBot == 0 then
            warp(worldPNB,doorPNB)
            sleep(100)
            for _, tile in pairs(getTiles()) do
                if tile.fg == 6946 then
                    gaiaX = tile.x
                    gaiaY = tile.y
                end
                if tile.fg == 6948 then
                    utX = tile.x
                    utY = tile.y
                end
            end
            while true do
                totalGems = checkFloat(112)
                desc1 = checker()
                sleep(100)
                webhookInfo(desc1)
                sleep(restTake)
                if findItem(itmSeed) < 200 then
                    takeGaia()
                end
                sleep(100)
                if findItem(itmId) < 200 then
                    takeUT()
                end
                sleep(100)
                if findItem(itmId) > 0 then
                    storeBlock()
                end
                if findItem(itmSeed) > 0 then
                    storeSeed()
                end
            end
        else
            warp(worldPNB,doorPNB)
            sleep(100)
            for _, tile in pairs(getTiles()) do
                if tile.fg == patokanPNB or tile.bg == patokanPNB then
                    botposX = tile.x - 1
                    botposY = tile.y
                    break
                end
            end
            botposX = botposX + botIndex
            sleep(100)
            while true do
                pnb()
            end
        end
    else
        warp(worldPNB,doorPNB)
        sleep(100)
        collectSet(true, 3)
        sleep(100)
        for _, tile in pairs(getTiles()) do
            if tile.fg == patokanPNB or tile.bg == patokanPNB then
                botposX = tile.x - 1
                botposY = tile.y
                break
            end
        end
        botposX = botposX + botIndex
        sleep(100)
        while true do
            if botIndex % maxBot == 0 then
                totalGems = checkFloat(112)
                desc1 = checker()
                sleep(100)
                webhookInfo(desc1)
            end
            pnb()
        end
    end
end
