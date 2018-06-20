
module ControlUnit (
    
    input wire [15:0] i_INSTRUCTION,
    
    output reg [1:0] o_SETSSR,
    output reg [3:0] o_ALUCONTROL,
    output reg [15:0] o_SPCHANGE,
    output reg o_MEMWRITE,
    output reg [2:0] o_MUXMEMDATA,
    output reg o_MUXMEMADDR,
    output reg [3:0] o_REGREADADDR,
    output reg [3:0] o_REGWRITEADDR,
    output reg o_REGWRITE,
    output reg [1:0] o_MUXJUMPADDR
);

// Define instruction name constants
parameter I_NOP  = 4'b0000;
parameter I_ALU  = 4'b0001;
parameter I_JUMP = 4'b0011;
parameter I_IF   = 4'b0010;
parameter I_DUP  = 4'b0111;
parameter I_OVER = 4'b0101;
parameter I_DROP = 4'b0110;
parameter I_AT   = 4'b1001;
parameter I_WRT  = 4'b1100;
parameter I_RW   = 4'b1110;
parameter I_RR   = 4'b1011;
parameter I_HALT = 4'b1111;

// Define constants for memory write mux
parameter MMW_INSTRUCTION = 3'b000;
parameter MMW_OP1         = 3'b001;
parameter MMW_OP2         = 3'b010;
parameter MMW_ALURES      = 3'b011;
parameter MMW_ATREAD      = 3'b100;
parameter MMW_REGREAD     = 3'b101;

// Define constants for memory address mux
parameter MMA_SP  = 0;
parameter MMA_OP1 = 1;

// Define constants for jump address mux
parameter MJA_PC   = 2'b00;
parameter MJA_OP1  = 2'b01;
parameter MJA_OP2  = 2'b10;
parameter MJA_HALT = 2'b11;

always @(*) begin
    
	// o_SETSSR
	if (i_INSTRUCTION[15] == 1) begin
		o_SETSSR <= i_INSTRUCTION[0];
	end
	else begin
		o_SETSSR <= 2'b10;
	end

	// o_ALUCONTROL
	o_ALUCONTROL <= i_INSTRUCTION[7:4];

	// o_SPCHANGE
	if (i_INSTRUCTION[15] == 0) begin
		o_SPCHANGE <= +1;
	end
	else begin
		case (i_INSTRUCTION[11:8]) 
			I_ALU:
				o_SPCHANGE <= i_INSTRUCTION[7:6] == 0 ? 0 : -1;
			I_IF, I_WRT:
				o_SPCHANGE <= -2;
			I_JUMP, I_DROP, I_RW:
				o_SPCHANGE <= -1;
			I_DUP, I_OVER, I_RR:
				o_SPCHANGE <= +1;
			default:
				o_SPCHANGE <= +0;
		endcase
	end

	// o_MEMWRITE
	if (i_INSTRUCTION[15] == 0) begin
		o_MEMWRITE <= +1;
	end
	else begin
		case (i_INSTRUCTION[11:8]) 
			I_ALU, I_OVER, I_DUP, I_AT, I_WRT, I_RR:
				o_MEMWRITE <= 1;
			default:
				o_MEMWRITE <= 0;
		endcase
	end
	
	// o_MUXMEMDATA
	if (i_INSTRUCTION[15] == 0) begin
		o_MUXMEMDATA <= MMW_INSTRUCTION;
	end
	else begin
		case (i_INSTRUCTION[11:8]) 
			I_ALU:
				o_MUXMEMDATA <= MMW_ALURES;
			I_OVER, I_WRT:
				o_MUXMEMDATA <= MMW_OP2;
			I_DUP:
				o_MUXMEMDATA <= MMW_OP1;
			I_AT:
				o_MUXMEMDATA <= MMW_ATREAD;
			I_RR:
				o_MUXMEMDATA <= MMW_REGREAD;
			default:
				o_MUXMEMDATA <= MMW_OP1;
		endcase
	end
	
	// o_MUXMEMADDR
	if (i_INSTRUCTION[15] == 0) begin
		o_MUXMEMADDR <= 0;
	end
	else begin
		case (i_INSTRUCTION[11:8]) 
			I_WRT:
				o_MUXMEMADDR <= MMA_OP1;
			default:
				o_MUXMEMADDR <= 0;
		endcase
	end
	
	// o_REGREADADDR
	o_REGREADADDR <= i_INSTRUCTION[7:4];
	
	// o_REGWRITEADDR
	o_REGWRITEADDR <= i_INSTRUCTION[7:4];
	
	// o_REGWRITE
	if (i_INSTRUCTION[15] == 0) begin
		o_REGWRITE <= 0;
	end
	else begin
		case (i_INSTRUCTION[11:8]) 
			I_RW:
				o_REGWRITE <= 1;
			default:
				o_REGWRITE <= 0;
		endcase
	end
	
	// o_MUXJUMPADDR
	if (i_INSTRUCTION[15] == 0) begin
		o_MUXJUMPADDR <= MJA_PC;
	end
	else begin
		case (i_INSTRUCTION[11:8]) 
			I_JUMP:
				o_MUXJUMPADDR <= MJA_OP1;
			I_IF:
				o_MUXJUMPADDR <= MJA_OP2;
			I_HALT:
				o_MUXJUMPADDR <= MJA_HALT;
			default:
				o_MUXJUMPADDR <= MJA_PC;
		endcase
	end
	
end

endmodule
