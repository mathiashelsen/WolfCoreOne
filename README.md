# WolfCoreOne

Under construction. Nothing to see here yet.

## logic

Directory [logic](logic/) contains the VHDL files defining the Core. [DE0_Nano_SoC.vhd](logic/DE0_Nano_SoC.vhd) is the top-level entity that wires the Core to a DE0 Nano SoC (Atlas SoC) development board.


### logic/src

Directory [logic/src](logic/src) contains the VHDL files defining the Core, independent of the hardware it's implemented on.


## soc

Directory [soc](soc/) contains code for the ARM SoC. This is mainly for testing.


## toolchain

Directory [toolchain](toolchain/) contains the compilation toolchain (assembler, emulator, ...)
