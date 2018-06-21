
module Memory (
    input c_XCLOCK,          // Clock X
    input c_YCLOCK,          // Clock X
    input c_ZCLOCK,          // Clock Z
    input [15:0] i_RADDR,    // Read Address
    input [15:0] i_WADDR,    // Write Address
    input [15:0] i_DATA,     // Data to write
    output reg [15:0] o_OP1, // Top of stack output
    output reg [15:0] o_OP2, // 2nd element of stack output
    input f_WRITE            // Enables write
);


reg [15:0] memcell [63:0];

initial
    $readmemb("mem.list", memcell);

always @(posedge (c_XCLOCK || c_YCLOCK || c_ZCLOCK)) begin
   
    o_OP1 <= memcell [i_RADDR];
    o_OP2 <= memcell [i_RADDR - 1];
   
end
	 
always @(negedge c_ZCLOCK) begin
 
    if (f_WRITE) begin
        memcell [i_WADDR] <= i_DATA ;
    end
    
end

endmodule
