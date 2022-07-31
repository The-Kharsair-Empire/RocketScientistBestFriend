@lazyGlobal off.

runOncePath("maths.function.ks").

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


function target_phase_angle { // assume same inclination and same parent body. adjust ship inclination beforehand, it doesn't spend you extra delta-V in theory cuz orbital rendevous is matching orbit
    parameter target_orbitable.

    if ship:body <> target_orbitable:body { // TODO:test purpose delete after
        return "This function assume same parent body".
    }

    local obtnormal is vCrs(-ship:body:position:normalized, ship:velocity:orbit:normalized):normalized.
    local body2targetVec is vXcl(obtnormal, target_orbitable:position - target_orbitable:body:position):normalized.

    local angle is vAng(-ship:body:position:normalized, body2targetVec). 

    local signVec is vCrs(obtnormal, -ship:body:position:normalized).
    local sign is vDot(body2targetVec, signVec).

    if sign >= 0 {
        return angle.
    } else {
        return 360 - angle. //If it is 5 degree behind, it is 355 degree ahead.
    }

}

function get_desired_orbital_period { 
    //calculate the desired orbital period to put your vessel into when rendevous with a target craft around the same parent body.
    //assuming the angle when your craft is at the intersecting point of two orbits, i.e. Ap or Pe during classical rendevous
    parameter target_orbitable.

    return target_orbitable:obt:period * (1 + ((360 - target_phase_angle(target_orbitable))/ 360)).
}



function target_phase_angle_on_equatorial_orbit {
    parameter target_orbitable. //get the phase angle or target orbiting the same parent body ahead of your vessel. If it is 5 degree behind, it is 355 degree ahead. equatorial orbit only
    parameter my_longitude is ship:longitude.

    return mod(
        lng_to_degree(get_orbitable(target_orbitable):longitude)
        - lng_to_degree(my_longitude) + 360,
        360
    ).
}


function get_desired_orbital_period_on_equatorial_orbit { //test only
    //calculate the desired orbital period to put your vessel into when rendevous with a target craft around the same parent body.
    //assuming the angle when your craft is at the intersecting point of two orbits
    parameter target_orbitable.
    parameter my_longitude is ship:longitude.


    return target_orbitable:obt:period * (1 + ((360 - target_phase_angle_on_equatorial_orbit(target_orbitable, my_longitude))/ 360)).
}