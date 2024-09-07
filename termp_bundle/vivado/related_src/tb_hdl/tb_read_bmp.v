`timescale 1ns / 1ps

/*
    Takeaways
        - How to read bmp file
        - How to use $fread
    Flow
        - open bmp file
        - read header data & image data
        - check each data
*/

module tb_read_bmp();

    parameter rd_file_name = "D://tb_test//lenna_256.bmp";
    parameter header_size = 54;
    parameter img_size = (256 * 256 * 3);
    
    integer fp_rd;
    integer r, i, j, k;
    
    reg [7:0] header_rd [53:0];
    reg [7:0] img_data_rd [(img_size-1):0];
    reg [7:0] tmp_byte_data;
    
    initial begin
        // open bmm file
        fp_rd = $fopen(rd_file_name, "rb");
        if (!fp_rd) begin
            $display("read bmp file open error\n");
            $finish;
        end
        $display("*** %s file opend ***", rd_file_name);
        
        // read header information
        for (i = 0; i < header_size; i = i + 1) begin
            r = $fread(tmp_byte_data, fp_rd);
            header_rd[i] = tmp_byte_data;
            #1;
        end
        $display("*** header data is read ***");
        
        // read image data
        for (i = 0; i < img_size; i = i + 1) begin
            r = $fread(tmp_byte_data, fp_rd);
            img_data_rd[i] = tmp_byte_data;
            #1;
        end
        $display("*** image data is read ***");
        
        // check header data
        $display("*** check header data ***");
        for (i = 0; i < header_size; i = i + 1) begin
            $display("header[%2h] = %h", i, header_rd[i]);
            #1;
        end
        
        // check some of image data
        $display("*** check front image data ***");
        for (i = 0; i < 8; i = i + 1) begin
            $display("img_data_rd[%2h] = %h", i, img_data_rd[i]);
            #1;
        end
        
        $display("*** check back image data ***");
        for (i = (img_size - 8); i < img_size; i = i + 1) begin
            $display("img_data_rd[%2h] = %h", i, img_data_rd[i]);
            #1;
        end
        
        $fclose(fp_rd);
        $stop;
    end



endmodule
