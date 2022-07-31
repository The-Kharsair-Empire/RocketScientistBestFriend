@lazyGlobal off.



function change_orbital_period { 
    //common rendevous technique by phasing angle. 
    // However, still undergoing development.
    //TODO: consider different scenario: e.g. coming from interplanetary capture (e > 1)
    
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

    lock throttle to 0.1.

    // wait until : TODO: until relative velovity vector revert and magitude > 5.
}