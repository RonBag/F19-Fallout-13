/datum/reagent/drug
	name = "Drug"
	id = "drug"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	taste_description = "bitterness"
	var/trippy = TRUE //Does this drug make you trip?

/datum/reagent/drug/on_mob_delete(mob/living/M)
	if(trippy)
		SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "[id]_high")

/datum/reagent/drug/space_drugs
	name = "Space drugs"
	id = "space_drugs"
	description = "An illegal chemical compound used as drug."
	color = "#60A584" // rgb: 96, 165, 132
	overdose_threshold = 30

/datum/reagent/drug/space_drugs/on_mob_life(mob/living/carbon/M)
	M.set_drugginess(15)
	if(isturf(M.loc) && !isspaceturf(M.loc))
		if(M.canmove)
			if(prob(10))
				step(M, pick(GLOB.cardinals))
	if(prob(7))
		M.emote(pick("twitch","drool","moan","giggle"))
	..()

/datum/reagent/drug/space_drugs/overdose_start(mob/living/M)
	to_chat(M, "<span class='userdanger'>You start tripping hard!</span>")
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "[id]_overdose", /datum/mood_event/drugs/overdose, name)

/datum/reagent/drug/space_drugs/overdose_process(mob/living/M)
	if(M.hallucination < volume && prob(20))
		M.hallucination += 5
	..()

/datum/reagent/drug/nicotine
	name = "Nicotine"
	id = "nicotine"
	description = "Slightly reduces stun times. If overdosed it will deal toxin and oxygen damage."
	reagent_state = LIQUID
	color = "#60A584" // rgb: 96, 165, 132
	addiction_threshold = 30
	taste_description = "smoke"
	trippy = FALSE

/datum/reagent/drug/nicotine/on_mob_life(mob/living/carbon/M)
	if(prob(1))
		var/smoke_message = pick("You feel relaxed.", "You feel calmed.","You feel alert.","You feel rugged.")
		to_chat(M, "<span class='notice'>[smoke_message]</span>")
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "smoked", /datum/mood_event/drugs/smoked, name)
	M.AdjustStun(-20, 0)
	M.AdjustKnockdown(-20, 0)
	M.AdjustUnconscious(-20, 0)
	M.adjustStaminaLoss(-0.5*REM, 0)
	..()
	. = 1

/datum/reagent/drug/crank
	name = "Crank"
	id = "crank"
	description = "Reduces stun times by about 200%. If overdosed or addicted it will deal significant Toxin, Brute and Brain damage."
	reagent_state = LIQUID
	color = "#FA00C8"
	overdose_threshold = 20
	addiction_threshold = 10

/datum/reagent/drug/crank/on_mob_life(mob/living/carbon/M)
	if(prob(5))
		var/high_message = pick("You feel jittery.", "You feel like you gotta go fast.", "You feel like you need to step it up.")
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.AdjustStun(-20, 0)
	M.AdjustKnockdown(-20, 0)
	M.AdjustUnconscious(-20, 0)
	..()
	. = 1

/datum/reagent/drug/crank/overdose_process(mob/living/M)
	M.adjustBrainLoss(2*REM)
	M.adjustToxLoss(2*REM, 0)
	M.adjustBruteLoss(2*REM, 0)
	..()
	. = 1

/datum/reagent/drug/crank/addiction_act_stage1(mob/living/M)
	M.adjustBrainLoss(5*REM)
	..()

/datum/reagent/drug/crank/addiction_act_stage2(mob/living/M)
	M.adjustToxLoss(5*REM, 0)
	..()
	. = 1

/datum/reagent/drug/crank/addiction_act_stage3(mob/living/M)
	M.adjustBruteLoss(5*REM, 0)
	..()
	. = 1

/datum/reagent/drug/crank/addiction_act_stage4(mob/living/M)
	M.adjustBrainLoss(3*REM)
	M.adjustToxLoss(5*REM, 0)
	M.adjustBruteLoss(5*REM, 0)
	..()
	. = 1

/datum/reagent/drug/krokodil
	name = "Krokodil"
	id = "krokodil"
	description = "Cools and calms you down. If overdosed it will deal significant Brain and Toxin damage. If addicted it will begin to deal fatal amounts of Brute damage as the subject's skin falls off."
	reagent_state = LIQUID
	color = "#0064B4"
	overdose_threshold = 20
	addiction_threshold = 15


