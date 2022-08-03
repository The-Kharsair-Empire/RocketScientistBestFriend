@lazyglobal off.



function lng_to_degree {
    parameter lng.
    //lng is between -180 to 180
    return mod(lng + 360, 360).
}

function close_enough {
    parameter a, b, margin.
    return a - margin < b and a + margin > b.
}


function delta_time {
    if not(defined __TKE_lastTimeStampForDeltaTimeCalcualtion) {
        global __TKE_lastTimeStampForDeltaTimeCalcualtion to time:seconds.
    }

    local dTime to time:seconds - __TKE_lastTimeStampForDeltaTimeCalcualtion.
    set __TKE_lastTimeStampForDeltaTimeCalcualtion to time:seconds.

    return dTime.
}
