# Template for UPDUINO V3.0/1 project in Verilog HDL

## Requierements:

A correct installation of [apio](https://github.com/FPGAwars/apio), such that you are able to use it from console.
**Optional:** installation of [netlistsvg](https://github.com/nturley/netlistsvg) will enable the usage of the show task in the makefile to generate a diagram of the synthesized circuit.

## Usage:

The project consist of a single Makefile with the PCF file containing the pins declarations from the Upduino board (check [docs](https://upduino.readthedocs.io/en/latest/)). There's two verilog files as a template, but they are not required. Before verifying, building or simulation, make sure that the makefile variables are correctly set. Modify this section in the makefile accordingly:

```makefile
LIB_SRC =
SOURCES = top.v $(LIB_SRC)
TBNAME = top_tb     # name of the testbench .vcd file
MODULE_TO_DRAW = top.v  # file with modules to draw to schematic diagram
SOURCES_TB = top_tb.v $(LIB_SRC)    # libs and testbench file
```

Once configured, it is posible to use the tasks in the makefile:

```makefile
verify      # check for compiling errors
all         # buld the project up to the bitstream
prog        # upload bitstream to board
sim         # generate VCD file with signals.
show        # generate svg file with the diagram of the compiled project
time        # generate timings calculations
clean       # clean intermidiate files
```

## Considerations

There can be problems in Windows while trying to upload code to the FPGA when the Analog Discovery 2 is connected to the PC. The solution is to disconnect the AD2.
Depending on the user, the .apio directory may not be located in the user folder, this should be corrected in the Makefile.
It is possible to use a trace visualizer in VSCode: [WaveTrace](https://marketplace.visualstudio.com/items?itemName=wavetrace.wavetrace), but not mandatory. Another useful and portable program is GTKWave.
