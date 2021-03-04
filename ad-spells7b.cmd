#DEBUG 10
put exp 0
pause 1
 # put #var LastCyclic 0

# A lucent sphere flickers around you, protecting your spirit.  A weak point in the Soul Shield is exposed, unraveling its energy entirely. ----> Soul Shield dropping due to Soul Attrition.
# Auspice increases spirit regen, Soul Shield is a shield, Vigil link spirit with someone else.

##USAGE ab-spells <enemy> <buff targ 1>
##USAGE EXAMPLE ab-spells bears|chickens charecter1 charecter2
## Must have globals set for spells see Example below
## Uses long names of spells in order to use SpellTimer PLUGIN - Required to use this correctly.
## Always have the "last" buff as NULL, can have as many as you want.
## Buff must appear in Spell Definitions too.. so if it's Sorcery, needs to be in there... 
## Example:
##		send #var cs2_spell.TrabeChalice.prep 5
##		send #var cs2_spell.TrabeChalice.symbiosis NO 

## NOTE : BUFF prep values are static - they dont change once set in variables.. if you want them to change set them as a trainer.

## TO DO ******* Add CYCLIC / RITUALS / SORCERY support
## TO DO ******* Should do attunement or something when spells max out

#######################################################################  Character Variables - Edit These ONLY
## Set to NULL if you dont want to train that spell type. EXAMPLE: var Augmentation_Trainer NULL
## Only set Train_Arcana to YES if you have a worn Sanowret Crystal, otherwise set to NULL

######################## Misc Variable Definitions
#put .ad-spelltrack
var spell_learn_check 4
var FLAG NO

var target %1
put #var cs2_snapcast_spell NULL
if (($Attunement.Ranks < 50) && ($Attunement.LearningRate < 30)) then put #var cs_Last_Perc.Timer $gametime


GoSub CLASS_SPELL_DEFINITIONS
GoSub INCLUDE_ACTIONS

if (%1 = "town") then put #var cs_TargetMonster town
put #var cs_TargetMonster_Group %1
GoSub MONSTER_CHECK  
######################## End of Misc Variable Definitions

## If no WORN Camb Item, set it to NULL
send #ECHO >Output *** NewSpellsCombat ***
if ("$charactername" = "Tanachu") then {
# TTTTTTTTTTTTTTTTTTTTTTT                                                   
# T:::::::::::::::::::::T                                                   
# T:::::::::::::::::::::T                                                   
# T:::::TT:::::::TT:::::T                                                   
# TTTTTT  T:::::T  TTTTTTaaaaaaaaaaaaa  nnnn  nnnnnnnn      aaaaaaaaaaaaa   
#         T:::::T        a::::::::::::a n:::nn::::::::nn    a::::::::::::a  
#         T:::::T        aaaaaaaaa:::::an::::::::::::::nn   aaaaaaaaa:::::a 
#         T:::::T                 a::::ann:::::::::::::::n           a::::a 
#         T:::::T          aaaaaaa:::::a  n:::::nnnn:::::n    aaaaaaa:::::a 
#         T:::::T        aa::::::::::::a  n::::n    n::::n  aa::::::::::::a 
#         T:::::T       a::::aaaa::::::a  n::::n    n::::n a::::aaaa::::::a 
#         T:::::T      a::::a    a:::::a  n::::n    n::::na::::a    a:::::a 
#       TT:::::::TT    a::::a    a:::::a  n::::n    n::::na::::a    a:::::a 
#       T:::::::::T    a:::::aaaa::::::a  n::::n    n::::na:::::aaaa::::::a 
#       T:::::::::T     a::::::::::aa:::a n::::n    n::::n a::::::::::aa:::a
#       TTTTTTTTTTT      aaaaaaaaaa  aaaa nnnnnn    nnnnnn  aaaaaaaaaa  aaaa

	#muttering blasphemies - DO is high.

	pause 1
	var Ritual_Focus_Item NULL
	var Train_Arcana YES
	var Camb_Item NULL
	var Camb_Item_MaxCharge 100
	var TM_FOCI_ITEM NULL
	var BUFF_PREP 77
	
#	put #var cs2_snapcast_spell Geyser

	# var Cyclic_0 ROTATE
	# var Cyclic_Options ROTATE
#	 var Cyclic_0 UniversalSolvent
#	 var Cyclic_0 RiteofGrace
	 var Cyclic_0 NULL
	 var Cyclic_Options NULL
	
	var Buff_0 NULL
	var Buff_1 NULL
	var Buff_2 NULL
	# var Buff_3 NULL
	# var Buff_4 NULL
	# var Buff_5 NULL
	# var Buff_6 NULL
	# var Buff_7 NULL
	# var Buff_8 NULL 
	# var Buff_9 NULL
	# var Buff_10 NULL
	# var Buff_11 NULL
	# var Buff_12 NULL
	# var Buff_13 NULL
	# var Buff_14 CalcifiedHide
	# var Buff_15 PhilosophersPreservation
	# var Buff_16 CallfromBeyond
	
	var Augmentation_Trainer Obfuscation
		put #var cs2_spell.Obfuscation.check MANUAL
#		put #var cs2_spell.Obfuscation.check 0
	var Warding_Trainer ManifestForce
		put #var cs2_spell.ManifestForce.check MANUAL
#		put #var cs2_spell.ManifestForce.check 0
	var Utility_Trainer EyesoftheBlind
		put #var cs2_spell.EyesoftheBlind.check MANUAL
#		put #var cs2_spell.EyesoftheBlind.check 0
	
	var Debilitation_Trainer PetrifyingVisions 
#	var Debilitation_Trainer ViscousSolution 
	var Debilitation_Trainer NULL 
	var Debilitation_Trainer_2 NULL
#	var Debilitation_Trainer_2 PetrifyingVisions
	
#	var Targeted_Magic_Trainer NULL
	var Targeted_Magic_Trainer SiphonVitality
	var Targeted_Magic_Trainer_2 NULL
	
	# var Sorcery_Trainer_Buff NULL
	var Sorcery_Trainer_Buff NULL 
	var Sorcery_Trainer_TM FrostScythe
	var Sorcery_Trainer_TM NULL
	var Sorcery_Trainer_Debil NULL
	var Sorcery_Trainer_Debil2 NULL

### .cyclic variables

	put #var cs2_Cyclics_Warding.Spell NULL
	put #var cs2_Cyclics_Warding.Options NULL
	
	put #var cs2_Cyclics_Utility.Spell NULL
	put #var cs2_Cyclics_Utility.Options NULL
	
	put #var cs2_Cyclics_Augmentation.Spell NULL
	put #var cs2_Cyclics_Augmentation.Options NULL
	
	#put #var cs2_Cyclics_Debilitation.Spell NULL
	put #var cs2_Cyclics_Debilitation.Spell NULL
	put #var cs2_Cyclics_Debilitation.Options NULL
	
	put #var cs2_Cyclics_Targeted_Magic.Spell NULL
#	put #var cs2_Cyclics_Targeted_Magic.Spell NULL
	put #var cs2_Cyclics_Targeted_Magic.Options NULL

	put #var cs2_Cyclics_LastCyclic 0

	put #var cs2_Cyclics_DefaultCyclic RiteofGrace
	put #var cs2_Cyclics_DefaultCyclic.Options
}


