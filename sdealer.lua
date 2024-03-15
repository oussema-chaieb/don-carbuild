-- Variables
local QBCore = exports['qb-core']:GetCoreObject()
local financetimer = {}

-- Functions
local function round(x)
    return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

local function GeneratePlate()
    local plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return GeneratePlate()
    else
        return plate:upper()
    end
end

local function comma_value(amount)
    local formatted = amount
    local k
    while true do
        formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1,%2')
        if (k == 0) then
            break
        end
    end
    return formatted
end

-- Callbacks
QBCore.Functions.CreateCallback('qb-vehicleshop:server:getVehicles', function(source, cb)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if player then
        local vehicles = MySQL.query.await('SELECT * FROM player_vehicles WHERE citizenid = ?', {player.PlayerData.citizenid})
        if vehicles[1] then
            cb(vehicles)
        end
    end
end)

QBCore.Functions.CreateCallback('qb-vehicleshop:server:checkstock', function(source, cb, car)
    local stock = nil
    MySQL.query('SELECT * FROM vehicle_stock ', function(db)
        stock = db
        for k, v in pairs(db) do
            if car == k then
                stock = v
            end
        end
    end)
    Wait(100)
    return cb(stock)
end)

QBCore.Functions.CreateCallback('qb-vehicleshop:server:getstock', function(source, cb, car)
    local result = MySQL.Sync.fetchScalar('SELECT stock FROM vehicle_stock WHERE car = ?', { car })
    if result then
        cb(tonumber(result))
    else
        cb(0)
    end
end)
-- Events

RegisterNetEvent('qb-vehicleshop:server:deleteVehicle', function (netId)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    DeleteEntity(vehicle)
end)

RegisterServerEvent('qb-vehicleshop:server:owncar', function(vehicle)
    local stock = nil
    local isthere = false
    local buycar = MySQL.query.await('SELECT * FROM vehicle_stock WHERE car = ?', { vehicle })
    for r, s in pairs(buycar) do
        if s.car == vehicle then
            stock = s.stock
            MySQL.query('UPDATE vehicle_stock SET stock = ? WHERE car = ?', {stock + 1 , vehicle})
            --print("updated", vehicle)
            --print(s.car, 'exists') 
            isthere = true
        end
    end
    if isthere then
        return
    else
       -- print('inserted', vehicle) 
        MySQL.insert('INSERT INTO vehicle_stock (car, stock) VALUES (?, ?)', { vehicle, 1 })
    end
end)

-- Sync vehicle for other players
RegisterNetEvent('qb-vehicleshop:server:swapVehicle', function(data)
    local src = source
    TriggerClientEvent('qb-vehicleshop:client:swapVehicle', -1, data)
    Wait(1500)-- let new car spawn
    TriggerClientEvent('qb-vehicleshop:client:homeMenu', src)-- reopen main menu
end)

-- Send customer for test drive
RegisterNetEvent('qb-vehicleshop:server:customTestDrive', function(vehicle, playerid)
    local src = source
    local target = tonumber(playerid)
    if not QBCore.Functions.GetPlayer(target) then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.Invalid_ID'), 'error')
        return
    end
    if #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(target))) < 3 then
        TriggerClientEvent('qb-vehicleshop:client:customTestDrive', target, vehicle)
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.playertoofar'), 'error')
    end
end)

-- Buy public vehicle outright
RegisterNetEvent('qb-vehicleshop:server:buyShowroomVehicle', function(vehicle)
    local src = source
    if vehicle.stock < 1 then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.outofstock'), 'error')
        return
    end
    vehicle = vehicle.buyVehicle
    local stock = vehicle.stock
    local pData = QBCore.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local cash = pData.PlayerData.money['cash']
    local bank = pData.PlayerData.money['bank']
    local vehiclePrice = QBCore.Shared.Vehicles[vehicle]['price']
    local plate = GeneratePlate()
    if cash > tonumber(vehiclePrice) then
        MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
            pData.PlayerData.license,
            cid,
            vehicle,
            GetHashKey(vehicle),
            '{}',
            plate,
            'pillboxgarage',
            0
        })
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.purchased'), 'success')
        TriggerClientEvent('qb-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        MySQL.execute('UPDATE vehicle_stock SET stock = ? WHERE car = ?', { stock - 1, vehicle })
        pData.Functions.RemoveMoney('cash', vehiclePrice, 'vehicle-bought-in-showroom')
        if Config.usejlcarboost then
            exports['jl-carboost']:AddVIN(plate)
        end
    elseif bank > tonumber(vehiclePrice) then
        MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
            pData.PlayerData.license,
            cid,
            vehicle,
            GetHashKey(vehicle),
            '{}',
            plate,
            'pillboxgarage',
            0
        })
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.purchased'), 'success')
        TriggerClientEvent('qb-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        MySQL.execute('UPDATE vehicle_stock SET stock = ? WHERE car = ?', { stock - 1, vehicle })
        pData.Functions.RemoveMoney('bank', vehiclePrice, 'vehicle-bought-in-showroom')
        if Config.usejlcarboost then
            exports['jl-carboost']:AddVIN(plate)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.notenoughmoney'), 'error')
    end
end)

