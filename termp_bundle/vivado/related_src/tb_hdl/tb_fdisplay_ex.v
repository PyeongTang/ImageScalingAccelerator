`timescale 1ns/1ps

/*
    Takeaways
        - How to open file and write the data into it
        - How to use $fopen, $fdisplay, $fclose
    Flow
        - Create text file
        - Write data into text file
*/

module tb_fdisplay_ex();
    parameter binary_wr_file_name = "D://tb_test//test_fdisplay_b.txt";
    parameter decimal_wr_file_name = "D://tb_test//test_fdisplay_d.txt";
    parameter hex_wr_file_name = "D://tb_test//test_fdisplay_h.txt";
    
    integer fp_wr_b;
    integer fp_wr_d;
    integer fp_wr_h;
    integer r, i;
    
    initial begin
        // create text files
        fp_wr_b = $fopen(binary_wr_file_name, "w");
        if (!fp_wr_b) begin
            $display("failed to open file\n");
            $finish;
        end

        fp_wr_d = $fopen(decimal_wr_file_name, "w");
        if (!fp_wr_d) begin
            $display("failed to open file\n");
            $finish;
        end

        fp_wr_h = $fopen(hex_wr_file_name, "w");
        if (!fp_wr_h) begin
            $display("failed to open file\n");
            $finish;
        end
        $display("*** txt files are created ***");
        
        // genearte sample data and write it into files
        for (i = 0; i < 16; i = i + 1) begin
            $fdisplay(fp_wr_b, "%b", i);
            $fdisplay(fp_wr_d, "%d", i);
            $fdisplay(fp_wr_h, "%h", i);
            #1;
        end
        $display("*** writing the data is done ***");
        
        $fclose(fp_wr_b);
        $fclose(fp_wr_d);
        $fclose(fp_wr_h);
        $stop;
    end
    

endmodule