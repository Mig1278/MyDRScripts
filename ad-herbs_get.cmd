DEBUG 10
#Herbie script by Boobear
#v1


#lujeakave root also room 557 in arthedale (NTR)
 
# echo #---------------------------------------------------------------------------#
# echo | BODY  |   External   |     Internal     |   External    |    Internal    |
# echo | PART  |    Wound     |      Wound       |     Scar      |      Scar      |
# echo |---------------------------------------------------------------------------|
# echo | HEAD  |  Nemoih Ung  |   Eghmok Tonic   |  Qun Poultice |   Hulij Elixer  |
# echo |---------------------------------------------------------------------------|
# echo | EYES  |  Sufil Ung   |  Aevas Tonic     |  Qun Poultice |   Hulij Elixer  |
# echo |---------------------------------------------------------------------------|
# echo | NECK  |  Georin Ung  |  Roilur Tonic    |  Qun Poultice  |   Hulij Elixer |
# echo |---------------------------------------------------------------------------|
# echo | LIMBS | Jadice Ung   |   Yelith Root    | Dioca Poultice | Belradi Elixer |
# echo |---------------------------------------------------------------------------|
# echo | CHEST |  Plovik Ung  |   Ithor Tonic    | Dioca Poultice | Belradi Elixer |
# echo |---------------------------------------------------------------------------|
# echo | ABS   |  Nilos Ung   |   Muljin Tonic   | Dioca Poultice | Belradi Elixer |
# echo |---------------------------------------------------------------------------|
# echo | BACK  | Hulnik Ung   | Junilar Tonic    | Dioca Poultice | Belradi Elixer |
# echo |---------------------------------------------------------------------------|
# echo | SKIN  | Aloe Ungent  | Lujeakave Tonic  | Cebi Poultices  | Hisan Elixer  |
# echo |---------------------------------------------------------------------------|
# echo |                NERVE WOUNDS use Lujeakave Tonic                           |
# echo |---------------------------------------------------------------------------|
# echo |     Compliments of Karissa... Be Well And Be Absolutely Fabulous!!!       |
# echo |---------------------------------------------------------------------------|
# echo |          Sponsored by Magavyn, for all your Alchemy Needs!                |
# echo #---------------------------------------------------------------------------#	

#STOREBOUGHT
		# if (matchre("%herb_name", "nemoih")) then setvar temp 3
		# if (matchre("%herb_name", "plovik")) then setvar temp 4
		# if (matchre("%herb_name", "jadice")) then setvar temp 5
		# if (matchre("%herb_name", "nilos")) then setvar temp 6
		# if (matchre("%herb_name", "georin")) then setvar temp 7
		# if (matchre("%herb_name", "junliar")) then setvar temp 9
		# if (matchre("%herb_name", "genich")) then setvar temp 11
		
		# if (matchre("%herb_name", "riolur")) then setvar temp 8
		# if (matchre("%herb_name", "aevaes")) then setvar temp 10
		# if (matchre("%herb_name", "ojhenik")) then setvar temp 12




action put #tvar $2.$3_amount $1 when ^\s+\-\s+(\d+) doses (?:dried|crushed) (\w+) (\w+)$
action put #tvar $2_amount $1 when ^\s+\-\s+(\d+) doses (?:dried|crushed) (\w+)$

#setvar Herbs_Check_List blue.flowers|red.flowers|muljin|belradi|aevaes|aloe|dioica|nilos|sufil|plovik|nemoih|hulnik|cebi|riolur|ithor|hulij|yelith|eghmok|junliar|georin|jadice|lujeakave|blocil|hisan|ojhenik|qun|nuloe|genich
setvar Herbs_Check_List muljin|belradi|aevaes|aloe|dioica|nilos|sufil|plovik|nemoih|hulnik|cebi|riolur|ithor|hulij|yelith|eghmok|junliar|georin|jadice|lujeakave|blocil|hisan|ojhenik|qun|nuloe|genich

