// ECE:3350 SISC computer project
// sisc testbench
// Sharukh Hasan & Mark Parise

`timescale 1ns/100ps

module sisc_tb;	
	parameter    tclk = 10.0;    
  reg          clk;
  reg          rst_f;
  reg [31:0]   ir;

  // component instantiation
  // "uut" stands for "Unit Under Test"
  sisc uut (.clk   (clk),
            .rst_f (rst_f),
            .ir    (ir));

  // clock driver
  initial
  begin
    clk = 0;    
  end
	
  always
  begin
    #(tclk/2.0);
    clk = ~clk;
  end
 
  // reset control
  initial 
  begin
    rst_f = 0;
    // wait for 20 ns;
    #20; 
    rst_f = 1;
  end


  initial
  begin
    // To test all of the arithmetic instructions:
    #25 ir = 32'h00000000; //NOP
    #50 ir = 32'h88010001; //ADDI R1 <- R0 + (0x0000)0001
    #50 ir = 32'h80112001; //ADD  R2 <- R1 + R1
    #50 ir = 32'h8022300B; //SHFL R3 <- R2 << [R2]
    #50 ir = 32'h80124002; //SUB  R4 <- R1 - R2
    #50 ir = 32'h8043400A; //SHFR R4 <- R4 >> [R3]
    #50 ir = 32'h80342007; //XOR  R2 <- R3 ^ R4
    #50 ir = 32'h80202004; //NOT  R2 <- ~R2
    #50 ir = 32'h80214009; //ROTL R4 <- R2 <.< [R1]
    #50 ir = 32'h80245005; //OR   R5 <- R2 | R4
    #50 ir = 32'h80243006; //AND  R3 <- R2 & R4
    #50 ir = 32'h00000000; //NOP

	/*
	 * At this point, registers should be as follows:
	 *   R1: 00000001		R4: FE000011
	 *   R2: FF000008		R5: FF000019
	 *   R3: FE000000		R0, R6-R15: 00000000
	 */

    // To test status code generation:
    #50 ir = 32'h00000000; //NOP
    #50 ir = 32'h88010001; //ADD  R1 <- R0 + (0x0000)0001 (STAT: 0000)
    #50 ir = 32'h80112002; //SUB  R2 <- R1 - R1           (STAT: 0001)
    #50 ir = 32'h80012002; //SUB  R2 <- R0 - R1           (STAT: 1010)
    #50 ir = 32'h80113008; //ROTR R3 <- R1 >> [R1]
    #50 ir = 32'h80234001; //ADD  R4 <- R2 + R3           (STAT: 1110)
    #50 ir = 32'hF0000000; //HALT

  end
endmodule