# SISC_Processor

The project consists of building and testing, and modifying a Simple Instruction Set Computer (SISC) processor using Verilog HDL and ModelSim. The project also involves writing machine code programs that correctly execute on this computer.

# Overview of the SISC Processor Architecture
This Simple Instruction Set Computer (SISC) is a multi-cycle RISC computer with separate memory for instructions and data, with the following characteristics:
word length: 32 bit
general purpose registers: 16 x 32 bit
Instruction/data space: 2^16 = 65536 words = 64 KW word
addressing resolution: word
instruction set: LOAD/STORE architecture
immediate operand lengths: 16 bit
clock rate: 1 cycle/10ns
cycles per instruction: 5 CPI
addressing modes: immediate, register-direct, register-indirect, index, absolute
