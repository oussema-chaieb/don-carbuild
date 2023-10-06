local QBCore = exports['qb-core']:GetCoreObject()
local spawnprojectcars = {}
local spawnprojectshell = {}
local PlayerData = {}
local blips = {}
local Useitem = {}
local benches_entites = {}
local inground = {}
local nuiopen = false
local near = false
local fetchdone = false
local playerLoaded = false
local spraying = false
local success = false
local finishdelivery = false
local deliverystart = false
local loaded = false
local UseBusy = false
local currentobject = nil
local standmodel , enginemodel = nil, nil
local target = nil
local abandonado = 0
local truckblip = nil
local deliveryblip = nil
local transport = nil
local trailertransport = nil
local hashh = 1246927682
local hashhh = "gr_prop_gr_tool_chest_01a"
local SucceededAttempts = 0
local NeededAttempts = 4
local spraycan = nil


RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
	PlayerData.job = job
	PlayerData.job.grade = PlayerData.job.grade.level
	playerjob = PlayerData.job.name
	inmark = false
	cancel = true
	markers = {}
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
	playerloaded = true
	QBCore.Functions.GetPlayerData(function(p)
		PlayerData = p
		if PlayerData.job ~= nil then
			PlayerData.job.grade = PlayerData.job.grade.level
		end
		if PlayerData.identifier == nil then
			PlayerData.identifier = PlayerData.license
		end
	end)
end)

local function getveh()
	local dist = 10.0
    local closest = 0
	for k,v in pairs(GetGamePool('CVehicle')) do
		local dis = #(GetEntityCoords(v) - GetEntityCoords(PlayerPedId()))
		if dis < dist 
		    or dist == -1 then
			closest = v
			dist = dis
		end
	end
	return closest, dist
end

local function Entergarage()
	local ped = PlayerPedId()
	Wait(500)
	DoScreenFadeOut(250)
	Wait(250)
	SetEntityCoords(ped, Config.Locations["inside"].x, Config.Locations["inside"].y, Config.Locations["inside"].z - 1)
	SetEntityHeading(ped, Config.Locations["inside"].w)
	Wait(1000)
	DoScreenFadeIn(250)
end

local function ExitGarage()
    local ped = PlayerPedId()
    Wait(500)
    DoScreenFadeOut(250)
    Wait(250)
    SetEntityCoords(ped, Config.Locations["outside"].x, Config.Locations["outside"].y, Config.Locations["outside"].z - 1)
    SetEntityHeading(ped, Config.Locations["outside"].w)
    Wait(1000)
    DoScreenFadeIn(250)
end

local function test()
	local p = promise.new() -- Do not touch
        exports['ps-ui']:Circle(function(success)
	            p:resolve(success)
				FreezeEntityPosition(PlayerPedId(), false)
				ClearPedTasks(PlayerPedId())
        end, math.random(4,7), math.random(7,15))
    return Citizen.Await(p) -- Do not touch
end

local function test3()
	local p = promise.new() -- Do not touch
	exports['ps-ui']:Thermite(function(success)
		p:resolve(success)
	 end, 10, 6, 3) -- Time, Gridsize (5, 6, 7, 8, 9, 10), IncorrectBlocks
    return Citizen.Await(p) -- Do not touch
end

local function test2(anim)
	local p = promise.new() -- Do not touch
	local ped = PlayerPedId()
	local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
	FreezeEntityPosition(ped, true)
	TriggerEvent('animations:client:EmoteCommandStart', {anim})
	Skillbar.Start({
		duration = math.random(4500, 10000),
		pos = math.random(10, 30),
		width = math.random(10, 20),
	}, function() 
		if SucceededAttempts + 1 >= NeededAttempts then
			SucceededAttempts = 0
			p:resolve(true) 
		else
			Skillbar.Repeat({
				duration = math.random(700, 1250),
				pos = math.random(10, 40),
				width = math.random(10, 13),
			})
			SucceededAttempts = SucceededAttempts + 1
		end
	end, function() 
		ClearPedTasks(PlayerPedId())
		SucceededAttempts = 0
		FreezeEntityPosition(ped, false)
		p:resolve(false) 
	end)
    return Citizen.Await(p) -- Do not touch
end

local function jeste(anim)
	if test() and test2(anim) and test() then
		return true
	else
		return false
	end
end

CreateThread(function()
	QBCore.Functions.GetPlayerData(function(p)
		PlayerData = p
		if PlayerData.job ~= nil then
			PlayerData.job.grade = PlayerData.job.grade.level
		end
		if PlayerData.identifier == nil then
			PlayerData.identifier = PlayerData.license
		end
	end)
	Wait(1000)
	while GlobalState.ProjectCars == nil do Wait(1000) end
	while true do
		while spraying do Wait(100) end
		SpawnProjectCars(GlobalState.ProjectCars)
		Wait(1000)
	end
end)

CreateThread(function()
	while not HasModelLoaded(hashh) do RequestModel(hashh); Wait(0); end
	obj = CreateObject(hashh,vector3(-1241.41, -2999.36, -49.49),true)
	SetModelAsNoLongerNeeded(hashh)
	SetEntityRotation(obj, vector3(0.0, 0.0, -90), 0.0, true)
	FreezeEntityPosition(obj, true)
	while not HasModelLoaded(hashhh) do RequestModel(hashhh); Wait(0); end
	obj2 = CreateObject(hashhh,vector3(-1271.41, -3049.52, -49.49),true)
	SetModelAsNoLongerNeeded(hashhh)
	SetEntityRotation(obj2, vector3(0.0, 0.0, 180.0), 0.0, true)
	FreezeEntityPosition(obj2, true)
end)

CreateThread(function()
	exports['qb-target']:AddCircleZone("dontest", Config.VehMenuCircleZone, 1.5,{
        name = "dontest",
        debugPoly = Config.DebugPoly,
        useZ=true
	},  {
        options = {
			{
                event = "don-carbuild:client:vehmenu",
                icon = Config.VehMenuTargetIcon,
                label = Config.VehMenuTargetLabel,
				job = Config.Job
            },
        },
        distance = 1.5
    })
	exports['qb-target']:AddBoxZone("donenter", Config.EnterTarget, 1.5, 1.5, {
        name="donenter",
        heading=Config.EnterHeading,
        debugPoly=Config.DebugPoly,
        minZ=Config.EnterTarget.z-1,
        maxZ=Config.EnterTarget.z+1
    }, {
        options = {{
            icon = Config.EnterTargetIcon,
            label = Config.EnterTargetLabel,
			action = function()
				Entergarage()
			end,
			job = Config.Job
        }},
        distance = 1.5
    })
	exports['qb-target']:AddBoxZone("donexit", Config.ExitTarget, 1.5, 1.5, {
        name="donexit",
        heading=Config.ExitHeading,
        debugPoly=Config.DebugPoly,
        minZ=Config.ExitTarget.z-1,
        maxZ=Config.ExitTarget.z+1
    }, {
        options = {{
            icon = Config.ExitTargetIcon,
            label = Config.ExitTargetLabel,
			action = function()
				ExitGarage()
			end,
        }},
        distance = 1.5
    })
end)

local spawn_bench = function(model, coord, rotation, label, event, args, hash)
	local modelHash
	model = model
	if model ~= "" then
		modelHash = GetHashKey(model)
	else
		modelHash = hash
	end

	if not HasModelLoaded(modelHash) then
		 RequestModel(modelHash)
		 while not HasModelLoaded(modelHash) do
			  Wait(10)
		 end
	end
	local entity = CreateObject(modelHash, coord, false)
	SetEntityAsMissionEntity(entity, true, true)
	while not DoesEntityExist(entity) do Wait(10) end
	SetEntityRotation(entity, rotation, 0.0, true)
	FreezeEntityPosition(entity, true)
	SetEntityProofs(entity, 1, 1, 1, 1, 1, 1, 1, 1)

	exports['qb-target']:AddTargetEntity(entity, {
		 options = { {
			  icon = "fas fa-sack-dollar",
			  label = label,
			  job = Config.Job,
			  action = function(entity)
				TriggerEvent(event,args)
		   	  end
		 }
		 },
		 distance = 1.5
	})

	return entity
end