/datum/reagent/drug/krokodil/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("You feel calm.", "You feel collected.", "You feel like you need to relax.")
	if(prob(5))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	..()

/datum/reagent/drug/krokodil/overdose_process(mob/living/M)
	M.adjustBrainLoss(0.25*REM)
	M.adjustToxLoss(0.25*REM, 0)
	..()
	. = 1

/datum/reagent/drug/krokodil/addiction_act_stage1(mob/living/M)
	M.adjustBrainLoss(2*REM)
	M.adjustToxLoss(2*REM, 0)
	..()
	. = 1

/datum/reagent/krokodil/addiction_act_stage2(mob/living/M)
	if(prob(25))
		to_chat(M, "<span class='danger'>Your skin feels loose...</span>")
	..()

/datum/reagent/drug/krokodil/addiction_act_stage3(mob/living/M)
	if(prob(25))
		to_chat(M, "<span class='danger'>Your skin starts to peel away...</span>")
	M.adjustBruteLoss(3*REM, 0)
	..()
	. = 1

/datum/reagent/drug/krokodil/addiction_act_stage4(mob/living/carbon/human/M)
	CHECK_DNA_AND_SPECIES(M)
	if(!istype(M.dna.species, /datum/species/krokodil_addict))
		to_chat(M, "<span class='userdanger'>Your skin falls off easily!</span>")
		M.adjustBruteLoss(50*REM, 0) // holy shit your skin just FELL THE FUCK OFF
		M.set_species(/datum/species/krokodil_addict)
	else
		M.adjustBruteLoss(5*REM, 0)
	..()
	. = 1

/datum/reagent/drug/methamphetamine
	name = "Methamphetamine"
	id = "methamphetamine"
	description = "Reduces stun times by about 300%, speeds the user up, and allows the user to quickly recover stamina while dealing a small amount of Brain damage. If overdosed the subject will move randomly, laugh randomly, drop items and suffer from Toxin and Brain damage. If addicted the subject will constantly jitter and drool, before becoming dizzy and losing motor control and eventually suffer heavy toxin damage."
	reagent_state = LIQUID
	color = "#FAFAFA"
	overdose_threshold = 20
	addiction_threshold = 10
	metabolization_rate = 0.75 * REAGENTS_METABOLISM

/* This is waaay too overpowered
/datum/reagent/drug/methamphetamine/on_mob_add(mob/living/L)
	..()
	L.add_trait(TRAIT_GOTTAGOREALLYFAST, id)
/datum/reagent/drug/methamphetamine/on_mob_delete(mob/living/L)
	L.remove_trait(TRAIT_GOTTAGOREALLYFAST, id)
	..()
*/

/datum/reagent/drug/methamphetamine/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("You feel hyper.", "You feel like you need to go faster.", "You feel like you can run the world.")
	if(prob(5))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.AdjustStun(-40, 0)
	M.AdjustKnockdown(-40, 0)
	M.AdjustUnconscious(-40, 0)
	M.adjustStaminaLoss(-2, 0)
	M.Jitter(2)
	M.adjustBrainLoss(rand(1,4))
	if(prob(5))
		M.emote(pick("twitch", "shiver"))
	..()
	. = 1

/datum/reagent/drug/methamphetamine/overdose_process(mob/living/M)
	if(M.canmove && !ismovableatom(M.loc))
		for(var/i in 1 to 4)
			step(M, pick(GLOB.cardinals))
	if(prob(20))
		M.emote("laugh")
	if(prob(33))
		M.visible_message("<span class='danger'>[M]'s hands flip out and flail everywhere!</span>")
		M.drop_all_held_items()
	..()
	M.adjustToxLoss(1, 0)
	M.adjustBrainLoss(pick(0.5, 0.6, 0.7, 0.8, 0.9, 1))
	. = 1

/datum/reagent/drug/methamphetamine/addiction_act_stage1(mob/living/M)
	M.Jitter(5)
	if(prob(20))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/methamphetamine/addiction_act_stage2(mob/living/M)
	M.Jitter(10)
	M.Dizzy(10)
	if(prob(30))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/methamphetamine/addiction_act_stage3(mob/living/M)
	if(M.canmove && !ismovableatom(M.loc))
		for(var/i = 0, i < 4, i++)
			step(M, pick(GLOB.cardinals))
	M.Jitter(15)
	M.Dizzy(15)
	if(prob(40))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/methamphetamine/addiction_act_stage4(mob/living/carbon/human/M)
	if(M.canmove && !ismovableatom(M.loc))
		for(var/i = 0, i < 8, i++)
			step(M, pick(GLOB.cardinals))
	M.Jitter(20)
	M.Dizzy(20)
	M.adjustToxLoss(5, 0)
	if(prob(50))
		M.emote(pick("twitch","drool","moan"))
	..()
	. = 1

