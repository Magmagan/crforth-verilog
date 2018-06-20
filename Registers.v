
module Registers (

    input wire c_CLOCKX,
    input wire c_CLOCKY,
    input wire c_CLOCKZ,
	 
    input wire [2:0] i_SSRSet,
	 
    input wire [3:0] i_RADDR,
    input wire [3:0] i_WADDR,
    input wire [15:0] i_DATA,
	 
    input wire f_WRITE,
	 
    input wire [15:0] i_PCDATA,
    input wire f_PCWRITE,
	 
    output wire o_SSR,
    output wire [15:0] o_PC,
    output wire [15:0] o_PSP,
    output wire [15:0] o_RSP,
    output wire [15:0] o_OfR,
    output reg [15:0] o_REG,
	 
    output reg [15:0] o_OUT
);

reg SSR;
reg [15:0] registers [15:0];

assign o_SSR = SSR;
assign o_PC  = registers[0];
assign o_PSP = registers[1];
assign o_RSP = registers[2];
assign o_OfR = registers[3];

initial begin
    registers[2] = 48;
    registers[3] = 56;
end

always @ (negedge (c_CLOCKX || c_CLOCKY || c_CLOCKZ)) begin
    o_OUT <= registers[i_RADDR];
end

always @ (posedge c_CLOCKX) begin
    SSR <= i_SSRSet == 0 || i_SSRSet == 1 ? i_SSRSet : SSR;
end

always @ (posedge (c_CLOCKY || c_CLOCKZ)) begin
    if (c_CLOCKY) begin // Clock D
        registers[i_WADDR] <= i_DATA;
    end
    if (c_CLOCKZ) begin // Clock F
        if (f_WRITE) begin
            registers[i_WADDR] <= i_DATA;
        end
        if (f_PCWRITE && (i_WADDR != 0 || !f_WRITE)) begin
            registers[0] <= i_PCDATA;
        end
    end
end

endmodule