if ("$charactername" = "Constantinne") then {
                                                                                                
                                                                                                
#         CCCCCCCCCCCCC                                                             tttt          
#      CCC::::::::::::C                                                          ttt:::t          
#    CC:::::::::::::::C                                                          t:::::t          
#   C:::::CCCCCCCC::::C                                                          t:::::t          
#  C:::::C       CCCCCC   ooooooooooo   nnnn  nnnnnnnn        ssssssssss   ttttttt:::::ttttttt    
# C:::::C               oo:::::::::::oo n:::nn::::::::nn    ss::::::::::s  t:::::::::::::::::t    
# C:::::C              o:::::::::::::::on::::::::::::::nn ss:::::::::::::s t:::::::::::::::::t    
# C:::::C              o:::::ooooo:::::onn:::::::::::::::ns::::::ssss:::::stttttt:::::::tttttt    
# C:::::C              o::::o     o::::o  n:::::nnnn:::::n s:::::s  ssssss       t:::::t          
# C:::::C              o::::o     o::::o  n::::n    n::::n   s::::::s            t:::::t          
# C:::::C              o::::o     o::::o  n::::n    n::::n      s::::::s         t:::::t          
#  C:::::C       CCCCCCo::::o     o::::o  n::::n    n::::nssssss   s:::::s       t:::::t    tttttt
#   C:::::CCCCCCCC::::Co:::::ooooo:::::o  n::::n    n::::ns:::::ssss::::::s      t::::::tttt:::::t
#    CC:::::::::::::::Co:::::::::::::::o  n::::n    n::::ns::::::::::::::s       tt::::::::::::::t
#      CCC::::::::::::C oo:::::::::::oo   n::::n    n::::n s:::::::::::ss          tt:::::::::::tt
#         CCCCCCCCCCCCC   ooooooooooo     nnnnnn    nnnnnn  sssssssssss              ttttttttttt  
	pause 1
	var Ritual_Focus_Item censer
	var Train_Arcana YES
	var Camb_Item water bag
	var Camb_Item_MaxCharge 100
	var TM_FOCI_ITEM NULL
	var BUFF_PREP 50

#	put #var cs2_snapcast_spell Paralysis

#	var Cyclic_0 ROTATE
#	var Cyclic_Options ROTATE
	 var Cyclic_0 BlessingoftheFae
	 # var Cyclic_Options NULL
	
	var Buff_0 RageoftheClans
	var Buff_1 DrumsoftheSnake
	var Buff_2 Harmony
	var Buff_3 NamingofTears
	var Buff_4 ManifestForce
	var Buff_5 Nexus
	var Buff_6 NULL
	# var Buff_7 NULL
	# var Buff_8 NULL 
	# var Buff_9 NULL
	# var Buff_10 NULL
	# var Buff_11 NULL
	# var Buff_12 NULL
	# var Buff_13 NULL
	# var Buff_14 NULL
	# var Buff_15 NULL
	# var Buff_16 NULL
	
	var Augmentation_Trainer EilliesCry
	var Warding_Trainer RedeemersPride
	var Utility_Trainer AuraofTongues
	
	# var Debilitation_Trainer NULL 
	var Debilitation_Trainer DesertsMaelstrom 
	var Debilitation_Trainer_2 NULL
	var Debilitation_Trainer_OtherCurse(vsWeapons) CurseOfZachriedek/ Malediction for offense/defense
	
	# var Targeted_Magic_Trainer NULL
	var Targeted_Magic_Trainer BreathofStorms
	var Targeted_Magic_Trainer_2 NULL
	
	# var Sorcery_Trainer_Buff NULL
	var Sorcery_Trainer_Buff NULL 
	var Sorcery_Trainer_TM NULL
	var Sorcery_Trainer_TM NULL
	var Sorcery_Trainer_Debil NULL
	var Sorcery_Trainer_Debil2 NULL

### .cyclic variables

	put #var cs2_Cyclics_Warding.Spell GlythtidesJoy
	put #var cs2_Cyclics_Warding.Options
	
	put #var cs2_Cyclics_Utility.Spell HodiernasLilt
	put #var cs2_Cyclics_Utility.Options
	
	put #var cs2_Cyclics_Augmentation.Spell BlessingoftheFae
	put #var cs2_Cyclics_Augmentation.Options
	
	#put #var cs2_Cyclics_Debilitation.Spell DamarisLullaby
	put #var cs2_Cyclics_Debilitation.Spell AetherWolves
	put #var cs2_Cyclics_Debilitation.Options creatures
	
	put #var cs2_Cyclics_Targeted_Magic.Spell PhoenixsPyre
#	put #var cs2_Cyclics_Targeted_Magic.Spell
	put #var cs2_Cyclics_Targeted_Magic.Options Creatures

	put #var cs2_Cyclics_LastCyclic 0
	put #var cs2_Cyclics_DefaultCyclic BlessingoftheFae
	put #var cs2_Cyclics_DefaultCyclic.Options area
}

