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


    // arm_auto_LV_staging(2).

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


    // arm_event_trigger({return ship:altitude > 70000.}, 
    //     {
    //         toggle ag1.
    //     }, true, "Extend Solar Array and Antenna"
    // ).


    low_altitude_ascent().
    mid_altitude_ascent().
    high_altitude_ascent().
    orbital_insertion().
    

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



