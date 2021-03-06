module CPU(
    input  wire        clk,
	 input  wire [15:0] switches,
	 input  wire        iostate,
	 
    output wire        iotype,
    output wire        iopause,
	 output wire [15:0] debug0,
	 output wire [15:0] debug1,
	 output wire [15:0] debug2,
	 output wire [15:0] debug3,
    output wire [15:0] debug4
);

/*
#######################################################################
                                WIRING                                 
#######################################################################
*/

// ClockDivisor

wire w_cyclex;
wire w_cycley;
wire w_cyclez;
wire [1:0] w_cstate;
wire w_cucpause;
wire w_ciostate;

// Memory

wire [15:0] w_mem_raddr;
wire [15:0] w_mem_waddr;
wire [15:0] w_mem_rdata;
wire [15:0] w_mem_rdata2;
wire [15:0] w_mem_wdata;

// Registers

wire  [3:0] w_reg_waddr;
wire [15:0] w_reg_wdata;
wire [15:0] w_reg_wpcdata;
wire [15:0] w_reg_rdata;
wire        w_reg_ssr;
wire [15:0] w_reg_pc;
wire [15:0] w_reg_psp;
wire [15:0] w_reg_rsp;
wire [15:0] w_reg_ofr;
wire [15:0] w_reg_ior;

// ALU

wire [15:0] w_alu_rop1;
wire [15:0] w_alu_rop2;
wire [15:0] w_alu_result;

// Operands registers

wire [15:0] w_iop_setop1;
wire [15:0] w_iop_setop2;
wire [15:0] w_iop_op1;
wire [15:0] w_iop_op2;

// Instruction register

wire [15:0] w_iop_setins;
wire [15:0] w_iop_ins;

// Control unit

wire [15:0] w_cuc_instruction;
wire  [1:0] w_cuc_reg_setssr;
wire  [3:0] w_cuc_alu_control;
wire [15:0] w_cuc_reg_spchange;
wire        w_cuc_mem_write;
wire  [2:0] w_cuc_mux_memdata;
wire        w_cuc_mux_memaddr;
wire  [3:0] w_cuc_reg_raddr;
wire  [3:0] w_cuc_reg_waddr;
wire        w_cuc_reg_write;
wire  [1:0] w_cuc_mux_jumpaddr;
wire        w_cuc_iso_iotype;
wire        w_cuc_iso_iopause;

/*
#######################################################################
                                 MUXES                                 
#######################################################################
*/

wire [15:0] w_stack_address;
assign w_stack_address =  w_reg_ssr == 0 ? w_reg_psp : w_reg_rsp;

wire  [3:0] w_sp_register_address;
assign w_sp_register_address = w_reg_ssr == 0 ? 1 : 2;

wire [15:0] w_stack_new_value;
assign w_stack_new_value = w_stack_address + w_cuc_reg_spchange;

wire [15:0] w_mux_instruction;
assign w_mux_instruction = w_cyclex || (w_cstate == 2 && !w_cycley) ? w_mem_rdata
                                                                    : w_iop_ins;

wire [15:0] w_mux_op1;
assign w_mux_op1 = w_cycley || (w_cstate == 3 && !w_cyclez) ? w_mem_rdata
                                                            : w_iop_op1;

wire [15:0] w_mux_op2;
assign w_mux_op2 = w_cycley || (w_cstate == 3 && !w_cyclez) ? w_mem_rdata2
                                                            : w_iop_op2;

wire [15:0] w_mux_mem_wdata;
assign w_mux_mem_wdata = w_cuc_mux_memdata == 0 ? w_mux_instruction :
                         w_cuc_mux_memdata == 1 ? w_mux_op1         :
                         w_cuc_mux_memdata == 2 ? w_mux_op2         :
                         w_cuc_mux_memdata == 3 ? w_alu_result      :
                         w_cuc_mux_memdata == 4 ? w_mem_rdata       :
                         w_cuc_mux_memdata == 5 ? w_reg_rdata       :
                                                  w_mux_instruction ;

wire [15:0] w_mux_mem_waddr;
assign w_mux_mem_waddr = w_cuc_mux_memaddr == 0 ? w_stack_address
                                                : w_mux_op1;

wire [15:0] w_mux_mem_waddr_with_offset;
assign w_mux_mem_waddr_with_offset = w_mux_mem_waddr + w_reg_ofr;

wire [15:0] w_mux_jump_address;
assign w_mux_jump_address = w_cuc_mux_jumpaddr == 0 ? w_reg_pc + 1 :
                            w_cuc_mux_jumpaddr == 1 ? w_mux_op1 :
                            w_cuc_mux_jumpaddr == 2 ?
                                (w_mux_op2 == 0 ? w_mux_op1 : w_reg_pc + 1 )
                                                    : w_reg_pc;

wire [15:0] w_mux_mem_raddr;
assign w_mux_mem_raddr = w_cstate == 1 ? w_reg_pc :
                         w_cstate == 2 ? w_stack_address :
                         w_cstate == 3 ? w_mux_op1 
                                       : w_reg_pc;

wire [15:0] w_mux_mem_raddr_with_offset;
assign w_mux_mem_raddr_with_offset = w_mux_mem_raddr + w_reg_ofr;

