
module OPRegs(
    input c_CLOCKY,
    input [15:0] i_SETOP1,
    input [15:0] i_SETOP2,
    output wire [15:0] o_OP1,
    output wire [15:0] o_OP2
);

reg [15:0] op1;
reg [15:0] op2;

assign o_OP1 = op1;
assign o_OP2 = op2;

always @(negedge c_CLOCKY) begin
    op1 <= i_SETOP1;
    op2 <= i_SETOP2;
end

endmodule
