`timescale 1ns / 1ps

/*
    Takeaways
        - How to copy bmp file
    Flow
        - open bmp file
        - read header data & image data
        - copy it into new bmp file
*/

module tb_copy_bmp();

    parameter rd_file_name = "D://tb_test//lenna_256.bmp";
    parameter wr_file_name = "D://tb_test//lanna_copied.bmp";
    parameter header_size = 54;
    parameter img_size = (256 * 256 * 3);
    
    integer fp_rd, fp_wr;
    integer r, i, j, k;
    
    reg [7:0] header_rd [53:0];
    reg [7:0] header_wr [53:0];
    reg [7:0] img_data_rd [(img_size-1):0];
    reg [7:0] img_data_wr [(img_size-1):0];
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
        end
        $display("*** header data is read ***");
        
        // read image data
        for (i = 0; i < img_size; i = i + 1) begin
            r = $fread(tmp_byte_data, fp_rd);
            img_data_rd[i] = tmp_byte_data;
        end
        $display("*** image data is read ***");
        
        // copy data
        for (i = 0; i < header_size; i = i + 1) begin
            header_wr[i] = header_rd[i];
        end
        $display("*** header data is copied ***");
        
        for (i = 0; i < img_size; i = i + 1) begin
            img_data_wr[i] = img_data_rd[i];
        end
        $display("*** image data is copied ***");
        
        // create new bmp file
        fp_wr = $fopen(wr_file_name, "wb");
        if (!fp_rd) begin
            $display("read bmp file open error\n");
            $finish;
        end
        $display("*** %s file opend ***", rd_file_name);
        
        // write copied header data
        for (i = 0; i < header_size; i = i + 1) begin
           $fwrite(fp_wr, "%c", header_wr[i]);
        end
        $display("*** header data is written ***", rd_file_name);
        
        // write copied image data
        for (i = 0; i < img_size; i = i + 1) begin
            $fwrite(fp_wr, "%c", img_data_rd[i]);
        end
        $display("*** image data is written ***", rd_file_name);
        
        
        $display("*** done ***");
        $fclose(fp_rd);
        $fclose(fp_wr);
        $stop;
    end



endmodule
