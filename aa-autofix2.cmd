debug 10

ACTION send exit when eval $health < 60
ACTION setvar item.giver $1; when ^(\S+) offers you


var Item.List stick|scorpion|sallet|plate|sleeves|cuirass|leathers|jacket|glove|mitts|gauntlets|handguards|thorakes|jerkin|collar|balaclava|longcoat|sleeves|sallet|aventail|greaves|vambraces|shield|buckler|targe|sipar|coif|cowl|gauntlet|half plate|lorica|breastplate|hauberk|field plate|tasset|ring mail|mask|helm|shirt|coat|hood|pants|cowl|cutlass|stilletto|sword|longsword|claymore|mattock|kaskara|ngalio|axe|dagger|mace|greathammer|star|bola|falcata|greatsword|nightstick|spear|blade|scimitar|falchion|bola|hammer|maul|claw|knuckles|staff|maul|crossbow|shortbow|bow|stonebow|longbow|latchbow|shovel|pickaxe|mallet|hammer|tongs|drawknife|chisel|wood saw|bone saw|rasp|riffler|shaper|plier|scraper|knitting needles|sew needles|scissors|mixing stick|wire sieve|stick
 

eval MaxItems count("%Item.List","|")
math MaxItems add 1
counter set 0  
setvar bag.check NO
setvar bag.done NO

##*************
ITEM.WAIT:
	match ITEM.GIVEN offers you
matchwait


##*************
ITEM.GIVEN:
	send stow right
	wait .5
	send stow left
	wait .5
	send accept
	setvar item.name $righthandnoun
	wait 1
	send whisper %item.giver Ok %item.giver, you have given me a :: $righthandnoun :: Just a moment.
	
	if matchre ("$righthandnoun",  "(sandpaper|stain|oil|brush|thread|slickstone)") then GOTO MATS.RECEIVED
	wait .5
	GoSub BAG.CHECK
	
	if %bag.check = "NO" then GOTO METAL.CLEAN
	if %bag.check = "YES" then GOTO GET_ITEMS

##*************
MATS.RECEIVED:
	send whisper %item.giver Thank you for $righthandnoun
	wait .5
	send stow $lefthandnoun
	wait .5
	if matchre ("$righthandnoun", "thread") then {
		send get my sew needles
		wait 1
		send put my thread on my  needle
		wait 1
		send stow my $lefthandnoun
		wait .5
	}
	send stow my $righthandnoun
	wait .5
	GOTO ITEM.WAIT

##*************
BAG.CHECK:
	if matchre ("$righthandnoun",  "(haversack|bag|pack|rucksack|backpack|satchel|bundle|sack)")) then {
		setvar bag.type $1
		setvar bag.check YES
		send lower my %bag.type ground left
		wait 1
	}
	RETURN
	 
   
##*************
GET_ITEMS:   
	if (%c > %MaxItems) then {
		setvar bag.done YES
		GOTO REPAIR.DONE
	}
		match METAL.CLEAN You get a 
		match METAL.CLEAN You get an 
		match METAL.CLEAN You get
	send get my %Item.List(%c) from my %bag.type
	matchwait 1
	counter add 1
	GOTO GET_ITEMS

	
 
## ****************** METAL REPAIR -- Armor, Weapons (metal), and Tools ***************************
	
##*************
METAL.CLEAN:

	if matchre ("$righthandnoun",  "(crossbow|shortbow|bow|stonebow)") then GOTO WOOD.CLEAN
	
	
	send get my brush
		match METAL.CLEAN2 You get
		match METAL.CLEAN2 You are already
		match NEED_STUFF.BRUSH What were you
		match FREEHAND.CLEAN You need a free hand
	matchwait 3
	
##*************	
FREEHAND.CLEAN:
		send stow my $lefthandnoun
		wait .50
		GOTO METAL.CLEAN
		
##*************	
METAL.CLEAN2:
	pause .5
	send rub my $righthandnoun with my brush
		match METAL.CLEAN2 Roundtime
		match METAL.OILIT appears ready to be oiled
		match REPAIR.DONE is not damaged enough to warrant repair
		match REPAIR.DONE You stop, realizing that cannot be repaired just yet.
		match REPAIR.DONE You cannot figure out how to do that. 
		match CLOTH_REPAIR You will need a different tool to repair that.
		matchwait 3
		GOTO REPAIR.DONE
		