if matchre("$charactername","Fangore") then {
# FFFFFFFFFFFFFFFFFFFFFF                                                     
# F::::::::::::::::::::F                                                     
# F::::::::::::::::::::F                                                     
# FF::::::FFFFFFFFF::::F                                                     
#   F:::::F       FFFFFFaaaaaaaaaaaaa  nnnn  nnnnnnnn       ggggggggg   ggggg
#   F:::::F             a::::::::::::a n:::nn::::::::nn    g:::::::::ggg::::g
#   F::::::FFFFFFFFFF   aaaaaaaaa:::::an::::::::::::::nn  g:::::::::::::::::g
#   F:::::::::::::::F            a::::ann:::::::::::::::ng::::::ggggg::::::gg
#   F:::::::::::::::F     aaaaaaa:::::a  n:::::nnnn:::::ng:::::g     g:::::g 
#   F::::::FFFFFFFFFF   aa::::::::::::a  n::::n    n::::ng:::::g     g:::::g 
#   F:::::F            a::::aaaa::::::a  n::::n    n::::ng:::::g     g:::::g 
#   F:::::F           a::::a    a:::::a  n::::n    n::::ng::::::g    g:::::g 
# FF:::::::FF         a::::a    a:::::a  n::::n    n::::ng:::::::ggggg:::::g 
# F::::::::FF         a:::::aaaa::::::a  n::::n    n::::n g::::::::::::::::g 
# F::::::::FF          a::::::::::aa:::a n::::n    n::::n  gg::::::::::::::g 
# FFFFFFFFFFF           aaaaaaaaaa  aaaa nnnnnn    nnnnnn    gggggggg::::::g 
#                                                                    g:::::g 
#                                                        gggggg      g:::::g 
#                                                        g:::::gg   gg:::::g 
#                                                         g::::::ggg:::::::g 
#                                                          gg:::::::::::::g  
#                                                            ggg::::::ggg    
#                                                               gggggg       

	var Ritual_Focus_Item spellbook
	var Train_Arcana YES
	var Camb_Item water bag
	var Camb_Item_MaxCharge 100
	var TM_FOCI_ITEM NULL
	var BUFF_PREP 50
	
#	put #var cs2_snapcast_spell FS

	 var Cyclic_0 ROTATE
	 var Cyclic_Options ROTATE
	# var Cyclic_0 ElectrostaticEddy
	# var Cyclic_0 FireRain
	# var Cyclic_Options creatures

	var Buff_0 YntrelSechra
	var Buff_1 Tailwind
	var Buff_2 SwirlingWinds
	var Buff_3 ManifestForce
	var Buff_4 SureFooting
	var Buff_5 NULL
	var Buff_6 MantleofFlame
	# var Buff_8 NULL
	# var Buff_9 EtherealFissure Fire
	# var Buff_10 ManifestForce
	
	# var Buff_15 NULL
	# var Buff_15 NULL

	var Augmentation_Trainer Substratum
	var Warding_Trainer EtherealShield
	var Utility_Trainer EtherealFissure Fire
	
	var Targeted_Magic_Trainer FireBall
	# var Targeted_Magic_Trainer NULL
	var Targeted_Magic_Trainer_2 NULL
	
	var Debilitation_Trainer IcePatch
	var Debilitation_Trainer_2 NULL
	# var Debilitation_Trainer_2 IcePatch
	
#	var Sorcery_Trainer_Buff Refresh 
	var Sorcery_Trainer_Buff NULL 
	var Sorcery_Trainer_TM NULL 
	var Sorcery_Trainer_Debil NULL
	var Sorcery_Trainer_Debil2 NULL
	
### .cyclic variables
	put #var cs2_Cyclics_Warding.Spell AetherCloak
	put #var cs2_Cyclics_Warding.Options
	
	put #var cs2_Cyclics_Utility.Spell NULL
	put #var cs2_Cyclics_Utility.Options
	
	put #var cs2_Cyclics_Augmentation.Spell NULL
	put #var cs2_Cyclics_Augmentation.Options
	
	put #var cs2_Cyclics_Debilitation.Spell ElectrostaticEddy
	put #var cs2_Cyclics_Debilitation.Options creatures
	
	put #var cs2_Cyclics_Targeted_Magic.Spell Rimefang
	# put #var cs2_Cyclics_Targeted_Magic.Spell FireRain
	put #var cs2_Cyclics_Targeted_Magic.Options creatures
	
	put #var cs2_Cyclics_Sorcery.Spell NULL
	put #var cs2_Cyclics_Sorcery.Options

	put #var cs2_Cyclics_LastCyclic 0	
	put #var cs2_Cyclics_DefaultCyclic ElectrostaticEddy
	put #var cs2_Cyclics_DefaultCyclic.Options creatures
}

