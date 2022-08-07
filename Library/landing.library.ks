@lazyglobal off.



function time_to_impact_vertically {
    // s = v0 x t + 1/2 x a x t^2, s is distance to cover, v0 is initial velocity, a is deceleration (or acceleration)
    // the question above is a quadratic equation for t: ax^2 + bx + c => 1/2a t^2 + v0 t - s = 0 => t = (-v0 +- sqrt(v0^2 - 4 (1/2a) -s )) / (2 (1/2a)) 
    // => t = (-v0 +- sqrt(v0^2 + 2as)) / a, and t cannot be negative! so t = ( + sqrt(v0^2 + 2as) - v0) / a
    //ANGLEAXIS(min(20, max(-20, VANG(UP:VECTOR, (-1)*SHIP:VELOCITY:SURFACE) )),vcrs(UP:VECTOR, -SHIP:VELOCITY:SURFACE)) * UP:VECTOR

    parameter margin is 0.

    local distance is alt:radar - margin.
    local v0 is -ship:verticalspeed.
    local gravity is ship:body:mu / ship:body:radius ^ 2. //limitation: assume constant surface gravity.

    return (sqrt(v0^2 + 2*gravity*distance) - v0) / gravity.
}
