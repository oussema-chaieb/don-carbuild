Config = {}
Config.UsingTarget = GetConvar('UseTarget', 'false') == 'true'
Config.Commission = 0.10 -- Percent that goes to sales person from a full car sale 10%
Config.FinanceCommission = 0.05 -- Percent that goes to sales person from a finance sale 5%
Config.FinanceZone = vector3(-29.53, -1103.67, 26.42)-- Where the finance menu is located
Config.PaymentWarning = 10 -- time in minutes that player has to make payment before repo
Config.PaymentInterval = 24 -- time in hours between payment being due

Config.ligature = 0
Config.management = "qb-management" -- qb-bossmenu/qb-management
Config.useenvireceipts = false
Config.usejlcarboost = false
Config.fuel = 'cdn-fuel'
Config.DebugPoly = false
Config.Job = "cardealer"
Config.VehMenuCircleZone = vector3(-1296.15, -3018.84, -48.67) 
Config.VehMenuTargetIcon = "fas fa-clipboard"
Config.VehMenuTargetLabel = "new project"

Config.EnterTarget = vector3(51.44, 6485.77, 31.43) 
Config.EnterHeading = 318.67
Config.EnterTargetIcon = "far fa-clipboard"
Config.EnterTargetLabel = "take the elevator"

Config.ExitTarget = vector3(-1243.31, -3023.15, -48.49) 
Config.ExitHeading = 91.72
Config.ExitTargetIcon = "far fa-clipboard"
Config.ExitTargetLabel = "take the elevator"

Config.finishedcarsTarget = vector3(-1293.83, -3022.73, -48.49)
Config.finishedcarsHeading = 183.36
Config.finishedcarsTargetIcon = "far fa-clipboard"
Config.finishedcarsTargetLabel = "See finished cars"

Config.SpawnNewCar = vector3(-1267.15, -3013.3, -48.49)
Config.DeliveryPoint = vector3(-49.51, -1687.65, 29.47)
Config.SpawnDelivery = vector4(140.64, 6419.26, 31.36, 74.16)
Config.DeliveryReturnPoint = vector3(44.27, 6450.53, 31.41)

Config.UseProgressbar = true
Config.hackui = "TN-minigame" -- both is for "ps-ui" and "qb-skillbar" together // "ps-ui" / "qb-skillbar" // "none" for nothing // TN-minigame
Config.TNminigame = "Laundromat" -- don't touch it if you won't use TN-minigame // Laundromat / RepairKit / RoofRunning

Config.LaundromatTime = 50 -- setting Laundromat time for TN-minigame
Config.RepairKitTime = 5 -- setting RepairKit time for TN-minigame
Config.RepairKitCount = 30 -- setting RepairKit Count for TN-minigame
Config.RoofRunningTime = 25 -- setting RoofRunning time for TN-minigame
Config.RoofRunningCols = 11 -- setting RoofRunning Cols for TN-minigame
Config.RoofRunningRows = 8 -- setting RoofRunning Rows for TN-minigame

Config.duration = math.random(7500, 35000)
Config.pos = math.random(10, 50)
Config.width = math.random(10, 40)

Config.repeatDuration = math.random(500, 1000)
Config.repeatPos = math.random(10, 30)
Config.repeatWidth = math.random(5, 12)

Config.psuiNumberOfCircles = math.random(2, 4)
Config.psuiMS = math.random(15, 25)

Config.psuiThermiteTime = 10
Config.psuiThermiteGridsize = 6
Config.psuiThermiteIncorrectBlocks = 3

Config.parts = { 
	['door'] = {}, 
	['bonnet'] = {}, 
	['trunk'] = {}, 
	['wheel'] = {}, 
	['seat'] = {},
	['engine'] = {}, 
	['transmition'] = {}, 
	['exhaust'] = {}, 
	['brake'] = {}, 
}

Config.Paint = {
	-- you can add other rgb patterns
    ['white'] = {item = 'paint_white', color = {255, 255, 255}},
    ['red'] =  {item = 'paint_red',color = {255, 0, 0}},
    ['pink'] = {item = 'paint_pink',color = {253, 51, 153}},
    ['blue'] = {item = 'paint_blue',color = {0, 0, 255}},
    ['yellow'] = {item = 'paint_yellow',color = {255, 255, 0}},
    ['green'] = {item = 'paint_green',color = {0, 255, 0}},
    ['orange'] = {item = 'paint_orange',color = {153, 76, 0}},
    ['brown'] = {item = 'paint_brown',color = {51, 25, 0}},
    ['purple'] =  {item = 'paint_purple',color = {128, 1, 128}},
    ['grey'] = {item = 'paint_grey',color = {50, 50, 50}},
    ['black'] = {item = 'paint_black',color = {0, 0, 0}},
}

