wait until ship:loaded and ship:unpacked.

core:part:getmodule("KOSProcessor"):doevent("Open Terminal").
if terminal:height <  70 {
    set terminal:height to (terminal:height * 2).
}
if terminal:width <  90 {
    set terminal:width to (terminal:width * 2).
}

print "Booting CPU (" + volume(1):name + ") on ship: " + ship:name.
wait 1.



if homeConnection:isconnected {
    local instr_dir to "0:/Instructions/Update/".
    local archievd_dir to "0:/Instructions/Archived/".
    local file_name to ship:name + ".instructions.update.ks".
    local directory to list("Instructions", "Update").

    if has_file(file_name, directory, 0) {
        local tmp to instr_dir + file_name.
        print "Getting new Instruction from: " + tmp.
        // local rawInstrJson to readJson(jsonFile).
        runPath(tmp).
        movePath(instr_dir + file_name, archievd_dir+file_name+".archived."+time:seconds).
        execute_instruction().
    } else {
        print "this vessel has no update instructions".
    }
} else {
    print "No connection to KSC, Standby".
}

wait until homeConnection:isconnected.
wait 10.
reboot.

function execute_instruction {
 
    local instructions to __TKE_update_instructions.
    local scriptsToRun to queue().
    for instr in instructions {
        if instr["CPU"] <> volume(1):name {
            print "instruction: " + instr["instruction_name"] + " is not for this CPU".
        } else {
            for dep in instr["dependencies"] {
                if not (require_library(dep)) {
                    install_library(dep).
                    require_library(dep).
                }
            }

            download_from_ksc(instr["script"]["path"], instr["script"]["name"]).
            local tmpFilePath to list(instr["script"]["path"], instr["script"]["name"]).
            //"/" + instr["script"]["path"]:join("/") + "/" + instr["script"]["name"].
            scriptsToRun:push(tmpFilePath).
        }
    }

    for script in scriptsToRun {
        run_script(script[0], script[1]).
    }

    unset __TKE_update_instructions.
}

function has_file {
    parameter name.
    parameter path.
    parameter vol.

    switch to vol.
    for dir in path {
        if (exists(dir)) {
            cd(dir).
        } else {
            switch to 1.
            return false.
        }
    }

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

function install_library {
    parameter library_name.

    local name to library_name + ".library.ks".
    local path to list("Library").

    if not has_file(name, path, 1) {
        download_from_ksc(path, name).
    } 

}

function require_library {
    parameter library_name.

    local name to library_name + ".library.ks".
    local path to list("Library").
    if not has_file(name, path, 1) {
        print "library (" + library_name  + ") not found on this vessel, download when signal available".
        return false.
    } else {
        local pathName to "/" + path:join("/") + "/" + name.
        runOncePath(pathName).
        print "library (" + library_name  + ") loaded".
        return true.
    }
}


function download_from_ksc {
    parameter directory.
    parameter file_name.

    local pathName to "/" + directory:join("/") + "/" + file_name.
    
    if has_file(file_name, directory, 0) {
        copyPath("0:" + pathName, pathName).
        print "Downloaded: " + pathName.
        return true.
    } else {
        print "Download failed, " + pathName + " doesn't exist".
        return false.
    }
}

function download_from_vol {
    parameter directory.
    parameter file_name.
    parameter vol.

    local pathName to "/" + directory:join("/") + "/" + file_name.
    
    if has_file(file_name, directory, vol) {
        copyPath(vol + ":" + pathName, pathName).
        print "Downloaded: " + pathName.
        return true.
    } else {
        print "Download failed, " + pathName + " doesn't exist".
        return false.
    }
}

function upload_to_ksc {
    parameter directory.
    parameter file_name.

    local pathName to "/" + directory:join("/") + "/" + file_name.
    
    if has_file(file_name, directory, 1) {
        copyPath(pathName, "0:" + pathName).
        print "uploaded: " + pathName.
        return true.
    } else {
        print "upload failed, " + pathName + " doesn't exist".
        return false.
    }
}


function run_script {
    parameter directory.
    parameter file_name.

    local pathName to "/" + directory:join("/") + "/" + file_name.

    if has_file(file_name, directory, 1) {
        runPath(pathName).
        print "run succeeded: " + pathName.
        return true.
    } else {
        print "run failed, " + pathName + " doesn't exist".
        return false.
    }
}