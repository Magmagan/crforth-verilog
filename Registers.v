
module Registers (

    input wire c_CLOCKX,
    input wire c_CLOCKY,
    input wire c_CLOCKZ,
    input wire [1:0] c_STATE,
	 
    input wire [1:0] i_SSRSet,
	 
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
    SSR = 0;
    registers[0]  = 0;
    registers[1]  = 48;
    registers[2]  = 56;
    registers[3]  = 0;
    registers[4]  = 0;
    registers[5]  = 0;
    registers[6]  = 0;
    registers[7]  = 0;
    registers[8]  = 0;
    registers[9]  = 0;
    registers[10] = 0;
    registers[11] = 0;
    registers[12] = 0;
    registers[13] = 0;
    registers[14] = 0;
    registers[15] = 0;
end

always @ (posedge (c_CLOCKX || c_CLOCKY || c_CLOCKZ)) begin
    o_OUT <= registers[i_RADDR];
end

always @ (negedge c_CLOCKX) begin
    SSR <= i_SSRSet == 0 || i_SSRSet == 1 ? i_SSRSet : SSR;
end

always @ (negedge (c_CLOCKY || c_CLOCKZ)) begin
    if (c_STATE == 3) begin // Clock D
        registers[i_WADDR] <= i_DATA;
    end
    if (c_STATE == 1) begin // Clock F
        if (f_WRITE) begin
            registers[i_WADDR] <= i_DATA;
        end
        if (f_PCWRITE && (i_WADDR != 0 || !f_WRITE)) begin
            registers[0] <= i_PCDATA;
        end
    end
end

endmodule
