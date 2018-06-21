
module ClockDivisor (
    input  wire i_CLOCK,
    output wire o_CYCLEX,
    output wire o_CYCLEY,
    output wire o_CYCLEZ
);

reg o_CLOCKA = 0;
reg o_CLOCKB = 0;
reg o_CLOCKC = 0;
reg o_CLOCKD = 0;
reg o_CLOCKE = 0;
reg o_CLOCKF = 0;

reg [2:0] state = 1;
wire [2:0] state_plus_one = state == 6 ? 0 : state + 1;

assign o_CYCLEX = o_CLOCKA ^ o_CLOCKB;
assign o_CYCLEY = o_CLOCKC ^ o_CLOCKD;
assign o_CYCLEZ = o_CLOCKE ^ o_CLOCKF;

always @(posedge i_CLOCK) begin
    
    if (state == 1) begin
        o_CLOCKA = !o_CLOCKA;
    end
    
    if (state == 3) begin
        o_CLOCKC = !o_CLOCKC;
    end
    
    if (state == 5) begin
        o_CLOCKE = !o_CLOCKE;
    end
    
end

always @(negedge i_CLOCK) begin
    
    if (state_plus_one == 2) begin
        o_CLOCKB = !o_CLOCKB;
        state = 3;
    end
    
    if (state_plus_one == 4) begin
        o_CLOCKD = !o_CLOCKD;
        state = 5;
    end
    
    if (state_plus_one == 6) begin
        o_CLOCKF = !o_CLOCKF;
        state = 1;
    end
    
end

endmodule
