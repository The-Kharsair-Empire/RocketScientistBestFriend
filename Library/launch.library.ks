@lazyglobal off.

runOncePath("0:/Library/shipsys.library.ks").
runOncePath("0:/Library/maneuver.library.ks").
runOncePath("0:/Library/maths.library.ks").

//TODO: allow these funciton to take in optional roll angle of launch vehicle (for shuttle, etc)
// function default_ascent_profile {
//     parameter target_altitude, target_heading.

//     low_altitude_ascent(10000, target_heading).
//     mid_altitude_ascent(40000, target_heading).
//     high_altitude_ascent(target_altitude, target_heading).
//     orbital_insertion(target_altitude, target_heading).
// }


function low_altitude_ascent { 
    // default heading 90 (equatorial orbit)
    
    parameter target_heading is 90.
    parameter end_altitude is 10000.
    parameter start_pitch is 90, end_pitch is 45, start_twr is 1.33, end_twr is 2.2.
    

    notify_msg("Maintaining Low Altitude Ascent Profile").

    lock throttle to 1.
    lock steering to heading(target_heading, 90).

    wait until ship:verticalSpeed > 50.
    notify_msg("Initiate Gravity Turn").

    local start_altitude is ship:altitude.

    lock target_pitch to start_pitch - ((start_pitch - end_pitch) * (ship:altitude - start_altitude) / (end_altitude - start_altitude)).
    lock target_twr to ((end_twr - start_twr) * (ship:altitude - start_altitude) / (end_altitude - start_altitude)) + start_twr.

    lock max_ship_twr to (ship:availablethrust / ship:mass) / (body:mu / (body:radius + ship:altitude) ^ 2).

    lock throttle to target_twr/max(1, max_ship_twr).
    lock steering to heading(target_heading, target_pitch).

    until ship:altitude > end_altitude {
        print "Target Pitch: " + target_pitch at(terminal:width/5, terminal:height/2).
        print "Optimized TWR: " + target_twr at(terminal:width/5, terminal:height/2 + 1).
        print "Adjusted Throttle: " + throttle at(terminal:width/5, terminal:height/2 + 2).
        wait 0.1.
    }
}

function mid_altitude_ascent { 
    // default heading 90 (equatorial orbit)
    //start twr can be (ship:availablethrust / ship:mass) / (body:mu / (body:radius + ship:altitude) ^ 2)
    
    parameter target_heading is 90.
    parameter end_altitude is 45000.
    parameter start_pitch is 45, end_pitch is 10, start_twr is 2.2, end_twr is 2.6.

    
    

    notify_msg("Maintaining Mid Altitude Ascent Profile").

    lock throttle to 1.
    lock steering to heading(target_heading, start_pitch).

    local start_altitude is ship:altitude.

    lock target_pitch to start_pitch - ((start_pitch - end_pitch) * (ship:altitude - start_altitude) / (end_altitude - start_altitude)).
    lock target_twr to ((end_twr - start_twr) * (ship:altitude - start_altitude) / (end_altitude - start_altitude)) + start_twr.

    lock max_ship_twr to (ship:availablethrust / ship:mass) / (body:mu / (body:radius + ship:altitude) ^ 2).

    lock throttle to target_twr/max(1, max_ship_twr).
    lock steering to heading(target_heading, target_pitch).

    until ship:altitude > end_altitude {
        print "Target Pitch: " + target_pitch at(terminal:width/5, terminal:height/2).
        print "Optimized TWR: " + target_twr at(terminal:width/5, terminal:height/2 + 1).
        print "Adjusted Throttle: " + throttle at(terminal:width/5, terminal:height/2 + 2).
        wait 0.1.
    }
}

