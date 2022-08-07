
SET Kp TO 0.048.
SET Ki TO 0.01.
SET Kd TO 0.083.
SET PID TO PIDLOOP(Kp, Ki, Kd, 0, 1).
SET PID:SETPOINT TO 50.
set heighOffset to alt:radar.
stage.
lights on.

local startFuelAmount to stage:resourcesLex["LIQUIDFUEL"]:amount.

lock steering to heading(90, 90).

SET thrott TO 1.
LOCK throttle TO thrott.
print "start testing".

until stage:resourcesLex["LIQUIDFUEL"]:amount < startFuelAmount * 1/4 {
    SET thrott TO PID:UPDATE(TIME:SECONDS, alt:radar).
    wait 0.05.
    print "PID Controller Output" + throttle at(terminal:width/2, terminal:height/2).
}

 print "Start landing" at(terminal:width/2, terminal:height/2 - 1).
until alt:radar - heighOffset < 0.3 {
    set PID:setpoint to PID:SETPOINT - 0.05 * 1.5.
    SET thrott TO PID:UPDATE(TIME:SECONDS, alt:radar).
    wait 0.05.
    print "PID Controller Output" + throttle at(terminal:width/2, terminal:height/2).
    
}
clearScreen.
print "Landed" at(terminal:width/2, terminal:height/2 - 1).
lock throttle to 0.

