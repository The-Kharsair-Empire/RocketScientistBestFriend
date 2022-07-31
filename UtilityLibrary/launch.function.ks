@lazyglobal off.

runOncePath("utility.function.ks").

function low_altitude_ascent { //TODO:
    // until ship:altitude > 10000


}

function high_altitude_ascent { //TODO:

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
    clearScreen.
    until count_down_from = when_to_pre_ignite {
        play_sound(0, 200, 0.2).
        notify_msg(count_down_from).
        wait 0.98.
        set count_down_from to count_down_from - 1.
    }

    print "Ignition!" at(terminal:width/5, terminal:height/2).
    do_safe_stage().
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
    print "Lift Off!" at(terminal:width/5, terminal:height/2 + 1).
    do_safe_stage().
    
}