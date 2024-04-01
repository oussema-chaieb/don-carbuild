# don-carbuild

# DESRIPTION

well the whole idea is how you're gonna make a stock systeme with you vehicle shop
but how you're gonna get the vehicles to added in you're store
well for that, you need to build your car step by step and then you will deliver it to the dealer shop
another thing, you will have the possibility to change the car price !

so let me explain ! the car price is not the same as in the qb-core/vehicles
its more with 30%
so if a car price is 100000 in qb-core/vehicles you will find it 130000
the dealer will win only 30000 !
so when he makes a discount he will lose that discount
exemple if he want to sell the car for only 120000 he will win only 20000 instead of 30000

# FEATURES

added a vehicle catalogue
i use now a forked script you can find it here
https://github.com/TN-DEVV/tn-vehiclecatalogue

added new ui for selling vehicles !

# INSTALLATION

-- add this to qb-core/shared/items

    paint_red 				 	 = {name = 'paint_red', 			  	  		label = 'Paint Red', 				weight = 200, 		type = 'item', 		image = 'paint_red.png', 			unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   description = 'Paint for Vehicle'},
    paint_white 				 = {name = 'paint_white', 			  	  		label = 'Paint White', 				weight = 200, 		type = 'item', 		image = 'paint_white.png', 			unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   description = 'Paint for Vehicle'},
    paint_pink 				 	 = {name = 'paint_pink', 			  	  		label = 'Paint Pink', 				weight = 200, 		type = 'item', 		image = 'paint_pink.png', 			unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   description = 'Paint for Vehicle'},
    paint_blue 				 	 = {name = 'paint_blue', 			  	  		label = 'Paint Blue', 				weight = 200, 		type = 'item', 		image = 'paint_blue.png', 			unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   description = 'Paint for Vehicle'},
    paint_yellow 				 = {name = 'paint_yellow', 			  	  		label = 'Paint Yellow', 			weight = 200, 		type = 'item', 		image = 'paint_yellow.png', 		unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   description = 'Paint for Vehicle'},
    paint_green 				 = {name = 'paint_green', 			  	  		label = 'Paint Green', 				weight = 200, 		type = 'item', 		image = 'paint_green.png', 			unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   description = 'Paint for Vehicle'},
    paint_orange 				 = {name = 'paint_orange', 			  	  		label = 'Paint Orange', 			weight = 200, 		type = 'item', 		image = 'paint_orange.png', 		unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   description = 'Paint for Vehicle'},
    paint_brown 				 = {name = 'paint_brown', 			  	  		label = 'Paint Brown', 				weight = 200, 		type = 'item', 		image = 'paint_brown.png', 			unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   description = 'Paint for Vehicle'},
    paint_purple 				 = {name = 'paint_purple', 			  	  		label = 'Paint Purple', 			weight = 200, 		type = 'item', 		image = 'paint_purple.png', 		unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   description = 'Paint for Vehicle'},
    paint_grey 				 	 = {name = 'paint_grey', 			  	  		label = 'Paint Grey', 				weight = 200, 		type = 'item', 		image = 'paint_grey.png', 			unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   description = 'Paint for Vehicle'},
    paint_black 				 = {name = 'paint_black', 			  	  		label = 'Paint Black', 				weight = 200, 		type = 'item', 		image = 'paint_black.png', 			unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   description = 'Paint for Vehicle'},
    door 				 	 	 = {name = 'door', 			  	  				label = 'Vehicle Door', 			weight = 200, 		type = 'item', 		image = 'door.png', 			unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   description = 'Parts for Vehicle'},
    bonnet 				 	 	 = {name = 'bonnet', 			  	  			label = 'Vehicle bonnet', 			weight = 200, 		type = 'item', 		image = 'bonnet.png', 			unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   description = 'Parts for Vehicle'},
    trunk 				 		 = {name = 'trunk', 			  	  			label = 'Vehicle trunk', 			weight = 200, 		type = 'item', 		image = 'trunk.png', 			unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   description = 'Parts for Vehicle'},
    wheel 				 	 	 = {name = 'wheel', 			  	  			label = 'Vehicle wheel', 			weight = 200, 		type = 'item', 		image = 'wheel.png', 			unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   description = 'Parts for Vehicle'},
    seat 				 		 = {name = 'seat', 			  	  				label = 'Vehicle seat', 			weight = 200, 		type = 'item', 		image = 'seat.png', 			unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   description = 'Parts for Vehicle'},
    engine 				 		 = {name = 'engine', 			  	  			label = 'Vehicle engine', 			weight = 200, 		type = 'item', 		image = 'engine.png', 			unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   description = 'Parts for Vehicle'},
    transmition 				 = {name = 'transmition', 			  	  		label = 'Vehicle transmition', 		weight = 200, 		type = 'item', 		image = 'transmition.png', 		unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   description = 'Parts for Vehicle'},
    exhaust 				 	 = {name = 'exhaust', 			  	  			label = 'Vehicle exhaust', 			weight = 200, 		type = 'item', 		image = 'exhaust.png', 			unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   description = 'Parts for Vehicle'},
    brake 				 	 	 = {name = 'brake', 			  	  			label = 'Vehicle brake', 			weight = 200, 		type = 'item', 		image = 'brake.png', 			unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   description = 'Parts for Vehicle'},

-- SQL
if you are using qb-vehicleshop you do not need to import vehshop.sql
if you don't so please import vehshop.sql

and import the sql.sql

--add itemsimages to your inventory script

--delete any other vehicle shop script and drag and drop the script
