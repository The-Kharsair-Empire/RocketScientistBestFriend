@lazyGlobal off.


function get_ship_deltaV { // warning. not tested
    // dV = Ve * Ln(M/Mf)
    return ship:DELTAV:current.
}


function get_ship_current_stage_deltaV { // warning. not tested
    return ship:STAGEDELTAV(ship:STAGENUM):current.
}

function get_mnv_burn_time {
    parameter deltaV.
    parameter split_half is false.


    local isp is 0. // devide by zero error if no engine is active
    local allEngines to list().
    list engines in allEngines.

    for en in allEngines {
        if en:ignition and not en:flameout {
            set isp to isp + (en:isp * (en:availableThrust / ship:availablethrust)).
        }
    }

    local Ve is isp * constant():g0.

    // dV = isp * g0 * ln(m0 / mf) => mf = m0/e^(dV/(isp * g0))
    // mf = m0 - (fuelFlow * t) => t = (m0 - mf) / fuelFlow
    // F = isp * g0 * fuelFlow => fuelFlow = F / (isp * g0)

    if split_half {
        local half_dv to deltaV / 2.
        local m0 is ship:mass.
        local m1 is m0 / constant():e ^ (half_dv / Ve).
        local fuelFlow is ship:availablethrust / Ve.
        local t1 is (m0 - m1) / fuelFlow.

        local m2 is m1 / constant():e ^ (half_dv / Ve).
        local t2 is (m1 - m2) / fuelFlow.

        return list(t1, t2).

    } else {
        local m0 is ship:mass.
        local mf is m0 / constant():e ^ (deltaV / Ve).
        local fuelFlow is ship:availablethrust / Ve.
        local t is (m0 - mf) / fuelFlow.

        return t.
    }
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

function raise_apoapsis {

}

function lower_apoapsis {

}

function raise_periapsis {

}

function lower_periapsis {

}

function circularization {
    
}

function achieve_circular_orbit_with_period {
    parameter period. // in seconds

}



// function test {
//     rcs off.
//     until false {
//         wait until rcs.
//         if (hasNode) {
//             local targetalt is nextNode:orbit:apoapsis.
//             local dv1 is get_vis_viva_dv1(ship:orbit:semimajoraxis - ship:body:radius, targetalt).
//             local dv2 is get_vis_viva_dv2(ship:orbit:semimajoraxis - ship:body:radius, targetalt).
//             print "target alt is: " + targetalt.
//             print "dV for transfer 1 :  " + dv1.
//             print "dV for transfer 2 :  " + dv2.
//             print "dV for Hohmann transfer:  " + get_hohmann_transfer_dv(targetalt).

//             local burn_time1 to  get_mnv_burn_time(dv1, false).
//             local burn_time1_split to  get_mnv_burn_time(dv1, true).
//             print "burn time for transfer 1 (whole): " + burn_time1.
//             print "burn time for transfer 1 (split): t1 = " + burn_time1_split[0] + " t2 = " + burn_time1_split[1].


//             local burn_time2 to  get_mnv_burn_time(dv2, false).
//             local burn_time2_split to  get_mnv_burn_time(dv2, true).
//             print "burn time for transfer 2 (whole): " + burn_time2.
//             print "burn time for transfer 2 (split): t1 = " + burn_time2_split[0] + " t2 = " + burn_time2_split[1].
//             print " ".
//             print " ".
//             print " ".
//         } else {
//             print "no node detected".
//             print " ".
//         }
        
//         rcs off.
//     }
// }

// test().