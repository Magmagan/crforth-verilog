
module CPU(
    input wire clk
);

wire w_cyclex;
wire w_cycley;
wire w_cyclez;

ClockDivisor divisor(clk, w_cyclex, w_cycley, w_cyclez);

wire [15:0] w_mem_raddr;
wire [15:0] w_mem_waddr;
wire [15:0] w_mem_data;
wire [15:0] w_op1;
wire [15:0] w_op2;

Memory memory (w_cyclex, w_cycley, w_cyclez, w_mem_raddr, w_mem_waddr, w_mem_data, w_op1, w_op2);

wire [3:0] w_reg_raddr;
wire [3:0] w_reg_waddr;
wire [15:0] w_reg_data;

Registers bank(w_cyclex, w_cycley, w_cyclez);








endmodule