@lazyglobal off.

function notify_msg {
    parameter msg.
    hudtext(msg, 3, 2, 20, green, false).
}

function notify_error {
    parameter msg.
    hudtext(msg, 3, 2, 20, red, false).
}


function __do_safe_stage {
    wait until stage:ready.
    stage.
}

function do_quick_stage {
    __do_safe_stage().
}

function do_safe_stage {
    local currentThrottle to throttle.
    __do_safe_stage(). wait 0.4.
    lock throttle to 0.
    lock throttle to currentThrottle.
}

function play_sound {
    parameter waveform, frequency, length. 
    local V0 TO GETVOICE(waveform). 
    V0:PLAY( NOTE(frequency, length) ).                        
}





function is_current_LV_stage_burnt_out {
    //use this function when you want to focus on events only during current stage.
    //e.g. wait until is_current_LV_stage_burnt_out(). or until is_current_LV_stage_burnt_out(true) {statements } for fine control of behaviour during each stage.
    // It is designed for launcher vehicle, cautious use for deep space vessel, as it assume thrust will drop by 10kN when burnout, deep space vessels might not even have that thrust!
    //don't put your fairing stage here.

    parameter doStage. // bool, want this function to do staging for ya?
    parameter fuelType is "LIQUIDFUEL". //can be switch to Liquid Hydrogen, Liquid Methane, SolidFuel, argon, NSW or whatever if u have mods.

    if not(defined __TKE_currentStageBurnoutChecker) {
        global __TKE_currentStageBurnoutChecker to "reset".
    }

    if __TKE_currentStageBurnoutChecker = "reset" {
        set __TKE_currentStageBurnoutChecker to ship:availablethrust.
        return false.
    }

    if __TKE_currentStageBurnoutChecker - ship:availableThrust > 10 and stage:resourcesLex[fuelType]:amount < 10 {
        if doStage {
            do_safe_stage().
        }

        // set __TKE_currentStageBurnoutChecker to "reset".
        unset __TKE_currentStageBurnoutChecker.
        return true.
    }

    return false.

}

function has_functioning_engine {
    local allEngines to list().
    list engines in allEngines.

    for engine in allEngines {
        if engine:ignition {
            return true.
        }
    }

    return false.
}

function arm_auto_LV_staging {
    //warning, not intended for realism overhaul players, staging sequence will defintely fail for that. Advanced players using RO should write their own staging sequence (replace doSafeStage()) depending on staging method of choice (i.e. hot staging or ullage motor)
    // will assume the first NumberOfStages stage be pure "booster staging", don't put your fairing stage here.
    parameter NumberOfStages.

    if not(defined __TKE_burnoutStageCounter) {
        global __TKE_burnoutStageCounter to 0.
    }

    if not(defined __TKE_currentStageThrust) {
        global __TKE_currentStageThrust to ship:availablethrust.
    }


    when __TKE_currentStageThrust - ship:availableThrust > 10 then {
        do_safe_stage().
        set __TKE_burnoutStageCounter to __TKE_burnoutStageCounter + 1. 

        if (has_functioning_engine()) {
            set __TKE_currentStageThrust to ship:availablethrust.
        }
        
        if __TKE_burnoutStageCounter < NumberOfStages {
            return true.
        } else {
            unset __TKE_burnoutStageCounter.
            unset __TKE_currentStageThrust.
            return false.
        }
    }

}


function arm_event_trigger {
    parameter condition.  //high-order function, event trigger condition.
    parameter event_function. // high-order function, what you want to do.
    parameter toNotifyEvent. // bool, want a notification message when event fired?
    parameter Msg is "". //optional notification msg


    when condition() then {
        event_function().

        if toNotifyEvent {
            notify_msg(Msg).
        }
    }

}











