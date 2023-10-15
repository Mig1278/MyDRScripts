#Script by Boobear
	# Special thanks to Jon for tons of help on the tricky bits! :)

#v1.2 (10/14/2023)
#v1.1 (10/13/2023)
#v1.0 (10/12/2023)
debug 11

# Change Log
	# v1.2 - Added ability to predict without a tool (set default_prediction_tool_item to NONE)
	# v1.2 - Minor variable fixes, Corrected misspelled vars
	# v1.2 - Added Prediction Check matchre table to ensure predictions actually happen successfully
	# v1.1 - Switched the array order back to the way it's suppose to be... 

#TODO 
	#Add Chant Cantrip to align to fix negative predictions
		# Will need to be heritage house, have cantrip, track CD of cantrip, recognize negative prediction, remove it
		# OR.... just redo the prediction??? not sure that works.
	# What if the left hand holds a loaded item
		# Need to check if it's a ranged item and unload it so can drop it.

#FEATURES:
	# Allows selection of 3 different predictions to try and keep up. Uses exp-mods to check which skills are being buffed and assumes it's from a prediction.
	# Allows the use of multiple tools based on pool and selection of a default tool
	# Clears the left hand of the item, tracks what it was, and then re-gets it after prediction
	# Supports Portal for prediction tool location.
	#script works stand alone as well as called from another script
		# If called from another script, you're waiting for PREDICTION DONE



####################################################################################################################
VARIABLE_INITIALIZATION:
	var first_predict_skill first aid
	var second_predict_skill evasion
	var third_predict_skill first aid

	var prediction_tool_location bag
	var default_prediction_tool_item NONE
		#set the tools you want to use. If none, then put NONE

	var prediction_available_tools prism
	#var prediction_available_tools prism|chart|bones|mirror|bowl	
		#Offense:Prism; magic:chart; survival:bones
		#Lore & Defense aren't detailed in epedia.. currently set as lore:mirror & defense:bowl
		#tokka cards not supported



####################################################################################################################
#############################    NO TOUCHY PAST THIS LINE ###################################
####################################################################################################################

MULTI_PREDICTION:
		# Initialize vars and actions for multi-predict
	gosub MULTI_PREDICT_VAR_INIT
		# check to see if you have available prediction pools full enough
	gosub MM_PREDICT_STATUS_CHECK
		#go predict some shit
	gosub MM_PREDICT


    put #parse PREDICTION DONE
	exit

MULTI_PREDICT_VAR_INIT:
		# initialize empaty array to capture what exp_mods are active and (we assume some are predictions)
	var up_predictions NULL|
		# set pool variables (just makes it easier to call them later)
	var defense_pool Brigandine|Defending|Chain Armor|Light Armor|Parry Ability|Plate Armor|Shield
	var offense_pool Bow|Brawling|Crossbow|Heavy Thrown|Large Blunt|Large Edged|Light Thrown|Melee Mastery|Missile Mastery|Offhand Weapon|Polearm|Slings|Small Blunt|Small Edged|Staves|Twohanded Blunt|Twohanded Edged|Expertise
	var magic_pool Arcana|Attunement|Augmentation|Debilitation|Primary Magic|Targeted Magic|Sorcery|Utility|Warding|Astrology
	var survival_pool Athletics|Evasion|First Aid|Locksmithing|Outdoorsmanship|Perception|Skinning|Stealth|Thievery
	var lore_pool Alchemy|Appraisal|Enchanting|Engineering|Forging|Outfitting|Performance|Scholarship|Tactics

		# remove the skill from the up_predictions array when they drop	
	action eval %up_predictions replacere("%up_predictions", "(?i)$1\|", "") when ^You recognize these fading strands of Fate as those that influence your (.*) skill\.$
		# clear the up_predictions array when exp mods is run so that there are never duplicates
	action var up_predictions NULL| when ^The following skills are currently under the influence of a modifier
		# add the skill to the up_predictions array when exp mods sees them
	action var up_predictions %up_predictions$1| when ^[+-]{1,2}\d+\((?:\d+\%|-)\)\s([\w\s]+)\s\(\d+\s+effective\s+ranks\)

	#general Astrology Actions for filling the pools
	put #script pause all except %scriptname
	action (mm_status_check) put #var PoolStatus.magic $1 when ^You have (.*) of the celestial influences over magic
	action (mm_status_check) put #var PoolStatus.lore $1 when ^You have (.*) of the celestial influences over lore
	action (mm_status_check) put #var PoolStatus.offensive $1 when ^You have (.*) of the celestial influences over offensive combat
	action (mm_status_check) put #var PoolStatus.defensive $1 when ^You have (.*) of the celestial influences over defensive combat
	action (mm_status_check) put #var PoolStatus.survival $1 when ^You have (.*) of the celestial influences over survival
	action (mm_status_check) on
	return

