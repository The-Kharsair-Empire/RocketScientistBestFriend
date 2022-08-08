@lazyGlobal off.



function change_orbital_period { 
    //common rendevous technique by phasing angle. 
    // However, still undergoing development.
    //TODO: consider different scenario: e.g. coming from interplanetary capture (e > 1), period will be negative
    parameter target_period.

    local currentPeriod to ship:orbit:period.


    if target_period > currentPeriod {
        lock steering to ship:prograde.
        wait until vAng(ship:direction:forevector, prograde:forevector) < 3.
        wait 0.5. lock throttle to 0.5.
        wait until ship:orbit:period >= target_period.
    } else {
        lock steering to ship:retrograde.
        wait until vAng(ship:direction:forevector, -prograde:forevector) < 3.
        wait 0.5. lock throttle to 0.5.
        wait until ship:orbit:period <= target_period.
    }

    lock throttle to 0.
    
}


function rendezvous_with_target_vessel {
    parameter target_vessel.

    if ship:body <> target_vessel:body {

    }
    
}




function await_cloest_approach { //waiting to be found out whether doing this is safe. ....
    parameter target_vessel.

    local lastDistance to 0.
    until false {
        set lastDistance to target_vessel:distance.
        wait 1.
        if target_vessel:distance > lastDistance {
            break.
        }
    }
}


function cancel_relative_velocity {
    parameter target_vessel.

    lock steering to target_vessel:velocity:orbit - ship:velocity:orbit. //retrograde vector in target navball mode.

    wait until vAng(ship:direction:forevector, target_vessel:velocity:orbit - ship:velocity:orbit) < 3.
    wait 0.5.

    lock throttle to 0.5.

    local lastVelDiff to 0.

    until false {
        set lastVelDiff to (target_vessel:velocity:orbit - ship:velocity:orbit):mag.
        wait 1.
        if (target_vessel:velocity:orbit - ship:velocity:orbit):mag > lastVelDiff {
            break.
        }
    }


}

function approach_target_vessel {
    parameter target_vessel.

    lock steering to target_vessel:position.

    wait until vAng(ship:direction:forevector, target_vessel:position) < 3.
    wait 0.5.

    lock throttle to 0.1. wait 0.5. lock throttle to 0.

    // wait until (target_vessel:velocity:orbit - ship:velocity:orbit):mag > 5.

    // wait until : TODO: until relative velovity vector revert and magitude > 5.
}


function on_approach_target {
    parameter target_vessel.

    until target_vessel:distance < 1000 {
        await_cloest_approach(target_vessel).
        cancel_relative_velocity(target_vessel).
        approach_target_vessel(target_vessel).
    }

    cancel_relative_velocity(target_vessel).
    
}