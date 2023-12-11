# CS6320 - Pipelined Double Precision Floating Point Adder

## Overview

This repository contains the source code and files for a pipelined double-precision (fp64) floating-point adder designed for CS6320 course project. The primary files include the main design (FPAdder64.bsv), the test bench (Testbench.bsv), and their corresponding generated Verilog files (mkFPAdder64.v and mkTestbench.v).

### Project Details

FPAdder64.bsv: Main design file for the pipelined double-precision floating-point adder.

Testbench.bsv: Test bench file for validating the functionality of the adder.

mkFPAdder64.v: Generated Verilog file of the main design.

mkTestbench.v: Generated Verilog file of the test bench.

EE20B072_EE20B121_project_CS6230.pdf: Final report containing all design details and synthesis results.

Reports: Folder containing synthesis results.

## How to Compile

Ensure that FPAdder64.bsv and Testbench.bsv are in the same directory.

Open a terminal and navigate to the directory containing the files.

Compile the main design:

bsc -u -verilog FPAdder64.bsv

Compile the test bench:

bsc -u -verilog Testbench.bsv

Compile for simulation:

bsc -u -sim Testbench.bsv

Build the simulation executable:

bsc -o sim -e mkTestbench mkTestbench.v

Run the simulation:

./sim

## Synthesis

Installation:

git clone https://github.com/The-OpenROAD-Project/OpenLane.git

Navigate to the cloned repository/folder

Go into the docker:

sudo make mount

Create/add the design file:

./flow.tcl -design <design_name> -init_design_config -add_to_designs -config_file config.tcl
 
Navigate to designs-->your design file

cd src/

Add the mkFPAdder64.v file generated from mkFPAdder64.bsv file:

vi mkFPAdder64.v

Navigate to config.tcl in your design folder, and check for the correct module name.

cd ..

cd config.tcl/

Navigate back to OpenLane folder in the docker, and create a file mkFPAdder64_synth.tcl with all the synthesis commands needed.

vi mkFPAdder64_synth.tcl

Add these commands for synthesis and save the file:

package require openlane

prep -design mkFPAdder64 -tag run1 -overwrite

run_synthesis

run_floorplan

run_placement

run_magic

Save and exit.

Run the design using

.\flow.tcl -interactive

source .\mkFPAdder64_synth.tcl

The generated results and reports of synthesis are added automatically in the runs folder inside the design folder

## Additional Information

For detailed information about the design, implementation, and synthesis results, refer to the document EE20B072_EE20B121_project_CS6230.pdf in the repository.



