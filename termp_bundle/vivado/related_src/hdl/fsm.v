module fsm(
    input wire clk,
    input wire rst_n,
    // TOP interface
    input wire start_i,
    output wire run_o,
    output reg done_o,
    output reg done_led_o,
    // ROM_RD interface
    input wire rom_rd_valid_i,
    output wire rom_rd_done_o,
    output wire ds_run_o,
    // DS interface
    input wire ds_done_i,
    // US interface
    output wire us_run_o,
    input wire us_done_i
    
);

/*
 / You have to wait enough time after finish up-sample
 / For example, you can wait around 1 sec by counting 33333300
*/
    

endmodule