eval Herbs_Check_List_count count("%Herbs_Check_List","|")

setvar tmp_counter 0
setvar Herbs_Needed_List BLANK

setvar HerbLocs_WillowWalk lujeakave root|riolur leaves|ithor root|nemoih root|hulnik grass|jadice flower|sufil sap|cebi root|blocil berries|blue flower|seolarn weed 	
setvar HerbLocs_WillowFountain hulij leaves|plovik leaves	
setvar HerbLocs_MidtonCircle belradi moss|muljin sap|hisan flower|cebi root|georin grass|junliar stem|red flower
setvar HerbLocs_CrossingStore qun pollen
setvar HerbLocs_KnifeClan nilos grass|aevaes leaves|nuloe stem
setvar HerbLocs_NTR	ojhenik root|aloe leaves|yelith root

setvar HerbLocs_Hib dioica sap
setvar HerbLocs_Riverhaven genich stem
setvar HerbLocs_Acenamacra eghmok moss

setvar DAY_HERBS hisan|jadice|muljin|ojhenik|sufil

############################################################################

###               SET YOUR CONTAINER              ########
setvar Herb_Container apron


## ****** 
HERBS_INITIALIZE:
	put #tvar %Herbs_Check_List(%tmp_counter)_amount 0
	math tmp_counter add 1
	if (%tmp_counter > %Herbs_Check_List_count) then GOTO CHECK_CASE
	GOTO HERBS_INITIALIZE
	
## ****** 	
CHECK_CASE:
	if (!matchre("$righthandnoun $lefthandnoun", %Herb_Container)) then {
		send remove %Herb_Container
		send get %Herb_Container
	}
	pause 1
	send assess %Herb_Container
	pause 3
	send wear %Herb_Container
	pause 1
	setvar tmp_counter 0
	GOTO LOW_HERB_CHECK
	
## ****** 	
LOW_HERB_CHECK:
	if ($%Herbs_Check_List(%tmp_counter)_amount < 75) then setvar Herbs_Needed_List %Herbs_Needed_List|%Herbs_Check_List(%tmp_counter)
	math tmp_counter add 1
	if (%tmp_counter > %Herbs_Check_List_count) then GOTO GET_HERBS
	GOTO LOW_HERB_CHECK

## ****** 	
GET_HERBS:
	ECHO %Herbs_Needed_List

	if (matchre("%HerbLocs_WillowWalk","%Herbs_Needed_List")) then GoSub MOVE_TO_COLLECTIONPOINT WillowWalk
	
	if (matchre("%HerbLocs_WillowFountain","%Herbs_Needed_List")) then GoSub MOVE_TO_COLLECTIONPOINT WillowFountain
	if (matchre("%HerbLocs_MidtonCircle","%Herbs_Needed_List")) then GoSub MOVE_TO_COLLECTIONPOINT MidtonCircle
	if (matchre("%HerbLocs_CrossingStore","%Herbs_Needed_List")) then GoSub MOVE_TO_COLLECTIONPOINT CrossingStore
	
	if (matchre("%HerbLocs_KnifeClan","%Herbs_Needed_List")) then GoSub MOVE_TO_COLLECTIONPOINT KnifeClan
	if (matchre("%HerbLocs_NTR","%Herbs_Needed_List")) then GoSub MOVE_TO_COLLECTIONPOINT NTR


	RETURN

