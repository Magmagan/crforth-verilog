module IOButton (
	input wire button,
	input wire cucpause,
	output reg state
);

initial begin
	state = 0;
end

always @ (negedge button) begin
	if(cucpause) begin
		state <= ~state;
	end
end

endmodule
