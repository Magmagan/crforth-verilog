
module ALU (
    input signed [15:0] i_OP1,  // Top of the stack
    input signed [15:0] i_OP2,  // 2nd element from stack
    output reg [15:0] o_RESULT, // 
    input c_YCLOCK,             // CLOCK D - Negedge Y
    input [3:0] f_aluctrl       // Control signal
 );

always @ (posedge c_YCLOCK) begin
    
    case (f_aluctrl)
        
        // Unary Operations: 00XX
        
        4'b0000: o_RESULT <= i_OP1 == 0 ? -1 : 0;                   // 0=
        4'b0001: o_RESULT <= i_OP1 < 0 ? -i_OP1 : i_OP1;            // ABS
        4'b0010: o_RESULT <= -i_OP1;                                // NEGATE
        4'b0011: o_RESULT <= ~i_OP1;                                // INVERT
        
        // Binary Operations
        
        // Arithmetic
        4'b0100: o_RESULT <= i_OP2 + i_OP1;                         // +
        4'b0101: o_RESULT <= i_OP2 - i_OP1;                         // -
        4'b0110: o_RESULT <= i_OP2 * i_OP1;                         // *
        
        // Shifts
        4'b0111: o_RESULT <= i_OP2 << (i_OP1 < 0 ? -i_OP1 : i_OP1); // LSHIFT
        4'b1000: o_RESULT <= i_OP2 >> (i_OP1 < 0 ? -i_OP1 : i_OP1); // RSHIFT
        
        // Logical
        4'b1001: o_RESULT <= i_OP2 & i_OP1;                         // AND
        4'b1010: o_RESULT <= i_OP2 | i_OP1;                         // OR
        4'b1011: o_RESULT <= i_OP2 ^ i_OP1;                         // XOR
        
        4'b1100: o_RESULT <= i_OP2 < i_OP1; 	            	        // <
        4'b1101: o_RESULT <= i_OP2 <= i_OP1; 	            	     // <=
        4'b1110: o_RESULT <= i_OP2 == i_OP1; 	            	     // =
        4'b1111: o_RESULT <= i_OP2 != i_OP1; 	            	     // <>
        
    endcase
    
end 

endmodule
