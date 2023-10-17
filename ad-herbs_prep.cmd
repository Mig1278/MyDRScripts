##DEBUG 10
#Herbie script by Boobear
#v1


# GoSub MAP_CHECK
# GoSub ROOM_CHECK 931

#pewter - the strongest catalyst, but also the most toxic. Pewter is made by smelting 3 parts tin with 2 parts lead. Both tin and lead can be found via mining.
 
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




setvar Internal_Herbs_Crush lujeakave root|hisan flower|aevaes leaves|belradi moss|blue flower|eghmok moss|hulij leaves|ithor root|junliar stem|muljin sap|nuloe stem|ojhenik root|riolur leaves|yelith root

setvar External_Herbs_Press aloe leaves|blocil berries|cebi root|dioica sap|genich stems|hulnik grass|jadice flower|jadice pollen|nemoih root|nilos grass|plovik leaves|qun pollen|red flower|sufil sap|georin grass

setvar RawHerb_Container rucksack
setvar PreppedHerb_Container case
setvar Second_Herb_Container apron


### START OF THE GOOD STUFF --- Making the herbs, oh man!


setvar Herb_List %Internal_Herbs_Crush
eval Herb_List_Total count("%Herb_List","|")
setvar Herb_Action grinder
setvar Herb_Counter 0
GoSub GET_HERB_LOOP


setvar Herb_List %External_Herbs_Press
eval Herb_List_Total count("%Herb_List","|")
setvar Herb_Action press
setvar Herb_Counter 0
GoSub GET_HERB_LOOP



##*********
GET_HERB_LOOP:
		matchre PREP_ACTION ^You get
	send get %Herb_List(%Herb_Counter) from my %RawHerb_Container
	matchwait 1
	
	math Herb_Counter add 1
	if (%Herb_Counter > %Herb_List_Total) then {
		if (%Herb_Action = "press")) then {
			ECHO DONE 
			EXIT
		}
		RETURN
	}
	GOTO GET_HERB_LOOP

##*********	
PREP_ACTION:
	send put $righthandnoun in %Herb_Action
	wait 4
		matchre GET_HERB_LOOP ^You put|^You combine|^You place
		matchre STACK_NEW ^That stack of herbs is too large 
	send put $righthandnoun in my %PreppedHerb_Container
	matchwait 2
	
##*********	
STACK_NEW:
	send put $righthandnoun in my %Second_Herb_Container
	goto GET_HERB_LOOP
	
	
	
	
##*********	
STACK_MAX:
	send drop $righthandnoun
	
		matchre STACK_MAX ^You get
	send get %Herb_List(%Herb_Counter) from my %RawHerb_Container
	matchwait 1
	
	math Herb_Counter add 1
	GOTO GET_HERB_LOOP



## ************************************************************************************
MAP_CHECK:
## Get back to CROSSING Map checks
		## zoneid-4 is Outside Crossing West Gate
	if ($zoneid = 4) then GoSub ROOM_CHECK 14
		## zoneid-6 is Outside Crossing North Gate
	if ($zoneid = 6) then GoSub ROOM_CHECK 23
		## zoneid-7 is Outside Crossing, Northern Trade Road
	if ($zoneid = 7) then GoSub ROOM_CHECK 349
		## zoneid-8 is Outside Crossing East Gate
	if ($zoneid = 8) then GoSub ROOM_CHECK 43
		## zoneid = 1 is Crossing
	if ($zoneid = 1) then RETURN
	
	GOTO MAP_CHECK
	
## ************************************************************************************
ROOM_CHECK:
	var Skills_Temp $1
ROOM_CHECK.SUB:	
	wait .3
	if ($roomid != %Skills_Temp) then {
			matchre RETURN ^YOU HAVE ARRIVED
			matchre ROOM_CHECK.SUB FAILED
			matchre ROOM_CHECK.SUB Destination ID
		put #goto %Skills_Temp
		matchwait 15
		GOTO ROOM_CHECK.SUB
	}
	RETURN

	
RETURN:
	RETURN
