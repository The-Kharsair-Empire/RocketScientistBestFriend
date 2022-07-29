wait until ship:loaded and ship:unpacked.
set ship:control:pilotmainthrottle to 0.

function has_file {
    parameter name.
    parameter vol.

    switch to vol.
    list files in allfiles.
    for file in allfiles {
        if file:name = name {
            switch to 1.
            return true.
        }
    }

    switch to 1.
    return false.
}