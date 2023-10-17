#DEBUG 10
include js_arrays.js

#Script by Boobear
## Thank you to Dasiffion/Ataelos/Any other Genie Folks on the chat boards I may have missed for helping build this.

## SETUP
## Requires cases to have the following labels (Holy, Life, Elemental, Lunar, Necro, Holy2, Life2, Elemental2, Lunar2) CASE SENSITIVE
## If you want different labels... then have fun.
## Will output to the Output window Spell Name - Spell Type it's going in.
## Will go through and flip all your cases when done to give you an inventory update.
## Set the following 3 variables below for your containers.
var scroll_container banana
var case_container ruck
var non_scrolls_container ruck

action (setup_action) var contents $1 when ^In the .* you see (.*)
action setvar SPELL_NAME $1 when description of the ((?:\w+(?:\s)?)+) spell
action setvar SPELL_NAME $1 when ^It is labeled "((?:\w+(?:\s)?)+)."
action instant var case_name $1 when ^You tap.* labeled \"(\S+)\" inside
action var temparray %temparray|$1 when ^@(?:an?|some).* ([\w-']+)


action (SPELL_TYPES) setvar SPELL_TYPE Holy when ^It is labeled \"(Aspects of the All-God|Auspice|Bitter Feast|Bless|Centering|Chill Spirit|Curse of Zachriedek|Divine Radiance|Fists of Faenella|Ghost Shroud|Glythtide's Gift|Hand of Tenemlor|Harm Evil|Heavenly Fires|Horn of the Black Unicorn|Huldah's Pall|Major Physical Protection|Malediction|Minor Physical Protection|Phelim's Sanction|Protection from Evil|Revelation|Sanctify Pattern|Soul Shield|Soul Sickness|Spite of Dergati|Uncurse|Vigil|Anti-Stun|Aspirant's Aegis|Clarity|Courage|Divine Guidance|Footman's Strike|Halt|Hands of Justice|Heroic Strength|Rebuke|Righteous Wrath|Rutilor's Edge|Sentinel's Resolve|Shatter|Smite Horde|Soldier's Prayer|Stun Foe)\.\"$

action (SPELL_TYPES) setvar SPELL_TYPE Life when ^It is labeled \"(Absolution|Adaptive Curing|Icutu Zaharenela|Aesandry Darlaeth|Aggressive Stance|Awaken|Blood Staunching|Compel|Gift of Life|Innocence|Iron Constitution|Lethargy|Mental Focus|Paralysis|Raise Power|Refresh|Tranquility|Vigor|Athleticism|Carrion Call|Compost|Curse of the Wilds|Deadfall|Devitalize|Eagle's Cry|Earth Meld|Essence of Yew|Forestwalker's Boon|Grizzly Claws|Hands of Lirisa|Harawep's Bonds|Instinct|Oath of the Firstborn|Senses of the Tiger|Stampede|Swarm|Wisdom of the Pack|Wolf Scent)\.\"$

action (SPELL_TYPES) setvar SPELL_TYPE Elemental when ^It is labeled \"(Beckon the Naga|Aura of Tongues|Breath of Storms|Demrris' Resolve|Drums of the Snake|Echoes of Aether|Eillie's Cry|Misdirection|Nexus|Rage of the Clans|Redeemer's Pride|Resonance|Soul Ablaze|Whispers of the Muse|Will of Winter|Words of the Wind|Air Bubble|Air Lash|Anther's Call|Arc Light|Ethereal Shield|Fire Ball|Fire Shards|Flame Shockwave|Frost Scythe|Frostbite|Gar Zeng|Geyser|Ice Patch|Ignite|Lightning Bolt|Paeldryth's Wrath|Rising Mists|Shockwave|Stone Strike|Substratum|Sure Footing|Swirling Winds|Tailwind|Thunderclap|Tingle|Tremor|Vertigo|Ward Break|Y'ntrel Sechra|Zephyr|Aethrolysis)\.\"$

action (SPELL_TYPES) setvar SPELL_TYPE Lunar when ^It is labeled \"(Saesordian Compass|Sever Thread|Sovereign Destiny|Tangled Fate|Tezirah's Veil|Artificer's Eye|Aura Sight|Burn|Cage of Light|Calm|Clear Vision|Dazzle|Dinazen Olkar|Hypnotize|Machinist's Touch|Partial Displacement|Piercing Gaze|Psychic Shield|Rend|Shadows|Shear|Sleep|Telekinetic Storm|Telekinetic Throw|Tenebrous Sense|Thoughtcast|Unleash|Avren Aevareae|Blur|Finesse|Fluoresce|Last Gift of Vithwok IV|Membrach's Greed|Nonchalance|Platinum Hands of Kertigen|Regalia|Turmar Illumination|Trabe Chalice|Crystal Dart|Iyqaromos Fire-Lens|Contingency)\.\"$

action (SPELL_TYPES) setvar SPELL_TYPE Necro when ^It is labeled \"(Acid Splash|Blood Burst|Heighten Pain|Liturgy|Obfuscation|Petrifying Visions|Researcher's Insight|Rite of Contrition|Rite of Grace|Siphon Vitality|Viscous Solution|Visions of Darkness|Alkahest Edge)\.\"$

action (SPELL_TYPES) setvar SPELL_TYPE Analogous when ^It is labeled \"(Burden|Dispel|Ease Burden|Gauge Flow|Imbue|Lay Ward|Manifest Force|Seal Cambrinth|Strange Arrow)\.\"$




send open %scroll_container
pause .5
send open %case_container
pause .5
send open %non_scrolls_container
pause .5



action (SPELL_TYPES) on
action (setup_action) on
pause 1
send look in my %scroll_container
pause 1

eval contents replacere("%contents", " and |, ", "|")
var contents |%contents|
eval total count("%contents", "|") 



var count_list first|second|third|fourth|fifth|sixth|seventh|eighth|ninth
eval case_count count("%count_list","|")
var i %case_count
var case_list

action (setup_action) off

## ***************
INIT_CASE_ARRAY:
	ECHO %case_count
#    pause 0.1
    if (%i > 0) then {
		send tap my %count_list(%i) case
		pause .4
		var case_list %case_name|%case_list
		ECHO edited list -> %case_list	
		math i subtract 1
		goto INIT_CASE_ARRAY
	}
	send tap my %count_list(%i) case
	pause .4
	var case_list %case_name|%case_list
	
	echo Ok, I have %case_list cases

	var i 0	
## ***************
LOOP:
    put #parse @%contents(%i)
    math i add 1
    pause 0.1
    if (%i>=%total) then goto STOW_SPELLS_START
    goto loop

STOW_SPELLS_START:
    var i 1
    SCROLL_LOOP:
	# You get a green vellum scroll labeled with See the Wind from inside your watersilk bag.
    if (%i>=%total) then goto done
        matchre READ_ITEM ^You get|^You are already holding that
        matchre STOW-RIGHT ^You need a free hand
    send get %temparray(%i) from my %scroll_container
    matchwait 5
	ECHO NO Scrolls/Spells?
    GOTO CASE_FLIP

STOW-RIGHT:
	send stow right
	wait .5
	GOTO STOW_SPELLS_START

READ_ITEM:
	action (SPELL_TYPES) off
	pause .5
	setvar SPELL_TYPE NULL
	send look my %temparray(%i)
	wait .5
	if ("%SPELL_TYPE" = "NULL") then {
				matchre NOT_SPELL There is nothing there to read.
		send read my %temparray(%i)
		matchwait 5
	}
	action (SPELL_TYPES) on
	pause .5
	send look my %temparray(%i)
	wait .5
	setvar counter 0
	action (SPELL_TYPES) off
	echo %SPELL_NAME of type %SPELL_TYPE
	pause .5
	GOTO LOOK_CASES
	
NOT_SPELL:
	send put $righthandnoun in my %non_scrolls_container
	math i add 1
	GOTO SCROLL_LOOP

LOOK_CASES:
	put #ECHO %SPELL_TYPE
	jscall case_loc findIndex ("case_list","%SPELL_TYPE")
	ECHO Case_loc --> %case_loc
LOOK_CASE_FAIL:
	if (%case_loc < 0) then {
		send stow $righthandnoun
		pause .5
		send stow $lefthandnoun
		pause .5
		var i %case_count
		var case_list
		goto INIT_CASE_ARRAY
	}
		matchre FOUND_CASE \b%SPELL_TYPE\b
		matchre EXIT ^I could not find what you were referring to.
		matchre EXIT ^What were
	send tap my %count_list(%case_loc) case in %case_container
	matchwait 2

	math case_loc add 1
	if (%case_loc > %case_count) then var case_loc 0
	GOTO LOOK_CASE_FAIL

EXIT:
	EXIT	

	
FOUND_CASE:
	if ("%SPELL_TYPE" = "NULL") then {
		put $righthandnoun in my %non_scrolls_container
		math i add 1
		GOTO SCROLL_LOOP
	}
		matchre GOT_CASE ^You get
	send get %count_list(%case_loc) case from my %case_container
	matchwait 1
	GOTO FOUND_CASE

GOT_CASE:	
		matchre CORRECT_CASE \b%SPELL_TYPE\b
	send tap my case
	matchwait 2
		
	GOTO FOUND_CASE
	
	send stow case
	wait .5
	GOTO LOOK_CASES
	
CORRECT_CASE:	
	send open my case
	wait .5
		matchre No_ROOM_CASE ^Flipping through your case, you realize there's no more room
	send push my case with my $righthandnoun
	matchwait 1
	js doRemove ("case_list","%SPELL_TYPE",1)
	pause 1
	var case_list %case_name|%case_list
	send stow case
	wait .1
	
	math i add 1
	send #ECHO >Output * %SPELL_NAME to %SPELL_TYPE
	GOTO SCROLL_LOOP

NO_ROOM_CASE:
	setvar counter 1
	pause .5
	send stow case
	wait .5
	if matchre("%SPELL_TYPE", "2") then {
		send put $righthandnoun in my %non_scrolls_container
		send #ECHO >Output * %SPELL_NAME to %non_scrolls_container

		math i add 1
		GOTO SCROLL_LOOP
	}
	if matchre("%SPELL_TYPE", "Elemental") then setvar SPELL_TYPE Elemental2
	if matchre("%SPELL_TYPE", "Holy") then setvar SPELL_TYPE Holy2
	if matchre("%SPELL_TYPE", "Life") then setvar SPELL_TYPE Life2
	if matchre("%SPELL_TYPE", "Lunar") then setvar SPELL_TYPE Lunar2
	
	GOTO LOOK_CASES

	
CASE_FLIP:
pause 1
send look in my %case_container
pause 1

eval contents replacere("%contents", " and |, ", "|")
var contents |%contents|
eval total count("%contents", "|") 
action var temparray %temparray|$1 when ^@(?:an?|some).* ([\w-']+)
var i 0
var temparray

	put #clear main
	var case_count 0
	CASE_FLIP_SUB:
			matchre DONE ^I could not find what you were referring to.
		send get my tenth case in %case_container
		matchwait 1
	
	FLIP_CASES:
		send flip my case
		wait 1
		send stow case
		wait .5
		math case_count add 1
		if %counter > 10 then EXIT
		GOTO CASE_FLIP_SUB
			
	DONE:
		setvar counter 0
		GoSub CASE_FLIP
		EXIT	