/datum/reagent/drug/bath_salts
	name = "Bath Salts"
	id = "bath_salts"
	description = "Makes you impervious to stuns and grants a stamina regeneration buff, but you will be a nearly uncontrollable tramp-bearded raving lunatic."
	reagent_state = LIQUID
	color = "#FAFAFA"
	overdose_threshold = 20
	addiction_threshold = 10
	taste_description = "salt" // because they're bathsalts?
	var/datum/brain_trauma/special/psychotic_brawling/bath_salts/rage

/datum/reagent/drug/bath_salts/on_mob_add(mob/living/L)
	..()
	L.add_trait(TRAIT_STUNIMMUNE, id)
	L.add_trait(TRAIT_SLEEPIMMUNE, id)
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		rage = new()
		C.gain_trauma(rage, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/reagent/drug/bath_salts/on_mob_delete(mob/living/L)
	L.remove_trait(TRAIT_STUNIMMUNE, id)
	L.remove_trait(TRAIT_SLEEPIMMUNE, id)
	if(rage)
		QDEL_NULL(rage)
	..()

/datum/reagent/drug/bath_salts/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("You feel amped up.", "You feel ready.", "You feel like you can push it to the limit.")
	if(prob(5))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.adjustStaminaLoss(-5, 0)
	M.adjustBrainLoss(4)
	M.hallucination += 5
	if(M.canmove && !ismovableatom(M.loc))
		step(M, pick(GLOB.cardinals))
		step(M, pick(GLOB.cardinals))
	..()
	. = 1

/datum/reagent/drug/bath_salts/overdose_process(mob/living/M)
	M.hallucination += 5
	if(M.canmove && !ismovableatom(M.loc))
		for(var/i in 1 to 8)
			step(M, pick(GLOB.cardinals))
	if(prob(20))
		M.emote(pick("twitch","drool","moan"))
	if(prob(33))
		M.drop_all_held_items()
	..()

/datum/reagent/drug/bath_salts/addiction_act_stage1(mob/living/M)
	M.hallucination += 10
	if(M.canmove && !ismovableatom(M.loc))
		for(var/i = 0, i < 8, i++)
			step(M, pick(GLOB.cardinals))
	M.Jitter(5)
	M.adjustBrainLoss(10)
	if(prob(20))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/bath_salts/addiction_act_stage2(mob/living/M)
	M.hallucination += 20
	if(M.canmove && !ismovableatom(M.loc))
		for(var/i = 0, i < 8, i++)
			step(M, pick(GLOB.cardinals))
	M.Jitter(10)
	M.Dizzy(10)
	M.adjustBrainLoss(10)
	if(prob(30))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/bath_salts/addiction_act_stage3(mob/living/M)
	M.hallucination += 30
	if(M.canmove && !ismovableatom(M.loc))
		for(var/i = 0, i < 12, i++)
			step(M, pick(GLOB.cardinals))
	M.Jitter(15)
	M.Dizzy(15)
	M.adjustBrainLoss(10)
	if(prob(40))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/bath_salts/addiction_act_stage4(mob/living/carbon/human/M)
	M.hallucination += 30
	if(M.canmove && !ismovableatom(M.loc))
		for(var/i = 0, i < 16, i++)
			step(M, pick(GLOB.cardinals))
	M.Jitter(50)
	M.Dizzy(50)
	M.adjustToxLoss(5, 0)
	M.adjustBrainLoss(10)
	if(prob(50))
		M.emote(pick("twitch","drool","moan"))
	..()
	. = 1

/datum/reagent/drug/aranesp
	name = "Aranesp"
	id = "aranesp"
	description = "Amps you up and gets you going, fixes all stamina damage you might have but can cause toxin and oxygen damage."
	reagent_state = LIQUID
	color = "#78FFF0"

/datum/reagent/drug/aranesp/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("You feel amped up.", "You feel ready.", "You feel like you can push it to the limit.")
	if(prob(5))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.adjustStaminaLoss(-18, 0)
	M.adjustToxLoss(0.5, 0)
	if(prob(50))
		M.losebreath++
		M.adjustOxyLoss(1, 0)
	..()
	. = 1

/datum/reagent/drug/jet
	name = "Jet Inhalant"
	id = "jet"
	description = "A chemical used to induce a euphoric high derived from brahmin dung. Fast-acting, powerful, and highly addictive."
	color = "#60A584" // rgb: 96, 165, 132
	overdose_threshold = 30
	addiction_threshold = 20

/datum/reagent/drug/jet/on_mob_life(mob/living/carbon/M)
	M.set_drugginess(20)
	if(isturf(M.loc) && !isspaceturf(M.loc))
		if(M.canmove)
			if(prob(10))
				step(M, pick(GLOB.cardinals))
	if(prob(12))
		M.emote(pick("twitch","drool","moan","giggle"))
	..()

/datum/reagent/drug/jet/overdose_start(mob/living/M)
	to_chat(M, "<span class='userdanger'>You start tripping hard!</span>")
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "[id]_overdose", /datum/mood_event/drugs/overdose, name)

