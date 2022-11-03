`timescale 1ns/1ns

module top_tb;

/*
*****************************
*   Variable declarations   *
*****************************
*/


/*
*************************************
*   External Modules declarations   *
*************************************
*/


/*
*******************
*   Clock setup   *
*******************
*/
reg clk = 0;
always #1 clk = ~clk;

/*
********************************
*   Initial simulation setup   *
********************************
*/
initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);   // module to dump
        // Space for variable modification in simulation of module

            
        #10
        $finish;
    end
/*
************************
*   Other statements   *
************************
*/
endmodule