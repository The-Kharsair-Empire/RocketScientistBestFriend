@lazyGlobal off.



runOncePath("0:/Library/landing.library.ks").
runOncePath("0:/Library/maneuver.library.ks").

local heighOffset to alt:radar.
stage.
lights on.
lock steering to heading(90, 90).
lock throttle to  1.

wait until ship:altitude > 6000.
lock throttle to 0.

wait until ship:verticalspeed < 0.


print "start landing procedural".

until time_to_impact_vertically(heighOffset) <= get_mnv_burn_time(-ship:verticalspeed) {
    wait 0.4.
    print "estimated TTI:" + time_to_impact_vertically(heighOffset).
}

print "start suicide burn".

lock throttle to 1.

wait until ship:verticalspeed > -5.

print "pid take over".

local Kp TO 0.048.
local Ki TO 0.01.
local Kd TO 0.083.
local pid TO PIDLOOP(Kp, Ki, Kd, 0, 1).

local thrott to 1.

lock throttle to thrott.
set pid:setpoint to min(alt:radar, 40).

until alt:radar - heighOffset < 0.3 {
    set pid:setpoint to pid:setpoint - 0.05 * 3.
    SET thrott TO PID:UPDATE(TIME:SECONDS, alt:radar).
    wait 0.05.
    print "PID Controller Output" + throttle at(terminal:width/2, terminal:height/2).
    
}

clearScreen.
print "Landed" at(terminal:width/2, terminal:height/2 - 1).
lock throttle to 0.