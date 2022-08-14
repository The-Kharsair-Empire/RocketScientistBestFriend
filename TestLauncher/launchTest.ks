

@lazyglobal off.

runOncePath("0:/Library/launch.library.ks").
runOncePath("0:/Library/shipsys.library.ks").

main().

function main {
    
    //getting defired target_heading factored in the target_inclination and latitude of the launch site.

    prepare_launch(3).
    launch_countdown(5, 1).


    arm_auto_LV_staging(2).

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

    // arm_event_trigger({return ship:altitude > 30000.}, 
    //     {
    //         toggle ag8.
    //     }, true, "Launch Escape System Jettisoned"
    // ).


    // arm_event_trigger({return ship:altitude > 70000.}, 
    //     {
    //         toggle ag1.
    //     }, true, "Solar Panel Deployed, Antenna Deployed"
    // ).

    arm_event_trigger({return ship:altitude > 70000.}, 
        {
            toggle ag1.
        }, true, "Deployed"
    ).

    // arm_event_trigger({return ship:altitude > 65000.}, 
    //     {
    //         toggle ag9.
    //     }, true, "Fairing Deployed"
    // ).


    // arm_event_trigger({return ship:altitude > 70000.}, 
    //     {
    //         toggle ag1.
    //     }, true, "Fairing Deployed"
    // ).
    
    low_altitude_ascent().
    mid_altitude_ascent().
    high_altitude_ascent().
    orbital_insertion().

    // default_ascent_profile(200000, 0).



    // low_altitude_ascent(12000, 0).
    // mid_altitude_ascent(47000, 0).
    // high_altitude_ascent(200000, 0).
    // // if shuttle, activate ag9.
    // orbital_insertion().

    // low_altitude_ascent(15000).
    // mid_altitude_ascent(45000).
    // high_altitude_ascent(400000).
    // orbital_insertion(400000).
    // wait 10.
    // notify_msg("Beginning Descent Procedural").
    // wait 2.
    // warpTo(time:seconds + 2/5 * ship:obt:period).
    // de_orbit(20000, {
    //     do_safe_stage().
    //     do_safe_stage().
    //     notify_msg("De-Orbit Completed").
    // }).

    
    

    // armAutoLVStagingTool(1).

    // armEventTrigger({return alt:radar > 10000.}, 
    //     {
    //         lock throttle to 0.
    //         toggle abort.
    //         lock throttle to 1.
    //     }, true, "Test Complete, Crew abort"
    // ).


    // armAutoLVStagingTool(3).
    //

    // armEventTrigger({return (eta:apoapsis < 3 and ship:altitude > 10000).}, 
    //     {
    //         lock throttle to 0.
    //         wait 0.5.
    //         toggle abort.
    //         wait 0.5.
    //         lock throttle to 1.
    //     }, true, "Test Complete, Crew abort"
    // ).
    // armEventTrigger({return (ship:altitude > 1).}, 
    //     {
    //         lock throttle to 0.
    //         wait 0.2.
    //         toggle abort.
    //         wait 0.2.
    //         lock throttle to 1.
    //         wait 4.
    //         lock throttle to 0.
    //         doQuickStage().  doQuickStage().
    //         toggle gear.
    //     }, true, "Abort Test"
    // ).

    // wait until false.


    // onAscent(2863334).
    
}