wire [3:0] w_mux_reg_waddr;
assign w_mux_reg_waddr = w_cstate == 1 && w_cyclex || w_cstate == 2 && !w_cycley ? w_cuc_reg_waddr :
                         w_cstate == 2 && w_cycley || w_cstate == 3 && !w_cyclez ? w_sp_register_address :
                         w_cstate == 3 && w_cyclez || w_cstate == 1 && !w_cyclex ? w_cuc_reg_waddr 
                                                                                 : w_cuc_reg_waddr;

wire [15:0] w_mux_reg_wdata;
assign w_mux_reg_wdata = w_cstate == 1 && w_cyclex || w_cstate == 2 && !w_cycley ? w_mux_op1 :
                         w_cstate == 2 && w_cycley || w_cstate == 3 && !w_cyclez ? w_stack_new_value :
                         w_cstate == 3 && w_cyclez || w_cstate == 1 && !w_cyclex ? (w_cuc_iso_iopause ? switches : w_mux_op1 )
                                                                                 : w_mux_op1;

assign iotype  = w_cuc_iso_iotype;
assign iopause = w_cuc_iso_iopause;

assign w_ciostate = iostate;
assign w_cucpause = w_cuc_iso_iopause;

assign w_cuc_instruction = w_mux_instruction;

assign w_mem_raddr = w_mux_mem_raddr_with_offset;
assign w_mem_waddr = w_mux_mem_waddr_with_offset;
assign w_mem_wdata = w_mux_mem_wdata;

assign w_reg_waddr = w_mux_reg_waddr;
assign w_reg_wdata = w_mux_reg_wdata;
assign w_reg_wpcdata = w_mux_jump_address;

assign w_alu_rop1 = w_mux_op1;
assign w_alu_rop2 = w_mux_op2;

assign w_iop_setop1 = w_mux_op1;
assign w_iop_setop2 = w_mux_op2;

assign w_iop_setins = w_mux_instruction;

assign debug0 = w_reg_ior;
assign debug1 = w_reg_psp    [3:0];
assign debug2 = w_reg_psp    [7:4];
assign debug3 = w_reg_wpcdata[3:0];
assign debug4 = w_reg_wpcdata[7:4];

/*
#######################################################################
                                MODULES                                
#######################################################################
*/

ClockDivisor divisor (
    .i_CLOCK    (clk),
    .i_CUCPAUSE (w_cucpause),
    .i_IOSTATE  (w_ciostate),
    .o_CYCLEX   (w_cyclex),
    .o_CYCLEY   (w_cycley),
    .o_CYCLEZ   (w_cyclez),
    .o_STATE    (w_cstate)
);

Memory memory (
    .c_XCLOCK (w_cyclex),
    .c_YCLOCK (w_cycley),
    .c_ZCLOCK (w_cyclez),
    .i_RADDR  (w_mem_raddr),
    .i_WADDR  (w_mem_waddr),
    .i_DATA   (w_mem_wdata),
    .o_OP1    (w_mem_rdata),
    .o_OP2    (w_mem_rdata2),
    .f_WRITE  (w_cuc_mem_write)
);

Registers regbank (
    .c_CLOCKX  (w_cyclex),
    .c_CLOCKY  (w_cycley),
    .c_CLOCKZ  (w_cyclez),
    .c_STATE   (w_cstate),
    .i_SSRSet  (w_cuc_reg_setssr),
    .i_RADDR   (w_cuc_reg_raddr),
    .i_WADDR   (w_reg_waddr),
    .i_DATA    (w_reg_wdata),
    .f_WRITE   (w_cuc_reg_write),
    .i_PCDATA  (w_reg_wpcdata),
    .o_OUT     (w_reg_rdata),
    .o_SSR     (w_reg_ssr),
    .o_PC      (w_reg_pc),
    .o_PSP     (w_reg_psp),
    .o_RSP     (w_reg_rsp),
    .o_OfR     (w_reg_ofr),
    .o_IOR     (w_reg_ior)
);

ALU alu (
    .c_YCLOCK  (w_cycley),
    .i_OP1     (w_alu_rop1),
    .i_OP2     (w_alu_rop2),
    .o_RESULT  (w_alu_result),
    .f_aluctrl (w_cuc_alu_control)
);

OPRegs operands (
    .c_CLOCKY (w_cycley),
    .i_SETOP1 (w_iop_setop1),
    .i_SETOP2 (w_iop_setop2),
    .o_OP1    (w_iop_op1),
    .o_OP2    (w_iop_op2)
);

InstructionReg instructionreg (
    .c_CLOCKX         (w_cyclex),
    .i_SETINSTRUCTION (w_iop_setins),
    .o_INSTRUCTION    (w_iop_ins)
);

ControlUnit controlunit (
    .i_INSTRUCTION  (w_cuc_instruction),
    .o_SETSSR       (w_cuc_reg_setssr),
    .o_ALUCONTROL   (w_cuc_alu_control),
    .o_SPCHANGE     (w_cuc_reg_spchange),
    .o_MEMWRITE     (w_cuc_mem_write),
    .o_MUXMEMDATA   (w_cuc_mux_memdata),
    .o_MUXMEMADDR   (w_cuc_mux_memaddr),
    .o_REGREADADDR  (w_cuc_reg_raddr),
    .o_REGWRITEADDR (w_cuc_reg_waddr),
    .o_REGWRITE     (w_cuc_reg_write),
    .o_MUXJUMPADDR  (w_cuc_mux_jumpaddr),
	 .o_IOTYPE       (w_cuc_iso_iotype),
	 .o_IOPAUSE      (w_cuc_iso_iopause)
);

endmodule