##*************	
METAL.OILIT:
	send stow my brush
	pause .5
	send get my oil
		match METAL.OILIT2 You get
		match NEED_STUFF.OIL What were you
		match FREEHAND.OIL You need a free hand
	matchwait 3
##*************	
FREEHAND.OIL:
		wait .5
		send stow my $lefthand
		wait .50
		GOTO METAL.OILIT
##*************	
METAL.OILIT2:
	pause .5
		match METAL.OILIIT You must be holding 
	send pour oil on my $righthandnoun
	matchwait 3
	wait 1
	send stow my oil
	goto METAL.CLEAN

##*************	
REPAIR.DONE:
	whisp %item.giver $righthand done, next!
	send #ECHO >Output *** $righthand done, next!

	if %bag.check = "NO" then {
		send whisper %item.giver Repair is done, here is your :: $righthand ::
		wait .1
		send give %item.giver
		wait 1
		
		counter set 0  
		setvar bag.check NO
		setvar bag.done NO
		GOTO ITEM.WAIT
	}
	if %bag.check = "YES" then {
		if %bag.done = "NO" then {
			counter add 1
			send put my $righthand in my %bag.type
			wait 1
			GOTO GET_ITEMS
		}
		if %bag.done = "YES" then {
			send put $righthand in my %bag.type
			wait 1
			send get %bag.type
			wait 1
			send whisper %item.giver Repair is done, here is your :: $righthand ::
			wait .1
			send give %item.giver 
			wait 1
			send whisper %item.giver Anything I haven't repaired give to me directly - Apologies if so.
			
			counter set 0  
			setvar bag.check NO
			setvar bag.done NO
			GOTO ITEM.WAIT
		}
	}

	EXIT



## ****************** CLOTH REPAIR  *********************************************************************************	
CLOTH_REPAIR:	
##*************	
CLOTH.CLEAN:
	pause .5
		match CLOTH.CLEAN2 You get
		match REPAIR.DONE is not damaged enough to warrant repair
		match FREEHAND.needle You need a free hand
		match REPAIR.DONE You cannot figure out how to do that. 
	send get my sewing needles
	matchwait 3

##*************	
FREEHAND.needle:
		wait .5
		send stow my $lefthand
		wait .50
		GOTO CLOTH.CLEAN
	
##*************	
CLOTH.CLEAN2:
	pause .5
		match CLOTH.CLEAN2 Roundtime
		match CLOTH.OIL_IT appears ready to be oiled
		match REPAIR.DONE is not damaged enough to warrant repair
		match THREAD The needles need to have thread put on them
		match REPAIR.DONE You cannot figure out how to do that. 
		match GET_ITEMS You must be holding 
	send push my $righthandnoun with my needle
	matchwait 3

##*************	
CLOTH.OIL_IT:
	pause .5
	send stow needle
	pause .5
		match CLOTH.OIL_IT2 You get
		match NEED_STUFF.SLICKSTONE What were you
		match FREEHAND.slick You need a free hand
	send get my slickstone
	matchwait 3
	
##*************	
FREEHAND.slick:
		wait .5
		send stow my $lefthand
		wait .50
		GOTO CLOTH.OIL_IT

##*************	
CLOTH.OIL_IT2:
	pause .5
		match REPAIR.DONE You cannot figure out how to do that. 
		match GET_ITEMSYou must be holding 
	send rub my $righthandnoun with my slickstone
	matchwait 3
	wait 1
	send stow my slickstone
	goto CLOTH.CLEAN

##*************	
THREAD:
	send stow $righthand
	wait .5
	send stow $lefthand
	wait .5
	send get my sew need
	wait .5
		matchre THREAD.FOUND You get
		mathre NEED_STUFF.THREAD What were you
	send get my thread
	matchwait 2
	
##*************	
THREAD.FOUND:
	send put my thread on my  needle
	wait 3
	send get my %item.name
	GOTO CLOTH_REPAIR
	
	
	

## ****************** WOOD REPAIR  *********************************************************************************	

##*************	
WOOD.CLEAN:
	pause .5
		match WOOD.CLEAN2 You get
		match WOOD.CLEAN2 You already
		match NEED_STUFF.SANDPAPER What were you
		match REPAIR.DONE is not damaged enough to warrant repair
		match FREEHAND.SANDPAPER You need a free hand
		match REPAIR.DONE You cannot figure out how to do that. 
	send get my sandpaper
	matchwait 3