-- Sell vehicle to customer
RegisterNetEvent('qb-vehicleshop:server:sellShowroomVehicle', function(data, playerid, remise, stock)
    local src = source
    if stock < 1 then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.outofstock'), 'error')
        return
    end
    local player = QBCore.Functions.GetPlayer(src)
    local target = QBCore.Functions.GetPlayer(tonumber(playerid))

    if not target then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.Invalid_ID'), 'error')
        return
    end

    if #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(target.PlayerData.source))) < 3 then
        local cid = target.PlayerData.citizenid
        local cash = target.PlayerData.money['cash']
        local bank = target.PlayerData.money['bank']
        local vehicle = data
        local prixx = QBCore.Shared.Vehicles[vehicle]['price']
        local vehiclePrice = prixx + (prixx * 0.3)
        local vehiclePriceAfterRemise = vehiclePrice * (1 - remise )
        local bossmenuMoney = vehiclePriceAfterRemise - prixx 
        local commission = round(bossmenuMoney * Config.Commission)
        local plate = GeneratePlate()
        if cash >= tonumber(vehiclePriceAfterRemise) then
            MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
                target.PlayerData.license,
                cid,
                vehicle,
                GetHashKey(vehicle),
                '{}',
                plate,
                'pillboxgarage',
                0
            })
            TriggerClientEvent('qb-vehicleshop:client:buyShowroomVehicle', target.PlayerData.source, vehicle, plate)
            target.Functions.RemoveMoney('cash', vehiclePriceAfterRemise, 'vehicle-bought-in-showroom')
            player.Functions.AddMoney('bank', commission)
            MySQL.execute('UPDATE vehicle_stock SET stock = ? WHERE car = ?', { stock - 1, vehicle })
            TriggerClientEvent('QBCore:Notify', src, Lang:t('success.earned_commission', {amount = comma_value(commission)}), 'success')
            if Config.management == "qb-bossmenu" then
                TriggerEvent('qb-bossmenu:server:addAccountMoney', player.PlayerData.job.name, bossmenuMoney)
            elseif Config.management == "qb-management" then
                exports['qb-management']:AddMoney(player.PlayerData.job.name, bossmenuMoney)
            end
            TriggerClientEvent('QBCore:Notify', target.PlayerData.source, Lang:t('success.purchased'), 'success')
            TriggerEvent('qb-log:server:CreateLog', 'invoices', 'vehicleshop', 'blue', '** new invoice with amount of :'.. amount)
            if Config.usejlcarboost then
                exports['jl-carboost']:AddVIN(plate)
            end
            if Config.useenvireceipts then
                exports['envi-receipts']:addToBill(src, vehicle, price)
                Wait(100)
                exports['envi-receipts']:giveBill(src, 1, true)
                Wait(500)
                exports['envi-receipts']:clearBill(src)
            end
        elseif bank >= tonumber(vehiclePriceAfterRemise) then
            MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
                target.PlayerData.license,
                cid,
                vehicle,
                GetHashKey(vehicle),
                '{}',
                plate,
                'pillboxgarage',
                0
            })
            TriggerClientEvent('qb-vehicleshop:client:buyShowroomVehicle', target.PlayerData.source, vehicle, plate)
            target.Functions.RemoveMoney('bank', vehiclePriceAfterRemise, 'vehicle-bought-in-showroom')
            player.Functions.AddMoney('bank', commission)
            MySQL.execute('UPDATE vehicle_stock SET stock = ? WHERE car = ?', { stock - 1, vehicle })
            if Config.management == "qb-bossmenu" then
                TriggerEvent('qb-bossmenu:server:addAccountMoney', player.PlayerData.job.name, bossmenuMoney)
            elseif Config.management == "qb-management" then
                exports['qb-management']:AddMoney(player.PlayerData.job.name, bossmenuMoney)
            end
            TriggerClientEvent('QBCore:Notify', src, Lang:t('success.earned_commission', {amount = comma_value(commission)}), 'success')
            TriggerClientEvent('QBCore:Notify', target.PlayerData.source, Lang:t('success.purchased'), 'success')
            TriggerEvent('qb-log:server:CreateLog', 'invoices', 'vehicleshop', 'blue', '** new invoice with amount of :'.. vehiclePriceAfterRemise)
            if Config.usejlcarboost then
                exports['jl-carboost']:AddVIN(plate)
            end
            if Config.useenvireceipts then
                exports['envi-receipts']:addToBill(src, vehicle, price)
                Wait(100)
                exports['envi-receipts']:giveBill(src, 1, true)
                Wait(500)
                exports['envi-receipts']:clearBill(src)
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t('error.notenoughmoney'), 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.playertoofar'), 'error')
    end
