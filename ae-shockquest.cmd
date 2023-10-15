######################################
### EMPATH SHOCK QUEST - Based off Shrooms empathShock script -> Modified by Boobear
### Requires: Updated Genie Maps, .travel Script, and ExpTracker plugin
### Must have at least 50+ Athletics
######################################

DEBUG 10
put #script abort all except %scriptname

action send exit when eval $health < 60|$spirit < 60
action instant put glance when ^YOU HAVE BEEN IDLE

put #config usertimeout 20000
if ($Athletics.Ranks < 70) then goto NOT_ENOUGH_ATHLETICS

if_1 then var temp %1

if (matchre("%temp","new")) then {
	put #var cs_SeedQuest_CurrentLoc 1
	put #var cs_SeedQuest_NextMedTime @unixtime@
	unvar temp
	pause 1
}
else {
	if !def(cs_SeedQuest_CurrentLoc) then put #var cs_SeedQuest_CurrentLoc 1
	if !def(cs_SeedQuest_NextMedTime) then put #var cs_SeedQuest_NextMedTime @unixtime@
}



# Seed Locations Format -> var SEED.0 city|CITY_ZONEID|SEED_ZONE_ID|travel_roomds|SEED_room
	# Seed_0 currently not used, will be used for Nadigo later. Seed locations start at SEED_1
var SEED.1 wolf|4|4|415
var SEED.2 riverhaven|30|32|204|9
	#Outside of Riverhaven
var SEED.3 alfren|60|60|5
var SEED.4 steelclaw|66|66|125
var SEED.5 boar|127|127|19
var SEED.6 corik|68|68|71

var SEED.7 hib|116|126|217|13
	#On the road just NW of Hib (Hawkistaal)
var SEED.8 boar|127|127|172
var SEED.9 hib|116|116|53
#var SEED.9 hib|116|116|126|217|53
	# Is it ont he road instead?

## *****************
START_QUEST:
	var new_launch YES

	if (@unixtime@ < $cs_SeedQuest_NextMedTime) then {
		evalmath current_timer ($cs_SeedQuest_NextMedTime - @unixtime@)/60
				
		echo =============================
		echo * Seed isn't Ready yet according to Timer.
		echo * %current_timer minutes left till seed is ready
		echo * 15 seconds to abort.
		echo =============================
		pause 5

		echo =============================
		echo * Seed isn't Ready yet according to Timer.
		echo * %current_timer minutes left till seed is ready
		echo * 10 seconds to abort.
		echo =============================
		pause 5
		
		echo =============================
		echo * Seed isn't Ready yet according to Timer.
		echo * %current_timer minutes left till seed is ready
		echo * 5 seconds to abort.
		echo =============================
		pause 5
		put #script abort all except %scriptname
		pause 1
	}
	gosub HAVE_SEED_CHECK
	

QUEST_LOOP:	
	gosub CLEAR
	gosub GOTO_SEED_LOC
	gosub MED_SEED
	gosub MED_WAIT
		#Successful Med! Yay
	GOTO QUEST_LOOP
	
	
## ***************
MED_WAIT:
	if (!matchre("%temp","HEALTHCHECK")) then {
		pause 1
		if ($hidden = 0) then put hide
		if ("%new_launch" != "YES") then pause 600
		if (@unixtime@ > $cs_SeedQuest_NextMedTime) then RETURN
		if ("%new_launch" = "YES") then var new_launch NO
		GOTO MED_WAIT
	}
	if (matchre("%temp","HEALTHCHECK")) then {
		put hcs
		pause 1
		exit
	}

## *****************
MED_SEED:
		matchre SEED_DONE You recall that you should return the seed to Nadigo for germination 
		matchre NEXT_SEED Bewildering alien visions flash through your mind\'s eye\, and you sense that the nascent consciousness growing within the seed is already familiar with this area\.
		matchre SEED_PAUSE ^Bewildering images briefly flash through your mind\'s eye|As the confusing sensations subside\, you sense that the seed is still processing the energy 
		matchre SEED_SUCCESS As the strange sensations subside\, you feel suddenly fatigued and unsteady\.
	send meditate seed
	matchwait 20

	echo MED_SEED FAILED
	goto SCRIPT_FAIL

	## *****************
	SEED_DONE:
		#Seed is done, go return it to nadigo
		if ($zoneid != 127) then {
			put .travel boar
			waitforre ^YOU ARRIVED\!
			if ($zoneid != 127) then goto GET_SEED
		}
		gosub ROOM_CHECK 628
		send remove seed
		pause 1
		send give nadigo
		waitforre ^Nadigo says, "I thank you.  For the plants, and for myself. 
		send say Shock Quest Done, Yay!
		send #echo >Output Gold SEED @datetime@ stp: DONE
		send #echo >Output Gold wait 48 hrs to try again

		var tmp2 @unixtime@
		math tmp2 add 173000
		send #var cs_SeedQuest_NextMedTime %tmp2
		pause 1
		var tmp 1


		put exit
		pause 1
		exit

	## *****************
	NEXT_SEED:
		var SEED_LOC.length 0
		eval SEED_LOC.length count("%SEED.$cs_SeedQuest_CurrentLoc","|")

		var tmp $cs_SeedQuest_CurrentLoc
		math tmp add 1
