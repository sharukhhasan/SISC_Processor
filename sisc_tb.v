// ECE:3350 SISC computer project
// sisc testbench
// Sharukh Hasan & Mark Parise

`timescale 1ns/100ps

module sisc_tb;
	wire clk;
	wire rst_f;
	//wire [31:0] ir;
	
	sisc mysisc(clk, rst_f);
	sisc_test mytestsisc(clk, rst_f);
	
endmodule

module sisc_test(clk, rst_f);
	output clk, rst_f;
	//output[31:0] IR;
	reg clk, rst_f;
	//reg[31:0] IR;

	initial
		begin
			clk = 0;
			rst_f = 1;
		end

	always       //drive clock, 10ns clock cycle -> 5ns on, 5ns off
		begin
			#5 CLK <= !CLK;
		end
		
	initial
		begin
			RST_F <= 0;
			#20
			RST_F <= 1;
		end
		
	
	// part 1
	/*initial begin
		CLK<=0; RST_F<=1;
		#20 RST_F <=0;
		#5  IR <=32'H00000000; RST_F<=1; //1st instruction nop
		#50 IR <=32'H8802000A;  //2nd instruction add immediate 10 into r[1]
		#50 IR <=32'H88030007;  //3rd instruction add immediate 7 into r[2]
		#50 IR <=32'H80231002;  //4th instruction r[1] <- r[2] - r[3]
		#50 IR <=32'H80101004;  //r[1] <- ~r[1]
		#50 IR <=32'H80231005;  //r[1] <- r[2] OR r[3]
		#50 IR <=32'H80231006;  //r[1] <- r[2] AND r[3]
		#50 IR <=32'H80231007;  //r[1] <- r[2] XOR r[3]
		#50 IR <=32'H88020001;  // load immediate 1 into r[2] for shifting
		#50 IR <=32'H80321008;  // rotate right by r[2]=1 from r[3] and store in r[1]
		#50 IR <=32'H80321009;  // rotate left by r[2]=1 from r[3] and store in r[1]
		#50 IR <=32'H8032100A;  // shift right by r[2]=1 from r[3] and store in r[1]
		#50 IR <=32'H8032100B;  // shift left by r[2]=1 from r[3] and store in r[1]
		#50 IR <=32'HF0000000;  //halt
		#50 $finish;
	end*/
endmodule