@lazyGlobal off.


function get_ship_deltaV {
    // dV = Ve * Ln(M/Mf)
}


function get_ship_current_stage_deltaV {

}

function get_burn_time_for_dv {
    parameter delta_v.
    
}

function get_vis_viva_dv1 {
    parameter start_altitude, target_altitude.

    local mu is ship:obt:body:mu.
    local r1 is start_altitude + ship:orbit:body:radius.
    local r2 is target_altitude + ship:orbit:body:radius.
    local dV1 is sqrt(mu / r1) * (sqrt((2 * r2) / (r1 + r2)) - 1).

    return dV1.
}

function get_vis_viva_dv2 {
    parameter start_altitude, final_altutude.

    local mu is ship:obt:body:mu.
    local r1 is start_altitude + ship:orbit:body:radius.
    local r2 is final_altutude + ship:orbit:body:radius.
    local dV2 is sqrt(mu / r2) * (1 - sqrt((2 * r1) / (r1 + r2))).

    return dV2.
}


function get_hohmann_transfer_dv {
    parameter target_altitude.
    parameter start_altitude is (ship:orbit:semimajoraxis - ship:body:radius).
    parameter separated is false.

    if separated {
        return list(get_vis_viva_dv1(start_altitude, target_altitude), get_vis_viva_dv2(start_altitude, target_altitude)).
    } else {
        return get_vis_viva_dv1(start_altitude, target_altitude) + get_vis_viva_dv2(start_altitude, target_altitude).
    }
    
    
}

function mnv_burn_time {
    parameter total_dV.
}

// function test {
//     rcs off.
//     until false {
//         wait until rcs.
//         if (hasNode) {
//             local targetalt is nextNode:orbit:apoapsis.
//             print "target alt is: " + targetalt.
//             print "dV for transfer 1 (near circular):  " + get_vis_viva_dv1(ship:orbit:semimajoraxis - ship:body:radius, targetalt).
//             print "dV for transfer 1 (circular):  " + get_vis_viva_dv1(ship:orbit:semimajoraxis - ship:body:radius, targetalt).
//             print " ".
//         } else {
//             print "no node detected".
//             print " ".
//         }
        
//         rcs off.
//     }
// }

// test().