if matchre("$charactername","Ashildr") then {
#                AAA                             hhhhhhh             
#               A:::A                            h:::::h             
#              A:::::A                           h:::::h             
#             A:::::::A                          h:::::h             
#            A:::::::::A             ssssssssss   h::::h hhhhh       
#           A:::::A:::::A          ss::::::::::s  h::::hh:::::hhh    
#          A:::::A A:::::A       ss:::::::::::::s h::::::::::::::hh  
#         A:::::A   A:::::A      s::::::ssss:::::sh:::::::hhh::::::h 
#        A:::::A     A:::::A      s:::::s  ssssss h::::::h   h::::::h
#       A:::::AAAAAAAAA:::::A       s::::::s      h:::::h     h:::::h
#      A:::::::::::::::::::::A         s::::::s   h:::::h     h:::::h
#     A:::::AAAAAAAAAAAAA:::::A  ssssss   s:::::s h:::::h     h:::::h
#    A:::::A             A:::::A s:::::ssss::::::sh:::::h     h:::::h
#   A:::::A               A:::::As::::::::::::::s h:::::h     h:::::h
#  A:::::A                 A:::::As:::::::::::ss  h:::::h     h:::::h
# AAAAAAA                   AAAAAAAsssssssssss    hhhhhhh     hhhhhhh
                                                                   	
	var LastObserveTime 0
	var Ritual_Focus_Item zenzic
	var Train_Arcana YES
	var Camb_Item water bag
	var Camb_Item_MaxCharge 100
	var planet_found NULL
	var TM_FOCI_ITEM NULL
	var BUFF_PREP 77

	put #var CS_TKS_ITEM kris
	put #var cs2_snapcast_spell FF

	# var Cyclic_0 NULL
	var Cyclic_0 ROTATE
	# var Cyclic_Options NULL

	var Cyclic_0 StarlightSphere
	var Cyclic_Options spider	

	var Buff_0 TenebrousSense
	var Buff_1 SeersSense
	var Buff_2 Shadowling
	var Buff_3 CageofLight
	var Buff_4 AuraSight
	var Buff_5 ManifestForce
	var Buff_6 HeroicStrength
	var Buff_7 NULL
	# var Buff_8 NULL
	# var Buff_9 NULL
	# var Buff_10 NULL
	
#	var Buff_15 RefractiveField
#	var Buff_15 InvocationoftheSpheres - MUST BE OUTSIDE

	var Augmentation_Trainer MachinistsTouch
		put #var cs2_spell.MachinistsTouch.check MANUAL
	var Warding_Trainer PsychicShield
		put #var cs2_spell.PsychicShield.check MANUAL
	var Utility_Trainer Thoughtcast
		put #var cs2_spell.Thoughtcast.check MANUAL
	var Debilitation_Trainer NULL
#		put #var cs2_spell.Swarm.check MANUAL
	var Targeted_Magic_Trainer NULL
#		put #var cs2_spell.TelekineticStorm.check MANUAL

#	var Augmentation_Trainer NULL
#	var Warding_Trainer NULL
#	var Utility_Trainer NULL
	var Debilitation_Trainer NULL	
	var Targeted_Magic_Trainer NULL
	
	var Targeted_Magic_Trainer_2 NULL
	var Debilitation_Trainer_2 MentalBlast
	
	var Sorcery_Trainer_Buff NULL 
	var Sorcery_Trainer_TM NULL 
#	var Sorcery_Trainer_Debil NULL
	var Sorcery_Trainer_Debil NULL
	var Sorcery_Trainer_Debil Swarm
#	var Sorcery_Trainer_Debil2 NULL
	
	### .cyclic variables

	put #var cs2_Cyclics_Warding.Spell NULL
	put #var cs2_Cyclics_Warding.Options NULL
	
	put #var cs2_Cyclics_Utility.Spell NULL
	put #var cs2_Cyclics_Utility.Options NULL
	
	put #var cs2_Cyclics_Augmentation.Spell NULL
	put #var cs2_Cyclics_Augmentation.Options NULL
	
	put #var cs2_Cyclics_Debilitation.Spell NULL
	put #var cs2_Cyclics_Debilitation.Options NULL
	
	put #var cs2_Cyclics_Targeted_Magic.Spell StarlightSphere
		#StarlightSphere
	put #var cs2_Cyclics_Targeted_Magic.Options spider	
	
	#put #var cs2_Cyclics_Targeted_Magic.Spell NULL
	#put #var cs2_Cyclics_Targeted_Magic.Options NULL
	
	put #var cs2_Cyclics_Sorcery.Spell Revelation
	put #var cs2_Cyclics_Sorcery.Options NULL
	
	put #var cs2_Cyclics_LastCyclic 0
	put #var cs2_Cyclics_DefaultCyclic NULL
		#StarlightSphere
	put #var cs2_Cyclics_DefaultCyclic.Options spider
}