/datum/reagent/drug/jet/overdose_process(mob/living/M)
	if(M.hallucination < volume && prob(20))
		M.hallucination += 5
		M.adjustToxLoss(0.5, 0)
	..()

/datum/reagent/drug/jet/addiction_act_stage1(mob/living/M)
	if(prob(20))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/jet/addiction_act_stage2(mob/living/M)
	M.Dizzy(5)
	if(prob(30))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/jet/addiction_act_stage3(mob/living/M)
	if(M.canmove && !ismovableatom(M.loc))
		for(var/i = 0, i < 4, i++)
			step(M, pick(GLOB.cardinals))
	M.Dizzy(10)
	if(prob(40))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/jet/addiction_act_stage4(mob/living/carbon/human/M)
	if(M.canmove && !ismovableatom(M.loc))
		for(var/i = 0, i < 8, i++)
			step(M, pick(GLOB.cardinals))
	M.Dizzy(15)
	if(prob(50))
		M.emote(pick("twitch","drool","moan"))
	..()
	. = 1

/datum/reagent/drug/cateye
	name = "Cateye"
	id = "cateye"
	description = "A chemical compound that, when consumed, enhance user vision via a yellow tint in dark places."
	reagent_state = LIQUID
	color = "#f5e664"
	overdose_threshold = 20
	addiction_threshold = 100
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/drug/cateye/on_mob_add(mob/M)
	..()
	if(isliving(M))
		var/mob/living/L = M
		var/obj/item/organ/eyes/eyes = M.getorganslot(ORGAN_SLOT_EYES)
		eyes.see_in_dark = 128
		eyes.lighting_alpha = LIGHTING_PLANE_ALPHA_LOWLIGHT_VISION
		M.add_client_colour(/datum/client_colour/cat_eye)
		L.add_trait(TRAIT_CAT_EYES_NV, id)
		M.update_sight()

/datum/reagent/drug/cateye/on_mob_delete(mob/M)
	if(isliving(M))
		var/mob/living/L = M
		var/obj/item/organ/eyes/eyes = M.getorganslot(ORGAN_SLOT_EYES)
		eyes.see_in_dark = initial(eyes.see_in_dark)
		eyes.lighting_alpha = initial(eyes.lighting_alpha)
		M.remove_client_colour(/datum/client_colour/cat_eye)
		L.remove_trait(TRAIT_CAT_EYES_NV, id)
		M.update_sight()
	..()

/datum/reagent/drug/cateye/overdose_process(mob/living/M)
	if(prob(15))
		M.emote(pick("scream", "cry", "moan_p"))
	if(prob(7))
		M.adjust_eye_damage(rand(1,3))
		M.blur_eyes(rand(10,20))
		M.visible_message("<span class='danger'>Your eyes burns!</span>")
	..()
	M.adjustToxLoss(1, 0)
	. = 1

/datum/reagent/drug/turbo
	name = "Turbo Inhalant"
	id = "turbo"
	description = "A chemical compound that, when inhaled, vastly increases the user's reflexes and slows their perception of time. Carries a risk of addiction and extreme nausea and toxin damage if overdosed."
	reagent_state = LIQUID
	color = "#FAFAFA"
	overdose_threshold = 20
	metabolization_rate = 2 * REAGENTS_METABOLISM

