module Top (
    input clk,
    input button,
    input [15:0] switches,
    
    output wire [6:0] SevenSegment0,
    output wire [6:0] SevenSegment1,
    output wire [6:0] SevenSegment2,
    output wire [6:0] SevenSegment3,
	 output wire [6:0] SevenSegment4,
    output wire [6:0] SevenSegment5,
    output wire [6:0] SevenSegment6,
	 output wire [6:0] SevenSegment7
);


wire io_type;
wire io_pause;
wire io_state;

wire [15:0] io_debug0;
wire [15:0] io_debug1;
wire [15:0] io_debug2;
wire [15:0] io_debug3;
wire [15:0] io_debug4;

wire cpu_clock;
wire new_clock;

wire debounced_button;

assign cpu_clock = new_clock;

FrequencyDivisor divisor (
    .i_clock        (clk),
    .o_reducedclock (new_clock)
);

Debouncer debounce (
	.clk       (clk),
	.button_in (button),
	.DB_out    (debounced_button)
);

IOButton io (
	.button   (debounced_button),
	.cucpause (io_pause),
	.state    (io_state)
);

ConvertSegmentDisplay converter1 (
    .i_HALFBYTE (io_debug0[3:0]),
    .o_OUT      (SevenSegment0)
);

ConvertSegmentDisplay converter2 (
    .i_HALFBYTE (io_debug0[7:4]),
    .o_OUT      (SevenSegment1)
);

ConvertSegmentDisplay converter3 (
    .i_HALFBYTE (io_debug0[11:8]),
    .o_OUT      (SevenSegment2)
);

ConvertSegmentDisplay converter4 (
    .i_HALFBYTE (io_debug0[15:12]),
    .o_OUT      (SevenSegment3)
);

ConvertSegmentDisplay converter5 (
    .i_HALFBYTE (io_debug1),
    .o_OUT      (SevenSegment4)
);

ConvertSegmentDisplay converter6 (
    .i_HALFBYTE (io_debug2),
    .o_OUT      (SevenSegment5)
);

ConvertSegmentDisplay converter7 (
    .i_HALFBYTE (io_debug3),
    .o_OUT      (SevenSegment6)
);

ConvertSegmentDisplay converter8 (
    .i_HALFBYTE (io_debug4),
    .o_OUT      (SevenSegment7)
);


CPU processor (
    .clk      (cpu_clock),
	 .switches (switches),
	 .iostate  (io_state),
    .iotype   (io_type),
    .iopause  (io_pause),
	 .debug0   (io_debug0),
    .debug1   (io_debug1),
	 .debug2   (io_debug2),
	 .debug3   (io_debug3),
	 .debug4   (io_debug4)
);

endmodule
