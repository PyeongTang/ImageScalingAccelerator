module us #(
    parameter DATA_WIDTH = 24
)(
    input wire clk,
    input wire rst_n,
    // FSM interface
    input wire us_run_i,
    output wire us_done_o,
    // RAM_WR interface
    output wire us_data_valid_o,
    output wire [DATA_WIDTH-1:0] us_data_o,
    // DS interface
    input wire ds_data_valid_i,
    input wire [DATA_WIDTH-1:0] ds_data_i
);

    


endmodule
