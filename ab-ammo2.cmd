DEBUG 10

# if (matchre("$righthandnoun|$lefthandnoun","unfinished drake-fang arrow")) then {
	# setvar ammo_count 1
	# setvar head_type fang
	# setvar ammo_type arrow
	# setvar shaping_knife carv knife
	# setvar shaping_shaper shaper
	# goto AMMO_ANAL	
# }



##USAGE .ab-ammo <ammo count desired(remmber groups of 5)> <monster name> <ARROW/BOLT> 

## Basilisk - Physical - 368 with techniques, 550 without
##IceAdder - 7/27 Cold w. 3/5/8 pun/sli/impact - 607 with techniques, 850 without
##StormBull - Jagged-Horn - 5/27 Electrical
##Fire Cat - Soot-stained - 5/27 Fire
##drake - drake-fang - 7/27 Fire 

action send stow shaft when You notice some arrow shafts at your feet
action send stow feet when do not wish to leave it behind
ACTION GOTO NEED_STUFF when ^What were you referring

setvar ammo_count_wanted 0
setvar shaping_knife carv knife
setvar shaping_shaper shaper
#need Scissors also
setvar temp_get_item NOTHING_YET

setvar ammo_count %1
setvar head_type %2
setvar ammo_type %3

if ((matchre(%ammo_type, "b")) || (matchre(%ammo_type, "B"))) then setvar ammo_type BOLT
if ((matchre(%ammo_type, "a")) ||(matchre(%ammo_type, "A"))) then setvar ammo_type ARROW


################################################################ Main LOOP START ##############################
START:
	math ammo_count_wanted add 1
	if %ammo_count_wanted > 5 then {
		put .ab-my-repair
		waitforre REPAIR DONE
		var ammo_count_wanted 0
	} 
#	if %ammo_count_wanted > %ammo_count then EXIT

	GoSub CLEAR
	GoSub MAKE_HEAD 
	GoSub MAKE_SHAFT
	GoSub MAKE_AMMO
	GoSub AMMO_ANAL
	#GoSub AMMO_SHAPE
	
	#GoSub ATTACH_FLIGHT
	GOTO START
	

## *********
MAKE_HEAD:
	GoSub CLEAN_HANDS

		matchre RETURN ^You tap
	send tap my %2 %3head
	matchwait 1
	
	if %2 = "boar" then setvar head_type tusk
	if %2 = "cougar" then setvar head_type claw
	if %2 = "hele'la" then setvar head_type tooth
	if %2 = "angiswaerd" then setvar head_type tooth
	if %2 = "sabretooth" then setvar head_type fang
	if %2 = "elsralael" then setvar head_type tooth
	if %2 = "basilisk" then setvar head_type fang
	if %2 = "firecats" then setvar head_type fang
	if %2 = "ice-adder" then setvar head_type fang
	if %2 = "drake" then setvar head_type fang
	if %2 = "stormbull" then setvar head_type horn
	

	GoSub GET2 %shaping_knife
	GoSub GET2 %head_type

	if (%ammo_type = "ARROW") then send shape %head_type into arrowhead
	if (%ammo_type = "BOLT") then send shape %head_type into bolthead
	waitforre ^Roundtime
	
	if %ammo_type = "ARROW" then send stow arrowhead
	if %ammo_type = "BOLT" then send stow bolthead
	pause 1
	RETURN
	
## *********
MAKE_SHAFT:
	pause .5
	GoSub CLEAN_HANDS
	
		match RETURN You tap
	send tap my %ammo_type shaft
	matchwait 1
	
	GoSub GET2 lumber
		
	## *********
	MAKE_SHAFT.LUMBER:
		pause 1
		send mark my lumber at 2
		## bolts might be marked at 2??
		pause .5
		
		GoSub GET2 scissors
		
		send cut my lumber with my scissors
		pause .5
		send stow scissors
		pause .5
		
		GoSub GET2 %shaping_shaper
		
		send shape my lumber into %ammo_type shaft
		waitforre ^Roundtime
		
		RETURN
	