Config.ShopItems = {
    label = "Tuner Shop",
    slots = 20,
    items = {
        [1] = {
            name = "paint_green",
            price = 0,
            amount = 40,
            info = {},
            type = "item",
            slot = 1
        },
        [2] = {
            name = "paint_orange",
            price = 0,
            amount = 40,
            info = {},
            type = "item",
            slot = 2
        },
        [3] = {
            name = "paint_brown",
            price = 0,
            amount = 40,
            info = {},
            type = "item",
            slot = 3
        },
        [4] = {
            name = "paint_purple",
            price = 0,
            amount = 40,
            info = {},
            type = "item",
            slot = 4
        },
        [5] = {
            name = "paint_grey",
            price = 0,
            amount = 40,
            info = {},
            type = "item",
            slot = 5
        },
        [6] = {
            name = "paint_black",
            price = 0,
            amount = 40,
            info = {},
            type = "item",
            slot = 6
        },
        [7] = {
            name = "paint_white",
            price = 0,
            amount = 40,
            info = {},
            type = "item",
            slot = 7
        },
        [8] = {
            name = "paint_red",
            price = 0,
            amount = 40,
            info = {},
            type = "item",
            slot = 8
        },
        [9] = {
            name = "paint_pink",
            price = 0,
            amount = 40,
            info = {},
            type = "item",
            slot = 9
        },
        [10] = {
            name = "paint_blue",
            price = 0,
            amount = 40,
            info = {},
            type = "item",
            slot = 10
        },
        [11] = {
            name = "paint_yellow",
            price = 0,
            amount = 40,
            info = {},
            type = "item",
            slot = 11
        },

        [12] = {
            name = "door",
            price = 0,
            amount = 40,
            info = {},
            type = "item",
            slot = 12
        },
        [13] = {
            name = "bonnet",
            price = 0,
            amount = 40,
            info = {},
            type = "item",
            slot = 13
        },
        [14] = {
            name = "trunk",
            price = 0,
            amount = 40,
            info = {},
            type = "item",
            slot = 14
        },
        [15] = {
            name = "wheel",
            price = 0,
            amount = 40,
            info = {},
            type = "item",
            slot = 15
        },
        [16] = {
            name = "seat",
            price = 0,
            amount = 40,
            info = {},
            type = "item",
            slot = 16
        },
        [17] = {
            name = "engine",
            price = 0,
            amount = 40,
            info = {},
            type = "item",
            slot = 17
        },
        [18] = {
            name = "transmition",
            price = 0,
            amount = 40,
            info = {},
            type = "item",
            slot = 18
        },
        [19] = {
            name = "exhaust",
            price = 0,
            amount = 40,
            info = {},
            type = "item",
            slot = 19
        },
        [20] = {
            name = "brake",
            price = 0,
            amount = 40,
            info = {},
            type = "item",
            slot = 20
        },
    }
}

Config.Locations = {
    ["inside"] = vector4(-1243.31, -3023.15, -48.49, 91.72),
    ["outside"] = vector4(51.44, 6485.77, 31.43, 318.67),
}

