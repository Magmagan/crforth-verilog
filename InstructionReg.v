
module InstructionReg (
    input c_CLOCKX,
    input [15:0] i_SETINSTRUCTION,
    output wire [15:0] o_INSTRUCTION
);

reg [15:0] instruction;

assign o_INSTRUCTION = instruction;

always @(negedge c_CLOCKX) begin
    instruction = i_SETINSTRUCTION;
end

endmodule
