// ECE:3350 SISC processor project
// 16-bit mux

`timescale 1ns/100ps

module mux4 (in_a, in_b, sel, swap_sel, out);

  /*
   *  4-BIT MULTIPLEXER - mux16.v
   *
   *  Inputs:
   *   - in_a (4 bits): First input to the multiplexer. Chosen when sel = 0.
   *   - in_b (4 bits): Second input to the multiplexer. Chosen when sel = 1.
   *   - sel: Controls which input is seen at the output.
   *
   *  Outputs:
   *   - out (4 bits): Output from the multiplexer.
   *
   */

  input  [3:0] in_a;
  input  [3:0] in_b;
  input  [3:0] swap_sel;
  input  [1:0] sel;
  output [3:0] out;

  reg   [3:0] out;
   
  always @ (in_a, in_b, sel)
  begin
    if (sel == 0)
      out <= in_a;
    else if(sel == 1)
    	out <= in_b;
    else if(sel == 2)
    	out <= swap_sel;
  end

endmodule 