## ****** 	
MOVE_TO_COLLECTIONPOINT:
	setvar Herb_Location $1
	if (matchre("%Herb_Location","Willow|Midton|Crossing")) then {
		GoSub MAP_CHECK crossing
		if (%Herb_Location = "WillowWalk") then GoSub ROOM_CHECK 257
		if (%Herb_Location = "WillowFountain") then GoSub ROOM_CHECK 767
		if (%Herb_Location = "MidtonCircle") then GoSub ROOM_CHECK 265
		if (%Herb_Location = "CrossingStore") then GoSub ROOM_CHECK 933
	}	
	if (matchre("%Herb_Location","Knife")) then {
		GoSub MAP_CHECK knife
		if (%Herb_Location = "KnifeClan") then GoSub ROOM_CHECK 456
	}
	if (matchre("%Herb_Location","NTR")) then {
		GoSub MAP_CHECK ntr
		if (matchre("aloe|yelith","(%Herbs_Needed_List)")) then GoSub ROOM_CHECK 91
		if (matchre("ojhenik","(%Herbs_Needed_List)")) then GoSub ROOM_CHECK 515
	}
	GOTO COLLECT_HERBS

	
## ****** 	
COLLECT_HERBS:
		##########################setvar DAY_HERBS hisan|jadice|muljin|ojhenik|sufil
	setvar temp NULL
#	send stow $righthandnoun
	
	if ((%Herb_Location = "WillowWalk") && (matchre("%HerbLocs_WillowWalk","(%Herbs_Needed_List)"))) then var temp $1
	if ((%Herb_Location = "WillowFountain") && (matchre("%HerbLocs_WillowFountain","(%Herbs_Needed_List)"))) then var temp $1
	if ((%Herb_Location = "MidtonCircle") && (matchre("%HerbLocs_MidtonCircle","(%Herbs_Needed_List)"))) then var temp $1
	if ((%Herb_Location = "CrossingStore") && (matchre("%HerbLocs_CrossingStore","(%Herbs_Needed_List)"))) then GOTO PURCHASE_SPECIAL
	if ((%Herb_Location = "KnifeClan") && (matchre("%HerbLocs_KnifeClan","(%Herbs_Needed_List)"))) then var temp $1
	
	GoSub DAY_HERB_CHECK
	if (%temp != "NULL") then {
			eval Herbs_Needed_List replace("%Herbs_Needed_List", "%temp", "")
			eval Herbs_Needed_List replacere("%Herbs_Needed_List",  "\|+", "|")
			eval Herbs_Needed_List replacere("%Herbs_Needed_List",  "^\|", "")
			eval Herbs_Needed_List replacere("%Herbs_Needed_List", "\|$", "")
			GoSub CONVERT_HERB_LONG %temp
			GoSub PICKUP_HERBS
			GOTO COLLECT_HERBS
	}
	RETURN
	
## ****** 	
DAY_HERB_CHECK:
	if ((matchre("%DAY_HERBS","%temp")) && ($Time.isDay = 0)) then {
		send #ECHO >Output Cant pick %temp at night
		eval Herbs_Needed_List replace("%Herbs_Needed_List", "%temp", "")
		eval Herbs_Needed_List replacere("%Herbs_Needed_List",  "\|+", "|")
		eval Herbs_Needed_List replacere("%Herbs_Needed_List",  "^\|", "")
		eval Herbs_Needed_List replacere("%Herbs_Needed_List", "\|$", "")
		setvar temp NIGHT
		RETURN
	}
	RETURN

## ****** 	
PURCHASE_SPECIAL:
	EXIT

## ****** 	
PICKUP_HERBS:
	if ("%long_herb" = "NIGHT") then RETURN
		matchre PICKUP_HERBS_FORAGE probably have better luck|hoping to find a better foraging spot|unable to find anything|can't quite seem to remember|wondering what you might find.
	send collect %long_herb
	matchwait 15

PICKUP_HERBS_FORAGE_RETURN:	
	if (matchre("%long_herb", "flowers")) then setvar temp flower
	if (matchre("%long_herb", "sap")) then setvar temp sap
	if (matchre("%long_herb", "moss")) then setvar temp moss
	if (matchre("%long_herb", "leaves")) then setvar temp leaves
	if (matchre("%long_herb", "grass")) then setvar temp grass
	if (matchre("%long_herb", "root")) then setvar temp root
	if (matchre("%long_herb", "stem")) then setvar temp stem
	if (matchre("%long_herb", "pollen")) then setvar temp pollen
	if (matchre("%long_herb", "berries")) then setvar temp berries
	
	PICKUP_HERBS_SUB:
			matchre RETURN ^What were|^Stow what
			matchre PICKUP_HERBS_SUB ^You put
		send stow %long_herb
		matchwait 1
		GOTO PICKUP_HERBS_SUB
		