## ****************************************************************************
MAKE_AMMO:
	pause .5
	GoSub CLEAN_HANDS
	pause 1
	if %ammo_type = "ARROW" then {
	
		GoSub GET2 shaping book
		
		send turn my book to chapt 5
		pause 1
			if %2 = "boar" then send turn my book to page 4
			if %2 = "cougar" then send turn my book to page 3
			if %2 = "hele'la" then send turn my book to page 7
			if %2 = "angiswaerd" then send turn my book to page 6
			if %2 = "sabretooth" then send turn my book to page 5
			if %2 = "elsralael" then send turn my book to page 9
			if %2 = "basilisk" then send turn my book to page 8
			if %2 = "firecat" then send turn my book to page 10
			if %2 = "ice-adder" then send turn my book to page 11
			if %2 = "drake" then send turn my book to page 12
			if %2 = "stormbull" then send turn my book to page 13
	}
	##BOLTS PAGES NEED UPDATING
	if %ammo_type = "BOLT" then {
	
		GoSub GET2 tink book

		send turn my book to chapt 7
		pause 1
			if %2 = "boar" then send turn my book to page 4
			if %2 = "cougar" then send turn my book to page 3
			if %2 = "hele'la" then send turn my book to page 7
			if %2 = "angiswaerd" then send turn my book to page 6
			if %2 = "sabretooth" then send turn my book to page 5
			if %2 = "elsralael" then send turn my book to page 9
			if %2 = "basilisk" then send turn my book to page 8
			if %2 = "firecat" then EXIT
			if %2 = "ice-adder" then turn my book to page 12
			if %2 = "drake" then send turn my book to page 14
			if %2 = "stormbull" then EXIT
	}
	send study my book
	waitforre ^Roundtime

	send stow my book
	pause 1

	GoSub GET2 %shaping_shaper
	
	GoSub GET2 %ammo_type shaft
	
		match MAKE_AMMO no idea how 
	send shape my shaft with my shaper
	matchwait 5

	send stow shaper
	pause 1
	
	## %head_type is the variable... added "head" at the end. for bolthead or arrowhead
	if (matchre("%head_type","fang")) then var head_type drake-fang
	GoSub GET2 %head_type %3head
	

	if (%ammo_type = "BOLT") then send assemble my boltheads with my bolts
	if (%ammo_type = "ARROW") then send assemble my arrowheads with my arrows
	pause 1
	
	setvar gluelocation ammo
	if (matchre("$righthandnoun|$lefthandnoun", "(knife|shaper|flights)")) then send stow $1

	GoSub GET2 wood glue
	
	if (!matchre("$righthandnoun|$lefthandnoun","(%ammo_type)")) then send get my %ammo_type
	if (!matchre("$righthandnoun|$lefthandnoun","glue")) then gosub GET2 wood glue
	
	## ***********
	MAKE_AMMO_GLUE:
			match AMMO_CARVE carving with a knife 
		if (%ammo_type = "BOLT") then send apply my glue to my bolts
		if (%ammo_type = "ARROW") then send apply my glue to my arrows
		waitforre ^Roundtime
		
		send stow glue
		pause .5
		RETURN
	
	
## **************************************	
AMMO_SHAPE:
	if (matchre("$righthandnoun|$lefthandnoun", "(knife|glue|flight)")) then send stow $1
	if (!matchre("$righthandnoun|$lefthandnoun", "shaper")) then GoSub GET2 %shaping_shaper
	
		matchre AMMO_SHAPE with a wood shaper
		matchre AMMO_CARVE with a knife
		matchre AMMO_FLIGHTS application of glue to attach the flights
		matchre AMMO_GLUE must have glue applied
		matchre DONE you complete working 
	send shape my %ammo_type with my shaper
	matchwait 1
	GOTO AMMO_ANAL

## **************************************	
AMMO_CARVE:
	if (matchre("$righthandnoun|$lefthandnoun", "(shaper|glue|flight)")) then send stow $1
	if (!matchre("$righthandnoun|$lefthandnoun", "knife")) then GoSub GET2 %shaping_knife
	
		matchre AMMO_SHAPE with a wood shaper
		matchre AMMO_CARVE with a knife
		matchre AMMO_FLIGHTS application of glue to attach the flights
		matchre AMMO_GLUE must have glue applied
		matchre DONE you complete working 
	send carve my %ammo_type with my knife
	matchwait 1
	GOTO AMMO_ANAL
	
	

## **************************************	
AMMO_ANAL:
		matchre AMMO_SHAPE with a wood shaper
		matchre AMMO_CARVE with a knife
		matchre AMMO_FLIGHTS application of glue to attach the flights
		matchre AMMO_GLUE must have glue applied
		matchre DONE you complete working 
	send anal my %ammo_type
	matchwait 1


	

	
## ****************************************************************************
## **************************************	
AMMO_FLIGHTS:
	if (matchre("$righthandnoun|$lefthandnoun", "(shaper|knife|glue)")) then send stow $1
	GoSub GET2 %ammo_type flights
	
ATTACH_FLIGHT.FLIGHT:
	if (!matchre("$righthandnoun|$lefthandnoun","flight")) then send get my flight
	pause .3
	if (!matchre("$righthandnoun|$lefthandnoun","(%ammo_type)")) then send get my %ammo_type
	pause .3

		matchre AMMO_SHAPE with a wood shaper
		matchre AMMO_CARVE with a knife
		matchre AMMO_FLIGHTS application of glue to attach the flights
		matchre AMMO_GLUE must have glue applied
		matchre DONE you complete working 
	send assemble my %ammo_type with my flights
	matchwait 1
	goto AMMO_GLUE

	setvar gluelocation flight
	
AMMO_GLUE:
	if (!matchre("$righthandnoun|$lefthandnoun","(glue)")) then GoSub GET2 wood glue
	pause .3
	if (!matchre("$righthandnoun|$lefthandnoun","(arrow)")) then GoSub GET2 my arrow
	pause .3

		matchre AMMO_SHAPE with a wood shaper
		matchre AMMO_CARVE with a knife
		matchre AMMO_FLIGHTS application of glue to attach the flights|another arrow flights 
		matchre AMMO_GLUE must have glue applied
		matchre DONE you complete working 
	send apply my glue to my %ammo_type
	matchwait 5
	goto AMMO_ANAL
	



