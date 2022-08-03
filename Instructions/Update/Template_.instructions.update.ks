function add_instruction {

    if not(defined __TKE_update_instructions) {
        global __TKE_update_instructions to "".
    }


    set __TKE_update_instructions to 
    list(
        lexicon(
            "instruction_name", "launch",
            "CPU", "MyVesselCPUTag",
            "script", lexicon(
                "name", "MyVesselLaunch.ks",
                "path", list("Launcher"),
                "vol", 0
            ),
            "dependencies", list("Lib1", "Lib2")
        )
    ).
}

add_instruction().

