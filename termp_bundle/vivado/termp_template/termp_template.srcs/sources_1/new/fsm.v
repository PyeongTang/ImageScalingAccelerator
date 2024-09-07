module fsm #(
    parameter       [24 : 0] WAIT_DELAY = 25'h1FCA034
)(
    // TOP interface
    input   wire    clk,
    input   wire    rst_n,

    input   wire    start_i,
    output  wire    run_o,
    output  wire    done_o,
    output  wire    done_led_o,
    
    // DS interface
    input   wire    ds_done_i,
    output  wire    ds_run_o,

    // US interface
    input   wire    us_store_done_i,
    output  wire    us_store_o,

    input   wire    us_write_done_i,
    output  wire    us_write_o,

    // Memory interface
    output  wire    rom_rd_done_o,
    output  wire    ram_wr_done_o
);

/*
 / You have to wait enough time after finish up-sample
 / For example, you can wait around 1 sec by counting 33333300
*/

    parameter   [2 : 0]     IDLE        =   3'h0;
    parameter   [2 : 0]     ROM_DS      =   3'h1;
    parameter   [2 : 0]     US_RAM      =   3'h2;
    parameter   [2 : 0]     WAIT        =   3'h3;
    parameter   [2 : 0]     DONE        =   3'h4;
    parameter   [24 : 0]    SEC         =   WAIT_DELAY;

    reg [2 : 0]     present_state;
    reg [2 : 0]     next_state;

    // TOP
    reg             r_run;
    reg             r_done;
    reg             r_done_led;

    // DS
    reg             r_ds_run;

    // US
    reg             r_us_write;
    reg             r_us_store;

    // Mem
    reg             r_rom_rd_done;
    reg             r_ram_wr_done;

    reg [24 : 0]    r_count;
    wire            w_count_done;

    // State transition
    always @(posedge clk) begin
        if (~rst_n) begin
            present_state <= IDLE;
        end
        else begin
            present_state <= next_state;
        end
    end

    // determine next state
    always @(*) begin
        if (~rst_n) begin
            next_state = IDLE;
        end
        else begin
            case (present_state)
                IDLE    : begin
                    if (start_i) begin
                        next_state = ROM_DS;
                    end
                    else begin
                        next_state = IDLE;
                    end
                end
                ROM_DS      : begin
                    if (ds_done_i) begin
                        next_state = WAIT;
                    end
                    else if (us_store_done_i) begin
                        next_state = US_RAM;
                    end
                    else begin
                        next_state = ROM_DS;
                    end
                end
                US_RAM      : begin
                    if (us_write_done_i) begin
                        next_state = ROM_DS;
                    end
                    else begin
                        next_state = US_RAM;
                    end
                end
                WAIT    : begin
                    if (w_count_done) begin
                        next_state  = DONE;
                    end
                    else begin
                        next_state = WAIT;
                    end
                end
                DONE    : begin
                    if (start_i) begin
                        next_state = IDLE;
                    end
                    else begin
                        next_state = DONE;
                    end
                end
                default: next_state = IDLE;
            endcase
        end
    end

    // determine output signal
    always @(*) begin
       if (~rst_n) begin
            r_run                   =   0;
            r_done                  =   0;
            r_done_led              =   0;
            r_ds_run                =   0;
            r_us_store              =   0;
            r_us_write              =   0;
            r_rom_rd_done           =   0;
            r_ram_wr_done           =   0;
       end
       else begin
            case (present_state)
            
                IDLE    : begin
                    r_run                   =   0;
                    r_done                  =   0;
                    r_done_led              =   0;
                    r_ds_run                =   0;
                    r_us_store              =   0;
                    r_us_write              =   0;
                    r_rom_rd_done           =   1;
                    r_ram_wr_done           =   1;
                end

                ROM_DS      : begin
                    r_run                   =   1;
                    r_done                  =   0;
                    r_done_led              =   0;
                    r_ds_run                =   1;
                    r_us_store              =   1;
                    r_us_write              =   0;
                    r_rom_rd_done           =   0;
                    r_ram_wr_done           =   0;
                end

                US_RAM      : begin
                    r_run                   =   1;
                    r_done                  =   0;
                    r_done_led              =   0;
                    r_ds_run                =   0;
                    r_us_store              =   0;
                    r_us_write              =   1;
                    r_rom_rd_done           =   0;
                    r_ram_wr_done           =   0;
                end

                WAIT    : begin
                    r_run                   =   1;
                    r_done                  =   0;
                    r_done_led              =   1;
                    r_ds_run                =   0;
                    r_us_store              =   0;
                    r_us_write              =   0;
                    r_rom_rd_done           =   1;
                    r_ram_wr_done           =   1;
                end

                DONE    : begin
                    r_run                   =   0;
                    r_done                  =   1;
                    r_done_led              =   1;
                    r_ds_run                =   0;
                    r_us_store              =   0;
                    r_us_write              =   0;
                    r_rom_rd_done           =   1;
                    r_ram_wr_done           =   1;
                end

                default: begin
                    r_run                   =   0;
                    r_done                  =   0;
                    r_done_led              =   0;
                    r_ds_run                =   0;
                    r_us_store              =   0;
                    r_us_write              =   0;
                    r_rom_rd_done           =   1;
                    r_ram_wr_done           =   1;
                end
            endcase
       end 
    end
    
    assign run_o            =   r_run;
    assign done_o           =   r_done;
    assign done_led_o       =   r_done_led;
    assign ds_run_o         =   r_ds_run;
    assign us_store_o       =   r_us_store;
    assign us_write_o       =   r_us_write;
    assign rom_rd_done_o    =   r_rom_rd_done;
    assign ram_wr_done_o    =   r_ram_wr_done;

    // Count in wait state
    always @(posedge clk) begin
       if (~rst_n) begin
            r_count <= 25'h0;
       end 
       else begin
            if (present_state == WAIT) begin
                if (r_count == (SEC - 25'h1)) begin
                    r_count <= 25'h0;
                end
                else begin
                    r_count <= r_count + 25'h1;
                end 
            end
            else begin
                r_count <= 25'h0;
            end 
       end
    end
    assign w_count_done = (r_count == (SEC - 25'h1)) ? 1'b1 : 1'b0;

endmodule

