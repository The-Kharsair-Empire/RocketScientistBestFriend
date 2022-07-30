@lazyGlobal off.

local autoThrottle to 0.
lock steering to  heading(90, 90).
lock throttle to autoThrottle.
rcs on.

local Kp to 0.01.
local Ki to 0.0003.
local Kd to 0.015.

local target_height to 100.
local groud_height to 26.
//proportional integral derivative

local lastP to 0.
local lastTime to 0.
local totalP to 0.

function PID_loop {
    parameter target_value, current_value.

    local output to 0.


    local proportional to target_value - current_value.
    local integral to 0.
    local derivative to 0.


    local now to time:seconds.

    if lastTime > 0 {
        set integral to totalP + ((proportional + lastP) / 2 * (now - lastTime)).
        set derivative to (proportional  - lastP) / (now - lastTime).
    }

    


    set output to proportional * Kp + integral * Ki + derivative * Kd.

    set lastP to proportional.
    set lastTime to now.
    set totalP to integral.

    clearScreen.

    print "P: " + proportional at(terminal:width/2, terminal:height/2).
    print "I: " + integral at(terminal:width/2, terminal:height/2 + 1)..
    print "D: " + derivative at(terminal:width/2, terminal:height/2 + 2)..

    print "Output: " + output at(terminal:width/2, terminal:height/2 + 3)..

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