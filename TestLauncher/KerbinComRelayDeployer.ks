//Craft ID :
//global craft_uid to "d53ea54c2814c1d078abcdf770c5ea7f".


@lazyglobal off.

runOncePath("0:/UtilityLibrary/utility.function.ks").


main().

function main {
    
    //getting defired target_heading factored in the target_inclination and latitude of the launch site.

    prepare_launch(5).
    launch_countdown(10, 2).
    // onAscent(2863334).
    
}

function onAscent {

    parameter target_altitude.


    until ship:verticalspeed > 50 

    clearScreen.

    lock targetPitch to  88.963 - 1.03287 * alt:radar^0.409511.
    local targetDirection to 90.
    lock steering to heading(targetDirection, targetPitch).

    local prevThrust to ship:availablethrust.
    until ship:orbit:apoapsis > target_altitude - 10000 {
        if ship:availableThrust < (prevThrust - 10) {
            
            lock throttle to 0.
            doSafeStage().
            lock throttle to 1.
            set prevThrust to ship:availablethrust.
        }

        if ship:altitude > 70000 and stage:resourcesLex["LiquidFuel"]:amount = 0 { //jettison fairing
            doSafeStage().
            toggle ag1.
        }

        wait 0.1.
    }

    lock steering to heading(targetDirection, 0).

    local variable_thrust to 0.

    lock throttle to  variable_thrust.

    until ship:orbit:apoapsis > target_altitude - 10 {
        if (orbit:eta:apoapsis > 45 and variable_thrust > 0) {
            set variable_thrust to variable_thrust - 0.1.
        } else if (orbit:eta:apoapsis < 45 and variable_thrust < 1) {
            set variable_thrust to variable_thrust + 0.1.
        }
    }

}


function executeAscentStep {
    parameter direction, minAlt, newAngle, newThrust.
    local prevThrust to ship:availablethrust.

    until false {
        if ship:availableThrust < (prevThrust - 10) {
            local currentThrottle to throttle.
            lock throttle to 0.
            doSafeStage().
            lock throttle to currentThrottle.
            set prevThrust to ship:availablethrust.
        }

        if ship:altitude > 70000 and stage:resourcesLex["LiquidFuel"]:amount = 0 { //jettison fairing
            doSafeStage().
        }


        if ship:altitude > minAlt {
            lock steering to heading(direction, newAngle).
            lock throttle to  newThrust.
            break.
        }

        wait 0.1.
    }
}

// function launch_countdown {
//     parameter count_down_from, when_to_pre_ignite.
//     clearScreen.
//     until count_down_from = when_to_pre_ignite {
//         playsound(0, 200, 0.2).
//         notify_msg(count_down_from).
//         wait 0.98.
//         set count_down_from to count_down_from - 1.
//     }

//     print "Ignition!" at(terminal:width/5, terminal:height/2).
//     doSafeStage().
//     lock steering to heading(90, 90).
    
//     lock throttle to 1.


//     until count_down_from = 0 {
//         playsound(0, 400, 0.5).
//         notify_msg(count_down_from).
//         wait 0.98.
//         set count_down_from to count_down_from - 1.
//     }

//     playsound(0, 800, 0.8).
//     notify_msg("Lift Off!").
//     print "Lift Off!" at(terminal:width/5, terminal:height/2 + 1).
//     doSafeStage().
    
// }

