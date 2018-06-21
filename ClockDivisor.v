
module ClockDivisor (
    input  wire i_CLOCK,
    output wire o_CYCLEX,
    output wire o_CYCLEY,
    output wire o_CYCLEZ,
    output wire [1:0] o_STATE
);

reg o_CLOCKA = 0;
reg o_CLOCKB = 0;
reg o_CLOCKC = 0;
reg o_CLOCKD = 0;
reg o_CLOCKE = 0;
reg o_CLOCKF = 0;

reg [1:0] state = 1;

assign o_CYCLEX = o_CLOCKA ^ o_CLOCKB;
assign o_CYCLEY = o_CLOCKC ^ o_CLOCKD;
assign o_CYCLEZ = o_CLOCKE ^ o_CLOCKF;
assign o_STATE  = state;

always @(posedge i_CLOCK) begin
    
    if (state == 1) begin
        o_CLOCKA <= !o_CLOCKA;
    end
    
    else if (state == 2) begin
        o_CLOCKC <= !o_CLOCKC;
    end
    
    else if (state == 3) begin
        o_CLOCKE <= !o_CLOCKE;
    end
    
end

always @(negedge i_CLOCK) begin
    
    if (state == 1) begin
        o_CLOCKB = !o_CLOCKB;
        state <= 2;
    end
    
    else if (state == 2) begin
        o_CLOCKD = !o_CLOCKD;
        state <= 3;
    end
    
    else if (state == 3) begin
        o_CLOCKF = !o_CLOCKF;
        state <= 1;
    end
    
end

endmodule
