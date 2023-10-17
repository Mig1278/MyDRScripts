DEBUG 10

# USAGE --> .ad-herbs_make <# desired> <herb name>
# EXAMPLE: .ad-herbs_make 5 nilos to make 5 nilos ungent
# EXAMPLE: .ad-herbs_make 1 nuloe to make 1 nuloe elixir

put #clear main



ACTION var herb_count_have $1 when ^You count out (\d+) pieces.* 
ACTION var product_have $1 when ^You count out (\d+) uses.* 

var catalyst coal
## NEED TO ADD IN THE MATS CHECK FOR THE OTHER TYPES OF CATALYSTS

var product_count_desired %1
var product_have 0

var herb_name %2
var herb_count_have 0

var product_type NULL
var water NULL



if (matchre("%herb_name", "georin|nilos|plovik|nemoih|hulnik|sufil|aloe|jadice")) then {
	var product_type ungent
	var water water
	}
if (matchre("%herb_name", "riolur|muljin|ithor|eghmok|junliar|aevaes|lujeakave|yelith")) then {
	var product_type tonic
	var water water
	}
if (matchre("%herb_name", "genich|dioica|cebi|blocil")) then {
	var product_type poultice
	var water alcohol
	}
if (matchre("%herb_name", "hisan|nuloe|ojhenik|hulij|belradi")) then {
	var product_type elixir
	var water alcohol
	}

	
MAIN:
	send stow left
	pause .1
	send stow right
	pause .1

	GoSub CHECK_COUNTS
	
	if (%product_have > %product_count_desired) then GOTO FINISHED
	GoSub READ_BOOK
	
#	GoSub BREAK_HERB
	GoSub MAKE_POTION
	GoSub COMBINE_POTION
	
	GOTO MAIN
	

# ************
COMBINE_POTION:
	send get my %product_type from my ruck
	pause .5
	send combine %product_type with %product_type
	pause .5
	RETURN
	
	
# ************
FINISHED:
	ECHO You have %product_have %herb_name %product_type and desire %product_count_desired
	ECHO You have %product_have %herb_name %product_type and desire %product_count_desired
	ECHO You have %product_have %herb_name %product_type and desire %product_count_desired
	EXIT

# ************
CHECK_COUNTS:
	pause 1
	send count my %herb_name %product_type
	pause .5
	if (%product_have > %product_count_desired) then GOTO FINISHED
	
	send count my %herb_name
	pause .5
	if (%herb_count_have < 25) then GOTO GET_HERBS

		matchre NO_WATER What were you|I could not find what you were referring to.
	send count my %water
	matchwait 1
	
		matchre NO_CATALYST What were you|I could not find what you were referring to.
	if ("%catalyst" = "coal") then send tap my %catalyst nugget
	matchwait 1
	

	RETURN

# ************	
NO_CATALYST:
	if ("%catalyst" = "coal") then {
		if ($zoneid = 30) then {
			GoSub ROOM_CHECK 400
			send order 2
			pause .5
			send order 2
			pause .5
		}
		send stow nug
	}
	else {
		ECHO NO CATALYST!
		ECHO NO CATALYST!
		ECHO NO CATALYST!
		ECHO NO CATALYST!
		EXIT
	}
	GOTO CHECK_COUNTS


# ************	
NO_WATER:
	if ($zoneid = 30) then GoSub ROOM_CHECK 472
		if ("%water" = "water") then {
			send order 1
			pause .5
			send order 1
			pause .5
		}
		if ("%water" = "alcohol") then {
			send order 2
			pause .5
			send order 2
			pause .5
		}
	send stow %water
	GOTO CHECK_COUNTS
	
	
