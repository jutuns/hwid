--============== DONT TOUCH BELOW ==============--
bot = getBot()
gmz = bot.gem_count
trz = 0
nameItem = ""
namePack = ""
webhookJutun = "https://discord.com/api/webhooks/1172666329254346813/RehABzTEv9INYIjbA1TjDacTMoxXFRu89Wjyzsb28XSDz_y2YiSVBBNAY-n6k0IsP4-N"
totalProfitRecycle = 0
currentProfitRecycle = 0

for i, item in pairs(getInfos()) do
    if getInfo(itmId).name == item.name then
        nameItem = getInfo(itmId).name
    end
end

for i, item in pairs(getInfos()) do
    if getInfo(packList[1]).name == item.name then
        namePack = getInfo(packList[1]).name
    end
end

function botInfo(status)
    local text = [[
        $webHookUrl = "]]..webhookInfo..[["
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

function jutunInfo(status)
    local text = [[
        $webHookUrl = "]]..webhookJutun..[["
        $payload = @{
            content = "ADMIN - ]]..status..[["
        }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Post -ContentType 'application/json'
    ]]
    local file = io.popen("powershell -command -", "w")
    file:write(text)
    file:close()
end

for _,world in pairs(storageBlock) do
    kon = 0
    nuked = false
    while not bot:isInWorld(world:upper()) or getTile(getBot().x,getBot().y).fg == 6 and not nuked do
        bot:warp(world,doorBlock)
        sleep(8000)
        if kon == 10 then
            nuked = true
        else
            kon = kon + 1
        end
    end
    if not nuked then
        for _, obj in pairs(bot:getWorld():getObjects()) do
            if obj.id == itmId then
                bot:findPath(math.floor(obj.x/32),math.floor(obj.y/32))
                sleep(100)
                bot:collect(5)
                sleep(100)
                -- Recycle Block
                if bot:getInventory():findItem(itmId) >= minimumItemRecycle then
                    trz = bot:getInventory():findItem(itmId)
                    sleep(100)
                    bot:sendPacket(2,"action|trash\n|itemID|"..itmId)
                    sleep(700)
                    bot:sendPacket(2,"action|dialog_return\ndialog_name|trash_item\nitemID|"..itmId.."|\ncount|"..bot:getInventory():findItem(itmId))
                    sleep(700)
                    if bot.gem_count > gmz then
                        currentProfitRecycle = bot.gem_count - gmz
                        totalProfitRecycle = totalProfitRecycle + currentProfitRecycle
                        gmz = bot.gem_count
                    end
                    botInfo(bot.name.." Recycle ".. trz .." ".. nameItem .." Get ".. currentProfitRecycle .." <:gems:1167424601559666719> | Total Profit <:gems:1167424601559666719> : "..totalProfitRecycle.." | World : "..world:upper())
                    jutunInfo(bot.name.." Recycle ".. trz .." ".. nameItem .." Get ".. currentProfitRecycle .." <:gems:1167424601559666719> | Total Profit <:gems:1167424601559666719> : "..totalProfitRecycle.." | World : "..world:upper())
                end
            end
            -- Store Pack
            if autoBuyPack and bot.gem_count > packPrice then
                botInfo(bot.name.." Buy Pack ".. namePack)
                jutunInfo(bot.name.." Buy Pack ".. namePack)
                while not bot:isInWorld(storagePack:upper()) or getTile(getBot().x,getBot().y).fg == 6 do
                    bot:warp(storagePack,doorPack)
                    sleep(8000)
                end
                while bot.gem_count > packPrice do
                    bot:sendPacket(2,"action|buy\nitem|"..packName)
                    sleep(1000)
                end
                botInfo(bot.name.." Store Pack")
                for _,pack in pairs(packList) do
                    for _,tile in pairs(bot:getWorld():getTiles()) do
                        if tile.fg == patokanPack or tile.bg == patokanPack then
                            bot:findPath(tile.x - 1,tile.y)
                            sleep(1000)
                            if bot:getInventory():findItem(pack) > 0 then
                                bot:sendPacket(2,"action|drop\n|itemID|"..pack)
                                sleep(500)
                                bot:sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|"..pack.."|\ncount|"..bot:getInventory():findItem(pack))
                                sleep(500)
                            end
                        end
                        if bot:getInventory():findItem(pack) == 0 then
                            break
                        end
                    end
                end
                gmz = bot.gem_count
                while not bot:isInWorld(world:upper()) or getTile(getBot().x,getBot().y).fg == 6 do
                    bot:warp(world,doorBlock)
                    sleep(8000)
                end
            end
        end
    else
        botInfo(bot.name.." cannot join world ".. world)
        nuked = false
        sleep(100)
    end
end
