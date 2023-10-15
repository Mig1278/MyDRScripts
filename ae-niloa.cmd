DEBUG 10
#goto MAKE_CIRCLE


if ((@unixtime@) < $cs2_timer_necroVial) then {
	ECHO NOT READY YET
	ECHO NOT READY YET
	ECHO NOT READY YET
	ECHO NOT READY YET
	ECHO NOT READY YET

	exit
}
put #script abort all except %scriptname
pause .1
put stl
pause .1
put str
pause .1

put exp all
pause 1
send prep eotb
pause 1
send cast
pause 1

gosub GOTO_NILOA
send release eotb
pause 1

gosub AT_NILOA

gosub ROOM_CHECK 14

gosub MAKE_CIRCLE
gosub CLEAN_CIRCLE

exit


GOTO_NILOA:
	if (($zoneid = 69) && ($roomid = 541)) then return 
	else 
		put .travel wyvern 541
		waitforre ^YOU ARRIVED!
		goto GOTO_NILOA
	return

AT_NILOA:
		matchre RETURN1 glass vial
		matchre CIRCLE_DONE I cannot yet give you another
	send GIVE NILOA 5000 DOKORAS
	matchwait 5
	goto AT_NILOA
	
	
MAKE_CIRCLE:
	gosub TURN_VIAL_RED
	pause 2
	gosub TURN_VIAL_GREEN
	pause 2
	gosub TURN_VIAL_BLACK
	pause 2
	return
	
	
TURN_VIAL_RED:
			matchre COLORFOUND red colored salt
		send turn my vial
		matchwait 1
		goto TURN_VIAL_RED
TURN_VIAL_GREEN:
			matchre COLORFOUND green colored salt
		send turn my vial
		matchwait 1
		goto TURN_VIAL_GREEN
TURN_VIAL_BLACK:
			matchre COLORFOUND black colored salt
		send turn my vial
		matchwait 1
		goto TURN_VIAL_BLACK

COLORFOUND:
		matchre RETURN1 You pour out|You carefully pour
	send pour vial
	matchwait 2
	goto COLORFOUND
		
		
CLEAN_CIRCLE:
		matchre CIRCLE_DONE expertly erasing
	send clean circle
	matchwait 2
	goto CLEAN_CIRCLE
	

CIRCLE_DONE:
	put #var cs2_timer_necroVial {#evalmath (@unixtime@ + 86430)}

	exit









## ************
RETURN1:
	return

## ************
ROOM_CHECK:
	var Tmp_Room_ID $1
	var Tmp_Map_ID $zoneid
ROOM_CHECK.SUB:	
	pause .3
	if (($roomid = 0) && ($zoneid = 13)) then gosub CHECK_DARK
	if (($roomid = 0) && ($zoneid = 127)) then {
		if (matchre("$zoneid","12a")) then {
			send .ac-fast3b resuscitant
			exit
		}
		send climb tree
		pause 3
		GOTO ROOM_CHECK.SUB
	}

	if (("$roomid" != "%Tmp_Room_ID") && ("$zoneid" = "%Tmp_Map_ID")) then {
			matchre ROOM_CHECK.ARRIVED ^YOU HAVE ARRIVED|not found
			matchre ROOM_CHECK.SUB FAILED
			matchre ROOM_CHECK.SUB Destination ID
		put #goto %Tmp_Room_ID
		matchwait 15
		GOTO ROOM_CHECK.SUB
	}
ROOM_CHECK.ARRIVED:	
	RETURN		

