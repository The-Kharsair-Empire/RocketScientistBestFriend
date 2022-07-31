@lazyGlobal off.

local autoThrottle to 0.
lock steering to  heading(90, 90).
lock throttle to autoThrottle.
rcs on.



local target_height to 100.
local groud_height to 26.


// local lastP to 0.
// local lastTime to 0.
// local totalP to 0.

function PID_loop { //proportional integral derivative controller
    parameter target_value, current_value.
    parameter console_debug. //bool, adjust PID parameters if you need them printed out on screen
    parameter Kp is 0.01, Ki is 0.0003, Kd is 0.015. // default parameter for test only

    local output to 0.


    local proportional to target_value - current_value.
    local integral to 0.
    local derivative to 0.


    if not(defined __TKS_lastProportionalForPIDController) {
        global __TKS_lastProportionalForPIDController to 0.
    }

    if not(defined __TKS_lastTimeValueForPIDController) {
        global __TKS_lastTimeValueForPIDController to 0.
    }

    if not(defined __TKS_accumulatedProportionalForPIDController) {
        global __TKS_accumulatedProportionalForPIDController to 0.
    }


    local now to time:seconds.

    if __TKS_lastTimeValueForPIDController > 0 {
        set integral to __TKS_accumulatedProportionalForPIDController + ((proportional + __TKS_lastProportionalForPIDController) / 2 * (now - __TKS_lastTimeValueForPIDController)).
        set derivative to (proportional  - __TKS_lastProportionalForPIDController) / (now - __TKS_lastTimeValueForPIDController).
    }

    


    set output to proportional * Kp + integral * Ki + derivative * Kd.

    set __TKS_lastProportionalForPIDController to proportional.
    set __TKS_lastTimeValueForPIDController to now.
    set __TKS_accumulatedProportionalForPIDController to integral.

    if console_debug {

        clearScreen.

        print "P: " + proportional at(terminal:width/2, terminal:height/2).
        print "I: " + integral at(terminal:width/2, terminal:height/2 + 1).
        print "D: " + derivative at(terminal:width/2, terminal:height/2 + 2).

        print "Output: " + output at(terminal:width/2, terminal:height/2 + 3).
    }
    

    return output.
}


stage.

local startFuelAmount to stage:resourcesLex["LIQUIDFUEL"]:amount.

until stage:resourcesLex["LIQUIDFUEL"]:amount < startFuelAmount * 3/4 {
    set autoThrottle to max(0, min(PID_loop(target_height, alt:radar), 1)).
    wait 0.01.
}

until alt:radar - groud_height < 2 {
    set target_height to target_height - 1.
    set autoThrottle to max(0, min(PID_loop(target_height, alt:radar), 1)).
    wait 1.
}