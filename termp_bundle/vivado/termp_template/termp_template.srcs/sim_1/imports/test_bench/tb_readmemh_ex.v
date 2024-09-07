`timescale 1ns / 1ps

/*
    Takeaways
        - How to use $readmemh ($readmemb)
    Flow
        - create mem file & text file
        - write data into mem file & text file
        - read data from mem file & text file
        - check data
*/

module tb_readmemh_ex();
    parameter wr_txt_file_name = "D://tb_test//test_mem.txt";
    parameter wr_mem_file_name = "D://tb_test//test_mem.mem";
    parameter rd_txt_file_name = "D://tb_test//test_mem.txt";
    parameter rd_mem_file_name = "D://tb_test//test_mem.mem";
    parameter data_num = 64;
    
    integer fp_wr_t;
    integer fp_wr_m;
    integer fp_rd_t;
    integer fp_rd_m;
    integer r, i;
    
    reg [7:0] test_data;
    reg [7:0] buffer_m [0:data_num-1];
    reg [7:0] buffer_t [0:data_num-1];
    
    
    initial begin
        // generate mem file & text file
        fp_wr_m = $fopen(wr_mem_file_name, "w");
        if (!fp_wr_m) begin
            $display("failed to open file\n");
            $finish;
        end
        $display("*** mem file is created ***");
        
        fp_wr_t = $fopen(wr_txt_file_name, "w");
        if (!fp_wr_t) begin
            $display("failed to open file\n");
            $finish;
        end                
        $display("*** txt file is created ***");

        // generate sample data and write it into files
        test_data = 0;        
        for (i = 0; i < data_num; i = i + 1) begin
            $fwrite(fp_wr_m, "%h\n", test_data);
            $fwrite(fp_wr_t, "%h\n", test_data);
            test_data = test_data + 1;
            #1;
        end
        $display("*** writing the data is done ***");
        
        $fclose(fp_wr_m);
        $fclose(fp_wr_t);
        
        // open mem file
        fp_rd_m = $fopen(rd_mem_file_name, "r");
        if (!fp_wr_m) begin
            $display("failed to open file\n");
            $finish;
        end
        $display("*** mem file is opened ***");
        // open txt file
        fp_rd_t = $fopen(rd_txt_file_name, "r");
        if (!fp_wr_t) begin
            $display("failed to open file\n");
            $finish;
        end                
        $display("*** txt file is opened ***");
        
        // read mem file
        $readmemh(rd_mem_file_name, buffer_m);
        $display("*** mem file is read ***");
        // read txt file
        $readmemh(rd_txt_file_name, buffer_t);
        $display("*** txt file is read ***");
        
        // check buffer
        for (i = 0; i < data_num; i = i + 1) begin
            $display("buffer_m[%h] = %h \t buffer_t[%h] = %h", i, buffer_m[i], i, buffer_t[i]);
            #1;
        end
        $display("*** print buffer is done ***");
        
        $stop;
    end

endmodule