if matchre("$charactername","Boobear") then {
# BBBBBBBBBBBBBBBBB                                     
# B::::::::::::::::B                                    
# B::::::BBBBBB:::::B                                   
# BB:::::B     B:::::B                                  
#   B::::B     B:::::B   ooooooooooo      ooooooooooo   
#   B::::B     B:::::B oo:::::::::::oo  oo:::::::::::oo 
#   B::::BBBBBB:::::B o:::::::::::::::oo:::::::::::::::o
#   B:::::::::::::BB  o:::::ooooo:::::oo:::::ooooo:::::o
#   B::::BBBBBB:::::B o::::o     o::::oo::::o     o::::o
#   B::::B     B:::::Bo::::o     o::::oo::::o     o::::o
#   B::::B     B:::::Bo::::o     o::::oo::::o     o::::o
#   B::::B     B:::::Bo::::o     o::::oo::::o     o::::o
# BB:::::BBBBBB::::::Bo:::::ooooo:::::oo:::::ooooo:::::o
# B:::::::::::::::::B o:::::::::::::::oo:::::::::::::::o
# B::::::::::::::::B   oo:::::::::::oo  oo:::::::::::oo 
# BBBBBBBBBBBBBBBBB      ooooooooooo      ooooooooooo   
                                         
############################ variables #######################
	var ABSOLUTION.CHECK 0

	var Ritual_Focus_Item statue
	var Train_Arcana YES
	var Camb_Item bag
	var Camb_Item_MaxCharge 100
	var TM_FOCI_ITEM NULL
	var BUFF_PREP 77
	
	put #var cs2_snapcast_spell LightningBolt

	# var Cyclic_0 IcutuZaharenela
	# var Cyclic_0 AesandryDarlaeth
	var Cyclic_0 GuardianSpirit
#	var Cyclic_0 Regenerate	
#   var Cyclic_0 ROTATE
#   var Cyclic_0 NULL
   
	var Cyclic_Options NULL

	var Buff_0 Heal
	var Buff_1 Refresh
	var Buff_2 AggressiveStance
	var Buff_3 Vigor
	var Buff_4 GiftofLife
	var Buff_5 ManifestForce
	var Buff_6 RageoftheClans
	var Buff_7 RighteousWrath
	var Buff_8 NULL
	var Buff_9 NULL
	var Buff_10 NULL
	 var Buff_11 TenebrousSense
	
	
	# var Buff_15 Shadows
	# var Buff_15 Tranquility
	# var Buff_15 CureDisease
	# var Buff_15 LayWard
	# var Buff_15 TenebrousSense
	# var Buff_15 FlushPoisons
	# var Buff_15 NULL

#	var Augmentation_Trainer NULL
#	var Warding_Trainer NULL
#	var Utility_Trainer NULL

	var Augmentation_Trainer MentalFocus
#		put #var cs2_spell.MentalFocus.check MANUAL
		put #var cs2_spell.MentalFocus.check 0
	var Warding_Trainer IronConstitution
#		put #var cs2_spell.IronConstitution.check MANUAL
		put #var cs2_spell.IronConstitution.check 0
	var Utility_Trainer GaugeFlow
#		put #var cs2_spell.GaugeFlow.check MANUAL
		put #var cs2_spell.GaugeFlow.check 0
	
	var Debilitation_Trainer Lethargy
#		put #var cs2_spell.Lethargy.check MANUAL

	var Debilitation_Trainer_2 NULL
	
#	var Targeted_Magic_Trainer StrangeArrow
	var Targeted_Magic_Trainer NULL
	var Targeted_Magic_Trainer_2 NULL
	
	var Sorcery_Trainer_Buff NULL
	var Sorcery_Trainer_TM NULL
	var Sorcery_Trainer_Debil NULL
	var Sorcery_Trainer_Debil2 NULL

	
### .cyclic variables
	put #var cs2_Cyclics_Warding.Spell NULL
	put #var cs2_Cyclics_Warding.Options NULL
	
	put #var cs2_Cyclics_Utility.Spell AesandryDarlaeth
	put #var cs2_Cyclics_Utility.Options NULL
	
	put #var cs2_Cyclics_Augmentation.Spell AesandryDarlaeth
	put #var cs2_Cyclics_Augmentation.Options NULL
	
	put #var cs2_Cyclics_Debilitation.Spell NULL
	put #var cs2_Cyclics_Debilitation.Options NULL
	
	put #var cs2_Cyclics_Targeted_Magic.Spell GuardianSpirit
	put #var cs2_Cyclics_Targeted_Magic.Options NULL
	
	# put #var cs2_Cyclics_Sorcery.Spell NULL
	# put #var cs2_Cyclics_Sorcery.Options NULL
	put #var cs2_Cyclics_Sorcery.Spell NULL
	put #var cs2_Cyclics_Sorcery.Options NULL

	put #var cs2_Cyclics_LastCyclic 0
	put #var cs2_Cyclics_DefaultCyclic Regenerate
	put #var cs2_Cyclics_DefaultCyclic.Options
}

