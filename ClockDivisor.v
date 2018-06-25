
module ClockDivisor (
    input  wire i_CLOCK,
    
    input  wire i_CUCPAUSE,
    input  wire i_IOPAUSE,
    
    output wire o_CYCLEX,
    output wire o_CYCLEY,
    output wire o_CYCLEZ,
    output wire [1:0] o_STATE
);

reg o_CLOCKA;
reg o_CLOCKB;
reg o_CLOCKC;
reg o_CLOCKD;
reg o_CLOCKF;
reg o_CLOCKE;

reg [1:0] state;
reg start;
reg pause;

initial begin
    o_CLOCKA = 0;
    o_CLOCKB = 0;
    o_CLOCKC = 0;
    o_CLOCKD = 0;
    o_CLOCKE = 0;
    o_CLOCKF = 0;
    state = 1;
    start = 1;
    pause = 0;
end

assign o_CYCLEX = o_CLOCKA ^ o_CLOCKB;
assign o_CYCLEY = o_CLOCKC ^ o_CLOCKD;
assign o_CYCLEZ = o_CLOCKE ^ o_CLOCKF;
assign o_STATE  = state;
assign enabled  = pause == i_IOPAUSE;

always @(posedge i_CLOCK) begin
    
    if (enabled) begin
        
        if (state == 1) begin
            o_CLOCKA <= !o_CLOCKA;
            start <= 0;
        end
        
        else if (state == 2) begin
            o_CLOCKC <= !o_CLOCKC;
            start <= i_CUCPAUSE;
        end
        
        else if (state == 3) begin
            o_CLOCKE <= !o_CLOCKE;
            start <= 0;
        end
        
    end
    
end

always @(negedge i_CLOCK) begin
    
    if (enabled) begin
    
        if (state == 1 && !start) begin
            o_CLOCKB <= !o_CLOCKB;
            state <= 2;
        end
        
        else if (state == 2) begin
            if (i_CUCPAUSE) begin
                pause <= ~pause;
            end
            o_CLOCKD <= !o_CLOCKD;
            state <= 3;
        end
        
        else if (state == 3 && !start) begin
            o_CLOCKF <= !o_CLOCKF;
            state <= 1;
        end
    
    end
    
end

endmodule