Config.workbenches = {
    -- -- items
    {
         table_model = "",
         hash = 551699682,
         coords = vector3(-1272.74, -2960.06, -49.49),
         rotation = vector3(0.0, 0.0, 90),
         label = "take wheel",
         event = "don-carbuild:client:useparts",
         args = "wheel",
    },
    {
        table_model = "",
        hash = 366075944,
        coords = vector3(-1268.08, -2960.25, -49.49),
        rotation = vector3(0.0, 0.0, 270),
        label = "take trunk",
        event = "don-carbuild:client:useparts",
        args = "trunk",
    },
    {
        table_model = "",
        hash = 1525321021,
        coords = vector3(-1263.92, -2960.96, -49.49),
        rotation = vector3(0.0, 0.0, 270),
        label = "take bonnet",
        event = "don-carbuild:client:useparts",
        args = "bonnet",
    },
    {
        table_model = "",
        hash = -238447120,
        coords = vector3(-1258.61, -2960.62, -49.49),
        rotation = vector3(0.0, 0.0, 270),
        label = "take exhaust",
        event = "don-carbuild:client:useparts",
        args = "exhaust",
    },
    {
        table_model = "",
        hash = 897719340,
        coords = vector3(-1265.59, -3048.87, -49.49),
        rotation = vector3(0.0, 0.0, 90),
        label = "take door",
        event = "don-carbuild:client:useparts",
        args = "door",
    },
    {
        table_model = "prop_car_engine_01",
        hash = "",
        coords = vector3(-1241.62, -2998.24, -48.76),
        rotation = vector3(0.0, 0.0, 0.0),
        label = "take engine",
        event = "don-carbuild:client:useparts",
        args = "engine",
    },
    {
        table_model = "imp_prop_impexp_gearbox_01",
        hash = "",
        coords = vector3(-1241.55, -3000.38, -48.69),
        rotation = vector3(0.0, 0.0, 0.0),
        label = "take transmition",
        event = "don-carbuild:client:useparts",
        args = "transmition",
    },
    {
        table_model = "prop_car_seat",
        hash = "",
        coords = vector3(-1268.81, -3049.66, -49.49),
        rotation = vector3(0.0, 0.0, 180.0),
        label = "take a seat",
        event = "don-carbuild:client:useparts",
        args = "seat",
    },
    {
        table_model = "imp_prop_impexp_brake_caliper_01a",
        hash = "",
        coords = vector3(-1271.41, -3049.52, -49.09),
        rotation = vector3(0.0, 0.0, 180.0),
        label = "take a brake",
        event = "don-carbuild:client:useparts",
        args = "brake",
    },
    {
        table_model = "prop_paints_bench01",
        hash = "",
        coords = vector3(-1289.59, -2989.96, -49.49),
        rotation = vector3(0.0, 0.0, 90.0),
        label = "take a paint",
        event = "don-carbuild:client:order",
        args = "",
    },
}

