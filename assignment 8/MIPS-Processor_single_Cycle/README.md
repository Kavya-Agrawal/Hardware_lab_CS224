# 32-bit MIPS Single Cycle Processor

This project was made a culmination of 3 courses:
- Digital Design
- Computer Architecture and Organization
- Hardware Lab

The processor implemented supports a subset of the core MIPS instruction set:

• The memory reference instructions: load word (lw) and store words (sw) 

• The arithmetic-logical instructions: add, sub, and, or, and set-less-than (slt) 

• Control transfer instructions: branch equal (beq) and jump (j)  

• Instructions for supporting subroutine: jump and link (jal) and jump register (jr)

• Immediate arithmetic: add immediate (addi)

• Custom instruction: exit (opcode 0xFC, which in standard instruction set is unused)

Note that the instruction set is complete, ie, any meaningful program can be implemented with the above instructions.

## Files/Folders

The project contains the following files/folders:

- `datapath.v`: datapath involving all the data submodules, takes input from MIPS and ALU controller
- `datamodules.v`: Contains implementation of data memory, register file, and other data path modules
- `MIPS_controller.v`: Main control unit that generates control signals based on instruction opcode
- `ALU_controller.v`: ALU control unit that determines ALU operation based on instruction function field
- `top.v`: Top-level module that instantiates and connects all components
- `data_mem.dat`: Data memory initialization file
- `instr_mem.dat`: Instruction memory initialization file containing the program
- `testbench.v`: Testbench for simulating the MIPS processor

## Current Program

The current program demonstrates various MIPS instructions through a simple array manipulation example:

1. Main Program:
   - Initializes an array with value 10 at 5 consecutive memory locations
   - Calls a subroutine `sum_array` to calculate the sum of array elements
   - Stores the result and exits

2. Subroutine `sum_array`:
   - Takes array base address and size as parameters
   - Iterates through the array elements
   - Returns the sum of all elements

The program showcases:
- Memory operations (sw, lw)
- Arithmetic operations (add, addi)
- Control flow (beq, j, jal, jr)
- Comparison operations (slt)
- Custom exit instruction


