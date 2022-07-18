@lazyglobal off.

function notify_msg {
    parameter msg.
    hudtext(msg, 3, 2, 20, green, false).
}

function notify_error {
    parameter msg.
    hudtext(msg, 3, 2, 20, red, false).
}


function doSafeStage {
    wait until stage:ready.
    stage.
}

function playsound {
    parameter waveform, frequency, length. 
    local V0 TO GETVOICE(waveform). 
    V0:PLAY( NOTE(frequency, length) ).                        
}

function delta_time {
    if not(defined lastTimeStamp) {
        global lastTimeStamp to time:seconds.
    }

    local dTime to time:seconds - lastTimeStamp.
    set lastTimeStamp to time:seconds.

    return dTime.
}