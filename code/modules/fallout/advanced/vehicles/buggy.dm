//Fallout 13 dune buggy directory

/obj/vehicle/fuel/motorcycle/buggy
	name = "dune buggy"
	desc = "<i>Ain't no place for fancy cars on the wasteland.<br>No place for classy brands, but nicknames.<br>Only the rusty and trusty death machines.<br>Only fuel and blood.</i>"
	icon = 'icons/fallout/vehicles/medium_vehicles.dmi'
	icon_state = "buggy_dune"
	var/datum_type = /datum/riding/motorcycle/buggy
	pixel_x = -17
	pixel_y = -2
	obj_integrity = 600
	max_integrity = 600
	fuel = 800
	max_fuel = 800
	self_weight = 700
	engine_on_sound = 'sound/f13machines/buggy_start.ogg'
	engine_loop_sound = 'sound/f13machines/buggy_loop.ogg'
	var/list/names = list("Badger", "Bandit", "Desert Punk", "Dune Buddy", "Duster", "Rebel", "Rooster")

/obj/vehicle/fuel/motorcycle/buggy/New()
	..()
	name = pick(names)

/obj/item/key/buggy
	name = "car key"
	desc = "A keyring with a small steel key.<br>By the look of the key cuts, it likely belongs to an automobile."
	icon = 'icons/fallout/vehicles/small_vehicles.dmi'

/obj/item/key/buggy/New()
	..()
	icon_state = pick("key-buggy-r","key-buggy-y","key-buggy-g","key-buggy-b")

/obj/item/key/buggy/wheel //I am the man... Who grabs the sun... RIDING TO VALHALLA!
	name = "steering wheel"
	desc = "A vital part of an automobile that is made of metal and decorated with a freaky skull.<br>Oh, what a day... What a lovely day for taking a ride!"
	icon_state = "wheel"

/obj/item/key/buggy/wheel/New()
	..()
	icon_state = "wheel"

/datum/riding/motorcycle/buggy
	keytype = /obj/item/key/buggy
	vehicle_move_delay = 0.8

/datum/riding/motorcycle/buggy/handle_vehicle_offsets()
	..()
	if(ridden.has_buckled_mobs())
		for(var/m in ridden.buckled_mobs)
			var/mob/living/buckled_mob = m
			switch(buckled_mob.dir)
				if(NORTH)
					buckled_mob.pixel_x = -1
					buckled_mob.pixel_y = 9
				if(EAST)
					buckled_mob.pixel_x = -5
					buckled_mob.pixel_y = 6
				if(SOUTH)
					buckled_mob.pixel_x = 0
					buckled_mob.pixel_y = 12
				if(WEST)
					buckled_mob.pixel_x = 3
					buckled_mob.pixel_y = 6

/obj/vehicle/fuel/motorcycle/buggy/olive
	icon_state = "buggy_olive"
	names = list("Bang-Bang", "Bolo", "Dittybopper", "Geardo", "Joe", "Pollywog", "Zoomie")

/obj/vehicle/fuel/motorcycle/buggy/red
	icon_state = "buggy_red"
	names = list("Crusher", "Grim Reaper", "Meat Grinder", "Mincer", "Reaver", "Ripper", "Ripsaw")

/obj/vehicle/fuel/motorcycle/buggy/hot
	icon_state = "buggy_hot"
	names = list("Dragon", "Fire And Flames", "Flash", "Igniter", "Heat", "Hot Wheels", "Trailblazer")

/obj/vehicle/fuel/motorcycle/buggy/interceptor
	icon_state = "interceptor"
	names = list("V8 Interceptor", "V8 Interceptor", "V8 Interceptor", "V8 Interceptor", "V8 Interceptor", "V8 Interceptor", "V8 Interceptor")

// Vertibird and thing

/obj/vehicle/fuel/motorcycle/buggy/vertibird
	name = "vertibird"
	desc = "A fucking vertibird. Holy shit."
	icon = 'icons/fallout/vehicles/vertibird.dmi'
	icon_state = "vb-fast"
	engine_on_sound = 'sound/f13machines/vertibird_start.ogg'
	engine_loop_sound = 'sound/f13machines/vertibird_loop.ogg'
	layer = RIPPLE_LAYER+0.5

// We'll make more fixes later - Sansaur

/obj/vehicle/fuel/motorcycle/buggy/vertibird/buckle_mob()
	. = ..()

/obj/vehicle/fuel/motorcycle/buggy/vertibird/relaymove(mob/user)
	. = ..()

/obj/vehicle/fuel/motorcycle/buggy/vertibird/post_buckle_mob(mob/living/M)
	. = ..()

/obj/vehicle/fuel/motorcycle/buggy/vertibird/New()
	..()
	name = "vertibird"

/obj/vehicle/fuel/motorcycle/buggy/vertibird/Move(NewLoc,Dir=0,step_x=0,step_y=0)
	forceMove(NewLoc)
	..()

/obj/vehicle/fuel/motorcycle/buggy/vertibird/ncr
	name = "ncr vertibird"
	desc = "A vertibird belonging to the NCR."
	icon = 'icons/fallout/vehicles/vertibird.dmi'
	icon_state = "vb-fast_ncr"
	engine_on_sound = 'sound/f13machines/vertibird_start.ogg'
	engine_loop_sound = 'sound/f13machines/vertibird_loop.ogg'
	layer = RIPPLE_LAYER+0.5
	bound_height = 64
	bound_width = 64

/datum/riding/motorcycle/buggy/vertibird/handle_vehicle_offsets()
	..()
	if(ridden.has_buckled_mobs())
		for(var/m in ridden.buckled_mobs)
			var/mob/living/buckled_mob = m
			switch(buckled_mob.dir)
				if(NORTH)
					buckled_mob.pixel_x = 128
					buckled_mob.pixel_y = 220
				if(EAST)
					buckled_mob.pixel_x = 210
					buckled_mob.pixel_y = 128
				if(SOUTH)
					buckled_mob.pixel_x = 128
					buckled_mob.pixel_y = 64
				if(WEST)
					buckled_mob.pixel_x = 64
					buckled_mob.pixel_y = 128