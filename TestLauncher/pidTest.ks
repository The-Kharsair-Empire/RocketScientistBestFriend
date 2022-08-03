
SET Kp TO 0.048.
SET Ki TO 0.01.
SET Kd TO 0.083.
SET PID TO PIDLOOP(Kp, Ki, Kd, 0, 1).
SET PID:SETPOINT TO 50.
stage.
lights on.

lock steering to heading(90, 90).

SET thrott TO 1.
LOCK throttle TO thrott.
print "start testing".

until false {
    SET thrott TO PID:UPDATE(TIME:SECONDS, alt:radar).
    wait 0.05.
    print throttle.
}