PICKUP_HERBS_FORAGE:
	send forage %long_herb
	pause 3
	send forage %long_herb
	pause 3
	send stow %long_herb; stow %long_herb
	pause 1

	send forage %long_herb
	pause 3
	send forage %long_herb
	pause 3
	send stow %long_herb; stow %long_herb
	pause 1

	send forage %long_herb
	pause 3
	send forage %long_herb
	pause 3
	send stow %long_herb; stow %long_herb
	pause 1

	send forage %long_herb
	pause 3
	send forage %long_herb
	pause 3
	send stow %long_herb; stow %long_herb
	pause 1

	send forage %long_herb
	pause 3
	send forage %long_herb
	pause 3
	send stow %long_herb; stow %long_herb
	pause 1

	send forage %long_herb
	pause 3
	send forage %long_herb
	pause 3

	GOTO PICKUP_HERBS_FORAGE_RETURN

		
## ****** 	
RETURN:
	RETURN
	
	

	
## ****** 	
CONVERT_HERB_LONG:
	var long_herb $1
	if (matchre("%long_herb", "blue.flowers")) then setvar long_herb blue flower
	if (matchre("%long_herb", "red.flowers")) then setvar long_herb red flower
	if (matchre("%long_herb", "muljin")) then setvar long_herb muljin sap
	if (matchre("%long_herb", "belradi")) then setvar long_herb belradi moss
	if (matchre("%long_herb", "aevaes")) then setvar long_herb aevaes leaves
	if (matchre("%long_herb", "aloe")) then setvar long_herb aloe leaves
	if (matchre("%long_herb", "dioica")) then setvar long_herb dioica sap
	if (matchre("%long_herb", "nilos")) then setvar long_herb nilos grass
	if (matchre("%long_herb", "sufil")) then setvar long_herb sufil sap
	if (matchre("%long_herb", "plovik")) then setvar long_herb plovik leaves
	if (matchre("%long_herb", "nemoih")) then setvar long_herb nemoih root
	if (matchre("%long_herb", "hulnik")) then setvar long_herb hulnik grass
	if (matchre("%long_herb", "cebi")) then setvar long_herb cebi root
	if (matchre("%long_herb", "riolur")) then setvar long_herb riolur leaves
	if (matchre("%long_herb", "ithor")) then setvar long_herb ithor root
	if (matchre("%long_herb", "hulij")) then setvar long_herb hulij leaves
	if (matchre("%long_herb", "yelith")) then setvar long_herb yelith root
	if (matchre("%long_herb", "eghmok")) then setvar long_herb eghmok moss
	if (matchre("%long_herb", "junliar")) then setvar long_herb junliar stem
	if (matchre("%long_herb", "georin")) then setvar long_herb georin grass
	if (matchre("%long_herb", "jadice")) then setvar long_herb jadice flower
	if (matchre("%long_herb", "lujeakave")) then setvar long_herb lujeakave root
	if (matchre("%long_herb", "blocil")) then setvar long_herb blocil berries
	if (matchre("%long_herb", "hisan")) then setvar long_herb hisan flower
	if (matchre("%long_herb", "ojhenik")) then setvar long_herb ojhenik root
	if (matchre("%long_herb", "qun")) then setvar long_herb qun pollen
	if (matchre("%long_herb", "nuloe")) then setvar long_herb nuloe stem
	if (matchre("%long_herb", "genich")) then setvar long_herb genich stem
	RETURN

	
	