local function Load_tables()
	if loaded then return end
	CreateThread(function()
		 for key, value in pairs(Config.workbenches) do
			  benches_entites[#benches_entites + 1] = spawn_bench(value.table_model, value.coords, value.rotation, value.label, value.event, value.args, value.hash)
		 end
		 loaded = true
	end)
end

local function ProjectCount()
	local c = 0
	for k,v in pairs(GlobalState.ProjectCars) do
		c = c + 1
	end
	return c
end

local SetVehicleProp = function(vehicle, props)
    if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleModKit(vehicle, 0)
		if props.sound then ForceVehicleEngineAudio(vehicle, props.sound) end
		if props.plate then SetVehicleNumberPlateText(vehicle, props.plate) end
		if props.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
		if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
		if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
		if props.tankHealth then SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0) end
		if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end
		if props.rgb then SetVehicleCustomPrimaryColour(vehicle, props.rgb[1], props.rgb[2], props.rgb[3]) end
		if props.rgb2 then SetVehicleCustomSecondaryColour(vehicle, props.rgb2[1], props.rgb2[2], props.rgb2[3]) end
		if props.color1 then SetVehicleColours(vehicle, props.color1, colorSecondary) end
		if props.color2 then SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2) end
		if props.pearlescentColor then SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor) end
		if props.wheelColor then SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor) end
		if props.wheels then SetVehicleWheelType(vehicle, props.wheels) end
		if props.windowTint then SetVehicleWindowTint(vehicle, props.windowTint) end

		if props.neonEnabled then
			SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
			SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
			SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
			SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
		end

		if props.extras then
			for extraId,enabled in pairs(props.extras) do
				if enabled then
					SetVehicleExtra(vehicle, tonumber(extraId), 0)
				else
					SetVehicleExtra(vehicle, tonumber(extraId), 1)
				end
			end
		end

		if props.neonColor then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end
		if props.xenonColor then SetVehicleXenonLightsColour(vehicle, props.xenonColor) end
		if props.modSmokeEnabled then ToggleVehicleMod(vehicle, 20, true) else ToggleVehicleMod(vehicle, 20, false) end
		if props.tyreSmokeColor then SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3]) end
		if props.modSpoilers then SetVehicleMod(vehicle, 0, props.modSpoilers, false) end
		if props.modFrontBumper then SetVehicleMod(vehicle, 1, props.modFrontBumper, false) end
		if props.modRearBumper then SetVehicleMod(vehicle, 2, props.modRearBumper, false) end
		if props.modSideSkirt then SetVehicleMod(vehicle, 3, props.modSideSkirt, false) end
		if props.modExhaust then SetVehicleMod(vehicle, 4, props.modExhaust, false) end
		if props.modFrame then SetVehicleMod(vehicle, 5, props.modFrame, false) end
		if props.modGrille then SetVehicleMod(vehicle, 6, props.modGrille, false) end
		if props.modHood then SetVehicleMod(vehicle, 7, props.modHood, false) end
		if props.modFender then SetVehicleMod(vehicle, 8, props.modFender, false) end
		if props.modRightFender then SetVehicleMod(vehicle, 9, props.modRightFender, false) end
		if props.modRoof then SetVehicleMod(vehicle, 10, props.modRoof, false) end
		if props.modEngine then SetVehicleMod(vehicle, 11, props.modEngine, false) end
		if props.modBrakes then SetVehicleMod(vehicle, 12, props.modBrakes, false) end
		if props.modTransmission then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
		if props.modHorns then SetVehicleMod(vehicle, 14, props.modHorns, false) end
		if props.modSuspension then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
		if props.modArmor then SetVehicleMod(vehicle, 16, props.modArmor, false) end
		if props.modTurbo then ToggleVehicleMod(vehicle,  18, props.modTurbo) else ToggleVehicleMod(vehicle,  18, false) end
		if props.modXenon then ToggleVehicleMod(vehicle,  22, props.modXenon) else ToggleVehicleMod(vehicle,  22, false) end
		if props.modFrontWheels then SetVehicleMod(vehicle, 23, props.modFrontWheels, false) end
		if props.modBackWheels then SetVehicleMod(vehicle, 24, props.modBackWheels, false) end
		if props.modPlateHolder then SetVehicleMod(vehicle, 25, props.modPlateHolder, false) end
		if props.modVanityPlate then SetVehicleMod(vehicle, 26, props.modVanityPlate, false) end
		if props.modTrimA then SetVehicleMod(vehicle, 27, props.modTrimA, false) end
		if props.modOrnaments then SetVehicleMod(vehicle, 28, props.modOrnaments, false) end
		if props.modDashboard then SetVehicleMod(vehicle, 29, props.modDashboard, false) end
		if props.modDial then SetVehicleMod(vehicle, 30, props.modDial, false) end
		if props.modDoorSpeaker then SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false) end
		if props.modSeats then SetVehicleMod(vehicle, 32, props.modSeats, false) end
		if props.modSteeringWheel then SetVehicleMod(vehicle, 33, props.modSteeringWheel, false) end
		if props.modShifterLeavers then SetVehicleMod(vehicle, 34, props.modShifterLeavers, false) end
		if props.modAPlate then SetVehicleMod(vehicle, 35, props.modAPlate, false) end
		if props.modSpeakers then SetVehicleMod(vehicle, 36, props.modSpeakers, false) end
		if props.modTrunk then SetVehicleMod(vehicle, 37, props.modTrunk, false) end
		if props.modHydrolic then SetVehicleMod(vehicle, 38, props.modHydrolic, false) end
		if props.modEngineBlock then SetVehicleMod(vehicle, 39, props.modEngineBlock, false) end
		if props.modAirFilter then SetVehicleMod(vehicle, 40, props.modAirFilter, false) end
		if props.modStruts then SetVehicleMod(vehicle, 41, props.modStruts, false) end
		if props.modArchCover then SetVehicleMod(vehicle, 42, props.modArchCover, false) end
		if props.modAerials then SetVehicleMod(vehicle, 43, props.modAerials, false) end
		if props.modTrimB then SetVehicleMod(vehicle, 44, props.modTrimB, false) end
		if props.modTank then SetVehicleMod(vehicle, 45, props.modTank, false) end
		if props.modWindows then SetVehicleMod(vehicle, 46, props.modWindows, false) end

		if props.modLivery then
			SetVehicleMod(vehicle, 48, props.modLivery, false)
			SetVehicleLivery(vehicle, props.modLivery)
		end
        if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) if DecorGetFloat(vehicle,'_FUEL_LEVEL') then DecorSetFloat(vehicle,'_FUEL_LEVEL',props.fuelLevel + 0.0) end end
	end
end

local function startAnim(ped, dictionary, anim)
	Citizen.CreateThread(function()
	  RequestAnimDict(dictionary)
	  while not HasAnimDictLoaded(dictionary) do
		Citizen.Wait(0)
	  end
		TaskPlayAnim(ped, dictionary, anim ,8.0, -8.0, -1, 50, 0, false, false, false)

		RequestAnimDict(dictionary)
		while not HasAnimDictLoaded(dictionary) do
		  Citizen.Wait(0)
		end
		  TaskPlayAnim(ped, dictionary, anim ,8.0, -8.0, -1, 50, 0, false, false, false)

		  RequestAnimDict(dictionary)
		  while not HasAnimDictLoaded(dictionary) do
			Citizen.Wait(0)
		  end
			TaskPlayAnim(ped, dictionary, anim ,8.0, -8.0, -1, 50, 0, false, false, false)
	end)
end

local function PreloadAnimation(dick)
	RequestAnimDict(dick)
    while not HasAnimDictLoaded(dick) do
        Citizen.Wait(0)
    end
end

local function GetNumSeat(vehicle)
    local c = 0
    for i=0-1, 7 do
        if IsVehicleSeatFree(vehicle,i) then
            c = c + 1
        end
    end
    return c
end

local function DrawText3Ds(pos, text)
	local onScreen,_x,_y=World3dToScreen2d(pos.x,pos.y,pos.z)

	if onScreen then
		SetTextScale(0.55, 0.55)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
	end