/datum/reagent/drug/turbo/on_mob_add(mob/M)
	..()
	if(isliving(M))
		var/mob/living/L = M
		L.add_trait(TRAIT_IGNORESLOWDOWN, id)

/datum/reagent/drug/turbo/on_mob_delete(mob/M)
	if(isliving(M))
		var/mob/living/L = M
		L.remove_trait(TRAIT_IGNORESLOWDOWN, id)
	..()

/datum/reagent/drug/turbo/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("You feel hyper.", "You feel like you need to go faster.", "You feel like you can run the world.")
	if(prob(5))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.Jitter(2)
	if(prob(5))
		M.emote(pick("twitch", "shiver"))
	..()
	. = 1

/datum/reagent/drug/turbo/overdose_process(mob/living/M)
	if(M.canmove && !ismovableatom(M.loc))
		for(var/i in 1 to 4)
			step(M, pick(GLOB.cardinals))
	if(prob(20))
		M.emote("laugh")
	if(prob(33))
		M.visible_message("<span class='danger'>[M]'s hands flip out and flail everywhere!</span>")
		M.drop_all_held_items()
	..()
	M.adjustToxLoss(2, 0)
	. = 1

/datum/reagent/drug/turbo/addiction_act_stage1(mob/living/M)
	M.Jitter(5)
	if(prob(20))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/turbo/addiction_act_stage2(mob/living/M)
	M.Jitter(10)
	M.Dizzy(10)
	if(prob(30))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/turbo/addiction_act_stage3(mob/living/M)
	if(M.canmove && !ismovableatom(M.loc))
		for(var/i = 0, i < 4, i++)
			step(M, pick(GLOB.cardinals))
	M.Jitter(15)
	M.Dizzy(15)
	if(prob(40))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/turbo/addiction_act_stage4(mob/living/carbon/human/M)
	if(M.canmove && !ismovableatom(M.loc))
		for(var/i = 0, i < 8, i++)
			step(M, pick(GLOB.cardinals))
	M.Jitter(20)
	M.Dizzy(20)
	M.adjustToxLoss(6, 0)
	if(prob(50))
		M.emote(pick("twitch","drool","moan"))
	..()
	. = 1

/datum/reagent/drug/psycho
	name = "Psycho Fluid"
	id = "psycho"
	description = "Makes the user hit harder and shrug off slight stuns, but causes slight brain damage and carries a risk of addiction."
	reagent_state = LIQUID
	color = "#FF0000"
	overdose_threshold = 20
	addiction_threshold = 15
	metabolization_rate = 0.3 * REAGENTS_METABOLISM
	var/datum/brain_trauma/special/psychotic_brawling/bath_salts/rage


/datum/reagent/drug/psycho/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("<br><font color='#FF0000'><b>FUCKING KILL!</b></font>", "<br><font color='#FF0000'><b>RAAAAR!</b></font>", "<br><font color='#FF0000'><b>BRING IT!</b></font>")
	if(prob(20))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.AdjustStun(-20, 0)
	M.AdjustKnockdown(-20, 0)
	M.AdjustUnconscious(-20, 0)
	M.adjustStaminaLoss(-3, 0)
	M.Jitter(2)
	M.adjustBrainLoss(rand(1,0))
	..()
	. = 1

