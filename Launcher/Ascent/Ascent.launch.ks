@lazyglobal off.

runOncePath("0:/UtilityLibrary/utility.function.ks").


main().

function main {
    
    //getting defired target_heading factored in the target_inclination and latitude of the launch site.

    prepare_launch().
    launch_countdown(10, 3).
    onAscent(-1, 100000).
    
}

function onAscent {

    parameter target_heading, target_altitude.

    local roll_angle to 0. // target is 45
    local liftOffSteering to steering. 
    lock steering to liftOffSteering - R(0, 0, roll_angle).

    notify_msg("Roll Program Started").

    until ship:verticalspeed > 50 {

        set roll_angle to ship:verticalSpeed * 90 / 50.

        print "Roll Angle: " + roll_angle at(terminal:width/5, terminal:height/2 + 2).

        if abort {
            AbortLaunch().
        }
        wait 0.1.
    }
    local ascentSteering to steering.
    notify_msg("Roll Program Finalized").
    clearScreen.

    lock targetPitch to (- 1.03287 * alt:radar^0.409511).// 180 - (88.963 - 1.03287 * alt:radar^0.409511). 
    //After roll (heading due east means going north in pitch), the pitch angle now mean yaw from 0 to -90.
    lock steering to ascentSteering + R(0, targetPitch, 0).

    until ship:orbit:apoapsis > target_altitude {
        if stage:resourcesLex["LiquidFuel"]:amount = 0 {
            doSafeStage().
        }
        if abort {
            AbortLaunch().
        }
        wait 0.1.
    }

    

}

function launch_countdown {
    parameter count_down_from, when_to_pre_ignite.
    clearScreen.
    until count_down_from = when_to_pre_ignite {
        playsound(0, 200, 0.2).
        notify_msg(count_down_from).
        wait 0.98.
        set count_down_from to count_down_from - 1.
    }

    print "Ignition!" at(terminal:width/5, terminal:height/2).
    doSafeStage().
    lock steering to ship:up - R(0, 0, 180).//R(90, 90, 180).//heading(90, 90).
    local warm_up_level to 0.
    local warm_up_rate to 1/when_to_pre_ignite.
    lock throttle to warm_up_level.


    until count_down_from = 0 {
        playsound(0, 400, 0.5).
        notify_msg(count_down_from).
        wait 0.98.
        set count_down_from to count_down_from - 1.
        set warm_up_level to  warm_up_level + warm_up_rate.
    }

    playsound(0, 800, 0.8).
    notify_msg("Lift Off!").
    print "Lift Off!" at(terminal:width/5, terminal:height/2 + 1).
    doSafeStage().
    
}

function prepare_launch {
    abort off.
    clearScreen.
    print "Clearing Launch Facility" at(terminal:width/5, terminal:height/2).
    toggle ag10.
    wait 15.
}


function AbortLaunch {
    lock throttle to 0.

    notify_msg("Abort Initiated!").
    notify_msg("Engine CutOff!").

    notify_msg("Fairing Jettisoned").
    notify_msg("Crewed Module Decoupled!").
    notify_msg("Abort Moter Fired!").


    wait 2.
    doSafeStage().
    notify_msg("Launch Escape System Jettisoned!").
    wait until alt:radar < 3000.
    doSafeStage().
    notify_msg("Drogue Chute Deployed!").
    notify_msg("Main Chute Deployed!").

    wait until alt:radar < 1.
    notify_msg("Crew Landed!").
}