## ***************
DONE:	
	send #ECHO >Output ****** %ammo_head - %ammo_type *******      
	send stow %ammo_type
	pause 1
	goto START





## ***************
GET2:
	setvar temp_get_item $0
		matchre NEED_STUFF ^What were you referring
	send get my $0
	matchwait 2
	RETURN


## **************************************
NEED_STUFF:
	put #ECHO >Output** Need %temp_get_item
	

	if (!matchre("%temp_get_item", "lumber|glue|flights")) then {
		send #ECHO >Output Need %temp_get_item - WE OUT!
		EXIT
	}
	if (matchre("%temp_get_item", "lumber")) then GOTO NEED_STUFF.LUMBER
	if (matchre("%temp_get_item", "glue")) then GOTO NEED_STUFF.GLUE
	if (matchre("%temp_get_item", "flights")) then GOTO NEED_STUFF.FLIGHTS

	EXIT
	
	
NEED_STUFF.LUMBER:	
	put #ECHO >Output***** You need wood.. HAHAHA!
	GoSub NEEDSTUFF LUMBER
	RETURN
	
NEED_STUFF.FLIGHTS:
	put #ECHO >Output***** need flights
	if %ammo_type = "ARROW" then GoSub NEEDSTUFF ARROW_FLIGHTS
	if %ammo_type = "BOLT" then GoSub NEEDSTUFF BOLT_FLIGHTS
	RETURN
	
NEED_STUFF.GLUE:
	put #ECHO >Output***** need glue
	GoSub NEEDSTUFF GLUE
	RETURN

	
NEEDSTUFF:
## if $zoneid = 1 then  -- crossing check, add later
	GoSub CLEAN_HANDS	

##LUMBER***
	if $0 = "LUMBER" then {
		GoSub ROOM_CHECK 874
			match NO_COINS.LUMBER don't have enough coins 
		send order 9
		matchwait 1
		pause 1
			match NO_COINS.LUMBER don't have enough coins 
		send order 9
		matchwait 1
		RETURN
	}	
##ARROW FLIGHTS***	
	if $0 = "ARROW_FLIGHTS" then {
		GoSub ROOM_CHECK 874
			match NO_COINS.ARROW_FLIGHTS don't have enough coins 
		send order 12
		matchwait 1
		pause 1
			match NO_COINS.ARROW_FLIGHTS don't have enough coins 
		send order 12
		matchwait 1
		send stow flights
			match NO_COINS.ARROW_FLIGHTS don't have enough coins 
		send order 12
		matchwait 1
		pause 1
			match NO_COINS.ARROW_FLIGHTS don't have enough coins 
		send order 12
		matchwait 1
		RETURN
	}
##BOLT FLIGHTS***	
	if $0 = "BOLT_FLIGHTS" then {
		GoSub ROOM_CHECK 874
			match NO_COINS.ARROW_FLIGHTS don't have enough coins 
		send order 13
		matchwait 1
		pause 1
			match NO_COINS.ARROW_FLIGHTS don't have enough coins 
		send order 13
		matchwait 1
		send stow flights
			match NO_COINS.ARROW_FLIGHTS don't have enough coins 
		send order 13
		matchwait 1
		pause 1
			match NO_COINS.ARROW_FLIGHTS don't have enough coins 
		send order 13
		matchwait 1
		RETURN
	}
##GLUE***	
	if $0 = "GLUE" then {
		GoSub ROOM_CHECK 851
			match NO_COINS.GLUE don't have enough coins 
		send order 13
		matchwait 1
		pause 1
			match NO_COINS.GLUE don't have enough coins 
		send order 13
		matchwait 1
		RETURN
	}
	EXIT


	
NO_COINS.LUMBER:
##zoneid = 1 is Crossing
	if $zoneid = 1 then {
		GoSub GOTO_BANK
		GoSub ROOM_CHECK 874
		GOTO NEEDSTUFF LUMBER
	}
	put #ECHO >Output***** NOT IN CROSSING AND NEED A LUMBER ***
	EXIT
	
NO_COINS.ARROW_FLIGHTS:
##zoneid = 1 is Crossing
	if $zoneid = 1 then {
		GoSub GOTO_BANK
		GoSub ROOM_CHECK 905
		GOTO NEEDSTUFF ARROW_FLIGHTS
	}
	put #ECHO >Output***** NOT IN CROSSING AND NEED ARROW_FLIGHTS ***
	EXIT	

NO_COINS.GLUE:
##zoneid = 1 is Crossing
	if $zoneid = 1 then {
		GoSub GOTO_BANK
		GoSub ROOM_CHECK 905
		GOTO NEEDSTUFF GLUE
	}
	put #ECHO >Output***** NOT IN CROSSING AND NEED GLUE ***
	EXIT

GOTO_BANK:
	GoSub ROOM_CHECK 233
	send withdraw 1 plat
	pause 1
	RETURN
	
	
	
	
	
include cs_subs.cmd
		