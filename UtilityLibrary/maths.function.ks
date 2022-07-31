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
