# Set up the enviroment(Download from https://github.com/YosysHQ/oss-cad-suite-build)
# On windows start.bat
# make.exe should be on PATH
# To verbose make all QUIET=
ifeq ($(OS),Windows_NT)
    uname_S := Windows
else
    uname_S := $(shell uname -s)
endif

ifeq ($(uname_S), Windows)
    APIOPKGFOLDER = 
endif
ifeq ($(uname_S), Linux)
    APIOPKGFOLDER = $${HOME}/.apio
endif
ifeq ($(uname_S), Darwin)
	APIOPKGFOLDER = $${HOME}/.apio
endif

LIB_SRC = ALU/ALU.v ./mainFSB/mainFSB.v ./keyboardCtrl/keyboardCtrl.v DisplayCtrl/bcd_2seg.v DisplayCtrl/fsm_bin_to_bcd.v ./DisplayCtrl/DisplayCtrl.v keyboardCtrl/keybToBCD.v
SOURCES = top.v $(LIB_SRC)
TBNAME = mainFSB_tb
MODULE_TO_DRAW = ./mainFSB/mainFSB.v
SOURCES_TB = mainFSB/mainFSB_tb.v $(LIB_SRC)
PCF = upduino.pcf
#QUIET = -q

IVERILOG = apio raw 'iverilog
YOSYS = apio raw 'yosys
ICE40 = apio raw 'nextpnr-ice40
ICEPROG = apio raw 'iceprog
ICEPACK = apio raw 'icepack
ICETIME = apio raw 'icetime
VVP = apio raw 'vvp

ifdef ComSpec
    RM=del /F /Q
	CP=copy
else
    RM=rm -f
	CP=cp
endif

all: hardware.bin

hardware.json: $(SOURCES)
#	yosys -p "synth_ice40 -dsp -json hardware.json -abc9 -device u" C $(SOURCES)
	$(YOSYS) -p "synth_ice40 -dsp -json hardware.json" $(QUIET) $(SOURCES)'

hardware.asc: $(PCF) hardware.json
	$(ICE40) --up5k --package sg48 --json hardware.json --asc hardware.asc --pcf $(PCF) --freq 72 $(QUIET)'

hardware.bin: hardware.asc
	$(ICEPACK) hardware.asc hardware.bin'

time: hardware.asc
	$(ICETIME) -d up5k -P sg48 -t hardware.asc'

prog: hardware.bin
	$(ICEPROG) -d i:0x0403:0x6014 hardware.bin'

sim: $(SOURCES)
	$(IVERILOG) -B "$(APIOPKGFOLDER)/packages/tools-oss-cad-suite/lib/ivl" -o $(TBNAME).out -D VCD_OUTPUT=$(TBNAME) -D NO_ICE40_DEFAULT_ASSIGNMENTS "$(APIOPKGFOLDER)/packages/tools-oss-cad-suite/share/yosys/ice40/cells_sim.v" $(SOURCES_TB)'
	$(VVP) $(TBNAME).out'

show: $(SOURCES)
	$(YOSYS) -p "prep; write_json output.json" $(MODULE_TO_DRAW)'
	netlistsvg output.json -o hardware.svg

verify:
	$(IVERILOG) -B "$(APIOPKGFOLDER)/packages/tools-oss-cad-suite/lib/ivl" -o hardware.out -D VCD_OUTPUT= -D NO_ICE40_DEFAULT_ASSIGNMENTS "$(APIOPKGFOLDER)/packages/tools-oss-cad-suite/share/yosys/ice40/cells_sim.v" $(SOURCES)'
	
iceprog: hardware.bin
	$(ICEPROG) hardware.bin'

install:
	$(RM) ../$(LIB_SRC)
	$(CP) $(LIB_SRC) ../

clean:
	$(RM) hardware.json hardware.asc hardware.bin abc.history *.out *.vcd