##@ *****
MM_PREDICT_STATUS_CHECK:
	# use predict state all to identify the pool fill status using the actions
	action (mm_status_check) on
	pause .5
	if ($monstercount > 1) then gosub retreat
		matchre MM_PREDICT_STATUS_CHECK_CAPTURED future events
	put retreat; predict state all
	matchwait 3
	goto MM_PREDICT_STATUS_CHECK

##@ *****
MM_PREDICT_STATUS_CHECK_CAPTURED:
	#pool fill status is captured, we're only using complete pools tho, so return if none completely full.
	action (mm_status_check) off
	pause .1
	if (!matchre("$PoolStatus.lore|$PoolStatus.magic|$PoolStatus.offensive|$PoolStatus.defensive|$PoolStatus.survival","complete")) then {
		put #var predict_pools_empty TRUE
		put #var predict_pools_empty_time @unixtime@
		put #script resume all
	}
	echo ******* POOL STATUS *******
	echo ******* lore : $PoolStatus.lore
	echo ******* magic : $PoolStatus.magic
	echo ******* offensive : $PoolStatus.offensive
	echo ******* defensive : $PoolStatus.defensive
	echo ******* survival : $PoolStatus.survival
	echo ******* POOL STATUS *******
	return

##@ *****	
MM_PREDICT:
	# this is set up so you can use other pool fill amounts (other then complete), if you want that, add them to the predict_current_amount array
	var predict_current_amount complete
	eval predict_current_amount_length count("%predict_current_amount","|")
	var current_amount_counter 0

	var predict_pool_type survival|magic|lore|offensive|defensive
	eval predict_pool_type_length count("%predict_pool_type","|")
	var predict_pool_type_counter 0

	##@ *****
	MM_PREDICT_READLOOP:
		#loop through the pool for the first one that matches the fill state dictated by predict_current_amount array
		if (matchre("$PoolStatus.%predict_pool_type(%predict_pool_type_counter)","%predict_current_amount(%current_amount_counter)")) then {
			var MM_TMP %predict_pool_type(%predict_pool_type_counter)
			goto MM_PREDICT_DRAIN_POOL
		}
		else {
			math predict_pool_type_counter add 1
			if (%predict_pool_type_counter > %predict_pool_type_length) then {
				# no pools match the fill state required by predict_current_amount
				var predict_pool_type_counter 0
				math current_amount_counter add 1
				if (%current_amount_counter > %predict_current_amount_length) then goto MM_PREDICT_NOTHINGLEFT
			}
			goto MM_PREDICT_READLOOP
		}
		#something broke
		echo MM_PREDICT_READLOOP Didn't work correctly.
		put #script resume all
		return

	##@ *****	
	MM_PREDICT_DRAIN_POOL:
		# prediction pool determined, echo it back and keep going
		echo ************** Pool to drain IS %MM_TMP **************
		echo pool type %predict_pool_type(%predict_pool_type_counter)
		if (matchre("%MM_TMP","(?i)offen")) then var MM_TMP offen
		if (matchre("%MM_TMP","(?i)defen")) then var MM_TMP defen
		if (matchre("%MM_TMP","(?i)surv")) then var MM_TMP surv
		pause .5
		goto MULTI_PREDICT_SET_SKILL

	##@ *****	
	MULTI_PREDICT_SET_SKILL:
			matchre MULTI_PREDICT_SET_SKILL_SUB ^The following skills are currently under
		send exp mods
		matchwait 2
		goto MULTI_PREDICT_SET_SKILL

	##@ *****	
	MULTI_PREDICT_SET_SKILL_SUB:
		pause 2
		# Determine what skill to predict. Order is 1st, 2nd, then 3rd until 1st drops.
		var next_prediction %third_predict_skill
		if (!matchre("%up_predictions","(?i)%second_predict_skill")) then var next_prediction %second_predict_skill
		if (!matchre("%up_predictions","(?i)%first_predict_skill")) then var next_prediction %first_predict_skill

		# Determine the prediction pool to use based off the "next_Prediction" variable.
		if (matchre("%defense_pool","(?i)%next_prediction")) then var prediction_pool defen
		if (matchre("%offense_pool","(?i)%next_prediction")) then var prediction_pool offen
		if (matchre("%magic_pool","(?i)%next_prediction")) then var prediction_pool magic
		if (matchre("%survival_pool","(?i)%next_prediction")) then var prediction_pool surv
		if (matchre("%lore_pool","(?i)%next_prediction")) then var prediction_pool lore

		echo ************** SKill to predict:  %next_prediction **************
		echo ************** Pool to transmog to:  %prediction_pool from %MM_TMP **************

		goto MULTI_PREDICT_TRANSMOG

	##@ *****	
	MULTI_PREDICT_TRANSMOG:
		if (matchre("%MM_TMP","%prediction_pool")) then goto MM_PREDICT_GET_TOOL_PRE
			matchre MM_PREDICT_GET_TOOL_PRE ^You delve into your prophetic reserves|^You already have a complete
		send align transmogrify %MM_TMP to %prediction_pool
		matchwait 2
		goto MULTI_PREDICT_TRANSMOG

	##@ *****	
	MM_PREDICT_GET_TOOL_PRE:
			#Assigns the appopriate tool for the prediction pool you want to use.
		# If you dont have the tool then it uses the default tool
		# If you dont want to use a tool, then it sets tool to NONE and goes to alignment sub

		if (matchre("%prediction_tool_item","(?i)NONE")) then {
			var prediction_tool_item NONE
			goto MM_PREDICT_ALIGN_YOSELF
		}

		# The domain bonus is defined for these three here: https://elanthipedia.play.net/Prediction#Tools
		if (matchre("offen","(?i)%prediction_pool")) then var prediction_tool_item prism
		if (matchre("magic","(?i)%prediction_pool")) then var prediction_tool_item chart
		if (matchre("surv","(?i)%prediction_pool")) then var prediction_tool_item bones
			#unknown what the domain bonus is for the others so just setting to bowl & mirror so they get used
		if (matchre("lore","(?i)%prediction_pool")) then var prediction_tool_item mirror
		if (matchre("defen","(?i)%prediction_pool")) then var prediction_tool_item bowl

			#checks to see if you have that tool available, if not it uses the default tool
		if (!matchre("%prediction_available_tools","(?i)%prediction_tool_item")) then var prediction_tool_item %default_prediction_tool_item

			#determine the prediction tool action to use based on the tool type
		if (matchre("prism","(?i)%prediction_tool_item")) then var prediction_tool_action raise
		if (matchre("chart","(?i)%prediction_tool_item")) then var prediction_tool_action review
		if (matchre("bones","(?i)%prediction_tool_item")) then var prediction_tool_action roll
		if (matchre("mirror","(?i)%prediction_tool_item")) then var prediction_tool_action gaze
		if (matchre("bowl","(?i)%prediction_tool_item")) then var prediction_tool_action gaze

		pause 4
		MM_PREDICT_GET_TOOL:
			if (!matchre("$lefthand","Empty")) then {
				var tmp_lefthand $lefthand
				send stow my $lefthand
				pause 1
				if (!matchre("$lefthand","Empty")) then {
					send put my $lefthand in my $cs_oversize_container
					pause 1
				}
			}
			matchre TOOL_NOT_FOUND ^What were
			matchre MM_PREDICT_ALIGN_YOSELF ^You get
		send get my %prediction_tool_item from my %prediction_tool_location
		matchwait 2
		goto MM_PREDICT_GET_TOOL

		##@ *****	
		TOOL_NOT_FOUND:
			pause .5
			send get my %prediction_tool_item
			pause .5
			if (!matchre("$lefthand|$righthand","%prediction_tool_item")) then {
				send get my %prediction_tool_item from my portal
				pause .5
			}
			if (!matchre("$lefthand|$righthand","%prediction_tool_item")) then {
				echo ************** No %prediction_tool_item found jack-hole **************
				echo ************** No %prediction_tool_item found jack-hole **************
			}
			goto MM_PREDICT_ALIGN_YOSELF

	##@ *****	
	MM_PREDICT_ALIGN_YOSELF:
			matchre MM_PREDICT_GO ^You focus internally
		send align %next_prediction
		matchwait 2
		goto MM_PREDICT_ALIGN_YOSELF

	## *****
	MM_PREDICT_GO:
		if ($monstercount > 1) then gosub retreat
		put #var last_predict_check @unixtime@
			matchre MM_PREDICT_GO ^You are far too occupied by present
			matchre MM_PREDICT_HURT You're having too much trouble focusing due to your recent injuries to accomplish that.
			matchre MM_PREDICT_STATUS_CHECK ^You realize you have not yet properly aligned yourself to perform a prediction.
				# Prism|Bowl|Tokka|Chart|Mirror|Bones Predict specific verbiage
			matchre MM_PREDICT_SUCCESS ^You carefully slip the prism from its chain|^You gaze into the bowl|^You prepare to deal from your Tokka deck|^You carefully review your charts|^You gaze deeply into your mirror|^You cast your bones before you
				# General Predict verbiage
			matchre MM_PREDICT_SUCCESS ^You look inside yourself|^You deliberately expel|^The unity of your mind sharpens the focus of your prophetic talent

		if ((matchre("%prediction_tool_item", "(?i)NONE")) || (!matchre("$lefthand|$righthand","%prediction_tool_item"))) then put retreat; predict future %next_prediction
		else if (matchre("$lefthand|$righthand","%prediction_tool_item")) then put retreat; %prediction_tool_action my %prediction_tool_item
		matchwait 3
		goto MM_PREDICT_GO
		
	MM_PREDICT_SUCCESS:
			# not matching via previous matchre table as there are too many permutations, fuck that noise
		if ((matchre("$lefthand|$righthand","%prediction_tool_item")) || (matchre("%prediction_tool_item", "(?i)NONE"))) then {
				#make successes easier to find in the log, stow prediction tool, get weapon from left hand if there was one
			echo PREDICTION SUCCESS : %prediction_tool_item : @unixtime@ 
			send put my %prediction_tool_item in my %prediction_tool_location
			pause 1
			send get my %tmp_lefthand
			pause .5
			unvar tmp_lefthand
		}

	## *****
	MM_PREDICT_ANALYZE:
		#might as well analyze for that extra astrology yo (if not at 1750 already)
		if ($Astrology.Ranks < 1750) then {
			if ($monstercount > 1) then gosub retreat
				matchre MM_PREDICT_ANALYZE ^You are far too occupied by present
				matchre MM_PREDICT_ANAL_SUCCESS ^Your masterful awareness brings|^You immediately will your consciousness deep|^The world around you fades from sight|^You close your eyes
			put retreat; predict analyze
			matchwait 3
		}
		put #script resume all
		return

	## *****
	MM_PREDICT_ANAL_SUCCESS:
		put #script resume all
		return

	## *****
	MM_PREDICT_HURT:
		# var skip HEAL
		# gosub HEALTHCHECK_SUB
		# put #script resume all
		return

	##@ *****
	MM_PREDICT_NOTHINGLEFT:
		put #var predict_pools_empty TRUE
		put #var predict_pools_empty_time @unixtime@
		put #script resume all
		return

	##@ *****
	RETREAT:
		pause .5
			matchre RETURN1 You retreat|You are already
			matchre RETREAT ^\.\.\.pause|^Sorry\,
		send retreat
		matchwait 1
		GOTO RETREAT

	##@ *****
	RETURN1:
		return














# chant cantrip align
# > You chant a small phrase, the power of your cantrip flowing from your lips!
# You focus on misaligning yourself away from the Plane of Probability.
# The world seems a little less foreboding than it did a moment ago.
# You recognize these fading strands of Fate as those that influence your first aid skill.


# chant cantrip align
# You've just recently chanted that cantrip, and will need time to restore your energies before trying again.