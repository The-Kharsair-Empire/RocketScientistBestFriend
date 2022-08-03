wait until ship:loaded and ship:unpacked.

if alt:radar < 100 {
    core:part:getmodule("KOSProcessor"):doevent("Open Terminal").
    set terminal:height to (terminal:height * 2).
    set terminal:width to (terminal:width * 2).
    print "Booting".
    wait 1.

    // switch to 0.
    print "Ready for Command".

    // runPath("0:/Launcher/Ascent/Ascent.launch.ks").
    // runPath("0:/TestLauncher/TestLaunch.ks").
    runOncePath("0:/Library/maneuver.library.ks").
    // runOncePath("0:/UtilityLibrary/navigation.function.ks").


}


