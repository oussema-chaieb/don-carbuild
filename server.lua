local QBCore = exports['qb-core']:GetCoreObject()
projectcars = {}
CreateThread(function()
    local result = MySQL.Sync.fetchAll('SELECT * FROM don_cars', {})  
    if result and result[1] then
        for k,v in pairs(result) do
        projectcars[v.plate] = v
        end
    end
    GlobalState.ProjectCars = projectcars or {}
end)
for k,v in pairs(Config.parts) do
    QBCore.Functions.CreateUseableItem(k, function(source,item,data)
        local source = source
        local xPlayer = QBCore.Functions.GetPlayer(source)
        local item = item
        TriggerClientEvent('don-carbuild:client:useparts',source,k)
    end)
end
for k,v in pairs(Config.Paint) do
    QBCore.Functions.CreateUseableItem(v.item, function(source,item)
        local source = source
        local xPlayer = QBCore.Functions.GetPlayer(source)
        TriggerClientEvent('don-carbuild:client:usepaint',source,k)
        xPlayer.Functions.RemoveItem(v.item, 1)
    end)
end

local function AddOwnedVehicles(data,props,xPlayer)
    projectcars[data.plate] = nil
    GlobalState.ProjectCars = projectcars
    MySQL.query('DELETE FROM don_cars WHERE TRIM(UPPER(plate)) = ?',{data.plate})
    TriggerClientEvent('don-carbuild:client:updateprojectable',-1,data.plate)
    Wait(1000)
    if xPlayer then
        xPlayer.Functions.RemoveMoney("bank", Config.ligature)
        TriggerClientEvent('don-carbuild:client:spawnfinishproject',xPlayer.PlayerData.source,data,props)
    end
end

local function ProjectProgress(projectcars,props,xPlayer)
    local status = json.decode(projectcars.status)
    local done = true
    for k,v in pairs(status) do
        if type(v) == 'number' and v > 0 then
        done = false
        end
        if type(v) == 'table' then
        for k,v2 in pairs(v) do
            if v2 > 0 then
            done = false
            end
        end
        end
    end
    if done then
        AddOwnedVehicles(projectcars,props,xPlayer)
    end
end

local function UpdateProject(data,xPlayer,props)
    local plate_ = string.gsub(data.plate, '^%s*(.-)%s*$', '%1')
    local result = MySQL.Sync.fetchAll('SELECT * FROM don_cars WHERE TRIM(plate) = @plate', {['@plate'] = plate_})  
    if result[1] == nil then
        local newproject = {}
        for k,v in pairs(Config.parts) do
            if k == 'engine' or k == 'transmition' then
                newproject[k] = 1
            end
            if k == 'bonnet' and data.bonnet then
                newproject[k] = data.bonnet
            end
            if k == 'trunk' and data.trunk then
                newproject[k] = data.trunk
            end
            if k == 'exhaust' and data.exhaust then
                newproject[k] = data.exhaust
            end
            if k == 'wheel' and data.wheel then
                newproject[k] = data.wheel
            end
            if k == 'brake' and data.brake then
                newproject[k] = data.brake
            end
            if k == 'door' and data.seat then
                local doordata = {}
                for i = 0,3 do
                doordata[tostring(i)] = 1
                if data.seat == 2 and i == 2 or data.seat == 2 and i == 3 then
                    doordata[tostring(i)] = 0
                end
                end
                newproject[k] = doordata
            end
            if k == 'seat' and data.seat then
                local seatdata = {}
                for i = 0,data.seat-1 do
                seatdata[tostring(i-1)] = 1
                end
                newproject[k] = seatdata
            end
            if k == 'paint' and data.paint then
                newproject[k] = 1
            end
        end
        MySQL.insert('INSERT INTO don_cars (plate, identifier, paint, coord, model, status) VALUES (?, ?, ?, ?, ?, ?)', {
            plate_,
            xPlayer.PlayerData.citizenid,
            json.encode(data.paint) or '[]',
            json.encode(vector4(data.coord,data.heading)),
            data.model,
            json.encode(newproject)
        })
        projectcars[plate_] = {}
        projectcars[plate_].plate = plate_
        projectcars[plate_].model = data.model
        projectcars[plate_].paint = data.paint
        projectcars[plate_].identifier = xPlayer.identifier
        projectcars[plate_].coord = json.encode(vector4(data.coord,data.heading))
        projectcars[plate_].status = json.encode(newproject)
        projectcars[plate_].paint = json.encode(data.paint) or '[]'
        GlobalState.ProjectCars = projectcars
    elseif result[1] then
        local status = projectcars[plate_].status
        MySQL.update('UPDATE don_cars SET status = ?, paint = ? WHERE TRIM(plate) = ?', {status, projectcars[plate_].paint or '[]', plate_})
        TriggerClientEvent('don-carbuild:client:updatelocalproject',-1,projectcars[plate_])
        ProjectProgress(projectcars[plate_],props,xPlayer)
    end
end

RegisterNetEvent('don-carbuild:server:removeitem', function(item)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    xPlayer.Functions.RemoveItem(item, 1)
end)

RegisterNetEvent('don-carbuild:server:updateprojectcars', function(data,plate,props)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    GlobalState.ProjectCars = data
    projectcars = data
    UpdateProject(data[plate],xPlayer,props)
end)

RegisterNetEvent('don-carbuild:server:newproject', function(data)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    UpdateProject(data,xPlayer)
end)

RegisterNetEvent('don-carbuild:server:pay', function(data)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    xPlayer.Functions.AddMoney("bank", Config.ligature)
end)

RegisterNetEvent('don-carbuild:server:spawnshell', function(data)
    TriggerClientEvent('don-carbuild:client:newcar',source,data.model)
end)