set_global_assignment -entity "mainPLL" -library "lib_mainPLL" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "mainPLL" -library "lib_mainPLL" -name IP_TOOL_VERSION "16.0"
set_global_assignment -entity "mainPLL" -library "lib_mainPLL" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_mainPLL" -name SPD_FILE [file join $::quartus(sip_path) "mainPLL.spd"]

set_global_assignment -library "lib_mainPLL" -name MISC_FILE [file join $::quartus(sip_path) "mainPLL_sim/mainPLL.vo"]
