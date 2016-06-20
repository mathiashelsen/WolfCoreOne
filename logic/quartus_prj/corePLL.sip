set_global_assignment -entity "corePLL" -library "lib_corePLL" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "corePLL" -library "lib_corePLL" -name IP_TOOL_VERSION "16.0"
set_global_assignment -entity "corePLL" -library "lib_corePLL" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_corePLL" -name SPD_FILE [file join $::quartus(sip_path) "corePLL.spd"]

set_global_assignment -library "lib_corePLL" -name MISC_FILE [file join $::quartus(sip_path) "corePLL_sim/corePLL.vo"]
