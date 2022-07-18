wait until ship:loaded and ship:unpacked.
core:part:getmodule("KOSProcessor"):doevent("Open Terminal").
set terminal:height to (terminal:height * 2).
set terminal:width to (terminal:width * 2).
print "Booting".
wait 1.

runPath("0:/Launcher/Ascent/Ascent.launch.ks").