Config.Shops = {
    ['luxury'] = {
        ['Type'] = 'managed', -- meaning a real player has to sell the car
        ['Zone'] = {
            ['Shape'] = {
                vector2(-55.0725440979, -1101.9108886719),
                vector2(-35.928512573242, -1109.0085449219),
                vector2(-32.249641418457, -1097.9272460938),
                vector2(-52.609630584717, -1087.8356933594)
            },
            ['minZ'] = 24.646457672119,
            ['maxZ'] = 32.516143798828,
            ['size'] = 2.75 -- size of the vehicles zones
        },
        ['Job'] = 'cardealer', -- Name of job or none
        ['ShopLabel'] = 'Premium Deluxe Motorsport',
        ['showBlip'] = true, -- true or false
        ['blipSprite'] = 326, -- Blip sprite
        ['blipColor'] = 3, -- Blip color
        ['TestDriveTimeLimit'] = 0.5,
        ['Location'] = vector3(-49.82, -1095.07, 26.42),
        ['ReturnLocation'] = vector3(-49.82, -1095.07, 26.42),
        ['VehicleSpawn'] = vector4(-46.64, -1113.49, 25.83, 67.04),
        ['TestDriveSpawn'] = vector4(-46.64, -1113.49, 25.83, 67.04), -- Spawn location for test drive
        ['ShowroomVehicles'] = {
            [1] = {
                coords = vector4(-47.79, -1099.65, 25.82, 315.53),
                defaultVehicle = 'sultan2',
                chosenVehicle = 'sultan2'
            },
            [2] = {
                coords = vector4(-38.38, -1102.85, 25.82, 310.36),
                defaultVehicle = 'issi7',
                chosenVehicle = 'issi7'
            }
        }
    }, -- Add your next table under this comma
    ['boats'] = {
        ['Type'] = 'managed', -- no player interaction is required to purchase a vehicle
        ['Zone'] = {
            ['Shape'] = {--polygon that surrounds the shop
                vector2(-729.39, -1315.84),
                vector2(-766.81, -1360.11),
                vector2(-754.21, -1371.49),
                vector2(-716.94, -1326.88)
            },
            ['minZ'] = 0.0, -- min height of the shop zone
            ['maxZ'] = 5.0, -- max height of the shop zone
            ['size'] = 6.2 -- size of the vehicles zones
        },
        ['Job'] = 'cardealer', -- Name of job or none
        ['ShopLabel'] = 'Marina Shop', -- Blip name
        ['showBlip'] = true, -- true or false
        ['blipSprite'] = 410, -- Blip sprite
        ['blipColor'] = 3, -- Blip color
        ['TestDriveTimeLimit'] = 1.5, -- Time in minutes until the vehicle gets deleted
        ['Location'] = vector3(-738.25, -1334.38, 1.6), -- Blip Location
        ['ReturnLocation'] = vector3(-714.34, -1343.31, 0.0), -- Location to return vehicle, only enables if the vehicleshop has a job owned
        ['VehicleSpawn'] = vector4(-727.87, -1353.1, -0.17, 137.09), -- Spawn location when vehicle is bought
        ['TestDriveSpawn'] = vector4(-722.23, -1351.98, 0.14, 135.33), -- Spawn location for test drive
        ['ShowroomVehicles'] = {
            [1] = {
                coords = vector4(-727.05, -1326.59, 0.00, 229.5), -- where the vehicle will spawn on display
                defaultVehicle = 'seashark', -- Default display vehicle
                chosenVehicle = 'seashark' -- Same as default but is dynamically changed when swapping vehicles
            },
            [2] = {
                coords = vector4(-732.84, -1333.5, -0.50, 229.5),
                defaultVehicle = 'dinghy',
                chosenVehicle = 'dinghy'
            },
            [3] = {
                coords = vector4(-737.84, -1340.83, -0.50, 229.5),
                defaultVehicle = 'speeder',
                chosenVehicle = 'speeder'
            },
            [4] = {
                coords = vector4(-741.53, -1349.7, -2.00, 229.5),
                defaultVehicle = 'marquis',
                chosenVehicle = 'marquis'
            },
        },
    },
    ['air'] = {
        ['Type'] = 'managed', -- no player interaction is required to purchase a vehicle
        ['Zone'] = {
            ['Shape'] = {--polygon that surrounds the shop
                vector2(-1607.58, -3141.7),
                vector2(-1672.54, -3103.87),
                vector2(-1703.49, -3158.02),
                vector2(-1646.03, -3190.84)
            },
            ['minZ'] = 12.99, -- min height of the shop zone
            ['maxZ'] = 16.99, -- max height of the shop zone
            ['size'] = 7.0, -- size of the vehicles zones
        },
        ['Job'] = 'cardealer', -- Name of job or none
        ['ShopLabel'] = 'Air Shop', -- Blip name
        ['showBlip'] = true, -- true or false
        ['blipSprite'] = 251, -- Blip sprite
        ['blipColor'] = 3, -- Blip color
        ['TestDriveTimeLimit'] = 1.5, -- Time in minutes until the vehicle gets deleted
        ['Location'] = vector3(-1652.76, -3143.4, 13.99), -- Blip Location
        ['ReturnLocation'] = vector3(-1628.44, -3104.7, 13.94), -- Location to return vehicle, only enables if the vehicleshop has a job owned
        ['VehicleSpawn'] = vector4(-1617.49, -3086.17, 13.94, 329.2), -- Spawn location when vehicle is bought
        ['TestDriveSpawn'] = vector4(-1625.19, -3103.47, 13.94, 330.28), -- Spawn location for test drive
        ['ShowroomVehicles'] = {
            [1] = {
                coords = vector4(-1651.36, -3162.66, 12.99, 346.89), -- where the vehicle will spawn on display
                defaultVehicle = 'volatus', -- Default display vehicle
                chosenVehicle = 'volatus' -- Same as default but is dynamically changed when swapping vehicles
            },
            [2] = {
                coords = vector4(-1668.53, -3152.56, 12.99, 303.22),
                defaultVehicle = 'luxor2',
                chosenVehicle = 'luxor2'
            },
            [3] = {
                coords = vector4(-1632.02, -3144.48, 12.99, 31.08),
                defaultVehicle = 'nimbus',
                chosenVehicle = 'nimbus'
            },
            [4] = {
                coords = vector4(-1663.74, -3126.32, 12.99, 275.03),
                defaultVehicle = 'frogger',
                chosenVehicle = 'frogger'
            },
        },
    },
}