end
-- spawn items
local function SpawnItem(prop,xPos,yPos,zPos,xRot,yRot,zRot)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    PreloadAnimation("anim@heists@box_carry@")
    TaskPlayAnim(ped, "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
    currentobject = CreateObject(GetHashKey(prop), coords.x, coords.y, coords.z,  true,  true, true)
    AttachEntityToEntity(currentobject, ped, GetPedBoneIndex(ped, 56604), xPos,yPos,zPos,xRot,yRot,zRot, true, true, false, true, 1, true)
end

local function repairengine(plate,engine,reverse)
	vehicle  = getveh()
	local prop_stand = 'prop_engine_hoist'
	local prop_engine = 'prop_car_engine_01'
	if not engine then
		prop_engine = 'imp_prop_impexp_gearbox_01'
	end
	--
	Citizen.Wait(200)
	local bone = GetEntityBoneIndexByName(vehicle ,'bonnet')
	local d1,d2 = GetModelDimensions(GetEntityModel(vehicle ))
	local stand = GetOffsetFromEntityInWorldCoords(vehicle , 0.0,d2.y+0.4,0.0)
	local obj = nil

	local veh_heading = GetEntityHeading(vehicle )
	local veh_coord = GetEntityCoords(vehicle ,false)
	local x,y,z = table.unpack(GetWorldPositionOfEntityBone(vehicle , bone))
	local coordf = veh_coord + GetEntityForwardVector(vehicle ) * 3.0
	standmodel = CreateObject(GetHashKey(prop_stand),coordf,true,true,true)
	obj = standmodel
	standprop = obj
	SetEntityAsMissionEntity(obj, true, true)
	SetEntityCompletelyDisableCollision(obj,true,false)
	SetEntityNoCollisionEntity(vehicle , obj, false)
	SetEntityHeading(obj, GetEntityHeading(vehicle ))
	PlaceObjectOnGroundProperly(obj)
	FreezeEntityPosition(obj, true)
	SetEntityCollision(obj, false, true)
	while not DoesEntityExist(obj) do
		Citizen.Wait(100)
	end
	local d21 = GetModelDimensions(GetEntityModel(obj))
	local stand = GetOffsetFromEntityInWorldCoords(obj, 0.0,d21.y+0.2,0.0)
	Citizen.Wait(500)
	local engine_r = GetEntityBoneRotation(vehicle , bone)
	local z = 1.45
	if reverse then
		z = 0.0
	end
	enginemodel = CreateObject(GetHashKey(prop_engine),stand.x+0.27,stand.y-0.2,stand.z+z,true,true,true)
	SetEntityCompletelyDisableCollision(enginemodel,true,false)
	AttachEntityToEntity(enginemodel,vehicle ,GetEntityBoneIndexByName(vehicle ,'neon_f'),0.0,-0.45,z,0.0,90.0,0.0,true,false,false,false,70,true)
	carryModel2 = enginemodel
	engineprop = carryModel2
	SetEntityAsMissionEntity(engineprop, true, true)
	FreezeEntityPosition(carryModel2, true)
end

local function SetVehicleUpdate(type,index)
	local index = tonumber(index)
	local vehicle = getveh()
	local projectcars = GlobalState.ProjectCars
	plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1')
	if projectcars[plate] then
		local status = json.decode(projectcars[plate].status)
		local bonnet = status.bonnet
		local trunk = status.trunk
		local doors = status.door
		local seat = status.seat
		local wheel = status.wheel
		local brake = status.brake
		local engine = status.engine
		local tranny = status.transmition
		local exhaust = status.exhaust
		local paint = status.paint
		SetVehicleFixed(vehicle)
		if type == 'wheel' then
			wheel[tostring(index)] = 0
			for i = 0, 3 do
				local i = tonumber(i)
				
				SetVehicleWheelTireColliderSize(vehicle,i,0.4)
				--
				if wheel[tostring(i)] and wheel[tostring(i)] >= 1 then
					if i == index then
						
						wheel[tostring(i)] = wheel[tostring(i)] - 1
					end
					if i ~= index then
						SetVehicleWheelTireColliderSize(vehicle, i, -5.0)
						
					end
				end
			end
		end
		
		if type == 'door' then
			doors[tostring(index)] = 0
			for i = 0, 7 do
				local i = tonumber(i)
				if status.door[tostring(i)] and status.door[tostring(i)] >= 1 then
					if i == index then
						status.door[tostring(i)] = status.door[tostring(i)] - 1
					end
					if i ~= index then
						SetVehicleDoorBroken(vehicle, i, true)
						
					end
				end
			end
		end
		
		if type == 'bonnet' then
			bonnet = 0
		elseif type == 'bonnet' and bonnet == 1 then
			SetVehicleDoorBroken(vehicle, 4, true)		
		end
		if type == 'trunk' then
			trunk = 0
		elseif type == 'trunk' and trunk == 1 then
			SetVehicleDoorBroken(vehicle, 5, true)	
		end
		if type == 'seat' then
			seat[tostring(index)] = 0
		end
		if type == 'brake' then
			brake[tostring(index)] = 0
		end
		if type == 'engine' then
			engine = 0
		end
		if type == 'transmition' then
			tranny = 0
		end
		if type == 'exhaust' then
			exhaust = 0
		end
		local props = GetVehicleProperties(vehicle)
		if type == 'paint' then
			paint = 0
			projectcars[plate].paint = json.encode(props.rgb)
			--print(projectcars[plate].paint)
		end

		status.wheel = wheel
		status.bonnet = bonnet
		status.trunk = trunk
		status.door = doors
		status.seat = seat
		status.brake = brake
		status.engine = engine
		status.transmition = tranny
		status.exhaust = exhaust
		status.paint = paint
		projectcars[plate].status = json.encode(status)
		TriggerServerEvent('don-carbuild:server:updateprojectcars',projectcars,plate,props)
	end
end

-- installation
local function InstallExhaust()
    local ped = PlayerPedId()
	local vehicle = getveh()
	success = false
	local bone = GetEntityBoneIndexByName(vehicle,'exhaust') ~= -1 or GetEntityBoneIndexByName(vehicle,'boot')
	local projectcars = GlobalState.ProjectCars
	
	plate = string.gsub(tostring(GetVehicleNumberPlateText(vehicle)), '^%s*(.-)%s*$', '%1')
	local status = json.decode(projectcars[plate].status or '[]') or {}
	local x,y,z = table.unpack(GetWorldPositionOfEntityBone(vehicle, bone))
	if vehicle ~= 0 and #(GetEntityCoords(ped) - vector3(x,y,z)) <= 10 then
		
		SetVehicleUpdate('exhaust',0)
		success = true
	else
		QBCore.Functions.Notify(Lang:t('error.toofar'),"error")
	end
    DeleteObject(exhaust)
    ClearPedTasks(ped)
end

local function InstallDoor(id)
    local ped = PlayerPedId()
	local nearestdoor = 10
	success = false
	local projectcars = GlobalState.ProjectCars
	local vehicle = getveh()
	plate = string.gsub(tostring(GetVehicleNumberPlateText(vehicle)), '^%s*(.-)%s*$', '%1')
	local status = json.decode(projectcars[plate].status)
	local seat = status.seat
	local door = status.door
	local reason = 'far'
	local dist = -1
	for i = 0, 7 do
		local doors = GetEntryPositionOfDoor(vehicle,i)
		
		if doors.x ~= 0.0 then
			local dis = #(GetEntityCoords(PlayerPedId()) - doors)
			if dist == -1 and door[tostring(i)] and door[tostring(i)] > 0 and dist < 4 or dist >= dis and door[tostring(i)] and door[tostring(i)] > 0 then
				dist = dis
				nearestdoor = i
			end
		end
	end
	if seat[tostring(nearestdoor-1)] and seat[tostring(nearestdoor-1)] <= 0 and door[tostring(nearestdoor)] > 0 and dist < 3 then
		success = true

	elseif seat[tostring(nearestdoor-1)] and seat[tostring(nearestdoor-1)] > 0 and door[tostring(nearestdoor)] > 0 then
		reason = 'seat'
		success = false
	elseif seat[tostring(nearestdoor-1)] and seat[tostring(nearestdoor-1)] <= 0 and door[tostring(nearestdoor)] <= 0 then
		reason = 'alreadyinstall'
		--break
	end
	if success then
		
		SetVehicleUpdate('door',nearestdoor)
	elseif reason == 'seat' then
		QBCore.Functions.Notify(Lang:t('error.install_sit_first'),"error")
		
	elseif reason == 'alreadyinstall' then
		QBCore.Functions.Notify(Lang:t('error.allreadyinstalled'),"error")
	else
		QBCore.Functions.Notify(Lang:t('error.toofar'),"error")
	end
	DeleteObject(currentobject)
	ClearPedTasks(ped)
end

local function InstallTrunk()
    local ped = PlayerPedId()
	local vehicle = getveh()
	success = false
	local bone = GetEntityBoneIndexByName(vehicle,'boot')
	local projectcars = GlobalState.ProjectCars
	
	plate = string.gsub(tostring(GetVehicleNumberPlateText(vehicle)), '^%s*(.-)%s*$', '%1')
	local status = json.decode(projectcars[plate].status or '[]') or {}
	local x,y,z = table.unpack(GetWorldPositionOfEntityBone(vehicle, bone))
	
	if vehicle ~= 0 and #(GetEntityCoords(ped) - vector3(x,y,z)) <= 4 then
		
		SetVehicleUpdate('trunk',0)
		success = true
	elseif status.engine == 1 then
		QBCore.Functions.Notify(Lang:t('error.install_engine_first'),"error")
	elseif status.transmition == 1 then
		QBCore.Functions.Notify(Lang:t('error.install_transmission_first'),"error")
	end
    DeleteObject(trunk)
    ClearPedTasks(ped)
end

local function InstallSeat()
    local ped = PlayerPedId()
	local nearestseat = 10
	success = false
	local projectcars = GlobalState.ProjectCars
	local vehicle = getveh()
	plate = string.gsub(tostring(GetVehicleNumberPlateText(vehicle)), '^%s*(.-)%s*$', '%1')
	local status = json.decode(projectcars[plate].status)
	local seat = status.seat
	local alreadyinstall = false
	local dist = -1
	for i = 0, 4 do
		local doors = GetEntryPositionOfDoor(getveh(),i)
		if doors.x ~= 0.0 then
			local i = i - 1
			local dis = #(GetEntityCoords(PlayerPedId()) - doors)
			if dist == -1 and seat[tostring(i)] and seat[tostring(i)] > 0 and dis < 3 or dist >= dis and seat[tostring(i)] and seat[tostring(i)] > 0 then
				dist = dis
				nearestseat = i
			elseif seat[tostring(i)] and seat[tostring(i)] <= 0 then
				alreadyinstall = true
			end
		end
	end
	
	if seat[tostring(nearestseat)] and seat[tostring(nearestseat)] > 0 and dist < 2 then
		success = true
	elseif seat[tostring(i)] and seat[tostring(i)] <= 0 and dist < 2 then
		alreadyinstall = true
	end
	if success then
		SetVehicleUpdate('seat',nearestseat)
	elseif alreadyinstall then
		QBCore.Functions.Notify(Lang:t('error.allreadyinstalled'),"error")
	end
	DeleteObject(currentobject)
	ClearPedTasks(ped)
end

local function InstallBonnet()
    local ped = PlayerPedId()
	local index = tonumber(index)
	local vehicle = getveh()
	success = false
	local bone = GetEntityBoneIndexByName(vehicle,'bonnet')
	
	local projectcars = GlobalState.ProjectCars
	plate = string.gsub(tostring(GetVehicleNumberPlateText(vehicle)), '^%s*(.-)%s*$', '%1')
	local status = json.decode(projectcars[plate].status or '[]') or {}
	local x,y,z = table.unpack(GetWorldPositionOfEntityBone(vehicle, bone))
	
	if vehicle ~= 0 and status.engine == 0 and status.transmition == 0 and #(GetEntityCoords(ped) - vector3(x,y,z)) <= 4.0 then
		SetVehicleUpdate('bonnet',0)
		success = true
	elseif status.engine == 1 then
		QBCore.Functions.Notify(Lang:t('error.install_engine_first'),"error")
	elseif status.transmition == 1 then
		QBCore.Functions.Notify(Lang:t('error.install_transmission_first'),"error")
	end
    DeleteObject(bonnet)
    ClearPedTasks(ped)
end

local function InstallBrake()
	local nearestwheel = 10
    local ped = PlayerPedId()
	local coord = GetEntityCoords(ped)-vec3(0,0,5.0)
	local vehicle = getveh()
	local bones = {
		[0] = 'wheel_lf',
		[1] = 'wheel_rf',
		[2] = 'wheel_lr',
		[3] = 'wheel_rr'
	}
	success = false
	local projectcars = GlobalState.ProjectCars
	plate = string.gsub(tostring(GetVehicleNumberPlateText(vehicle)), '^%s*(.-)%s*$', '%1')
	local status = json.decode(projectcars[plate].status)
	local wheelob = status.wheel
	local brake = status.brake
	local status = false
	local alreadyinstall = false
	local dist = -1
	for k,v in pairs(bones) do
		local wheelworldpos = GetWorldPositionOfEntityBone(vehicle,GetEntityBoneIndexByName(vehicle,v))
		local wheelpos = GetOffsetFromEntityGivenWorldCoords(vehicle, wheelworldpos.x, wheelworldpos.y, wheelworldpos.z)
		
		local wheelcoord = #(coord - wheelworldpos)
		if dist == -1  and wheelcoord < 3 or dist >= wheelcoord then
			nearestwheel = k
			dist = wheelcoord
		end
	end
	
	if dist > -1 and wheelob[tostring(nearestwheel)] and wheelob[tostring(nearestwheel)] >= 0 and brake[tostring(nearestwheel)] and brake[tostring(nearestwheel)] > 0 and dist < 2 then
		status = true
		success = true
	elseif brake[tostring(nearestwheel)] and brake[tostring(nearestwheel)] <= 0 and dist < 2 or dist == -1 then
		alreadyinstall = true
	end
	
	if status then
		SetVehicleUpdate('brake',nearestwheel)
	elseif alreadyinstall then
		QBCore.Functions.Notify(Lang:t('error.allreadyinstalled'),"error")
	else
		QBCore.Functions.Notify(Lang:t('error.toofar'),"error")
	end
    DeleteObject(wheel)
    ClearPedTasks(ped)
end

local function InstallWheel()
	local nearestwheel = 10
    local ped = PlayerPedId()
	local coord = GetEntityCoords(ped)-vec3(0,0,5.0)
	local vehicle = getveh()
	local bones = {
		[0] = 'wheel_lf',
		[1] = 'wheel_rf',
		[2] = 'wheel_lr',
		[3] = 'wheel_rr'
	}
	local projectcars = GlobalState.ProjectCars
	plate = string.gsub(tostring(GetVehicleNumberPlateText(vehicle)), '^%s*(.-)%s*$', '%1')
	local status = json.decode(projectcars[plate].status)
	local wheelob = status.wheel
	local brake = status.brake
	success = false
	local alreadyinstall = false
	local installbreak = false
	local dist = -1
	for k,v in pairs(bones) do
		local wheelworldpos = GetWorldPositionOfEntityBone(vehicle,GetEntityBoneIndexByName(vehicle,v))
		local wheelpos = GetOffsetFromEntityGivenWorldCoords(vehicle, wheelworldpos.x, wheelworldpos.y, wheelworldpos.z)
		--
		local wheelcoord = #(coord - wheelworldpos)
		
		
		if dist == -1 and wheelob[tostring(k)] and wheelob[tostring(k)] >= 1 and wheelcoord < 3 or dist >= wheelcoord and wheelob[tostring(k)] and wheelob[tostring(k)] >= 1 then
			dist = wheelcoord
			nearestwheel = k
		end
	end
	
	if brake[tostring(nearestwheel)] and brake[tostring(nearestwheel)] <= 0 and wheelob[tostring(nearestwheel)] and wheelob[tostring(nearestwheel)] >= 1 and dist < 2 then
		success = true
	elseif brake[tostring(nearestwheel)] and brake[tostring(nearestwheel)] >= 1 and dist < 2 then
		installbreak = true
	elseif wheelob[tostring(nearestwheel)] and wheelob[tostring(nearestwheel)] <= 0 and dist < 2 then
		alreadyinstall = true
		--break
	elseif wheelob[tostring(nearestwheel)] and wheelob[tostring(nearestwheel)] <= 0 then
		alreadyinstall = true
		--break
	end
	
	if success then
		
		SetVehicleUpdate('wheel',nearestwheel)
	elseif installbreak then
		QBCore.Functions.Notify(Lang:t('error.install_brake_first'),"error")
	elseif alreadyinstall then
		QBCore.Functions.Notify(Lang:t('error.allreadyinstalled'),"error")
	else
		QBCore.Functions.Notify(Lang:t('error.toofar'),"error")
	end
	DeleteObject(wheel)
	ClearPedTasks(ped)
end

local function playanimation(animDict,name)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do 
		Wait(1)
		RequestAnimDict(animDict)
	end
	TaskPlayAnim(PlayerPedId(), animDict, name, 2.0, 2.0, -1, 47, 0, 0, 0, 0)
end

local function SpawnEngine(engine,reverse)
	success = false
	local vehicle = getveh()
	local ped = PlayerPedId()
	local bone = GetEntityBoneIndexByName(vehicle,'bonnet')
	if bone == -1 then
		bone = GetEntityBoneIndexByName(vehicle,'engine')
	end
	if bone == -1 then
		bone = GetEntityBoneIndexByName(vehicle,'wheel_rf')
	end
	local x,y,z = table.unpack(GetWorldPositionOfEntityBone(vehicle, bone))
	--print(vehicle, #(GetEntityCoords(ped) - vector3(x,y,z)))
	if vehicle ~= 0 and #(GetEntityCoords(ped) - vector3(x,y,z)) <= 10 then
		busy_install = true
		plate = tostring(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1')
		Citizen.Wait(2000)
		playanimation('creatures@rottweiler@tricks@','petting_franklin')
		Wait(2500)
		ClearPedTasks(ped)
		Wait(200)
		installing = true
		if installing then
			repairengine(plate,engine,reverse)
		end
		engine_c = GetOffsetFromEntityInWorldCoords(enginemodel)
		standProp = GetOffsetFromEntityInWorldCoords(standmodel)
		local count = 25
		DetachEntity(enginemodel)
		while installing do
			DrawText3Ds(standProp+vec3(0.0,0.0,2.0), 'Press ⬆️ - ⬇️ to Pull') 
			if IsControlJustReleased(1, 173) then
				SetEntityCoords(enginemodel,engine_c.x,engine_c.y,engine_c.z - 0.05)
				engine_c = GetOffsetFromEntityInWorldCoords(enginemodel)
				count = not reverse and count - 1 or count + 1
			end
			if IsControlJustReleased(1, 172) then
				SetEntityCoords(enginemodel,engine_c.x,engine_c.y,engine_c.z + 0.05)
				engine_c = GetOffsetFromEntityInWorldCoords(enginemodel)
				count = not reverse and count + 1 or count - 1
			end
			if count <= 0 then
				installing = false
				busy_install = false
				break
			end
			Wait(0)
		end
		playanimation('creatures@rottweiler@tricks@','petting_franklin')
		Wait(10000)
		busy_install = false
		installing = false
		DeleteEntity(enginemodel)
		DeleteEntity(standmodel)
		ClearPedTasks(ped)
		if not reverse then
			SetVehicleUpdate(engine and 'engine' or 'transmition',0)
		end
		success = true
	else
		success = false
		QBCore.Functions.Notify(Lang:t('error.toofar'),"error")
	end
end

GetVehicleProperties = function(vehicle)
    if DoesEntityExist(vehicle) then
        if DoesEntityExist(vehicle) then
            local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
            local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
            local extras = {}
            for extraId=0, 12 do
                if DoesExtraExist(vehicle, extraId) then
                    local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
                    extras[tostring(extraId)] = state
                end
            end
            local plate = GetVehicleNumberPlateText(vehicle)
			plate = string.gsub(tostring(GetVehicleNumberPlateText(vehicle)), '^%s*(.-)%s*$', '%1')
            local modlivery = GetVehicleLivery(vehicle)
            if modlivery == -1 then
                modlivery = GetVehicleMod(vehicle, 48)
            end
            return {
                model             = GetEntityModel(vehicle),
                plate             = plate,
                plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

                bodyHealth        = MathRound(GetVehicleBodyHealth(vehicle), 1),
                engineHealth      = MathRound(GetVehicleEngineHealth(vehicle), 1),
                tankHealth        = MathRound(GetVehiclePetrolTankHealth(vehicle), 1),

                fuelLevel         = MathRound(GetVehicleFuelLevel(vehicle), 1),
                dirtLevel         = MathRound(GetVehicleDirtLevel(vehicle), 1),
                color1            = colorPrimary,
                color2            = colorSecondary,
                rgb				  = table.pack(GetVehicleCustomPrimaryColour(vehicle)),
                rgb2				  = table.pack(GetVehicleCustomSecondaryColour(vehicle)),
                pearlescentColor  = pearlescentColor,
                wheelColor        = wheelColor,

                wheels            = GetVehicleWheelType(vehicle),
                windowTint        = GetVehicleWindowTint(vehicle),
                xenonColor        = GetVehicleXenonLightsColour(vehicle),

                neonEnabled       = {
                    IsVehicleNeonLightEnabled(vehicle, 0),
                    IsVehicleNeonLightEnabled(vehicle, 1),
                    IsVehicleNeonLightEnabled(vehicle, 2),
                    IsVehicleNeonLightEnabled(vehicle, 3)
                },

                neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
                extras            = extras,
                tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

                modSpoilers       = GetVehicleMod(vehicle, 0),
                modFrontBumper    = GetVehicleMod(vehicle, 1),
                modRearBumper     = GetVehicleMod(vehicle, 2),
                modSideSkirt      = GetVehicleMod(vehicle, 3),
                modExhaust        = GetVehicleMod(vehicle, 4),
                modFrame          = GetVehicleMod(vehicle, 5),
                modGrille         = GetVehicleMod(vehicle, 6),
                modHood           = GetVehicleMod(vehicle, 7),
                modFender         = GetVehicleMod(vehicle, 8),
                modRightFender    = GetVehicleMod(vehicle, 9),
                modRoof           = GetVehicleMod(vehicle, 10),

                modEngine         = GetVehicleMod(vehicle, 11),
                modBrakes         = GetVehicleMod(vehicle, 12),
                modTransmission   = GetVehicleMod(vehicle, 13),
                modHorns          = GetVehicleMod(vehicle, 14),
                modSuspension     = GetVehicleMod(vehicle, 15),
                modArmor          = GetVehicleMod(vehicle, 16),

                modTurbo          = IsToggleModOn(vehicle, 18),
                modSmokeEnabled   = IsToggleModOn(vehicle, 20),
                modXenon          = IsToggleModOn(vehicle, 22),

                modFrontWheels    = GetVehicleMod(vehicle, 23),
                modBackWheels     = GetVehicleMod(vehicle, 24),

                modPlateHolder    = GetVehicleMod(vehicle, 25),
                modVanityPlate    = GetVehicleMod(vehicle, 26),
                modTrimA          = GetVehicleMod(vehicle, 27),
                modOrnaments      = GetVehicleMod(vehicle, 28),
                modDashboard      = GetVehicleMod(vehicle, 29),
                modDial           = GetVehicleMod(vehicle, 30),
                modDoorSpeaker    = GetVehicleMod(vehicle, 31),
                modSeats          = GetVehicleMod(vehicle, 32),
                modSteeringWheel  = GetVehicleMod(vehicle, 33),
                modShifterLeavers = GetVehicleMod(vehicle, 34),
                modAPlate         = GetVehicleMod(vehicle, 35),
                modSpeakers       = GetVehicleMod(vehicle, 36),
                modTrunk          = GetVehicleMod(vehicle, 37),
                modHydrolic       = GetVehicleMod(vehicle, 38),
                modEngineBlock    = GetVehicleMod(vehicle, 39),
                modAirFilter      = GetVehicleMod(vehicle, 40),
                modStruts         = GetVehicleMod(vehicle, 41),
                modArchCover      = GetVehicleMod(vehicle, 42),
                modAerials        = GetVehicleMod(vehicle, 43),
                modTrimB          = GetVehicleMod(vehicle, 44),
                modTank           = GetVehicleMod(vehicle, 45),
                modWindows        = GetVehicleMod(vehicle, 46),
                modLivery         = modlivery
            }
        else
            return
        end
    end
end

local function RestoreItem(use)
	DeleteObject(currentobject)
	ClearPedTasks(PlayerPedId())
	UseBusy = false
	if use and success then
		TriggerServerEvent('don-carbuild:server:removeitem',use)
        QBCore.Functions.Notify(Lang:t('success.partinstalled'),"success")
	end
end

local function GetNearestProjectCar(projectcar)
	local projectcars = projectcar or GlobalState.ProjectCars
	local nearestdist,data = -1, nil
	for k,v in pairs(projectcars) do
		local coord = json.decode(v.coord)
		local t = {
			status = json.decode(v.status),
			coord = vector3(coord.x,coord.y,coord.z),
			heading = coord.w,
			model = v.model,
			paint = v.paint,
			plate = v.plate
		}
		local dist = #(GetEntityCoords(PlayerPedId()) - vector3(coord.x,coord.y,coord.z))
		if nearestdist == -1 and dist < 300 or nearestdist >= dist then
			nearestdist = dist
			data = t
		end
	end
	return nearestdist,data
end

Useitem['bonnet'] = function()
	if UseBusy then return end
	UseBusy = true
	SpawnItem('imp_prop_impexp_bonnet_02a',0.0, 0.75, 0.45, 2.0, 0.0, 0.0)
	local install = true
	local use = false
    local projectcars = GlobalState.ProjectCars
	local data = nil
	local dist = -1
	local radius = 5000
	local vehicle = nil
	CreateThread(function()
		while install do
			Wait(300)
			dist, data = GetNearestProjectCar(projectcars)
			vehicle = getveh() 
		end
		return
	end)
    while install and ProjectCount() > 0 do
		dist, data = GetNearestProjectCar()
		if data and dist ~= -1 and dist < radius and install then
			while data and dist < radius and install do
				if dist < 4 then
					local bone = GetEntityBoneIndexByName(vehicle,'engine')
					local coordbone = GetWorldPositionOfEntityBone(vehicle, bone)
					DrawText3Ds(coordbone, '[~b~E~w~] - Install Bonnet') 
					if IsControlPressed(0,38) then
						if jeste("mechanic2") then
							InstallBonnet()
						else
							QBCore.Functions.Notify(Lang:t('error.fail'),'error')
						end
						install = false
						use = 'bonnet'
						DeleteObject(currentobject)
						Wait(100)
						break
					end
				end
				if IsControlPressed(0,73) then
					install = false
					Wait(100)
					break
				end
				dist = #(GetEntityCoords(PlayerPedId()) - data.coord)
				Wait(0)
			end
		end
		install = false
		Wait(1000)
	end
	RestoreItem(use)
end

Useitem['trunk'] = function()
	if UseBusy then return end
	UseBusy = true
	SpawnItem('imp_prop_impexp_trunk_01a',0.0, 0.40, 0.1, 0.0, 0.0, 180.0)
	local install = true
	local use = false
    local projectcars = GlobalState.ProjectCars
	local data = nil
	local dist = -1
	local radius = 5000
	local vehicle = nil
	CreateThread(function()
		while install do
			Wait(300)
			dist, data = GetNearestProjectCar(projectcars)
			vehicle = getveh() 
		end
		return
	end)
    while install and ProjectCount() > 0 do
		dist, data = GetNearestProjectCar()
		olddata = data
		if data and dist < radius and install then
			while dist < radius and install do
				dist, data = GetNearestProjectCar()
				local trunk = tonumber(data.status.trunk)
				if dist < 4 and trunk == 1 then
					local bone = GetEntityBoneIndexByName(vehicle,'taillight_l')
					local coordbone = GetWorldPositionOfEntityBone(vehicle, bone)
					DrawText3Ds(coordbone, '[~b~E~w~] - Install Trunk '..bone)
					if IsControlPressed(0,38) then
						if jeste("mechanic2") then
							InstallTrunk()
						else
							QBCore.Functions.Notify(Lang:t('error.fail'),"error")
						end
						install = false
						use = 'trunk'
						DeleteObject(currentobject)
						Wait(100)
						break
					end
				end
				if IsControlPressed(0,73) then
					install = false
					Wait(100)
					break
				end
				dist = #(GetEntityCoords(PlayerPedId()) - data.coord)
				Wait(0)
			end
		end
		install = false
		Wait(1000)
	end
	RestoreItem(use)
end

Useitem['door'] = function()
	if UseBusy then return end
	UseBusy = true
	SpawnItem('prop_car_door_01',0.1, 0.40, -0.65, 0.0, 0.0, 180.0)
	local install = true
	local use = false
	local projectcars = GlobalState.ProjectCars
	local data = nil
	local dist = -1
	local radius = 300
	local vehicle = nil
	CreateThread(function()
		while install do
			Wait(300)
			dist, data = GetNearestProjectCar(projectcars)
			vehicle = getveh() 
		end
		return
	end)
	vehicle = getveh() 
	plate = string.gsub(tostring(GetVehicleNumberPlateText(vehicle)), '^%s*(.-)%s*$', '%1')
	local status = json.decode(projectcars[plate].status)
    while install and ProjectCount() > 0 do
		dist, data = GetNearestProjectCar()
		if data and dist < radius and install then
			local doors = {}
			local doors2 = {
				'seat_dside_f',
				'seat_dside_r',
				'seat_pside_f',
				'seat_pside_r'
			}
			local door = data.status.door
			local numseat = GetNumSeat(vehicle)
			if numseat == 2 then
				for k,v in pairs(doors2) do
					if k == 1 or k == 3 then
						table.insert(doors,v)
					end
				end
			else
				doors = doors2
			end
			while data and dist < radius and install do
				if dist < 4 then
					doors = {}
					door = data.status.door
					local numseat = GetNumSeat(vehicle)
					if numseat == 2 then
						for k,v in pairs(doors2) do
							if k == 1 or k == 3 then
								table.insert(doors,v)
							end
						end
					else
						doors = doors2
					end
					local closest = nil
					local dist = -1
					local mycoord = GetEntityCoords(PlayerPedId())
					for k,v in pairs(doors) do
						local bone = GetEntityBoneIndexByName(vehicle,v)
						local coordbone = GetWorldPositionOfEntityBone(vehicle, bone)
						if bone ~= -1 and tonumber(door[tostring(k-1)]) == 1 then
							DrawText3Ds(coordbone, '[~b~E~w~] - Install Door')
						end
					end
					if IsControlPressed(0,38) then
						if jeste("pull") then
							InstallDoor(closest)
						else
							QBCore.Functions.Notify(Lang:t('error.fail'),"error")
						end
						install = false
						use = 'door'
						DeleteObject(currentobject)
						Wait(100)
						break
					end
				end
				if IsControlPressed(0,73) then
					install = false
					Wait(100)
					break
				end
				dist = #(GetEntityCoords(PlayerPedId()) - data.coord)
				Wait(0)
			end
		end
		install = false
		Wait(1000)
	end
	RestoreItem(use)
end

Useitem['wheel'] = function()
	if UseBusy then return end
	UseBusy = true
	SpawnItem('prop_wheel_01',-0.08, 0.30, 0.37, 0.0, 0.0, 180.0)
	local install = true
	local use = false
    local projectcars = GlobalState.ProjectCars
	local data = nil
	local dist = -1
	local radius = 8000
	local vehicle = nil
	CreateThread(function()
		while install do
			Wait(300)
			dist, data = GetNearestProjectCar(projectcars)
			vehicle = getveh() 
		end
		return
	end)
    while install and ProjectCount() > 0 do
		dist, data = GetNearestProjectCar()
		if data and dist < radius and install then
			local doors = {
				'wheel_lf',
				'wheel_rf',
				'wheel_lr',
				'wheel_rr'
			}
			local wheel = data.status.wheel
			while dist < radius and install do
				if dist < 4 then
					for k,v in pairs(doors) do
						local bone = GetEntityBoneIndexByName(vehicle,v)
						local coordbone = GetWorldPositionOfEntityBone(vehicle, bone)
						if bone ~= -1 and wheel[tostring(k-1)] == 1 then
							DrawText3Ds(coordbone+vec3(0.0,0.0,5.5), '[~b~E~w~] - Install Wheel')
						end
					end
					if IsControlPressed(0,38) then
						if jeste("mechanic4") then
							InstallWheel()
						else
							QBCore.Functions.Notify(Lang:t('error.fail'),"error")
						end
						install = false
						DeleteObject(currentobject)
						use = 'wheel'
						Wait(100)
						break
					end
				end
				if IsControlPressed(0,73) then
					install = false
					Wait(100)
					break
				end
				dist = #(GetEntityCoords(PlayerPedId()) - data.coord)
				Wait(0)
			end
		end
		install = false
		Wait(1000)
	end
	RestoreItem(use)
end

Useitem['exhaust'] = function()
	if UseBusy then return end
	UseBusy = true
	SpawnItem('imp_prop_impexp_exhaust_01',-0.08, 0.30, 0.37, 0.0, 0.0, 180.0)
	local install = true
	local use = false
    local projectcars = GlobalState.ProjectCars
	local data = nil
	local dist = -1
	local radius = 500
	local vehicle = nil
	CreateThread(function()
		while install do
			Wait(300)
			dist, data = GetNearestProjectCar(projectcars)
			vehicle = getveh() 
		end
		return
	end)
    while install and ProjectCount() > 0 do
		dist, data = GetNearestProjectCar()
		if data and dist < radius and install then
			local doors = {
				'exhaust',
			}
			while dist < radius and install do
				if dist < 4 then
					for k,v in pairs(doors) do
						local bone = GetEntityBoneIndexByName(vehicle,v)
						local coordbone = GetWorldPositionOfEntityBone(vehicle, bone)
						if bone ~= -1 then
							DrawText3Ds(coordbone, '[~b~E~w~] - Install Exhaust')
						end
					end
					if IsControlPressed(0,38) then
						exports['ps-ui']:Circle(function(success)
							if success then
								InstallExhaust()
							else
								QBCore.Functions.Notify(Lang:t('error.fail'),"error")
							end
						end, 3, 10)
						--[[if Interaction('exhaust') then
							InstallExhaust()
						end]]
						install = false
						DeleteObject(currentobject)
						use = 'exhaust'
						Wait(100)
						break
					end
				end
				if IsControlPressed(0,73) then
					install = false
					Wait(100)
					break
				end
				dist = #(GetEntityCoords(PlayerPedId()) - data.coord)
				Wait(0)
			end
		end
		install = false
		Wait(1000)
	end
	RestoreItem(use)
end

Useitem['brake'] = function()
	if UseBusy then return end
	UseBusy = true
	SpawnItem('imp_prop_impexp_brake_caliper_01a',-0.08, 0.30, 0.37, 0.0, 0.0, 180.0)
	local install = true
	local use = false
    local projectcars = GlobalState.ProjectCars
	local data = nil
	local dist = -1
	local radius = 5000
	local vehicle = nil
	CreateThread(function()
		while install do
			Wait(300)
			dist, data = GetNearestProjectCar(projectcars)
			vehicle = getveh() 
		end
		return
	end)
    while install and ProjectCount() > 0 do
		dist, data = GetNearestProjectCar()
		if data and dist < radius and install then
			local doors = {
				'wheel_lf',
				'wheel_rf',
				'wheel_lr',
				'wheel_rr'
			}
			local brake = data.status.brake
			for k,v in pairs(brake) do
				--print(k,v)
			end
			while dist < radius and install do
				if dist < 4 then
					for k,v in pairs(doors) do
						local bone = GetEntityBoneIndexByName(vehicle,v)
						local coordbone = GetWorldPositionOfEntityBone(vehicle, bone)
						if bone ~= -1 and tonumber(brake[tostring(k-1)]) == 1 then
							DrawText3Ds(coordbone+vec3(0.0,0.0,5.5), '[~b~E~w~] - Install Brake')
						end
					end
					if IsControlPressed(0,38) then
						if jeste("mechanic4") then
							InstallBrake()
						else
							QBCore.Functions.Notify(Lang:t('error.fail'),"error")
						end
						install = false
						DeleteObject(currentobject)
						use = 'brake'
						Wait(100)
						break
					end
				end
				if IsControlPressed(0,73) then
					install = false
					Wait(100)
					break
				end
				dist = #(GetEntityCoords(PlayerPedId()) - data.coord)
				Wait(0)
			end
		end
		install = false
		Wait(1000)
	end
	RestoreItem(use)
end

Useitem['seat'] = function()
	if UseBusy then return end
	UseBusy = true
	SpawnItem('prop_car_seat',0.1, 0.40, -0.65, 0.0, 0.0, 180.0)
	local install = true
	local use = false
    local projectcars = GlobalState.ProjectCars
	local data = nil
	local dist = -1
	local radius = 5000
	local vehicle = nil
	CreateThread(function()
		while install do
			Wait(300)
			dist, data = GetNearestProjectCar(projectcars)
			vehicle = getveh() 
		end
	end)
    while install and ProjectCount() > 0 do
		dist, data = GetNearestProjectCar()
		if data and dist < radius and install then
			local doors = {}
			local doors2 = {
				'seat_dside_f',
				'seat_dside_r',
				'seat_pside_f',
				'seat_pside_r'
			}
			local door = data.status.door
			local numseat = GetNumSeat(vehicle)
			if numseat == 2 then
				for k,v in pairs(doors2) do
					if k == 1 or k == 3 then
						table.insert(doors,v)
					end
				end
			else
				doors = doors2
			end
			while dist < radius and install do
				if dist < 4 then
					doors = {}
					door = data.status.door
					local numseat = GetNumSeat(vehicle)
					if numseat == 2 then
						for k,v in pairs(doors2) do
							if k == 1 or k == 3 then
								table.insert(doors,v)
							end
						end
					else
						doors = doors2
					end
					for k,v in pairs(doors) do
						local bone = GetEntityBoneIndexByName(vehicle,v)
						local coordbone = GetWorldPositionOfEntityBone(vehicle, bone)
						if bone ~= -1 and tonumber(door[tostring(k-1)]) == 1 then
							DrawText3Ds(coordbone, '[~b~E~w~] - Install Seat')
						end
					end
					if IsControlPressed(0,38) then
						if jeste("pull") then
							InstallSeat()
						else
							QBCore.Functions.Notify(Lang:t('error.fail'),"error")
						end
						install = false
						DeleteObject(currentobject)
						use = 'seat'
						Wait(100)
						break
					end
				end
				if IsControlPressed(0,73) then
					install = false
					Wait(100)
					break
				end
				dist = #(GetEntityCoords(PlayerPedId()) - data.coord)
				Wait(0)
			end
		end
		install = false
		Wait(1000)
	end
	RestoreItem(use)
end

Useitem['transmition'] = function()
	if UseBusy then return end
	UseBusy = true
	local radius = 5000
	local projectcars = GlobalState.ProjectCars or {}
	local dist, data = GetNearestProjectCar()
	local vehicle = nil
	local install = true
	CreateThread(function()
		while install do
			Wait(300)
			dist, data = GetNearestProjectCar(projectcars)
			vehicle = getveh() 
		end
		return
	end)

	SpawnItem('imp_prop_impexp_gearbox_01',-0.08, 0.30, 0.37, 0.0, 0.0, 180.0)
		while install do
			dist, data = GetNearestProjectCar()
			radius = 300
			install = true
			while install do
				if dist < 4 then
					local bone = GetEntityBoneIndexByName(vehicle,'engine')
					local coordbone = GetWorldPositionOfEntityBone(vehicle, bone)
					if bone ~= -1 then
						DrawText3Ds(coordbone, '[~b~E~w~] - Prepare Install')
					end
					if IsControlPressed(0,38) then
						if test3() then
							Wait(100)
							DeleteEntity(currentobject)
							install = false
							break
						else
							QBCore.Functions.Notify(Lang:t('error.fail'),"error")
						end
					end
				end
				if IsControlPressed(0,73) then
					install = false
					Wait(100)
					break
				end
				dist = #(GetEntityCoords(PlayerPedId()) - data.coord)
				Wait(0)
			end
			Wait(500)
		end

	if data and dist < radius then
		SpawnEngine(false)
		TriggerServerEvent('don-carbuild:server:removeitem','transmition')
		QBCore.Functions.Notify(Lang:t('success.dowell'),"success")
	end
	UseBusy = false
end

Useitem['engine'] = function()
	if UseBusy then return end
	UseBusy = true
	local radius = 5000
	local projectcars = GlobalState.ProjectCars or {}
	local dist, data = GetNearestProjectCar()
	install = true
	local vehicle = nil
	CreateThread(function()
		while install do
			Wait(100)
			dist, data = GetNearestProjectCar(projectcars)
			vehicle = getveh() 
		end
		return
	end)

	SpawnItem('prop_car_engine_01',0.025, 0.0, 0.15, 90.0, 0.0, 180.0)
		while install do
			dist, data = GetNearestProjectCar()
			radius = 300
			while install do
				if dist < 4 then
					if not vehicle then vehicle = getveh() end
					local bone = GetEntityBoneIndexByName(vehicle,'engine')
					local coordbone = GetWorldPositionOfEntityBone(vehicle, bone)
					if bone ~= -1 then
						DrawText3Ds(coordbone, '[~b~E~w~] - Prepare Install')
					end
					if IsControlPressed(0,38) then
						if test3() then
							Wait(100)
							DeleteEntity(currentobject)
							install = false
							break
						else
							QBCore.Functions.Notify(Lang:t('error.fail'),"error")
						end
					end
				else
					vehicle = nil
				end
				if IsControlPressed(0,73) then
					install = false
					Wait(100)
					break
				end
				dist = #(GetEntityCoords(PlayerPedId()) - data.coord)
				Wait(0)
			end
			Wait(500)
		end

	--print(data , dist < radius)
	if data and dist < radius then
		SpawnEngine(true)
		TriggerServerEvent('don-carbuild:server:removeitem','engine')
		QBCore.Functions.Notify(Lang:t('success.dowell'),"success")
	end
	UseBusy = false
end

local function DeliveryStart(point,spawn,car,veh)
	RequestModel(GetHashKey('phantom'))
	while not HasModelLoaded(GetHashKey('phantom')) do
		Citizen.Wait(0)
	end
	RequestModel(GetHashKey('tr2'))
	while not HasModelLoaded(GetHashKey('tr2')) do
		Citizen.Wait(0)
	end
	--ClearAreaOfVehicles(loc.Location.x, loc.Location.y, loc.Location.z, 15.0, false, false, false, false, false) 	
	transport = CreateVehicle(GetHashKey('phantom'), spawn.x,spawn.y,spawn.z,spawn.w, true, true)
	SetEntityAsMissionEntity(transport)
	SetEntityHeading(transport, spawn.w)
	TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(transport))
	trailertransport = CreateVehicle(GetHashKey('tr2'), spawn.x,spawn.y-1,spawn.z,spawn.w, true, true)
	SetEntityAsMissionEntity(trailertransport)
	SetEntityHeading(trailertransport, spawn.w)
	AttachVehicleToTrailer(transport,trailertransport, 1.00)
	local vehRotation = GetEntityRotation(trailertransport)
	local localcoords = GetOffsetFromEntityGivenWorldCoords(trailertransport, GetEntityCoords(car))
	--print(vehRotation)
	--print(localcoords)
	AttachVehicleOnToTrailer(car, trailertransport, 0.0, 0.0, 0.0, 0.103679, 4.122245, 2.789666 + 0.08, vehRotation.x, vehRotation.y, 0.0, false)
	truckblip = AddBlipForEntity(transport)
	SetBlipSprite(truckblip,477)
	SetBlipColour(truckblip,26)
	SetBlipAsShortRange(truckblip,false)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName('My Delivery Truck')
	EndTextCommandSetBlipName(truckblip)
	DoScreenFadeIn(333)
	SetNewWaypoint(point)
	deliveryblip = AddBlipForCoord(point.x,point.y,point.z)
	SetBlipSprite(deliveryblip,358)
	SetBlipColour(deliveryblip,26)
	SetBlipAsShortRange(deliveryblip,false)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName('My Delivery Point')
	EndTextCommandSetBlipName(deliveryblip)
	SetBlipRoute(deliveryblip,true)
	SetBlipRouteColour(deliveryblip,3)
	target = point
	while DoesEntityExist(trailertransport) do
		Wait(10)
		if #(target - GetEntityCoords(trailertransport)) < 10 and GetVehiclePedIsIn(PlayerPedId()) == transport then
			exports['qb-core']:DrawText(Lang:t('commands.turnbacktruck'))
            if IsControlJustReleased(0, 38) then
                exports['qb-core']:KeyPressed(38)
                exports['qb-core']:HideText()
				TriggerEvent("don-carbuild:client:deliverydone",veh)
            end
		else
			exports['qb-core']:HideText()
		end
		if not DoesEntityExist(trailertransport) then
			break
		end
	end
end

RegisterNetEvent('don-carbuild:client:vehmenu', function()
    local categomenu = {}
    local categmenu = {
        {
            header = Lang:t('menus.veh_menu'),
            isMenuHeader = true,
            icon = "fa-solid fa-circle-info",
        }
    }
    for k, v in pairs(QBCore.Shared.Vehicles) do
        if type(QBCore.Shared.Vehicles[k]["shops"]) == 'table' then
            for _, shops in pairs(QBCore.Shared.Vehicles[k]["shops"]) do
                if shops == inshop then
                    categomenu[v.category] = v.category
                end
            end
        elseif QBCore.Shared.Vehicles[k]["shops"] == inshop then
            categomenu[v.category] = v.category
        end
    end
    for k, v in pairs(categomenu) do
        categmenu[#categmenu + 1] = {
            header = k,
            icon = "fa-solid fa-circle",
            params = {
                event = 'don-carbuild:client:openVehCats',
                args = {
                    catName = k
                }
            }
        }
    end
    exports['qb-menu']:openMenu(categmenu)
end)

RegisterNetEvent('don-carbuild:client:openVehCats', function(data)
    local carMenu = {
        {
            header = 'Return',
            icon = "fa-solid fa-angle-left",
            params = {
                event = 'don-carbuild:client:vehmenu'
            }
        }
    }
    for k, v in pairs(QBCore.Shared.Vehicles) do
        if QBCore.Shared.Vehicles[k]["category"] == data.catName then
                carMenu[#carMenu + 1] = {
                    header = v.name,
                    icon = "fa-solid fa-car-side",
                    params = {
                        event = "don-carbuild:client:newprojet",
                        args = {
                            model = v.model,
                        }
                    }
                }
        end
    end
    exports['qb-menu']:openMenu(carMenu)
end)

RegisterNetEvent('don-carbuild:client:newprojet', function(data)
	TriggerServerEvent("don-carbuild:server:spawnshell",data)
end)

RegisterNetEvent('don-carbuild:client:newcar', function(model)
    local model = model
    DoScreenFadeIn(10000)
	local ped = PlayerPedId()
	local hash = GetHashKey(model)
	RequestModel(hash)
	while not HasModelLoaded(hash) do
		RequestModel(hash)
		Citizen.Wait(1)
	end
	local spawn = vector3(-1267.15, -3013.3, -48.49)
	local appliance = CreateObject(hash,spawn, true, true)
	while not DoesEntityExist(appliance) do Wait(0) end
	local moveSpeed = 0.001
	SetEntityHeading(prop, 356.61)
	PlaceObjectOnGroundProperly(appliance)
	FreezeEntityPosition(appliance, true)
	SetEntityAlpha(appliance, 200, true)
	spawnedcar = appliance
	SendNUIMessage({show = true,type = "spawn", })
	while spawnedcar ~= nil do
		Citizen.Wait(1)
		--HelpText1(Config.Strings.frnHelp1)
		DisableControlAction(0, 51)
		DisableControlAction(0, 96)
		DisableControlAction(0, 97)
		for i = 108, 112 do
			DisableControlAction(0, i)
		end
		DisableControlAction(0, 117)
		DisableControlAction(0, 118)
		DisableControlAction(0, 171)
		DisableControlAction(0, 254)
		if IsDisabledControlPressed(0, 171) then -- caps
			moveSpeed = moveSpeed + 0.001
		end
		if IsDisabledControlPressed(0, 254) then -- L shift
			moveSpeed = moveSpeed - 0.001
		end
		if moveSpeed > 1.0 or moveSpeed < 0.001 then
			moveSpeed = 0.001
		end
		HudWeaponWheelIgnoreSelection()
		for i = 123, 128 do
			DisableControlAction(0, i)
		end
		DrawMarker(36, GetEntityCoords(spawnedcar)+vec3(0,0.0,1.5), 0, 0, 0, 0, 0, 0.0, 0.7, 0.7, 0.7, 200, 255, 255, 255, 0, 0, 1, 1, 0, 0, 0)
		if IsDisabledControlJustPressed(0, 51) then
				local plate = "DON"..math.random(10000, 99999)
				local coord = GetEntityCoords(spawnedcar)
				local heading = GetEntityHeading(spawnedcar)
				DeleteEntity(spawnedcar)
				vehicle = CreateVehicle(hash,coord,heading, false, true)
				SetEntityCompletelyDisableCollision(vehicle,false,false)
				shell = CreateObject(hash,coord, false, true)
				SetEntityHeading(shell,heading)
				SetEntityCompletelyDisableCollision(shell,true,false)
				SetEntityCanBeDamaged(shell,false)
				SetEntityInvincible(shell,true)
				SetEntityAlpha(shell,0,false)
				SetVehicleEngineOn(vehicle,false,true,true)
				SetVehicleFuelLevel(vehicle,0.0)
				for i = 0, 7 do
					SetVehicleWheelTireColliderSize(vehicle, i, -5.0)
					SetVehicleDoorBroken(vehicle, i, true)
				end
				FreezeEntityPosition(vehicle,true)
				FreezeEntityPosition(shell,true)
				SetVehicleOnGroundProperly(vehicle)
				SetVehicleNumberPlateText(vehicle,plate)
				plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1')
				local wheels = {}
				local brakes = {}
				
				for tireid = 0, GetVehicleNumberOfWheels(vehicle) -1 do
					wheels[tireid] = 1
					brakes[tireid] = 1
				end
				local data = {
					plate = plate,
					doors = GetNumberOfVehicleDoors(vehicle),
					seat = GetNumSeat(vehicle),
					trunk = GetEntityBoneIndexByName(vehicle,'boot') ~= -1 and 1 or 0,
					exhaust = GetEntityBoneIndexByName(vehicle,'exhaust') ~= -1 and 1 or 0,
					bonnet = GetEntityBoneIndexByName(vehicle,'bonnet') ~= -1 and 1 or 0,
					wheel = wheels,
					brake = brakes,
					model = model,
					coord = coord,
					heading = heading,
					paint = table.pack(GetVehicleCustomPrimaryColour(vehicle))
				}
				TriggerServerEvent('don-carbuild:server:newproject',data)
				spawnprojectcars[plate] = vehicle
				spawnprojectshell[plate] = shell
				SendNUIMessage({show = false,type = "spawn", })
			break
		end
		if IsDisabledControlPressed(0, 96) then -- wheel scroll
			SetEntityCoords(spawnedcar, GetOffsetFromEntityInWorldCoords(spawnedcar, 0.0, 0.0, moveSpeed))
		end
		if IsDisabledControlPressed(0, 97) then -- wheel scroll
			SetEntityCoords(spawnedcar, GetOffsetFromEntityInWorldCoords(spawnedcar, 0.0, 0.0, -moveSpeed))
		end
		if IsDisabledControlPressed(0, 108) then -- num4
			SetEntityHeading(spawnedcar, GetEntityHeading(spawnedcar) + 0.5)
		end
		if IsDisabledControlPressed(0, 109) then -- num6
			SetEntityHeading(spawnedcar, GetEntityHeading(spawnedcar) - 0.5)
		end
		if IsDisabledControlPressed(0, 111) then
			SetEntityCoords(spawnedcar, GetOffsetFromEntityInWorldCoords(spawnedcar, 0.0, -moveSpeed, 0.0))
		end
		if IsDisabledControlPressed(0, 110) then
			SetEntityCoords(spawnedcar, GetOffsetFromEntityInWorldCoords(spawnedcar, 0.0, moveSpeed, 0.0))
		end
		if IsDisabledControlPressed(0, 117) then
			SetEntityCoords(spawnedcar, GetOffsetFromEntityInWorldCoords(spawnedcar, moveSpeed, 0.0, 0.0))
		end
		if IsDisabledControlPressed(0, 118) then
			SetEntityCoords(spawnedcar, GetOffsetFromEntityInWorldCoords(spawnedcar, -moveSpeed, 0.0, 0.0))
		end
	end
end)

RegisterNetEvent('don-carbuild:client:useparts', function(part)
	Useitem[part]()
	Wait(500)
end)

RegisterNetEvent('don-carbuild:client:updateprojectable', function(plate)
	DeleteEntity(spawnprojectcars[plate] or 0)
	DeleteEntity(spawnprojectshell[plate] or 0)
	if blips[plate] and DoesBlipExist(blips[plate] or 0) then
		RemoveBlip(blips[plate])
	end
end)

RegisterNetEvent('don-carbuild:client:spawnfinishproject', function(data,props)
	local coord = json.decode(data.coord)
	local props = props
	local vehicle = IsAnyVehicleNearPoint(coord.x,coord.y,coord.z,1.1)
	if vehicle then
		if spawnprojectshell[data.plate] and DoesEntityExist(spawnprojectshell[data.plate]) then
			DeleteEntity(spawnprojectshell[data.plate])
		end
		if spawnprojectcars[data.plate] and DoesEntityExist(spawnprojectcars[data.plate]) then
			DeleteEntity(spawnprojectcars[data.plate])
		end
	end
	local hash = props.model
	RequestModel(hash)
	while not HasModelLoaded(hash) do
		RequestModel(hash)
		Citizen.Wait(1)
	end
	vehicle = CreateVehicle(hash,vector3(coord.x,coord.y,coord.z),coord.w, true, true)
	SetVehicleOnGroundProperly(vehicle)
	SetVehicleNumberPlateText(vehicle,props.plate)
	SetVehicleProp(vehicle,props)
	DeliveryStart(vector3(-345.01, -1299.16, 31.38),vector4(140.64, 6419.26, 31.36, 74.16),vehicle,data.model)
	QBCore.Functions.Notify(Lang:t('success.finishcar'),"success")
end)

RegisterNetEvent('don-carbuild:client:order', function()
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "Cardealer Shop", Config.ShopItems)
end)

RegisterNetEvent('don-carbuild:client:updatelocalproject', function(data)
	local coord = json.decode(data.coord)
	local vehicle = IsAnyVehicleNearPoint(coord.x,coord.y,coord.z,1.1)
	if vehicle then
		local data = {
			status = json.decode(data.status),
			coord = vector3(coord.x,coord.y,coord.z),
			heading = coord.w,
			model = data.model,
			plate = data.plate
		}
		UpdateProjectcar(data)
	end
	success = true
	Wait(3000)
	success = false
end)

-- truck
MathRound = function(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

VehicleBlip = function(data)
	if blips[data.plate] == nil then
		local blip = AddBlipForCoord(data.coord.x, data.coord.y, data.coord.z)
		SetBlipSprite (blip, 562)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.3)
		SetBlipColour (blip, 81)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName("Project Car : "..data.model.." - "..data.plate)
		EndTextCommandSetBlipName(blip)
		blips[data.plate] = blip
	end
end

SpawnProjectCars = function(projectcars)
	local mycoord = GetEntityCoords(PlayerPedId())
	local nearest, datas = -1, nil
	for k,v in pairs(projectcars) do
		local coord = json.decode(v.coord)
		local data = {
			status = json.decode(v.status),
			coord = vector3(coord.x,coord.y,coord.z),
			heading = coord.w,
			model = v.model,
			paint = v.paint,
			plate = v.plate
		}
		local dis = #(mycoord - vector3(coord.x,coord.y,coord.z))
		if dis < 50 then
			if not spawnprojectcars[data.plate] then
				SpawnNewProject(data)
			else
				local status = data.status
				for i = 0, 3 do
					local i = tonumber(i)
					
					local paint = json.decode(data.paint or '[]') or {}
					if paint and data.status['paint'] == 0 then
						SetVehicleColours(spawnprojectcars[data.plate],0,0)
						SetVehicleExtraColours(vehicle,0,0)
						SetVehicleDirtLevel(spawnprojectcars[data.plate], 0.0)
						SetVehicleRudderBroken(spawnprojectcars[data.plate],false)
						SetVehicleEnveffScale(spawnprojectcars[data.plate],0.0)
						SetVehicleCustomPrimaryColour(spawnprojectcars[data.plate], paint[1], paint[2], paint[3])
					else
						SetVehicleColours(spawnprojectcars[data.plate],117,117)
						SetVehicleDirtLevel(spawnprojectcars[data.plate], 15.0)
						SetVehicleRudderBroken(spawnprojectcars[data.plate],true)
						SetVehicleEnveffScale(spawnprojectcars[data.plate],1.0)
					end
					if not inground[data.plate] then
						SetVehicleOnGroundProperly(spawnprojectcars[data.plate])
						inground[data.plate] = true
					end
					SetEntityCompletelyDisableCollision(spawnprojectcars[data.plate],false,false)
					--
					SetVehicleWheelTireColliderSize(spawnprojectcars[data.plate],i,0.4)
					--
					if status.wheel[tostring(i)] and status.wheel[tostring(i)] >= 1 then
						SetVehicleWheelTireColliderSize(spawnprojectcars[data.plate], i, -5.0)
					end
				end
			end
		else
			near = false
			if spawnprojectcars[data.plate] then
				DeleteEntity(spawnprojectcars[data.plate])
				spawnprojectcars[data.plate] = nil
				DeleteEntity(spawnprojectshell[data.plate])
				spawnprojectshell[data.plate] = nil
			end
		end
		if nearest == -1 and dis < 10 or nearest >= dis then
			nearest = dis
			datas = data
		end
	end
	local dis, data = nearest, datas
	if data and IsPedStopped(PlayerPedId()) then
		local status = data.status
		if dis < 3 and IsPedStopped(PlayerPedId()) then
			SendNUIMessage({show = false,type = "project_status", status = data.status, info = QBCore.Shared.Vehicles[data.model]})
			Wait(100)
			SetVehicleFuelLevel(spawnprojectcars[data.plate],0.0)
			nuiopen = true
			near = true
			lastdis = #(GetEntityCoords(PlayerPedId()) - datas.coord)
			SendNUIMessage({show = true,type = "project_status", status = data.status, info = QBCore.Shared.Vehicles[data.model]})
			while not success and MathRound(lastdis) == MathRound(dis) do 
				Wait(1) 
				dis = #(GetEntityCoords(PlayerPedId()) - datas.coord) 
			end
			nuiopen = false
			Wait(1)
			SendNUIMessage({show = false,type = "project_status", status = data.status, info = QBCore.Shared.Vehicles[data.model]})
		end
	end
end

function UpdateProjectcar(data,netid)
	local status = data.status
	
	local vehicle = spawnprojectcars[data.plate] or getveh()
	
	SetVehicleFixed(vehicle)
	for i = 0, 7 do
		if status.door[tostring(i)] and status.door[tostring(i)] ~= 0 then
			SetVehicleDoorBroken(vehicle, i, true)
		end
		if i == 4 and status.bonnet ~= 0 then
			SetVehicleDoorBroken(vehicle, i, true)
		end
		if i == 5 and status.trunk ~= 0 then
			SetVehicleDoorBroken(vehicle, i, true)
		end
	end
	for i = 0, 3 do
		local i = tonumber(i)
		SetVehicleWheelTireColliderSize(vehicle,i,0.4)
		--
		if status.wheel[tostring(i)] and status.wheel[tostring(i)] >= 1 then
			SetVehicleWheelTireColliderSize(vehicle, i, -5.0)
			
		end
	end
end

SetOwned = function(vehicle)
    local attempt = 0
	if NetworkHasControlOfEntity(vehicle) then return end
    SetEntityAsMissionEntity(vehicle,true,true)
    NetworkRequestControlOfEntity(vehicle)
    while not NetworkHasControlOfEntity(vehicle) and attempt < 500 and DoesEntityExist(vehicle) do
        NetworkRequestControlOfEntity(vehicle)
        Citizen.Wait(0)
        attempt = attempt + 1
    end
end

SprayParticles = function(ped,dict,n,vehicle,m)
    local dict = "scr_recartheft"
    local ped = PlayerPedId()
    local fwd = GetEntityForwardVector(ped)
    local coords = GetEntityCoords(ped) + fwd * 0.5 + vector3(0.0, 0.0, -0.5)

    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(0)
    end
    local pointers = {}
    local color = Config.Paint[n].color
    local heading = GetEntityHeading(ped)
    UseParticleFxAssetNextCall(dict)
    SetParticleFxNonLoopedColour(color[1] / 255, color[2] / 255, color[3] / 255)
    SetParticleFxNonLoopedAlpha(1.0)
    local spray = StartNetworkedParticleFxNonLoopedAtCoord("scr_wheel_burnout", coords.x, coords.y, coords.z + 1.5, 0.0, 0.0, heading, 0.7, 0.0, 0.0, 0.0)
end

PaintCar = function(n,vehicle)
    local ped = PlayerPedId()
    spraying = true
    custompaint = true
    local n = n:lower()
    CreateThread(function()
        local min = 255
        while spraying do
            local sleep = 3000
            min = min - (min/sleep) * 1000
            SprayParticles(ped,dict,n,vehicle,min)
            Wait(3000)
        end
    end)
    while not custompaint do Wait(100) end
    RemoveNamedPtfxAsset(dict)
    while ( not HasAnimDictLoaded( 'anim@amb@business@weed@weed_inspecting_lo_med_hi@' ) ) do
        RequestAnimDict( 'anim@amb@business@weed@weed_inspecting_lo_med_hi@' )
        Citizen.Wait( 1 )
    end
    TaskPlayAnim(ped, 'anim@amb@business@weed@weed_inspecting_lo_med_hi@', 'weed_spraybottle_stand_spraying_01_inspector', 1.0, 1.0, -1, 16, 0, 0, 0, 0 )
    local min = 255
    local r,g,b = table.unpack(Config.Paint[n].color)
    local rd,gd,bd = 255,255,255
    DeleteEntity(spraycan or 0)
    Wait(100)
    spraycan = CreateObject(GetHashKey('ng_proc_spraycan01b'),0.0, 0.0, 0.0,true, false, false)
    AttachEntityToEntity(spraycan, ped, GetPedBoneIndex(ped, 57005), 0.072, 0.041, -0.06,33.0, 38.0, 0.0, true, true, false, true, 1, true)
    SetOwned(vehicle)
    while spraying do
        while rd ~= r or gd ~= g or bd ~= b do
            if rd ~= r then
                rd = rd - 1
            end
            if gd ~= g then
                gd = gd - 1
            end
            if bd ~= b then
                bd = bd - 1
            end
            SetVehicleCustomPrimaryColour(vehicle,rd,gd,bd)
            Wait(100)
        end
		SetVehicleCustomPrimaryColour(vehicle,r,g,b)
		SetVehicleDirtLevel(vehicle,0.0)
		SetVehicleEnveffScale(vehicle,0.0)
        spraying = false
        Wait(100)
    end
    spraying = false
    DeleteEntity(spraycan)
    ClearPedTasks(ped)
	local plate = GetVehicleNumberPlateText(vehicle)
	plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1')
	if GlobalState.ProjectCars[plate] then
		SetVehicleUpdate('paint',0)
	end
end

RegisterNetEvent('don-carbuild:client:usepaint', function(color)
	PaintCar(color,getveh())
end)

RegisterNetEvent('don-carbuild:client:deliverydone', function(car)
	--finishdelivery = true
	if #(target - GetEntityCoords(trailertransport)) < 10 then
		DeleteEntity(trailertransport)
		SetBlipRoute(deliveryblip,false)
		if DoesBlipExist(deliveryblip) then
			RemoveBlip(deliveryblip)
		end
		QBCore.Functions.Notify(Lang:t('success.turnbacktruck'),"success")
		Wait(2000)
		deliveryblip = AddBlipForCoord(44.27, 6450.53, 31.41)
		SetBlipSprite(deliveryblip,358)
		SetBlipColour(deliveryblip,26)
		SetBlipAsShortRange(deliveryblip,false)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName('My Delivery Point')
		EndTextCommandSetBlipName(deliveryblip)
		SetBlipRoute(deliveryblip,true)
		SetBlipRouteColour(deliveryblip,3)
		SetNewWaypoint(vector3(44.27, 6450.53, 31.41))
		TriggerServerEvent('qb-vehicleshop:server:owncar',car)
		--print(car)
		while DoesEntityExist(transport) do
			Wait(10)
			if #(vector3(41.8, 6448.56, 31.41) - GetEntityCoords(transport)) < 10 and GetVehiclePedIsIn(PlayerPedId()) == transport then
				exports['qb-core']:DrawText(Lang:t('commands.turnbacktruck'))
				if IsControlJustReleased(0, 38) then
					exports['qb-core']:KeyPressed(38)
					exports['qb-core']:HideText()
					DeleteEntity(transport)
					SetBlipRoute(deliveryblip,false)
					RemoveBlip(deliveryblip)
					QBCore.Functions.Notify(Lang:t('success.moneyback'),"success")
					TriggerServerEvent('don-carbuild:server:pay')
				end
			else
				exports['qb-core']:HideText()
			end
		end
	end
end)

SpawnNewProject = function(data)
	local hash = GetHashKey(data.model)
	if not HasModelLoaded(hash) then
		RequestModel(hash)
		while not HasModelLoaded(hash) do
			RequestModel(hash)
			Citizen.Wait(1)
		end
	end
	local status = data.status
	vehicle = CreateVehicle(hash,vector3(data.coord.x,data.coord.y,data.coord.z+0.7),data.heading, false, true)
	SetEntityCompletelyDisableCollision(vehicle,false,false)
	shell = CreateObject(hash,vector3(data.coord.x,data.coord.y,data.coord.z+0.7), false, true)
	SetEntityHeading(shell,GetEntityHeading(vehicle))
	SetEntityNoCollisionEntity(shell,vehicle,false)
	SetEntityCompletelyDisableCollision(shell,true,false)
	SetVehicleOnGroundProperly(vehicle)
	FreezeEntityPosition(vehicle,true)
	FreezeEntityPosition(shell,true)
	SetEntityCanBeDamaged(shell,false)
	SetEntityInvincible(shell,true)
	SetEntityAlpha(shell,0,false)
	SetVehicleEngineOn(vehicle,false,true,true)
	SetVehicleFuelLevel(vehicle,0.0)
	for i = 0, 7 do
		if status == nil or status.door[tostring(i)] and tonumber(status.door[tostring(i)]) == 1 then
			SetVehicleDoorBroken(vehicle, i, true)
		end
		if i == 4 and status.bonnet ~= 0 then
			SetVehicleDoorBroken(vehicle, i, true)
		end
		if i == 5 and status.trunk ~= 0 then
			SetVehicleDoorBroken(vehicle, i, true)
		end
	end
	for i = 0, 3 do
		local i = tonumber(i)
		SetVehicleWheelTireColliderSize(vehicle,i,0.4)
		--
		if status.wheel[tostring(i)] and status.wheel[tostring(i)] >= 1 then
			SetVehicleWheelTireColliderSize(vehicle, i, -5.0)
			
		end
	end
	local paint = json.decode(data.paint or '[]') or {}
	if paint and status['paint'] == 0 then
		SetVehicleCustomPrimaryColour(vehicle, paint[1], paint[2], paint[3])
	else
		SetVehicleColours(vehicle,13,13)
		SetVehicleDirtLevel(vehicle, 15.0)
		SetVehicleRudderBroken(vehicle,true)
		SetVehicleEnveffScale(vehicle,1.0)
	end
	SetVehicleNumberPlateText(vehicle,data.plate)
	spawnprojectcars[data.plate] = vehicle
	spawnprojectshell[data.plate] = shell
	return vehicle
end

AddEventHandler('onResourceStop', function(resourceName)
	if resourceName == GetCurrentResourceName() then
		 for key, value in pairs(benches_entites) do
			  DeleteObject(value)
		 end
		 local projectcars = GlobalState.ProjectCars or {}
		for k,v in pairs(projectcars) do
			local plate = v.plate
			DeleteEntity(spawnprojectcars[plate])
			DeleteEntity(spawnprojectshell[plate])
			if blips[plate] then
				RemoveBlip(blips[plate])
			end
		end
		DeleteObject(obj)
		DeleteObject(obj2)
	end
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		 return
	end
	Load_tables()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	Wait(1500)
	Load_tables()
end)