#		if (%tmp > %SEED_LOC.length) then var tmp 1

		send #var cs_SeedQuest_CurrentLoc %tmp
		pause 1
		GOTO QUEST_LOOP
		
	## *****************
	SEED_PAUSE:
		pause 1
		echo ==============
		echo * USED SEED TOO RECENTLY - PAUSING 5 min.
		echo ==============
		if ($hidden = 0) then put hide
		pause 300
		goto MED_SEED
		
	## *****************
	SEED_SUCCESS:
		var tmp2 @unixtime@
		math tmp2 add 2450
		send #var cs_SeedQuest_NextMedTime %tmp2
		pause 1
		var tmp $cs_SeedQuest_CurrentLoc
		math tmp add 1
		send #var cs_SeedQuest_CurrentLoc %tmp
		send #echo >Output Gold SEED @datetime@ stp: $cs_SeedQuest_CurrentLoc
		
		send exit
		exit
		RETURN


# ***********************
GOTO_SEED_LOC:
	var SEED_LOC.length 0
	eval SEED_LOC.length count("%SEED.$cs_SeedQuest_CurrentLoc","|")

	if (("$zoneid" = "%SEED.$cs_SeedQuest_CurrentLoc(2)") && ("$roomid" = "%SEED.$cs_SeedQuest_CurrentLoc(%SEED_LOC.length)")) then RETURN
		# If SeedZoneID match && Room_ID match then RETURN - You're there.
		
	if (("$zoneid" = "%SEED.$cs_SeedQuest_CurrentLoc(2)") && ("$roomid" != "%SEED.$cs_SeedQuest_CurrentLoc(%SEED_LOC.length)")) then {
		# If SeedZoneID match && Room_ID DOESN"T match
			#goto last entry in the array which is the room in the correct zone
		gosub ROOM_CHECK %SEED.$cs_SeedQuest_CurrentLoc(%SEED_LOC.length)
		RETURN
		}
	if ("$zoneid" = "%SEED.$cs_SeedQuest_CurrentLoc(1)") then {
		# if SeedZoneID doesn't match && NearestCityZoneID match
			# work through the array rooms starting with %SEED.$cs_SeedQuest_CurrentLoc(3)
			var tmp 3
			goto GOTO_SEED_ROOM
		}	
	if (("$zoneid" != "%SEED.$cs_SeedQuest_CurrentLoc(1)") && ("$zoneid" != "%SEED.$cs_SeedQuest_CurrentLoc(2)")) then {
		# if SeedZoneID doesn't match && NearestCityZoneID doesn't match (not in nearest city, not in seed zone, where are you?!)
		put .travel %SEED.$cs_SeedQuest_CurrentLoc(0)
        waitforre ^YOU ARRIVED\!
		goto GOTO_SEED_LOC
	}
	echo GOTO_SEED_LOC FAILED
	goto SCRIPT_FAIL
	
	## *****************
	GOTO_SEED_ROOM:
		if (%tmp <= %SEED_LOC.length) then {
			gosub ROOM_CHECK %SEED.$cs_SeedQuest_CurrentLoc(%tmp)
			math tmp add 1
			goto GOTO_SEED_ROOM
		}
		GOTO GOTO_SEED_LOC
		
## *****************
GET_SEED:
	#Dont have a seed, go get it.
	if ($zoneid != 127) then {
		put .travel boar
		waitforre ^YOU ARRIVED\!
		if ($zoneid != 127) then goto GET_SEED
	}
	gosub ROOM_CHECK 628
	GOTO NADIGO
	

## *****************
NADIGO:
	#Start quest from Nadigo
	send #var cs_SeedQuest_CurrentLoc 1
	send ask nadigo about shock
	pause 1
		matchre CANCEL_TASK I cannot start you on the shock quest until you have finished your other task for me
		matchre RETURN ^Nadigo says\, \"It\'s strung on a medallion\, don\'t take it off again until you\'re ready for me to germinate it for you
	send ask nadigo about shock
	matchwait 80
	goto NADIGO
	
	## ***	
	CANCEL_TASK:
		send ask nadigo about cancel
		pause 1
		goto NADIGO	

## *****************
HAVE_SEED_CHECK:
	# Do you already have the seed?

		matchre RETURN vela'tohr seed 
		matchre GET_SEED ^I could not find what you were referring to.
	send tap seed
	matchwait 2
	GOTO SCRIPT_FAIL

## *****************
SCRIPT_FAIL:
	echo =============================
	echo * For some reason script has failed out. Sorry. 
	echo =============================
	EXIT
	

## *****************
NOT_ENOUGH_ATHLETICS:
	echo =============================
	echo * OH NO! NOT ENOUGH ATHLETICS 
	echo * TO MAKE IT ALL THE WAY TO BOAR CLAN!
	echo * GO PRACTICE CLIMBING!!!!!!
	echo =============================
	pause 
	exit

## *****************
RETURN:
	RETURN

## ************************************************************************************
ROOM_CHECK:
	var Tmp_Room_ID $1
	var Tmp_Map_ID $zoneid
	
	pause 1
ROOM_CHECK.SUB:	
	pause .3
	if ("%Tmp_Room_ID" = "") then RETURN

	if (("$roomid" != "%Tmp_Room_ID") && ("$zoneid" = "%Tmp_Map_ID")) then {
			matchre ROOM_CHECK.ARRIVED ^YOU HAVE ARRIVED
			matchre ROOM_CHECK.SUB FAILED
			matchre ROOM_CHECK.SUB Destination ID
		put #goto %Tmp_Room_ID
		matchwait 15
		GOTO ROOM_CHECK.SUB
	}
ROOM_CHECK.ARRIVED:	
	RETURN