end)

RegisterServerEvent('qb-vehicleshop:server:givedocument', function(PlayerFirst, PlayerLast, Vehicle, Plate, id)
    local Player
    if id then
        Player = QBCore.Functions.GetPlayer(id)
    else
        Player = QBCore.Functions.GetPlayer(source)
    end
    info = {
        firstname = PlayerFirst,
        lastname = PlayerLast,
        vehicle = Vehicle,
        vehicleplate = Plate
    }
    if Player then
        Player.Functions.AddItem("vehicleproprety", 1, false, info)
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["vehicleproprety"], "add")
    end
end)

-- Transfer vehicle to player in passenger seat
QBCore.Commands.Add('transfervehicle', Lang:t('general.command_transfervehicle'), {{name = 'ID', help = Lang:t('general.command_transfervehicle_help')}, {name = 'amount', help = Lang:t('general.command_transfervehicle_amount')}}, false, function(source, args)
    local src = source
    local buyerId = tonumber(args[1])
    local sellAmount = tonumber(args[2])
    if buyerId == 0 then return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.Invalid_ID'), 'error') end
    local ped = GetPlayerPed(src)
    local targetPed = GetPlayerPed(buyerId)
    if targetPed == 0 then return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.buyerinfo'), 'error') end
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.notinveh'), 'error') end
    local plate = QBCore.Shared.Trim(GetVehicleNumberPlateText(vehicle))
    if not plate then return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.vehinfo'), 'error') end
    local player = QBCore.Functions.GetPlayer(src)
    local target = QBCore.Functions.GetPlayer(buyerId)
    local row = MySQL.single.await('SELECT * FROM player_vehicles WHERE plate = ?', {plate})
    if Config.PreventFinanceSelling then
        if row.balance > 0 then return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.financed'), 'error') end
    end
    if row.citizenid ~= player.PlayerData.citizenid then return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.notown'), 'error') end
    if #(GetEntityCoords(ped) - GetEntityCoords(targetPed)) > 5.0 then return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.playertoofar'), 'error') end
    local targetcid = target.PlayerData.citizenid
    local targetlicense = QBCore.Functions.GetIdentifier(target.PlayerData.source, 'license')
    if not target then return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.buyerinfo'), 'error') end
    -- local item = player.Functions.GetItemByName('vehicleproprety')
    -- local mod = GetHashKey(item.info.vehicle)

    -- if item then 
    --     if item.info.firstname == Player.PlayerData.charinfo.firstname and item.info.lastname == Player.PlayerData.charinfo.lastname and mod == model and item.info.vehicleplate == plate then
    --         player.Functions.RemoveItem('vehicleproprety', 1)
    --     else
    --         return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.vehinformation'), 'error') 
    --     end
    -- else
    --     return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.manquevehprop'), 'error') 
    -- end
    if not sellAmount then
        MySQL.update('UPDATE player_vehicles SET citizenid = ?, license = ? WHERE plate = ?', {targetcid, targetlicense, plate})
        --TriggerEvent('qb-vehicleshop:server:givedocument', target.PlayerData.charinfo.firstname, target.PlayerData.charinfo.lastname, vehicle, plate, buyerId)
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.gifted'), 'success')
        TriggerClientEvent('vehiclekeys:client:SetOwner', buyerId, plate)
        TriggerClientEvent('QBCore:Notify', buyerId, Lang:t('success.received_gift'), 'success')
        return
    end
    if target.Functions.GetMoney('cash') > sellAmount then
        MySQL.update('UPDATE player_vehicles SET citizenid = ?, license = ? WHERE plate = ?', {targetcid, targetlicense, plate})
        player.Functions.AddMoney('cash', sellAmount)
        target.Functions.RemoveMoney('cash', sellAmount)
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.soldfor') .. comma_value(sellAmount), 'success')
        TriggerClientEvent('vehiclekeys:client:SetOwner', buyerId, plate)
        TriggerClientEvent('QBCore:Notify', buyerId, Lang:t('success.boughtfor') .. comma_value(sellAmount), 'success')
    elseif target.Functions.GetMoney('bank') > sellAmount then
        MySQL.update('UPDATE player_vehicles SET citizenid = ?, license = ? WHERE plate = ?', {targetcid, targetlicense, plate})
        player.Functions.AddMoney('bank', sellAmount)
        target.Functions.RemoveMoney('bank', sellAmount)
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.soldfor') .. comma_value(sellAmount), 'success')
        TriggerClientEvent('vehiclekeys:client:SetOwner', buyerId, plate)
        TriggerClientEvent('QBCore:Notify', buyerId, Lang:t('success.boughtfor') .. comma_value(sellAmount), 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.buyertoopoor'), 'error')
    end
end)
