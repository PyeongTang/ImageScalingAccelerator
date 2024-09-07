`timescale 1ns / 1ps

/*
    Takeaways
        - How to use $fscanf
    Flow
        - Read data from text files
        - Check data
*/

module tb_fscanf_ex();

    parameter binary_rd_file_name = "D://tb_test//test_fwrite_b.txt";
    parameter decimal_rd_file_name = "D://tb_test//test_fwrite_d.txt";
    parameter hex_rd_file_name = "D://tb_test//test_fwrite_h.txt";
    
    integer fp_rd_b;
    integer fp_rd_d;
    integer fp_rd_h;
    integer r, i;
    integer data_num_b;
    integer data_num_d;
    integer data_num_h;

    reg [31:0] tmp_data;
    reg [31:0] buffer_b [0:15];
    reg [31:0] buffer_d [0:15];
    reg [31:0] buffer_h [0:15];

    initial begin 
        // open text files
        fp_rd_b = $fopen(binary_rd_file_name, "r");
        if (!fp_rd_b) begin
            $display("failed to open file\n");
            $finish;
        end

        fp_rd_d = $fopen(decimal_rd_file_name, "r");
        if (!fp_rd_d) begin
            $display("failed to open file\n");
            $finish;
        end

        fp_rd_h = $fopen(hex_rd_file_name, "r");
        if (!fp_rd_h) begin
            $display("failed to open file\n");
            $finish;
        end
        $display("*** txt files are opened ***");


        // read data until to reach the last data
        i = 0;
        while(!$feof(fp_rd_b)) begin
            r = $fscanf(fp_rd_b, "%b\n", tmp_data);
            buffer_b[i] = tmp_data;
            i = i + 1;
            #1;
        end
        data_num_b = i;
        
        i = 0;
        while(!$feof(fp_rd_d)) begin
            r = $fscanf(fp_rd_d, "%d\n", tmp_data);
            buffer_d[i] = tmp_data;
            i = i + 1;
            #1;
        end
        data_num_d = i;
        
        i = 0;
        while(!$feof(fp_rd_h)) begin
            r = $fscanf(fp_rd_h, "%h\n", tmp_data);
            buffer_h[i] = tmp_data;
            i = i + 1;
            #1;
        end
        data_num_h = i;
        $display("*** reading the data is done ***");
        
        // print the data
        $display("*** print all the data ***");
        $display("*** Binary ***");
        for (i = 0; i < data_num_b; i = i + 1) begin
            $display("buffer_b[%2h] = %b", i, buffer_b[i]);
            #1;
        end
        $display("*** Decimal ***");
        for (i = 0; i < data_num_d; i = i + 1) begin
            $display("buffer_d[%2h] = %d", i, buffer_d[i]);
            #1;
        end
        $display("*** Hex ***");
        for (i = 0; i < data_num_h; i = i + 1) begin
            $display("buffer_h[%2h] = %h", i, buffer_h[i]);
            #1;
        end
        $display("*** done ***");

        $fclose(fp_rd_b);
        $fclose(fp_rd_d);
        $fclose(fp_rd_h);
        
        $stop;
    end

endmodule