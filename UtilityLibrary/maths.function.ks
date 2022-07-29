@lazyglobal off.

function lng_to_degree {
    parameter lng.
    //lng is between -180 to 180
    return mod(lng + 360, 360).
}


function get_orbitable {
    parameter name.

    local vessels to list().
    list targets in vessels.

    for v in vessels {
        if v:name = name {
            return vessel(name).
        }
    } 
    return body(name).


}

function target_angle {
    parameter target_orbitable.

    return mod(
        lng_to_degree(get_orbitable(target_orbitable):longitude)
        - lng_to_degree(ship:longitude) + 360,
        360
    ).
}