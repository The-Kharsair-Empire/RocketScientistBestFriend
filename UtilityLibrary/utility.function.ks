@lazyglobal off.

function notify_msg {
    parameter msg.
    hudtext(msg, 3, 2, 20, green, false).
}

function notify_error {
    parameter msg.
    hudtext(msg, 3, 2, 20, red, false).
}


function doSafeStage {
    wait until stage:ready.
    stage.
}

function playsound {
    parameter waveform, frequency, length. 
    local V0 TO GETVOICE(waveform). 
    V0:PLAY( NOTE(frequency, length) ).                        
}

function delta_time {
    if not(defined lastTimeStampForDeltaTimeCalcualtion) {
        global lastTimeStampForDeltaTimeCalcualtion to time:seconds.
    }

    local dTime to time:seconds - lastTimeStampForDeltaTimeCalcualtion.
    set lastTimeStampForDeltaTimeCalcualtion to time:seconds.

    return dTime.
}


function closeEnough {
    parameter a, b, margin.
    return a - margin < b and a + margin > b.
}


function isCurrentStageBurntOutOnLauncher {
    //use this function when you want to focus on events only during current stage.
    //e.g. wait until isBurntOut().
    // launcher vehicle only, don't use for deep space vessel
    parameter doStage.

    if not(defined currentStageBurnOutChecker) {
        global currentStageBurnOutChecker to "reset".
    }

    if currentStageBurnOutChecker = "reset" {
        set currentStageBurnOutChecker to ship:availablethrust.
        return false.
    }

    if currentStageBurnOutChecker - ship:availableThrust > 10 and stage:resourcesLex["LIQUIDFUEL"]:amount < 10 {
        if doStage {
            local currentThrottle to throttle.
            lock throttle to 0.
            doSafeStage(). wait 0.8.
            LOCK throttle TO currentThrottle.

        }

        set currentStageBurnOutChecker to "reset".
        return true.
    }

    return false.

}

function doAutoStage {

}