/datum/reagent/drug/psycho/on_mob_add(mob/living/L)
	..()
	L.add_trait(TRAIT_SLEEPIMMUNE, id)
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		rage = new()
		C.gain_trauma(rage, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/reagent/drug/psycho/on_mob_delete(mob/living/L)
	L.remove_trait(TRAIT_SLEEPIMMUNE, id)
	if(rage)
		QDEL_NULL(rage)
	..()

/datum/reagent/drug/psycho/overdose_process(mob/living/M)
	M.hallucination += 20
	if(M.canmove && !istype(M.loc, /atom/movable))
		for(var/i = 0, i < 8, i++)
			step(M, pick(GLOB.cardinals))
	if(prob(20))
		M.emote(pick("twitch","scream","laugh"))
	M.adjustBrainLoss(2)
	..()
	return TRUE

/datum/reagent/drug/psycho/addiction_act_stage1(mob/living/M)
	M.hallucination += 10
	M.Jitter(5)
	M.adjustBrainLoss(1)
	if(prob(20))
		M.emote(pick("twitch","scream","laugh"))
	..()
	return
/datum/reagent/drug/psycho/addiction_act_stage2(mob/living/M)
	M.hallucination += 20
	M.Jitter(10)
	M.Dizzy(10)
	M.adjustBrainLoss(1)
	if(prob(30))
		M.emote(pick("twitch","scream","laugh"))
	..()
	return
/datum/reagent/drug/psycho/addiction_act_stage3(mob/living/M)
	M.hallucination += 30
	if(M.canmove && !istype(M.loc, /atom/movable))
		for(var/i = 0, i < 2, i++)
			step(M, pick(GLOB.cardinals))
	M.Jitter(15)
	M.Dizzy(15)
	M.adjustBrainLoss(10)
	if(prob(40))
		M.emote(pick("twitch","scream","laugh"))
	..()
	return
/datum/reagent/drug/psycho/addiction_act_stage4(mob/living/carbon/human/M)
	M.hallucination += 40
	if(M.canmove && !istype(M.loc, /atom/movable))
		for(var/i = 0, i < 4, i++)
			step(M, pick(GLOB.cardinals))
	M.Jitter(50)
	M.Dizzy(50)
	M.adjustToxLoss(5)
	M.adjustBrainLoss(15)
	if(prob(50))
		M.emote(pick("twitch","scream","laugh"))
	..()

//хайль гидра

/datum/reagent/drug/hydra
	name = "Hydra"
	id = "hydra"
	description = "A powerful drug that heals damaged bones and other."
	color = "#C8A5DC"
	reagent_state = SOLID
	overdose_threshold = 40
	addiction_threshold = 25

/datum/reagent/drug/hydra/on_mob_add(mob/living/L)
	var/power = 3 * L.special._intelligence
	L.adjustToxLoss(-0.5 * power, 0)
	L.adjustOxyLoss(-1.4 * power, 0)
	L.adjustBruteLoss(-1.2 * power, 0)
	L.adjustFireLoss(-1.3 * power, 0)
	..()

/datum/reagent/drug/hydra/on_mob_delete(mob/living/L)
	. = ..()

/datum/reagent/drug/hydra/on_mob_life(mob/living/carbon/M)
	if(prob(5))
		to_chat(M, "<span class='notice'>You don't feel any pain!</span>")
	..()
	. = 1

/datum/reagent/drug/hydra/overdose_process(mob/living/M)
	if(prob(33))
		M.Dizzy(2)
		M.Jitter(2)
		M.adjustBrainLoss(2*REM)
	..()

/datum/reagent/drug/hydra/addiction_act_stage1(mob/living/M)
	if(prob(33))
		M.Jitter(2)
	..()

/datum/reagent/drug/hydra/addiction_act_stage2(mob/living/M)
	if(prob(33))
		. = 1
		M.Dizzy(3)
		M.Jitter(3)
	..()

/datum/reagent/drug/hydra/addiction_act_stage3(mob/living/M)
	if(prob(33))
		M.adjustToxLoss(1*REM, 0)
		M.adjustBrainLoss(2*REM)
		. = 1
		M.Dizzy(4)
		M.Jitter(4)
	..()

/datum/reagent/drug/hydra/addiction_act_stage4(mob/living/M)
	if(prob(33))
		M.drop_all_held_items()
		M.adjustToxLoss(1.5*REM, 0)
		M.adjustBrainLoss(3*REM)
		. = 1
		M.Dizzy(5)
		M.Jitter(5)
	..()

// READY-STEADY

/obj/effect/proc_holder/spell/targeted/view_range
	name = "Concentrate vision"
	desc = "The reward for using Steady."
	action_icon = 'icons/obj/chemical.dmi'
	action_icon_state = "steady"

/datum/reagent/drug/steady
	name = "Steady"
	id = "steady"
	description = "A combat drug made from unknown chemicals, it provides the user with a steady aim that makes it impossible to miss in sharpshooting, perfect for snipers lining themselves up for the perfect shot. Due to the potency and untested nature of the drug, however, it is also highly addictive"
	color = "#C8A5DC"
	reagent_state = LIQUID
	overdose_threshold = 60
	addiction_threshold = 35

/datum/reagent/drug/steady/on_mob_add(mob/living/L)
	. = ..()
	L.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/view_range(null))

