// Major thanks to jopheno for helping out with this code!

module ConvertSegmentDisplay (
    input  [3:0] i_HALFBYTE,
    output [6:0] o_OUT
);

// OUT format .GFEDCBA

assign o_OUT = i_HALFBYTE == 4'b0000 ? 8'b01000000 : // 0
               i_HALFBYTE == 4'b0001 ? 8'b01111001 : // 1
               i_HALFBYTE == 4'b0010 ? 8'b00100100 : // 2
               i_HALFBYTE == 4'b0011 ? 8'b00110000 : // 3
               i_HALFBYTE == 4'b0100 ? 8'b00011001 : // 4
               i_HALFBYTE == 4'b0101 ? 8'b00010010 : // 5
               i_HALFBYTE == 4'b0110 ? 8'b00000010 : // 6
               i_HALFBYTE == 4'b0111 ? 8'b01111000 : // 7
               i_HALFBYTE == 4'b1000 ? 8'b00000000 : // 8
               i_HALFBYTE == 4'b1001 ? 8'b00010000 : // 9
               i_HALFBYTE == 4'b1010 ? 8'b00001000 : // A
               i_HALFBYTE == 4'b1011 ? 8'b00000011 : // B
               i_HALFBYTE == 4'b1100 ? 8'b01000110 : // C
               i_HALFBYTE == 4'b1101 ? 8'b00100001 : // D
               i_HALFBYTE == 4'b1110 ? 8'b00000110 : // E
                                       8'b00001110 ; // F

endmodule