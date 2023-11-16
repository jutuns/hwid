currentWorld = ""
outputWorld = getBot().name:upper().."-RESULT.txt"
nukedTXT = getBot().name:upper().."-NUKED.txt"

file = io.open(outputWorld, "w+")
file:close()

file = io.open(nukedTXT, "w+")
file:close()

function log(txt)
    file = io.open(outputWorld, "a")
    if file then
        file:write(txt.."\n")
        file:close()
    end
end

function logNuke(txt)
    file = io.open(nukedTXT, "a")
    if file then
        file:write(txt.."\n")
        file:close()
    end
end

function worldChecker(status)
    local text = [[
        $webHookUrl = "]]..webhookActive..[["
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

function nukeWorldInfo(status)
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

function CheckNuke(var)
    if var[0]:find("OnConsoleMessage") and var[1]:find("That world is inaccessible.") then
        nuked = true
    end
end

function warp(world)
    cok = 0
    setJob("Warp to "..world)
    addHook("onvariant","nukecheck", CheckNuke)
    while getBot().world ~= world:upper() and not nuked do
        while getBot().status ~= "online" or getPing() > 1000 do
            connect()
            sleep(10000)
            if getBot().status == "suspended" or getBot().status == "banned" then
                removeBot(getBot().name)
                error()
            end
        end
        sendPacket("action|join_request\nname|"..world:upper().."\ninvitedWorld|0",3)
        sleep(7000)
        if cok == 5 then
            nuked = true
        else
            cok = cok + 1
        end
    end
    removeHooks()
    sleep(100)
end

function join(worldName,id)
    if getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 then 
        sendPacket(3,"action|join_request\nname|"..worldName:upper().."|"..id:upper().."\ninvitedWorld|0")
        sleep(1000)
    end
end

for _,world in pairs(worldList) do
    nuked = false
    sleep(100)
    warp(world)
    sleep(100)
    if not nuked then
        plantedz = 0
        readyz = 0
        fossilz = 0
        toxicwst = 0
        doorText = ""
        log("=====================")
        log("World : "..world:upper())
        for _,tile in pairs(getTiles()) do
            if getTile(tile.x,tile.y).fg == itmSeed and getBot().world:upper() == world:upper() then
                plantedz = plantedz + 1
                if tile.ready then
                    readyz = readyz + 1
                end
            end
            if getTile(tile.x,tile.y).fg == 3918 and getBot().world:upper() == world:upper() then
                fossilz = fossilz + 1
            end
            if getTile(tile.x,tile.y).fg == 778 and getBot().world:upper() == world:upper() then
                toxicwst = toxicwst + 1
            end
        end
        if checkTree then
            log("Total Tree : ".. plantedz)
            log("Ready Harvest : " .. readyz)
        end
        if checkFossil then
            log("Fossil : " .. fossilz)
        end
        if checkToxicWaste then
            if toxicwst == 0 then
                log("Toxic Waste : None ")
            else
                log("Toxic Waste : " .. toxicwst)
            end
        end
        if checkDoor then
            if getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 then 
                sendPacket(3,"action|join_request\nname|"..world:upper().."|"..doorFarm:upper().."\ninvitedWorld|0")
                sleep(3000)
                if getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 then 
                    doorText = " [ <:doorgt:1174565529135091752> Failed ]"
                    log("Door : Failed")
                else
                    doorText = " [ <:doorgt:1174565529135091752> Success ]"
                    log("Door : Success")
                end
            end
        end
        worldChecker("**"..world:upper().. "** [ <:treegt:1174568853091659827> Total : ".. plantedz .. " ] [ <:treegt:1174568853091659827> Ready : " .. readyz .. " ] [ <:fossilrockgt:1174565935231803414> : " .. fossilz.." ]"..doorText)
    else
        sleep(100)
        nuked = false
        sleep(1000)
        nukeWorldInfo(world:upper().." is nuked. @everyone")
        sleep(100)
        logNuke(world.." NUKED!")
    end
end