# ************	
GET_HERBS:
	if (matchre("%herb_name", "nemoih|plovik|jadice|nilos|georin|riolur|junliar|aevaes|genich|ojhenik")) then {
		if ($zoneid = 30) then GoSub ROOM_CHECK 472
	
		if (matchre("%herb_name", "nemoih")) then setvar temp 3
		if (matchre("%herb_name", "plovik")) then setvar temp 4
		if (matchre("%herb_name", "jadice")) then setvar temp 5
		if (matchre("%herb_name", "nilos")) then setvar temp 6
		if (matchre("%herb_name", "georin")) then setvar temp 7
		if (matchre("%herb_name", "riolur")) then setvar temp 8
		if (matchre("%herb_name", "junliar")) then setvar temp 9
		if (matchre("%herb_name", "aevaes")) then setvar temp 10
		if (matchre("%herb_name", "genich")) then setvar temp 11
		if (matchre("%herb_name", "ojhenik")) then setvar temp 12

		send order %temp
		pause .5
		send order %temp
		pause .5
		send stow %herb_name
		
		send order %temp
		pause .5
		send order %temp
		pause .5
		send stow %herb_name
		GOTO CHECK_COUNTS
	}
	else {
		ECHO NEED HERBS, CANT BUY THEM!!
		ECHO NEED HERBS, CANT BUY THEM!!
		ECHO NEED HERBS, CANT BUY THEM!!
		EXIT
	}
# ************** 	
READ_BOOK:
	send get remed book
	pause 1
	
	if (matchre("%herb_name", "georin|nilos|plovik|nemoih|hulnik|sufil|aloe|jadice")) then {
		send turn book to chapt 3
		pause 1	
		if (matchre("%herb_name", "georin")) then send turn book to page 12
		if (matchre("%herb_name", "nilos")) then send turn book to page 11
		if (matchre("%herb_name", "plovik")) then send turn book to page 10
		if (matchre("%herb_name", "nemoih")) then send turn book to page 9
		if (matchre("%herb_name", "hulnik")) then send turn book to page 14
		if (matchre("%herb_name", "sufil")) then send turn book to page 13
		if (matchre("%herb_name", "aloe")) then send turn book to page 16
		if (matchre("%herb_name", "jadice")) then send turn book to page 15
	}
	
	if (matchre("%herb_name", "riolur|muljin|ithor|eghmok|junliar|aevaes|lujeakave|yelith")) then {
		send turn book to chapt 4
		pause 1
		if (matchre("%herb_name", "riolur")) then send turn book to page 12
		if (matchre("%herb_name", "muljin")) then send turn book to page 11
		if (matchre("%herb_name", "ithor")) then send turn book to page 10
		if (matchre("%herb_name", "eghmok")) then send turn book to page 9
		if (matchre("%herb_name", "junliar")) then send turn book to page 14
		if (matchre("%herb_name", "aevaes")) then send turn book to page 13
		if (matchre("%herb_name", "lujeakave")) then send turn book to page 16
		if (matchre("%herb_name", "yelith")) then send turn book to page 15
	}
	send stow book
	pause 1
	RETURN


# ************** 	
BREAK_HERB:
	if (%herb_count_have = 5) then RETURN
	send get my %herb_name
	pause .5
	send mark %herb_name at 5
	pause .5
	send break my %herb_name
	pause .5
	send stow other %herb_name
	pause .5
	send stow %herb_name
	pause .5

	RETURN

	
# ************** 	
MAKE_POTION:
	if (matchre("%product_type", "salve|cream|ungent|balm|ointment|poultice")) then var temp 1
	if (matchre("%product_type", "tonic|wash|potion|draught| elixir")) then var temp 2
	
	if ("%catalyst" = "coal") then setvar catalyst nugget
	
	put .alchemy %temp %product_type %herb_name none %water %catalyst ruck ruck
	waitforre ALCHEMY DONE	

	RETURN


## ************************************************************************************
ROOM_CHECK:
	var Tmp_Room_ID $1
	var Tmp_Map_ID $zoneid
ROOM_CHECK.SUB:	
	wait .3
	if (($roomid != %Tmp_Room_ID) && ($zoneid = %Tmp_Map_ID) then {
			matchre RETURN ^YOU HAVE ARRIVED
			matchre ROOM_CHECK.SUB FAILED
			matchre ROOM_CHECK.SUB Destination ID
		put #goto %Tmp_Room_ID
		matchwait 15
		GOTO ROOM_CHECK.SUB
	}
	RETURN
	
## ******
RETURN:
	RETURN	



