

@lazyglobal off.

runOncePath("0:/Library/launch.library.ks").
runOncePath("0:/Library/shipsys.library.ks").

main().

function main {


    prepare_launch(3).
    launch_countdown(5, 1).


    arm_auto_LV_staging(2).


 

    // arm_event_trigger({return ship:altitude > 70000.}, 
    //     {
    //         toggle ag1.
    //     }, true, "Deployed Stuffs"
    // ).

    // arm_event_trigger({return ship:altitude > 69800.}, 
    //     {
    //         toggle ag2.
    //     }, true, "Fairing Deployed"
    // ).




    
    // low_altitude_ascent().
    // mid_altitude_ascent().
    // high_altitude_ascent(240000).
    // orbital_insertion(240000).
    low_altitude_ascent(14000, 0).
    mid_altitude_ascent(52000, 0).
    high_altitude_ascent(200000, 0).
    orbital_insertion(200000, 0).

 
    
}



