// 55:035 sisc processor project
// part 3 - swap register addresses

`timescale 1ns/100ps

module register_swap(in_a, in_b, sel, data_out);

	/*
 	 * 	SWAP REG REGISTER FILE - swap_reg.v
 	 *	Inputs:	
 	 *		-in_a (4bits): Address of Rs 
 	 *		-in_b (4bits): Address of Rt
 	 *		-sel 1 bit: multiplexer inputs into rf (0 -> swap rs;) (1-> swap rt;)
 	 *	OUTPUTS:
 	 *		-data_out (4bits): Address of register to be swapped
 	 */

input [3:0] in_a;
input [3:0] in_b;
input sel;

output [3:0] data_out;
reg [3:0] data_out;

always @ (in_a, in_b, sel)
begin
	if(sel == 1'b0)
	begin
		data_out <= in_b;
	end
	if(sel == 1'b1)
	begin
		data_out <= in_a;
	end
end

endmodule