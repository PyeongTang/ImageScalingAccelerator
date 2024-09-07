module us #(
    parameter DATA_WIDTH = 24
)(
    // Top interface
    input       wire                                clk,
    input       wire                                rst_n,

    // FSM interface
    input       wire                                us_store_i,
    output      wire                                us_store_done_o,

    input       wire                                us_write_i,
    output      wire                                us_write_done_o,

    // DS interface
    input       wire                                ds_data_valid_i,
    input       wire        [DATA_WIDTH-1:0]        ds_data_i,

    // RAM_WR interface
    output      wire                                us_data_valid_o,
    output      wire        [DATA_WIDTH-1:0]        us_data_o
);
    localparam WIDTH = 256;

    // Counting number of data from ds module
    // store upto length of WIDTH
    reg [8 : 0] r_store_col_count;
    always @(posedge clk) begin
        if (~rst_n) begin
            r_store_col_count <= 0;
        end
        else begin
            if (us_store_i && ds_data_valid_i) begin
                if (r_store_col_count == (WIDTH-2)) begin
                    r_store_col_count <= 0;
                end
                else begin
                    r_store_col_count <= r_store_col_count + 2; 
                end
            end
        end
    end
    
    // Done flag of stored 2 rows of ds data
    reg r_us_store_done;
    always @(posedge clk) begin
        if (~rst_n) begin
            r_us_store_done <= 0;
        end
        else begin
            if (r_store_col_count == (WIDTH-2)) begin
                r_us_store_done <= 1;
            end
            else begin
                r_us_store_done <= 0;
            end 
        end
    end

    // Do up-scale from ds data,
    // for 2 rows consists uppper and lower one
    reg [DATA_WIDTH-1 : 0] r_us_data_upper [0 : WIDTH - 1];
    reg [DATA_WIDTH-1 : 0] r_us_data_lower [0 : WIDTH - 1];
    // reg [DATA_WIDTH-1 : 0] r_us_data [0 : WIDTH - 1];

    integer col;
    always @(posedge clk) begin
        if (~rst_n) begin
            for (col = 0; col < WIDTH; col = col + 1) begin
                r_us_data_upper[col] <= 24'h0;
                r_us_data_lower[col] <= 24'h0;
                // r_us_data[col] <= 24'h0;
            end
        end
        else begin
            if (us_store_i && ds_data_valid_i) begin
                r_us_data_upper[r_store_col_count + 0] <= ds_data_i;
                r_us_data_upper[r_store_col_count + 1] <= ds_data_i;
                r_us_data_lower[r_store_col_count + 0] <= ds_data_i;
                r_us_data_lower[r_store_col_count + 1] <= ds_data_i;
                // r_us_data[r_store_col_count + 0] <= ds_data_i;
                // r_us_data[r_store_col_count + 1] <= ds_data_i;
            end
        end
    end

    // Counting number of data wrote
    // as datas of 2 row are same, r_row_count acts like a toggle switch
    // write upper row of up-scaled image if r_row_count is 0, write lower row if it's 1
    reg         r_write_row_count;
    reg [8 : 0] r_write_col_count;

    always @(posedge clk) begin
        if (~rst_n) begin
            r_write_row_count <= 0;
            r_write_col_count <= 0;
        end
        else begin
            if (us_write_i) begin
                r_write_col_count <= r_write_col_count + 1;
                if (r_write_col_count == WIDTH - 1) begin
                    r_write_col_count <= 0;
                    r_write_row_count <= 1;
                end
            end
            else begin
                r_write_col_count <= 0;
                r_write_row_count <= 0;
            end
        end
    end

    // Determine temporary up-scaled data that is gonna be transfered to the RAM
    reg [DATA_WIDTH-1 : 0]  r_temp_upsampled_data;
    reg                     r_us_data_valid;
    always @(posedge clk) begin
        if (~rst_n) begin
            r_temp_upsampled_data       <=  24'h0;
            r_us_data_valid             <=  0;
        end
        else begin
            if (us_write_i) begin
                if (r_write_row_count == 0) begin
                    r_temp_upsampled_data       <=  {r_us_data_upper[r_write_col_count][7 : 0], r_us_data_upper[r_write_col_count][15 : 8], r_us_data_upper[r_write_col_count][23 : 16]};
                    r_us_data_valid             <=  1;
                end
                else if (r_write_row_count == 1) begin
                    r_temp_upsampled_data       <=  {r_us_data_lower[r_write_col_count][7 : 0], r_us_data_lower[r_write_col_count][15 : 8], r_us_data_lower[r_write_col_count][23 : 16]};
                    r_us_data_valid             <=  1;
                end
                // r_temp_upsampled_data       <=  {r_us_data[r_write_col_count][7 : 0], r_us_data[r_write_col_count][15 : 8], r_us_data[r_write_col_count][23 : 16]};
                // r_us_data_valid             <=  1;
            end
            else begin
                r_temp_upsampled_data       <=  24'h0;
                r_us_data_valid             <=  0;
            end
        end
    end

    assign us_data_valid_o  =   r_us_data_valid;
    assign us_data_o        =   r_temp_upsampled_data;
    assign us_write_done_o  =   ((r_write_col_count == WIDTH - 1) && (r_write_row_count == 1)) ? 1'b1 : 1'b0;
    assign us_store_done_o  =   r_us_store_done;

endmodule
