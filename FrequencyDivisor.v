module FrequencyDivisor (
    input i_clock,
    output reg o_reducedclock
);

reg [31:0] state;

initial begin
    state = 0;
    o_reducedclock = 0;
end

always @ (posedge i_clock) begin
    
    if (state == 100000) begin
      state <= 0;
      o_reducedclock <= ~o_reducedclock;
    end else begin
      state <= state + 1;
    end
    
end

endmodule
