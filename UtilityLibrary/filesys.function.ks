@lazyglobal off.


function has_file {
    parameter name.
    parameter vol.

    switch to vol.
    local allfiles to list().
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


function download_file_from_ksc {
    parameter filename.

    if has_file(filename, 1) {
        // 0:/TestLauncher/KerbinComRelayDeployer.ks"
        deletePath("1:/" + filename).
        print filename + "exist in current ship, deleting".
    }

    if has_file(filename, 0) {
        copyPath("0:/" + filename, "1:/" + filename).
        print filename + "downloaded successfully".
    } else {
        print "file you are looking for downloading doesn't exist".
    }


}


function upload {
    parameter filename.

    if has_file(filename, 0) {
        deletePath("0:/" + filename).
        print "overwirting old file " + filename + " at KSC".
    }

    if has_file(filename, 1) {
        copyPath("1:/" + filename, "0:/" + filename).
        print filename + "uploaded to KSC successfully".
    } else {
        print "file to upload doesn't exist".
    }

}


function check_for_script_update {
    local updateScriptName to ship:name + ".update.ks".

    if homeConnection:isconnected {
        if has_file(updateScriptName, 0) {
            download_file_from_ksc(updateScriptName).
            switch to 0. deletePath("0:/" + updateScriptName). switch to 1.
            if has_file("update.ks", 1) {
                deletePath("1:/update.ks").
            }
            movePath("1:/" + updateScriptName, "1:/update.ks").
            return true.
        } else {
            return false.
        }
    } else {
        return false.
    }

    
}


function reboot_space_craft_mid_flight {

    if (check_for_script_update()) {
        runPath("1:/update.ks").
        deletePath("1:/update.ks").
    } 
    
    if (has_file("startup.ks", 1)) {
        runPath("1:/startup.ks").
    } else {
        wait until homeConnection:isconnected.
        wait 10.
        reboot.
    }
    
}