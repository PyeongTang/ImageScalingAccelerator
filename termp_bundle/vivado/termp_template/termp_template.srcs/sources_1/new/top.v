module top #(
    parameter           DATA_WIDTH  = 24,
    parameter           ADDR_WIDTH  = 16,
    parameter [24 : 0]  WAIT_DELAY  = 25'h1FCA034
)(
    // System interface
    input       wire                            clk,
    input       wire                            rst_n,

    // FSM interface
    input       wire                            start_i,
    output      wire                            run_o,
    output      wire                            done_o,
    output      wire                            done_led_o,

    // RAM interface
    output      wire    [31 : 0]                ram_addr_o,
    output      wire    [31 : 0]                ram_dout_o,
    output      wire                            ram_en_o,
    output      wire    [3 : 0]                 ram_wr_en_o,

    // Simulation
    output      wire    [DATA_WIDTH - 1 : 0]    test_us_data,
    output      wire                            test_us_data_valid
);
    
    // Block rom - rom read
    wire                        rom_en_w;
    wire    [ADDR_WIDTH-1:0]    rom_addr_w;
    wire    [DATA_WIDTH-1:0]    rom_dout_w;

    // rom read - fsm
    wire                        rom_rd_done_w;
    wire                        ds_run_w;

    // ram write - fsm
    wire                        ram_wr_done_w;

    // ds - fsm
    wire                        ds_done_w;

    // us - fsm
    wire                        us_write_w;
    wire                        us_store_w;
    wire                        us_write_done_w;
    wire                        us_store_done_w;

    // rom read - ds
    wire                        rd_data_valid_w;
    wire    [DATA_WIDTH-1:0]    rd_data_w;

    // ds - us
    wire                        ds_data_valid_w;
    wire    [DATA_WIDTH-1:0]    ds_data_w;

    // us - ram write
    wire                        us_data_valid_w;
    wire    [DATA_WIDTH-1:0]    us_data_w;    
    
    blk_rom rom_inst(
        .clka                   (clk),    
        .ena                    (rom_en_w),      
        .addra                  (rom_addr_w),  
        .douta                  (rom_dout_w)  
    );
    
    rom_rd #(
        .DATA_WIDTH             (DATA_WIDTH),
        .ADDR_WIDTH             (ADDR_WIDTH)
    ) rom_rd_inst(
        .clk                    (clk),
        .rst_n                  (rst_n),

        // FSM interface
        .rom_rd_en_i            (ds_run_w),
        .rom_rd_done_i          (rom_rd_done_w),
        
        // Rom interface
        .rom_en_o               (rom_en_w),
        .rom_addr_o             (rom_addr_w),
        .rom_din_i              (rom_dout_w),
        
        // DS interface
        .rom_dout_o             (rd_data_w),
        .rom_dout_valid_o       (rd_data_valid_w)
    );
    
    fsm #(
        .WAIT_DELAY             (WAIT_DELAY)
    )fsm_inst(
        .clk                    (clk),
        .rst_n                  (rst_n),

        // TOP interface
        .start_i                (start_i),
        .run_o                  (run_o),
        .done_o                 (done_o),
        .done_led_o             (done_led_o),

        // DS interface
        .ds_done_i              (ds_done_w),
        .ds_run_o               (ds_run_w),

        // US interface
        .us_store_done_i        (us_store_done_w),
        .us_write_done_i        (us_write_done_w),
        .us_store_o             (us_store_w),
        .us_write_o             (us_write_w),

        // Memory interface
        .rom_rd_done_o          (rom_rd_done_w),
        .ram_wr_done_o          (ram_wr_done_w)
    );
    
    ds #(
        .DATA_WIDTH(DATA_WIDTH)
    ) ds_inst(
        .clk                    (clk),
        .rst_n                  (rst_n),

        // FSM interface
        .ds_done_o              (ds_done_w),

        // ROM_RD interface
        .rd_data_valid_i        (rd_data_valid_w),
        .rd_data_i              (rd_data_w),

        // US interface
        .ds_data_valid_o        (ds_data_valid_w),
        .ds_data_o              (ds_data_w)
    );
    
    us #(
        .DATA_WIDTH(DATA_WIDTH)
    ) us_inst(
        .clk                    (clk),
        .rst_n                  (rst_n),

        // FSM interface
        .us_store_i             (us_store_w),
        .us_write_i             (us_write_w),
        .us_store_done_o        (us_store_done_w),
        .us_write_done_o        (us_write_done_w),

        // DS interface
        .ds_data_valid_i        (ds_data_valid_w),
        .ds_data_i              (ds_data_w),

        // RAM_WR interface
        .us_data_valid_o        (us_data_valid_w),
        .us_data_o              (us_data_w)
    );

    assign test_us_data         =   us_data_w;
    assign test_us_data_valid   =   us_data_valid_w;

    // Make bmp image file and write up-scaled data into it 
    parameter BMP_DIR = "C:/Users/qwer/Desktop/DSD_2022/lenna_from_verilog.bmp";
    parameter TXT_DIR = "C:/Users/qwer/Desktop/DSD_2022/lenna_from_verilog.txt";
    integer BMP_header [0 : 53];
    initial begin
        BMP_header[ 0] = 66;BMP_header[28] =24;
        BMP_header[ 1] = 77;BMP_header[29] = 0;
        BMP_header[ 2] = 54;BMP_header[30] = 0;
        BMP_header[ 3] =  0;BMP_header[31] = 0;
        BMP_header[ 4] =  3;BMP_header[32] = 0;
        BMP_header[ 5] =  0;BMP_header[33] = 0;
        BMP_header[ 6] =  0;BMP_header[34] = 0;
        BMP_header[ 7] =  0;BMP_header[35] = 0;
        BMP_header[ 8] =  0;BMP_header[36] = 3;
        BMP_header[ 9] =  0;BMP_header[37] = 0;
        BMP_header[10] = 54;BMP_header[38] = 0;
        BMP_header[11] =  0;BMP_header[39] = 0;
        BMP_header[12] =  0;BMP_header[40] = 0;
        BMP_header[13] =  0;BMP_header[41] = 0;
        BMP_header[14] = 40;BMP_header[42] = 0;
        BMP_header[15] =  0;BMP_header[43] = 0;
        BMP_header[16] =  0;BMP_header[44] = 0;
        BMP_header[17] =  0;BMP_header[45] = 0;
        BMP_header[18] =  0;BMP_header[46] = 0;
        BMP_header[19] =  1;BMP_header[47] = 0;
        BMP_header[20] =  0;BMP_header[48] = 0;
        BMP_header[21] =  0;BMP_header[49] = 0;
        BMP_header[22] =  0;BMP_header[50] = 0;
        BMP_header[23] =  1;BMP_header[51] = 0;	
        BMP_header[24] =  0;BMP_header[52] = 0;
        BMP_header[25] =  0;BMP_header[53] = 0;
        BMP_header[26] =  1;
        BMP_header[27] =  0;
    end
    integer bmp_fp, txt_fp;
    integer i;
    initial begin
        bmp_fp = $fopen(BMP_DIR, "wb+");
        txt_fp = $fopen(TXT_DIR, "wb+");
        for(i=0; i<54; i=i+1) begin
            $fwrite(bmp_fp, "%c", BMP_header[i][7:0]);
        end
    end
    always @(posedge clk) begin
       if (test_us_data_valid) begin
            $fwrite(bmp_fp, "%c", test_us_data[23 : 16]);
            $fwrite(bmp_fp, "%c", test_us_data[15 : 8]);
            $fwrite(bmp_fp, "%c", test_us_data[7 : 0]);
            $fdisplay(txt_fp, "%x,", test_us_data);
       end
       if (done_o) begin
            $fclose(bmp_fp);
            $fclose(txt_fp);
       end
    end
    
    ram_wr #(
        .DATA_WIDTH             (DATA_WIDTH)
    ) ram_wr_inst(
        .clk                    (clk),
        .rst_n                  (rst_n),
        
        // FSM interface
        .us_run_i               (us_write_w),

        // US interface
        .us_done_i              (ram_wr_done_w),
        .us_data_valid_i        (us_data_valid_w),
        .us_data_i              (us_data_w),

        // RAM interface
        .ram_addr_o             (ram_addr_o),
        .ram_dout_o             (ram_dout_o),
        .ram_en_o               (ram_en_o),
        .ram_wr_en_o            (ram_wr_en_o)
    );
    
    
endmodule