if ("$charactername" = "Morgann") then {
# MMMMMMMM               MMMMMMMM                                                         
# M:::::::M             M:::::::M                                                         
# M::::::::M           M::::::::M                                                         
# M:::::::::M         M:::::::::M                                                         
# M::::::::::M       M::::::::::M   ooooooooooo   rrrrr   rrrrrrrrr      ggggggggg   ggggg
# M:::::::::::M     M:::::::::::M oo:::::::::::oo r::::rrr:::::::::r    g:::::::::ggg::::g
# M:::::::M::::M   M::::M:::::::Mo:::::::::::::::or:::::::::::::::::r  g:::::::::::::::::g
# M::::::M M::::M M::::M M::::::Mo:::::ooooo:::::orr::::::rrrrr::::::rg::::::ggggg::::::gg
# M::::::M  M::::M::::M  M::::::Mo::::o     o::::o r:::::r     r:::::rg:::::g     g:::::g 
# M::::::M   M:::::::M   M::::::Mo::::o     o::::o r:::::r     rrrrrrrg:::::g     g:::::g 
# M::::::M    M:::::M    M::::::Mo::::o     o::::o r:::::r            g:::::g     g:::::g 
# M::::::M     MMMMM     M::::::Mo::::o     o::::o r:::::r            g::::::g    g:::::g 
# M::::::M               M::::::Mo:::::ooooo:::::o r:::::r            g:::::::ggggg:::::g 
# M::::::M               M::::::Mo:::::::::::::::o r:::::r             g::::::::::::::::g 
# M::::::M               M::::::M oo:::::::::::oo  r:::::r              gg::::::::::::::g 
# MMMMMMMM               MMMMMMMM   ooooooooooo    rrrrrrr                gggggggg::::::g 
#                                                                                 g:::::g 
#                                                                     gggggg      g:::::g 
#                                                                     g:::::gg   gg:::::g 
#                                                                      g::::::ggg:::::::g 
#                                                                       gg:::::::::::::g  
#                                                                         ggg::::::ggg    
#                                                                            gggggg       																		   
	pause 1
	put #var cs2_snapcast_spell DO
	
	var Ritual_Focus_Item censer
	var Train_Arcana YES
	var Camb_Item bag
	var Camb_Item_MaxCharge 100
	var TM_FOCI_ITEM NULL
	
	var Orb_Buffs PersistenceofMana|MurrulasFlames|ProtectionfromEvil|MajorPhysicalProtection|Benediction|DivineRadiance|MinorPhysicalProtection|SoulShield|Bless
	# var Orb_Buffs NONE
	var Orb_SpellPrep 77
	var BUFF_PREP 77

	# var Cyclic_0 ROTATE
	# var Cyclic_Options ROTATE
	 var Cyclic_0 HydraHex
	 var Cyclic_Options MALE off
	
	var Buff_0 PersistenceofMana
	var Buff_1 MurrulasFlames
	var Buff_2 SoulShield
	var Buff_3 MajorPhysicalProtection
	var Buff_4 Benediction
	var Buff_5 ProtectionfromEvil
	var Buff_6 Bless
	var Buff_7 DivineRadiance
	var Buff_8 MinorPhysicalProtection
	var Buff_9 NULL
	var Buff_10 NULL
	var Buff_11 NULL
	var Buff_12 ShieldofLight
	var Buff_13 AspirantsAegis
	# var Buff_14 NULL
	# var Buff_15 NULL
	# var Buff_16 NULL
	
	var Augmentation_Trainer Centering
	var Warding_Trainer SanyuLyba
	var Utility_Trainer MassRejuvenation
	
	var Debilitation_Trainer NULL 
	# var Debilitation_Trainer PhelimsSanction 
	var Debilitation_Trainer_2 NULL
#	var Debilitation_Trainer_OtherCurse(vsWeapons) CurseOfZachriedek/ Malediction for offense/defense
	
	# var Targeted_Magic_Trainer NULL
	var Targeted_Magic_Trainer FireOfUshnish
	var Targeted_Magic_Trainer_2 NULL
	
	var Sorcery_Trainer_Buff MembrachsGreed
	var Sorcery_Trainer_Buff NULL
	# var Sorcery_Trainer_Buff Tailwind
	# var Sorcery_Trainer_TM NULL
	var Sorcery_Trainer_TM NULL
	var Sorcery_Trainer_Debil NULL
	var Sorcery_Trainer_Debil2 NULL

### .cyclic variables

	put #var cs2_Cyclics_Warding.Spell GhostShroud
	put #var cs2_Cyclics_Warding.Options Morgann
	
	put #var cs2_Cyclics_Utility.Spell NULL
	put #var cs2_Cyclics_Utility.Options NULL
	
	put #var cs2_Cyclics_Augmentation.Spell Revelation
		#Revelation
	put #var cs2_Cyclics_Augmentation.Options Morgann
	
	put #var cs2_Cyclics_Debilitation.Spell HydraHex
		#Hydra Hex
	put #var cs2_Cyclics_Debilitation.Options MALE off
	
	put #var cs2_Cyclics_Targeted_Magic.Spell NULL
	put #var cs2_Cyclics_Targeted_Magic.Options NULL

	put #var cs2_Cyclics_LastCyclic 0
	put #var cs2_Cyclics_DefaultCyclic HydraHex
		#Hydra Hex
	put #var cs2_Cyclics_DefaultCyclic.Options male off
}



put #var save
goto PRE_ROTATION_ONEOFFS

#######################################################################  END of Character Variables - Edit Nothing Else



#######################################################################  Pre-Spell Rotation One-Offs
#@ *****
PRE_ROTATION_ONEOFFS:
put #var spells_last_sub PRE_ROTATION_ONEOFFS
	if (matchre("($guild|$Guild)","Moon")) then goto ONEOFFS_MOON 
	if (matchre("($guild|$Guild)","Warrior")) then goto ONEOFFS_WARMAGE
	if (matchre("($guild|$Guild)","Empath")) then goto ONEOFFS_EMPATH
	goto ONEOFFS_SKIP

#@ *****
ONEOFFS_MOON:
put #var spells_last_sub ONEOFFS_MOON
	# if (matchre("$charactername","Ashildr")) then gosub CAST_SPELL TelekineticStorm
	# if (matchre("$charactername","Ashildr")) then gosub CAST_SPELL TelekineticStorm
	# goto ONEOFFS_MOON

		matchre ONEOFFS_SKIP ^You are 
	send look $charactername
	matchwait 2
	goto ONEOFFS_MOON

#@ *****
ONEOFFS_WARMAGE:
put #var spells_last_sub ONEOFFS_WARMAGE
	put #var cs_WM_PATHWAY OFF
	goto ONEOFFS_SKIP

