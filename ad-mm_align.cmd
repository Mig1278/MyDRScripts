debug 11

action (mm_status_check) put #var PoolStatus.magic $1 when ^You have (.*) of the celestial influences over magic
action (mm_status_check) put #var PoolStatus.lore $1 when ^You have (.*) of the celestial influences over lore
action (mm_status_check) put #var PoolStatus.offensive $1 when ^You have (.*) of the celestial influences over offensive combat
action (mm_status_check) put #var PoolStatus.defensive $1 when ^You have (.*) of the celestial influences over defensive combat
action (mm_status_check) put #var PoolStatus.survival $1 when ^You have (.*) of the celestial influences over survival
action (mm_status_check) on

##@ *****
MM_PREDICT_STATUS_CHECK_CHECK:
        matchre MM_PREDICT_STATUS_CHECK_CAPTURED future events
    send predict state all
    matchwait 3
    goto MM_PREDICT_STATUS_CHECK_CHECK

##@ *****	
MM_PREDICT_STATUS_CHECK_CAPTURED:
	var predict_smallest_pool feeble|weak|fledgling|modest|decent|significant|potent|insightful|powerful
	eval predict_smallestpool_length count("%predict_smallest_pool","|")
	var lowpool_counter 0

	var predict_largest_pool powerful|insightful|potent|significant
	eval predict_largestpool_length count("%predict_largest_pool","|")
	var largepool_counter 0

	var predict_pool_type magic|lore|offensive|defensive|survival
	eval predict_pool_type_length count("%predict_pool_type","|")

	var predict_pool2_type survival|defensive|offensive|lore|magic
	eval predict_pool2_type_length count("%predict_pool2_type","|")

    var pooltype_counter 0

##@ *****
FIND_SMALLEST_POOL_LOOP:
    if (matchre("$PoolStatus.%predict_pool_type(%pooltype_counter)","%predict_smallest_pool(%lowpool_counter)")) then {
        var pool_smallest %predict_pool_type(%pooltype_counter)
        var pooltype_counter 0
        goto FIND_LARGEST_POOL_LOOP
    }
    else {
        math pooltype_counter add 1
        if (%pooltype_counter > %predict_pool_type_length) then {
            var pooltype_counter 0
            math lowpool_counter add 1
            if (%lowpool_counter > %predict_smallestpool_length) then goto MM_PREDICT_DONE
        }
        goto FIND_SMALLEST_POOL_LOOP
    }
    echo FIND_SMALLEST_POOL_LOOP Didn't work correctly.
    exit

##@ *****
FIND_LARGEST_POOL_LOOP:
    if (matchre("$PoolStatus.%predict_pool2_type(%pooltype_counter)","%predict_largest_pool(%largepool_counter)")) then {
        var pool_largest %predict_pool2_type(%pooltype_counter)

            # Had to create tmp pools for large/small as the conversion to surv/defen/etc breaks the comparison to exit out of the loop
        var pool_large_tmp %pool_largest
        var pool_small_tmp %pool_smallest
        goto BOTH_POOLS_FOUND
    }
    else {
        math pooltype_counter add 1
        if (%pooltype_counter > %predict_pool2_type_length) then {
            var pooltype_counter 0
            math largepool_counter add 1
            if (%largepool_counter > %predict_smallestpool_length) then goto MM_PREDICT_DONE
        }
        goto FIND_LARGEST_POOL_LOOP
    }
    echo FIND_LARGEST_POOL_LOOP Didn't work correctly.
    exit

##@ *****	
BOTH_POOLS_FOUND:
    echo ************** Smallest Pool is %pool_smallest @ $PoolStatus.%pool_smallest **************
    echo ************** Largest Pool is %pool_largest @ $PoolStatus.%pool_largest **************

    if (matchre("%pool_smallest","offen")) then var pool_smallest offen
    if (matchre("%pool_smallest","defen")) then var pool_smallest defen
    if (matchre("%pool_smallest","surv")) then var pool_smallest surv

    if (matchre("%pool_largest","offen")) then var pool_largest offen
    if (matchre("%pool_largest","defen")) then var pool_largest defen
    if (matchre("%pool_largest","surv")) then var pool_largest surv

    if (matchre("%pool_largest","%pool_smallest")) then {
        echo ************** ERROR **************
        exit
    }
    if (matchre("$PoolStatus.%pool_small_tmp|$PoolStatus.%pool_large_tmp"."no|complete")) then {
        unvar pool_large_tmp
        unvar pool_small_tmp
        goto MM_PREDICT_DONE
    }
    goto ALIGN_POOLS


##@ *****	
ALIGN_POOLS:
    pause 2
        matchre MM_PREDICT_STATUS_CHECK_CHECK Unfortunately this process has left your magic reserves exhausted.
        matchre MM_PREDICT_STATUS_CHECK_CHECK Having finished this process you are pleased to discover some of your defense reserves remain.
    send align transmogrify %pool_smallest to %pool_largest
    matchwait 3
    goto MM_PREDICT_STATUS_CHECK_CHECK

# ALIGN_SMALL_NOT_EMPTY:
    ## DOESN"T WORK

#     math pooltype_counter add 1
#     if (%pooltype_counter > %predict_pool_type_length) then {
#         var pooltype_counter 0
#         math largepool_counter add 1
#         if (%largepool_counter > %predict_smallestpool_length) then goto MM_PREDICT_DONE
#     }
#     goto FIND_LARGEST_POOL_LOOP



##@ *****	
MM_PREDICT_DONE:
    echo ************** Lore: $PoolStatus.lore
    echo ************** Magic: $PoolStatus.magic
    echo ************** Offensive: $PoolStatus.offensive
    echo ************** Defensive: $PoolStatus.defensive
    echo ************** Survival: $PoolStatus.survival

    put #var last_rtr_time $gametime
    put #parse RTR DONE