## ************************************************************************************
MAP_CHECK:
	setvar map_desired $1
	if (%map_desired = "crossing") then {
		## zoneid = 1 is Crossing
		if ($zoneid = 1) then RETURN
		else {
			put .travel crossing
			waitforre YOU HAVE ARRIVED
			RETURN	
		}
	}
	if (%map_desired = "knife") then {
		## Not Crossing Area
			if (matchre("$zoneid", "8|7|6|4|1")) then {
				put .travel crossing
				waitforre YOU HAVE ARRIVED
				RETURN
			}
		## zoneid-8 is Outside Crossing East Gate
			if ($zoneid = 8) then GoSub ROOM_CHECK 43
		## zoneid-7 is Outside Crossing, Northern Trade Road
			if ($zoneid = 7) then GoSub ROOM_CHECK 349
		## zoneid-6 is Outside Crossing North Gate
			if ($zoneid = 6) then GoSub ROOM_CHECK 23
		## zoneid = 1 is Crossing
			if ($zoneid = 1) then GoSub ROOM_CHECK 172
		## zoneid-4 is Outside Crossing West Gate
			if ($zoneid = 4) then RETURN
	}
	if (%map_desired = "ntr") then {
		## Not Crossing Area
			if (matchre("$zoneid", "8|7|6|4|1")) then {
				put .travel crossing
				waitforre YOU HAVE ARRIVED
				RETURN
			}
		## zoneid-4 is Outside Crossing West Gate
			if ($zoneid = 4) then GoSub ROOM_CHECK 14
		## zoneid-8 is Outside Crossing East Gate
			if ($zoneid = 8) then GoSub ROOM_CHECK 43
		## zoneid-6 is Outside Crossing North Gate
			if ($zoneid = 6) then GoSub ROOM_CHECK 23
		## zoneid = 1 is Crossing
			if ($zoneid = 1) then GoSub ROOM_CHECK 171
		## zoneid-7 is Outside Crossing, Northern Trade Road
			if ($zoneid = 7) then RETURN
	}
	GOTO MAP_CHECK
	
## ************************************************************************************
ROOM_CHECK:
	var Skills_Temp $1
ROOM_CHECK.SUB:	
	pause .3
	if ($roomid != %Skills_Temp) then {
			matchre RETURN ^YOU HAVE ARRIVED
			matchre ROOM_CHECK.SUB FAILED
			matchre ROOM_CHECK.SUB Destination ID
		put #goto %Skills_Temp
		matchwait 30
		GOTO ROOM_CHECK.SUB
	}
	RETURN




# Willow Walk, Garden Path - lujeakave root, riolur leaves, ithor root, nemoih root, hulnik grass, jadice flower, sufil sap, cebi root, blocil berries, blue flower, seolarn weed ----- CROSSING ROOM 257
# Willow Walk, Fountain - hulij leaves, plovik leaves ---- CROSSING ROOM 767

# Knife Clan, Woodland's Edge - nilos grass, aevaes leaves, nuloe stem ---- map 4 ROOM 456


# Midton Circle - Clumps of tiny wild flowers hug ---- CROSSING ROOM 265
	# - belradi moss, muljin sap, hisan flower, cebi root, georin grass,junliar stem




# ojhenik root (daytime only) - MAP 7NTR, ROOM 515
# aloe leaves - NTR - ROOM 91, map 7 NTR
# yelith root - NTR - ROOM 91, map 7

# dioica sap -  ROOM 114, INNER HIB, MAP 116
# eghmok moss - MAP 58, ROOM 18 - Acenamacra village Road (Possibly Serpents Tree also)
# genich stem -  Riverhaven, out east gate, ROOM 40, MAP 31


# qun pollen - ?????  --- CROSSING _ STORE BOUGHT ----- ORDER 15, comes in stacks of 4
	#qun pollen	Muspar'i	Muspar'i, along the Velakan Trade Route	??
	