##*************	
FREEHAND.SANDPAPER:
		wait .5
		send stow $lefthand
		wait .50
		GOTO WOOD.CLEAN
	

##*************	
WOOD.CLEAN2:
	pause .5
		match WOOD.CLEAN2 Roundtime
		match WOOD.STAIN_IT appears ready to be stained
		match REPAIR.DONE is not damaged enough to warrant repair
		match REPAIR.DONE You cannot figure out how to do that. 
		match GET_ITEMS You must be holding 
	send rub my $righthandnoun with my sandpaper
	matchwait 3

##*************	
WOOD.STAIN_IT:
	send stow sandpaper
	pause .5
		match WOOD.STAIN_IT2 You get
		match NEED_STUFF.STAIN What were you
		match FREEHAND.STAIN You need a free hand
	send get stain
	matchwait 3
	
##*************	
FREEHAND.STAIN:
		wait .5
		send stow $lefthand
		wait .50
		GOTO WOOD.STAIN_IT

##*************	
WOOD.STAIN_IT2:
	pause .5
		match REPAIR.DONE You cannot figure out how to do that. 
		match GET_ITEMS You must be holding 
	send pour stain on my $righthandnoun
	matchwait 3
	wait 1
	send stow stain
	goto WOOD.CLEAN


	

##***********************************  OUT OF MATS *****************************************
##******************************************************************************************
NEED_STUFF.BRUSH:
	send whisper %item.giver It looks like I'm out of brushes so I cannot complete repairs. So Sorry. If you wish, you can get the required mats for me. Just re-give me the things to be repaired after giving me the mats. Apologies for the inconvenience.
	wait .1
	send #ECHO >Output ****** Need Brushes
	GOTO NEED_STUFF

##*************	
NEED_STUFF.OIL:	
	send whisper %item.giver It looks like I'm out of oil so I cannot complete repairs. So Sorry. If you wish, you can get the required mats for me. Just re-give me the things to be repaired after giving me the mats. Apologies for the inconvenience.
	wait .1
	send #ECHO >Output ****** Need OIL
	GOTO NEED_STUFF

NEED_STUFF.SLICKSTONE
##*************	
	send whisper %item.giver It looks like I'm out of slickstones so I cannot complete repairs. So Sorry. If you wish, you can get the required mats for me. Just re-give me the things to be repaired after giving me the mats. Apologies for the inconvenience.
	wait .1
	send #ECHO >Output ****** Need Slickstones
	GOTO NEED_STUFF
	
##*************	
NEED_STUFF.THREAD:
	send whisper %item.giver It looks like I'm out of thread so I cannot complete repairs. So Sorry. If you wish, you can get the required mats for me. Just re-give me the things to be repaired after giving me the mats. Apologies for the inconvenience.
	wait .1
	send #ECHO >Output ****** Need Thread
	GOTO NEED_STUFF
	
##*************	
NEED_STUFF.SANDPAPER:
	send whisper %item.giver It looks like I'm out of sandpaper so I cannot complete repairs. So Sorry. If you wish, you can get the required mats for me. Just re-give me the things to be repaired after giving me the mats. Apologies for the inconvenience.
	wait .1
	send #ECHO >Output ****** Need Sandpaper
	GOTO NEED_STUFF	
	
##*************	
NEED_STUFF.STAIN:
	send whisper %item.giver It looks like I'm out of stain so I cannot complete repairs. So Sorry. If you wish, you can get the required mats for me. Just re-give me the things to be repaired after giving me the mats. Apologies for the inconvenience.
	wait .1
	send #ECHO >Output ****** Need Stain
	GOTO NEED_STUFF		
	
	
##*************	THIS SECTION NEEDS TO BE UPDATED ---- 
NEED_STUFF:

	if %bag.check = "NO" then {
		send whisper %item.giver Please take your :: $righthand ::
		wait 1
		send give %item.giver
		wait 1
		GOTO ITEM.WAIT
	}
	if %bag.check = "YES" then {
		send put $righthand in my %bag.type
		wait 1
		send get %bag.type
		wait 1
		send whisper %item.giver Please take your :: $righthand ::
		wait .1
		send give %item.giver 
		wait 1
		GOTO ITEM.WAIT
	}

##***********************************  OUT OF MATS DONE ************************************
##******************************************************************************************
	
	