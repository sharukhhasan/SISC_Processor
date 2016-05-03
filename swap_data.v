// 55:035 sisc processor project
// part 3 - swap data registers

`timescale 1ns/100ps

module swap_data(in_a, in_b, sel, swap_en, data_out);

		/*
		 * SWAP DATA REGISTER FILE - swap_data.v
		 *	Inputs:	
		 *		-in_a (32bits): Data to be swapped from RS 
		 *		-in_b (32bits): Data to be swapped from RT
		 *		-sel 1 bit: choose which register to output to multiplexer. multiplexer inputs into rf
		 *			0 -> swap rs; 1-> swap rt
		 * 		-swap_en: enable bit for swap write to register
		 *	OUTPUTS:
		 *		-data_out (32bits): Data chosen to be swapped
		 */

input [31:0] in_a;
input [31:0] in_b;
input sel;
input swap_en;

reg[31:0] reg_a;
reg[31:0] reg_b;

output [31:0] data_out;
reg [31:0] data_out;

always @(sel)
begin
	if(sel == 1'b1)
	begin
		assign data_out = reg_b;
	end
	if(sel == 1'b0)
	begin
		assign data_out = reg_a;
	end
end

always @(swap_en)
begin 
	if(swap_en == 1)
	begin
		reg_a <= in_a;
		reg_b <= in_b;
	end
end

endmodule