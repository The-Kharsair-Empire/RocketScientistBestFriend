//Craft ID :
//global craft_uid to "d53ea54c2814c1d078abcdf770c5ea7f".


@lazyglobal off.

runOncePath("0:/UtilityLibrary/launch.function.ks").

main().

function main {
    
    //getting defired target_heading factored in the target_inclination and latitude of the launch site.

    prepare_launch(3).
    launch_countdown(5, 1).

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

    wait until false.


    // onAscent(2863334).
    
}



