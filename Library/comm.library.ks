@lazyglobal off.
//comm means communication

function timeDelay {
    //kerbin:distance has bug!!
    //these functions, including kerbin:position, are of type orbitable, which is getting the info of something relative to active vessel's reference frame
    local distToKerbin to kerbin:position:mag - 600000.
    set distToKerbin to distToKerbin * 2. //round trip
    local delay to distToKerbin / constant():c.
    return delay.
}