function high_altitude_ascent { //TODO:
    
    parameter target_heading is 90.
    parameter target_altitude is 100000.
    parameter max_pitch is 10.
    // parameter start_pitch is 45, end_pitch is 5.
    clearScreen.

    notify_msg("Maintaining High Altitude Ascent Profile").

    local apoapsis_throttle_down_threshold to target_altitude/20 * 19.

    lock throttle_param_periapsis to max(0, min(1, ship:periapsis)).
    lock throttle_param_apoapsis to max(0, min(1, (ship:apoapsis -  apoapsis_throttle_down_threshold)/ (target_altitude - apoapsis_throttle_down_threshold))).

    lock target_throttle to (1 - max(throttle_param_periapsis, throttle_param_apoapsis) * (ship:apoapsis/target_altitude * 0.99)).
    
    lock throttle to target_throttle.
    lock target_pitch to max(0, min(max_pitch, (1 - (eta:apoapsis - 30) / (60 - 30)) * (max_pitch - 0))).
    lock steering to heading(target_heading, target_pitch).

 
    until ship:apoapsis >= target_altitude {

        print "Target Pitch: " + target_pitch at(terminal:width/5, terminal:height/2).
        print "throttle down ratio: " +  max(0, min(1, ship:periapsis)) * ship:apoapsis/target_altitude * 0.99 at(terminal:width/5, terminal:height/2 + 5).
        print "adjusted throttle: " + target_throttle at(terminal:width/5, terminal:height/2 + 6).
        print "actual throttle: " + throttle at(terminal:width/5, terminal:height/2 + 8).


        wait 1.
    }

    lock throttle to 0.

   
    lock steering to ship:prograde.
    notify_msg("Wait for reaching Karmen line and adjust ship Apoapsis").

    wait until ship:altitude > 70000.

    notify_msg("Adjusting Apoapsis").
    lock throttle to  1 - (ship:apoapsis/target_altitude * 0.99).

    wait until ship:apoapsis >= target_altitude.
    
    lock throttle to 0.
    unlock steering.

    notify_msg("Target Altitude Reached, Waiting For Orbital Insertion Burn").
}

function orbital_insertion { 
    
    // parameter target_heading is 90.
    parameter autoWrap is true.
    parameter target_altitude is 100000.
    clearScreen.

    
    local insertion_dv is get_vis_viva_dv2(ship:periapsis, ship:apoapsis).
    print "Insertion Delta V: " + insertion_dv at(terminal:width/5, terminal:height/2).
    local burn_time is get_mnv_burn_time(insertion_dv, true).
    print "Insertion Burn Time: First half -> " + burn_time[0] + " ; Second half ->" + burn_time[1] at(terminal:width/5, terminal:height/2 + 1).
    local total_burn_time is burn_time[0] + burn_time[1].

    // lock steering to heading(target_heading, 0).
    lock steering to ship:prograde.

    if autoWrap {
        warpTo(time:seconds + eta:apoapsis - burn_time[0] - 30).
    }
    

    wait until burn_time[0] >= eta:apoapsis.
    local autoThrottle to 1.
    lock throttle to autoThrottle.
    wait total_burn_time - 1.5.
    until close_enough(ship:apoapsis, ship:periapsis, 200) or (not close_enough(ship:apoapsis, target_altitude, 500)) {
        set autoThrottle to 1 - (ship:periapsis / ship:apoapsis * 0.97).
        wait 0.1.
    }

    notify_msg("Orbital Insertion Completed").
    lock throttle to 0.
    unlock steering.
    
}


function prepare_launch {
    parameter preparingTime.
    clearScreen.
    print "Clearing Launch Facility" at(terminal:width/5, terminal:height/2).
    toggle ag10.
    wait preparingTime.
}


function launch_countdown {
    parameter count_down_from, when_to_pre_ignite.
    parameter pre_ignition is true.
    clearScreen.
    until count_down_from = when_to_pre_ignite {
        play_sound(0, 200, 0.2).
        notify_msg(count_down_from).
        wait 0.98.
        set count_down_from to count_down_from - 1.
    }

    if pre_ignition {
        print "Ignition!" at(terminal:width/5, terminal:height/2).
        do_safe_stage().
    }


    lock steering to heading(90, 90).
    
    lock throttle to 1.


    until count_down_from = 0 {
        play_sound(0, 400, 0.5).
        notify_msg(count_down_from).
        wait 0.98.
        set count_down_from to count_down_from - 1.
    }

    play_sound(0, 800, 0.8).
    notify_msg("Lift Off!").
    if not pre_ignition {
        print "Ignition!" at(terminal:width/5, terminal:height/2).
    }
    print "Lift Off!" at(terminal:width/5, terminal:height/2 + 1).
    do_safe_stage().
    
}