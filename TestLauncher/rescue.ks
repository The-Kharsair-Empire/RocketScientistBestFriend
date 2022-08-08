//Craft ID :
//global craft_uid to "d53ea54c2814c1d078abcdf770c5ea7f".


@lazyglobal off.

runOncePath("0:/Library/launch.library.ks").
runOncePath("0:/Library/shipsys.library.ks").

main().

function main {
    
    //getting defired target_heading factored in the target_inclination and latitude of the launch site.

    prepare_launch(3).
    launch_countdown(5, 1).


    arm_auto_LV_staging(3).

    // arm_event_trigger({return ship:STAGEDELTAV(ship:STAGENUM):current < 1000.}, 
    //     {
    //         do_safe_stage().
    //     }, true, "Booster Separation"
    // ).

    // arm_event_trigger({return ship:altitude > 65000.}, 
    //     {
    //         toggle ag9.
    //     }, true, "Fairing Jettisoned"
    // ).


    arm_event_trigger({return ship:altitude > 70000.}, 
        {
            toggle ag1.
        }, true, "Orbital System Deployed"
    ).


    low_altitude_ascent().
    mid_altitude_ascent().
    high_altitude_ascent().
    orbital_insertion().
    // wait 10.
    // notify_msg("Beginning Descent Procedural").
    // wait 2.
    // warpTo(time:seconds + 2/5 * ship:obt:period).
    // de_orbit(20000, {
    //     do_safe_stage().
    //     do_safe_stage().
    //     notify_msg("De-Orbit Completed").
    // }).

    

    
}



