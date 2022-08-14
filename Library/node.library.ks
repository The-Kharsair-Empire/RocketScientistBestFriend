@lazyGlobal off.

runOncePath("0:/Library/maneuver.library.ks").
runOncePath("0:/Library/shipsys.library.ks").

function execute_maneuver_node {
    parameter autoWarp is true.

    if hasNode {
        notify_msg("Calculating Maneuver Info").

        local node is nextNode.

        local v is node:burnVector.

        local burn_time is get_mnv_burn_time(v:mag, true).

        local startTime is time:seconds + node:eta - burn_time[0].

        lock steering to node:burnVector.

        if autoWarp {warpTo(startTime - 30).}

        wait until time:seconds >= startTime.

        notify_msg("Start Executing Maneuver Node").
        lock throttle to min(1, get_mnv_burn_time(node:burnVector:mag)).

        wait until vDot(v, node:burnvector) < 0.

        lock throttle to 0.
        unlock steering.
        remove node.

        notify_msg("Maneuver Completed").
    } else {

        notify_error("Cannot Detect Flight Plan").
    }

    


}