/datum/reagent/drug/steady/on_mob_delete(mob/living/L)
	. = ..()
	L.mind.RemoveSpell(/obj/effect/proc_holder/spell/targeted/view_range)
	L.client.change_view(CONFIG_GET(string/default_view))

/datum/reagent/drug/hydra/on_mob_life(mob/living/carbon/M)
	if(prob(5))
		to_chat(M, "<span class='notice'>You feel way more powerful and athletic!</span>")
	..()
	. = 1

/datum/reagent/drug/steady/overdose_process(mob/living/M)
	if(prob(33))
		M.Dizzy(2)
		M.Jitter(2)
		M.adjustBrainLoss(2*REM)
	..()

/datum/reagent/drug/steady/addiction_act_stage1(mob/living/M)
	if(prob(33))
		M.Jitter(2)
	..()

/datum/reagent/drug/steady/addiction_act_stage2(mob/living/M)
	if(prob(33))
		. = 1
		M.Dizzy(3)
		M.Jitter(3)
	..()

/datum/reagent/drug/steady/addiction_act_stage3(mob/living/M)
	if(prob(33))
		M.adjustToxLoss(1*REM, 0)
		M.adjustBrainLoss(2*REM)
		. = 1
		M.Dizzy(4)
		M.Jitter(4)
	..()

/datum/reagent/drug/steady/addiction_act_stage4(mob/living/M)
	if(prob(33))
		M.drop_all_held_items()
		M.adjustToxLoss(2*REM, 0)
		M.adjustBrainLoss(4*REM)
		. = 1
		M.Dizzy(5)
		M.Jitter(5)
	..()



/datum/reagent/drug/rebound
	name = "rebound jija"
	id = "rebound"
	description = "A chemical compound that, when inhaled, vastly increases the user's reflexes and slows their perception of time. Carries a risk of addiction and extreme nausea and toxin damage if overdosed."
	reagent_state = LIQUID
	color = "#FAFAFA"
	overdose_threshold = 50
	addiction_threshold = 35
	metabolization_rate = 3 * REAGENTS_METABOLISM

/datum/reagent/drug/rebound/on_mob_add(mob/M)
	..()
	if(isliving(M))
		var/mob/living/L = M
		L.add_trait(TRAIT_IGNORESLOWDOWN, id)

/datum/reagent/drug/rebound/on_mob_delete(mob/M)
	if(isliving(M))
		var/mob/living/L = M
		L.remove_trait(TRAIT_IGNORESLOWDOWN, id)
	..()

/datum/reagent/drug/rebound/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("You feel hyper.", "You feel like you need to go faster.", "You feel like you can run the world.")
	if(prob(5))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.Jitter(2)
	M.set_drugginess(25)
	if(prob(5))
		M.emote(pick("twitch", "shiver"))
	..()
	. = 1

/datum/reagent/drug/rebound/overdose_process(mob/living/M)
	if(M.canmove && !ismovableatom(M.loc))
		for(var/i in 1 to 4)
			step(M, pick(GLOB.cardinals))
	if(prob(20))
		M.emote("laugh")
	if(prob(33))
		M.visible_message("<span class='danger'>[M]'s hands flip out and flail everywhere!</span>")
		M.drop_all_held_items()
	..()
	M.adjustToxLoss(3, 0)
	. = 1

/datum/reagent/drug/rebound/addiction_act_stage1(mob/living/M)
	M.Jitter(5)
	if(prob(20))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/rebound/addiction_act_stage2(mob/living/M)
	M.Jitter(20)
	M.Dizzy(20)
	if(prob(30))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/rebound/addiction_act_stage3(mob/living/M)
	if(M.canmove && !ismovableatom(M.loc))
		for(var/i = 0, i < 4, i++)
			step(M, pick(GLOB.cardinals))
	M.Jitter(15)
	M.Dizzy(15)
	if(prob(40))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/rebound/addiction_act_stage4(mob/living/carbon/human/M)
	if(M.canmove && !ismovableatom(M.loc))
		for(var/i = 0, i < 8, i++)
			step(M, pick(GLOB.cardinals))
	M.Jitter(20)
	M.Dizzy(20)
	M.adjustToxLoss(6, 0)
	if(prob(50))
		M.emote(pick("twitch","drool","moan"))
	..()
	. = 1