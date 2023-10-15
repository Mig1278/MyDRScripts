echo sells pouch, tips person


ACTION setvar item_giver $1; setvar item_given $2 when ^(\S+) offers you.* (\S+). Enter
ACTION setvar sold_amount $1; setvar money_type $2 when hands you (\d+) (\S+).
ACTION var spell_ready 1 when ^You feel fully prepared to cast your spell\.|^Your target pattern has finished forming around the area\.|^The formation of the target pattern around .* has completed\.|^Your formation of a targeting pattern around .* has completed\.	
action send drop pouch; goto ITEM_pause when That's worthless to me

var spell_ready 0

send stow right
pause .1
send stow left
pause .1

RESTART:
if (!$SpellTimer.Finesse.active) then {
	pause 1
	send prep FIN 77
	gosub SPELL_pause
	send cast
	pause 1
	goto RESTART
}
	pause 1
	send say OK, I'm Ready.

##*************
ITEM_pause:
	match ITEM_GIVEN offers you
	matchwait

##*************
ITEM_GIVEN:
	send accept
	pause 1
	send sell %item_given
	pause 1
	send tip %item_giver %sold_amount %money_type
	pause 1
#	send give %item_giver
#	pause 1
	send drop $righthandnoun
	GOTO ITEM_pause



SPELL_pause:
	pause 15
	if %spell_ready = 1 then RETURN
	GOTO SPELL_pause
	