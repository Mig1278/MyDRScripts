remove #DEBUG 10
ECHO *************************
ECHO *************************
ECHO Transfers everything from bag 1 to bag 2
ECHO usage example: .ad-transfer rucksack carryall
ECHO *************************
ECHO *************************

	var container_one %1
	var container_two %2
	


action var contents $1 when ^In the .* you see (.*)
#action var contents $1 when ^On the .* you see (.*)
  
var case_list first|second|third|fourth|fifth|sixth|seventh|eighth|ninth|tenth
eval Case_Count count("%case_list","|")
math Case_Count add 1

pause 1
send look in my %container_one
pause 1

eval contents replacere("%contents", " and |, ", "|")
var contents |%contents|
eval total count("%contents", "|") 
action var temparray %temparray|$1 when ^@(?:an?|some).* ([\w-']+)
var i 0
var temparray

## ***************
LOOP:
    put #parse @%contents(%i)
    math i add 1
    pause 0.1
    if (%i>=%total) then goto STOW_START
    goto loop
STOW_START:
    var i 1
    STOW_LOOP:
    if (%i>=%total) then goto done
        matchre STOW_ITEM ^You get|^You are already holding that|You remove
        matchre STOW-RIGHT ^You need a free hand
    send get %temparray(%i) from %container_one
    matchwait 1
	
	math i add 1
	GOTO STOW_LOOP
	
	
	ECHO EMPTY
	EXIT
STOW-RIGHT:
#	send put $righthandnoun in my %container_two
#	send stow right
	send drop %temparray(%i)
	wait .5
	GOTO STOW_LOOP
STOW_ITEM:
#	send stow $righthandnoun
	send put %temparray(%i) in my %container_two
#	send drop $righthandnoun
	math i add 1
	GOTO STOW_LOOP
