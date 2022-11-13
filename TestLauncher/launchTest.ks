

@lazyglobal off.

runOncePath("0:/Library/launch.library.ks").
runOncePath("0:/Library/shipsys.library.ks").

parameter azimuth_heading is 90.
parameter target_altitude is 100000.

    // prepare_launch(3).
launch_countdown(5, 1, false).


// arm_auto_LV_staging(3).




// arm_event_trigger({return ship:altitude > 140000.}, 
//     {
//         toggle ag1.
//     }, true, "Deployed Stuffs"
// ).


// arm_event_trigger({return ship:altitude > 110000.}, 
//     {
//         toggle ag9.
//     }, true, "Jettison"
// ).

// low_altitude_ascent().
// mid_altitude_ascent().
// high_altitude_ascent().
// toggle ag2. //start fuel cell
// set warp to 0.
// orbital_insertion().

launch().

 

function launch {
    low_altitude_ascent(azimuth_heading).
    mid_altitude_ascent(azimuth_heading).
    high_altitude_ascent(azimuth_heading, target_altitude).
    orbital_insertion(azimuth_heading, target_altitude).
}