#@ *****
ONEOFFS_EMPATH:
put #var spells_last_sub ONEOFFS_EMPATH
	action send touch $1; send -1 link $1 persist; send -1 link $1 hodierna when ^(\S+) whispers, ".*hodierna/i
	action send touch $1; send -1 link $1 persist; send -1 link $1 unity when ^(\S+) whispers, ".*unity/i
	action send touch $1; send -1 take $1 all when ^(\S+) whispers, ".*heal/i
	
	action send hodi Ashildr when ^Executioner Ashildr just arrived
	#ACTION send hodi Kromdor when ^Destroyer Kromdor just arrived
	action send hodi Morgann when ^Soul Magus Morgann just arrived
	#ACTION send hodi Const when ^Constantinne just arrived
	#ACTION send hodi Fang when ^Fangore just arrived

	# ACTION send touch Morgann; wait 1; send take Morgann all; wait 1; when ^Soul Magus Morgann just arrived
	# ACTION send touch Constantinne; wait 1; send take Constantinne all; wait 1; when ^Constantinne just arrived
	# ACTION send touch Fangore; wait 1; send take Fangore all; wait 1; when ^Fangore just arrived
	# ACTION send hodi $1 when (\w+) just (arrived|skipped in)(\.|,)|^(\w+)'s group came|As your eyes slowly recover, you notice a dazed-looking (\w+), who wasn't there before\.$
	goto ONEOFFS_SKIP


#@ *****
ONEOFFS_SKIP: 
# if matchre("$charactername","Ashildr") then {
# 	gosub CAST_SPELL %Utility_Trainer Trainer
# #	gosub CAST_SPELL %Augmentation_Trainer Trainer
# #	gosub CAST_SPELL %Warding_Trainer Trainer
# 	goto ONEOFFS_SKIP
# }

	put #var spells_last_sub ONEOFFS_SKIP
	goto SPELL_LOOP

#######################################################################  End of Pre-Spell Rotation One-Offs

#######################################################################  SPELL LOOP
#@ *****
SPELL_LOOP:
put #var spells_last_sub SPELL_LOOP
	GoSub CLEAR
	if matchre("$guild|$Guild","Warrior")) then gosub WARMAGE_PATHWAY
	if (("%Train_Arcana" = "YES") && ($Arcana.LearningRate < 5)) then gosub TRAIN_ARCANA
	if (($Attunement.Ranks < 50) && ($Attunement.LearningRate < 30) && ($gametime > $cs_Last_Perc.Timer)) then gosub TRAIN_ATTUNEMENT_LOW_LVL

	if (matchre("%Cyclic_0","ROTATE")) then gosub CYCLICCHECK
#	debug 0
	else if (("%Cyclic_0" != "NULL") && (!$SpellTimer.%Cyclic_0.active)) then gosub CAST_SPELL %Cyclic_0

	gosub BUFF_LOOP
	if ("%current_spell_stance" != "POTENCY") then put spell stance 130 100 70
	if (($Augmentation.LearningRate < %spell_learn_check) && ("%Augmentation_Trainer" != "NULL") && ($Augmentation.Ranks < 1750)) then gosub CAST_SPELL %Augmentation_Trainer 
	if (($Warding.LearningRate < %spell_learn_check) && ("%Warding_Trainer" != "NULL") && ($Warding.Ranks < 1750)) then gosub CAST_SPELL %Warding_Trainer
	if (($Utility.LearningRate < %spell_learn_check) && ("%Utility_Trainer" != "NULL") && ($Utility.Ranks < 1750)) then gosub CAST_SPELL %Utility_Trainer
	
	if (!matchre("($cs_TargetMonster)","own")) then {
		if ((matchre("$guild|$Guild","Empath")) && (%ABSOLUTION.CHECK = 1) || ($cs_absolution = 1) && ($SpellTimer.Absolution.duration < 5)) then gosub CAST_SPELL Absolution
		gosub MONSTER_CHECK
		if ("%current_spell_stance" != "INTEGRITY") then put spell stance 100 70 130
		if (($Debilitation.LearningRate < %spell_learn_check) && ("%Debilitation_Trainer" != "NULL") && ($Debilitation.Ranks < 1750)) then gosub CAST_SPELL %Debilitation_Trainer Trainer
		if (($Debilitation.LearningRate < %spell_learn_check) && ("%Debilitation_Trainer_2" != "NULL") && ($Debilitation.Ranks < 1750)) then gosub CAST_SPELL %Debilitation_Trainer_2 Trainer
		
		if (($Targeted_Magic.LearningRate < %spell_learn_check) && ("%Targeted_Magic_Trainer" != "NULL") && ($Targeted_Magic.Ranks < 1750)) then gosub CAST_SPELL %Targeted_Magic_Trainer $cs_TargetMonster
		if (($Targeted_Magic.LearningRate < %spell_learn_check) && ("%Targeted_Magic_Trainer_2" != "NULL") && ($Targeted_Magic.Ranks < 1750)) then gosub CAST_SPELL %Targeted_Magic_Trainer_2 $cs_TargetMonster
	
		if (("%Sorcery_Trainer_Buff" != "NULL") && (($Sorcery.LearningRate < %spell_learn_check)) && ($Sorcery.Ranks < 1750)) then gosub CAST_SPELL %Sorcery_Trainer_Buff
		if (("%Sorcery_Trainer_TM" != "NULL") && ((($Sorcery.LearningRate < %spell_learn_check) && ($Sorcery.Ranks < 1750)) || (($Targeted_Magic.LearningRate < %spell_learn_check) && ($Targeted_Magic.Ranks < 1750)))) then gosub CAST_SPELL %Sorcery_Trainer_TM $cs_TargetMonster
		if (("%Sorcery_Trainer_Debil" != "NULL") && ((($Sorcery.LearningRate < %spell_learn_check) && ($Sorcery.Ranks < 1750)) || (($Debilitation.LearningRate < %spell_learn_check) && ($Debilitation.Ranks < 1750)))) then gosub CAST_SPELL %Sorcery_Trainer_Debil creatures
	}

	## Slow Increase of Learning Rate so that all types get working.... 
	if (!matchre("($cs_TargetMonster)","own")) then {
		if ((!matchre("%Targeted_Magic_Trainer","NULL")) && ($Targeted_Magic.LearningRate >= %spell_learn_check)) then {
			if ((!matchre("%Debilitation_Trainer","NULL")) && ($Debilitation.LearningRate >= %spell_learn_check)) then {
				if ((!matchre("%Sorcery_Trainer_Buff","NULL")) && ($Sorcery.LearningRate >= %spell_learn_check)) then {
					if (($Warding.LearningRate > %spell_learn_check) && ($Utility.LearningRate >= %spell_learn_check) && ($Augmentation.LearningRate > %spell_learn_check)) then var FLAG YES
				}
			}
		}
	}
	# Increases learnign rate based off of Warding/Utility/Augmentation (Only) also. As TM/Debil are a pita.
	if (($Warding.LearningRate >= %spell_learn_check) && ($Utility.LearningRate >= %spell_learn_check) && ($Augmentation.LearningRate >= %spell_learn_check)) then var FLAG YES
	
	if ("%FLAG" = "YES") then {
		var FLAG NO
		if (%spell_learn_check > 30) then wait 120
		if (%spell_learn_check < 30) then {
			math spell_learn_check add 2
		}
	}
	wait 1
	goto SPELL_LOOP
