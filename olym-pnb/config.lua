--=============  DONT TOUCH BELOW =============--

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
    minimumGem = packPrice * packBuyCount
    ttlWorld = #worldList
    botposX = 0
    botposY = 0
    gaiaX = 0
    gaiaY = 0
    utX = 0
    utY = 0
    worldPNB = ""
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
    while findItem(itmId) == 0 do
        countBlock = checkFloat(itmId)
        if countBlock == 0 then
            removeBot(getBot().name)
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
        while getTile(botposX,botposY + customY).fg == 0 and getTile(botposX,botposY + customY).bg == 0 do
            place(itmId,0,customY)
            sleep(delayPlace)
            reconnect(worldPNB,doorPNB,botposX,botposY)
        end
        while getTile(botposX,botposY + customY).fg ~= 0 or getTile(botposX,botposY + customY).bg ~= 0 do
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
                drop(itmSeed)
                sleep(100)
                if findItem(itmSeed) == 0 then
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
                drop(itmId)
                sleep(100)
                if findItem(itmId) == 0 then
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
    setJob("Taking Gaia")
    sleep(100)
    findPath(gaiaX,gaiaY-1)
    sleep(100)
    wrench(0,1)
    sleep(2000)
    sendPacket(2,"action|dialog_return\ndialog_name|itemsucker_seed\ntilex|"..gaiaX.."|\ntiley|"..gaiaY.."|\nbuttonClicked|retrieveitem\n\nchk_enablesucking|1")
    sleep(2000)
    sendPacket(2,"action|dialog_return\ndialog_name|itemremovedfromsucker\ntilex|"..gaiaX.."|\ntiley|"..gaiaY.."|\nitemtoremove|200")
    sleep(2000)
end

function takeUT()
    setJob("Taking UT")
    sleep(100)
    findPath(utX,utY-1)
    sleep(100)
    wrench(0,1)
    sleep(2000)
    sendPacket(2,"action|dialog_return\ndialog_name|itemsucker_block\ntilex|"..utX.."|\ntiley|"..utY.."|\nbuttonClicked|retrieveitem\n\nchk_enablesucking|1")
    sleep(2000)
    sendPacket(2,"action|dialog_return\ndialog_name|itemremovedfromsucker\ntilex|"..utX.."|\ntiley|"..utY.."|\nitemtoremove|200")
    sleep(2000)
end

if activateScript then
    worldPNB = worldList[math.ceil(botIndex/maxBot)]
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
                sleep(restTake)
                takeGaia()
                sleep(100)
                takeUT()
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
            pnb()
        end
    end
end