#######################################################################  END OF SPELL LOOP

## *************
BUFF_LOOP:
put #var spells_last_sub BUFF_LOOP
	var tmp_counter 0
	var tmp_item NULL
	## ***
	BUFF_LOOP_SUB:
	put #var spells_last_sub BUFF_LOOP_SUB
	if ("%Buff_%tmp_counter" = "NULL") then return
	#loops through all the buffs until the next #'d buff is NULL
		if (matchre("($guild|$Guild)","Cleric")) then {
			gosub OSRELMERAUD_CHECK
			if (matchre("%Buff_%tmp_counter","%Orb_Buffs")) then {
				if (!$SpellTimer.%Buff_%tmp_counter.active) then gosub CAST_SPELL %Buff_%tmp_counter ORB
				math tmp_counter add 1
				goto BUFF_LOOP_SUB
			}			
		}		
		if (matchre("($guild|$Guild)","Necromancer")) then {
			if (("%Buff_%tmp_counter" = "QuickentheEarth") && (!$SpellTimer.%Buff_%tmp_counter.active)) then {
				gosub NECRO_QuickentheEarth
				put #script resume all
				math tmp_counter add 1
				goto BUFF_LOOP_SUB
			}
		}
		if (matchre("($guild|$Guild)","Warrior")) then {
			if (("%Buff_%tmp_counter" = "EtherealFissure") && (!matchre ("$roomobjs", "fissure"))) then {
				gosub CAST_SPELL EtherealFissure Fire
				math tmp_counter add 1
				goto BUFF_LOOP_SUB
			}
		}
		if (matchre("($guild|$Guild)","Empath")) then {
			if (("%Buff_%tmp_counter" = "Heal") && ($SpellTimer.Heal.duration < 5)) then {
				gosub CAST_SPELL Heal BUFF
				math tmp_counter add 1
				goto BUFF_LOOP_SUB
			}
			if (("%Buff_%tmp_counter" = "FlushPoisons") && ($SpellTimer.FlushPoisons.duration < 5)) then {
				gosub CAST_SPELL FlushPoisons BUFF
				math tmp_counter add 1
				goto BUFF_LOOP_SUB
			}
		}
		if (!$SpellTimer.%Buff_%tmp_counter.active) then {
			if (%Buff_%tmp_counter = "AvrenAevareae") then {
				if matchre ("$roomobjs", "hazy") then {
					math tmp_counter add 1
					goto BUFF_LOOP_SUB
				}
				else if ($Time.isKatambaUp) then {
					gosub CAST_SPELL AvrenAevareae BUFF
					math tmp_counter add 1
					goto BUFF_LOOP_SUB
				}
			} 
			if (%Buff_%tmp_counter = "GiftofLife") then {
				if (((%ABSOLUTION.CHECK = 0) || ($cs_absolution = 0)) && ($SpellTimer.GiftofLife.active = 0)) then gosub CAST_SPELL GiftofLife BUFF
				math tmp_counter add 1
				goto BUFF_LOOP_SUB
			}
			if (%Buff_%tmp_counter = "CageofLight") then {
				if ($SpellTimer.CageofLight.active = 1) then {
					math tmp_counter add 1
					goto BUFF_LOOP_SUB				
				}
				if $Time.isKatambaUp then gosub CAST_SPELL CageofLight Katamba
				else if $Time.isXibarUp then gosub CAST_SPELL CageofLight Xibar
				else if $Time.isYavashUp then gosub CAST_SPELL CageofLight Yavash
				math tmp_counter add 1
				goto BUFF_LOOP_SUB
			}
			if (%Buff_%tmp_counter = "Shadowling") then {
				if ($SpellTimer.Shadowling.active = 0) then {
					gosub CAST_SPELL Shadowling BUFF
					send invoke Shadowling
				}
				math tmp_counter add 1
				goto BUFF_LOOP_SUB
			}
			gosub CAST_SPELL %Buff_%tmp_counter BUFF
		}
		math tmp_counter add 1
		goto BUFF_LOOP_SUB


#include cs_SPELLS_INCLUDE2b.cmd

include cs_SPELLS_INCLUDE3.cmd
include cs_Spells_harness_camb.cmd
