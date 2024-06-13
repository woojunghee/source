// ------------------------------------------------------------------------------------------------
//     COPYRIGHT 2008-2013, TRILINEAR TECHNOLOGIES, INC.
//     
//     THE SOURCE CODE CONTAINED HEREIN IS PROVIDED ON AN "AS IS" BASIS.
//     TRILINEAR TECHNOLOGIES, INC. DISCLAIMS ANY AND ALL WARRANTIES, 
//     WHETHER EXPRESS, IMPLIED, OR STATUTORY, INCLUDING ANY IMPLIED
//     WARRANTIES OF MERCHANTABILITY OR OF FITNESS FOR A PARTICULAR PURPOSE.
//     IN NO EVENT SHALL TRILINEAR TECHNOLOGIES, INC. BE LIABLE FOR ANY
//     INCIDENTAL, PUNITIVE, OR CONSEQUENTIAL DAMAGES OF ANY KIND WHATSOEVER
//     ARISING FROM THE USE OF THIS SOURCE CODE.
//     
//     THIS DISCLAIMER OF WARRANTY EXTENDS TO THE USER OF THIS SOURCE CODE
//     AND USER'S CUSTOMERS, EMPLOYEES, AGENTS, TRANSFEREES, SUCCESSORS,
//     AND ASSIGNS.
//     
//     THIS IS NOT A GRANT OF PATENT RIGHTS
// ------------------------------------------------------------------------------------------------
//     DESCRIPTION : Clock generator module for top level test bench simulation
// ------------------------------------------------------------------------------------------------

// ----------------------------------------------
//  directives
// ----------------------------------------------
`default_nettype none
`timescale 1ps/1ps

// ----------------------------------------------
//  includes
// ----------------------------------------------

// ----------------------------------------------
//  module declaration
// ----------------------------------------------
module vm_clkgen
(
    output reg      clk_0,                      // clock 0
    output reg      clk_1,                      // clock 1
    output reg      clk_2,                      // clock 2
    output reg      clk_3                       // clock 3

);

    // ------------------------------------------------------------------------------------------------------------
    //                                          internal definitions
    // ------------------------------------------------------------------------------------------------------------
    integer     clk_period_0;                   // clock 0 period in ps
    integer     clk_period_1;                   // clock 0 period in ps
    integer     clk_period_2;                   // clock 0 period in ps
    integer     clk_period_3;                   // clock 0 period in ps

    // ------------------------------------------------------------------------------------------------------------
    //                                          initial clock period
    // ------------------------------------------------------------------------------------------------------------
    initial begin : ClkPeriod
        // clock period values
        clk_period_0 = 10000;
        clk_period_1 = 10000;
        clk_period_2 = 10000;
        clk_period_3 = 10000;
        // clock signals
        clk_0 = 1'b0;
        clk_1 = 1'b0;
        clk_2 = 1'b0;
        clk_3 = 1'b0;
    end // ClkPeriod

    // ------------------------------------------------------------------------------------------------------------
    //                                          clock assignments
    // ------------------------------------------------------------------------------------------------------------
    always #(clk_period_0 / 2) clk_0 <= ~clk_0;
    always #(clk_period_1 / 2) clk_1 <= ~clk_1;
    always #(clk_period_2 / 2) clk_2 <= ~clk_2;
    always #(clk_period_3 / 2) clk_3 <= ~clk_3;

    // ------------------------------------------------------------------------------------------------------------
    //                                          task to change the clock period
    // ------------------------------------------------------------------------------------------------------------
    task set_period;
        input integer clk_num;
        input integer new_period;
    begin
        case (clk_num)
            0:  clk_period_0 = new_period;
            1:  clk_period_1 = new_period;
            2:  clk_period_2 = new_period;
            3:  clk_period_3 = new_period;
            default: begin
                $display("vm_clkgen - invalid clock number specified");
            end // default
        endcase
    end endtask // set_period

    task set_freq;
        input integer clk_num;
        input integer new_frequency;
    begin
        case (clk_num)
            0:  clk_period_0 = (1000000000 / new_frequency);
            1:  clk_period_1 = (1000000000 / new_frequency);
            2:  clk_period_2 = (1000000000 / new_frequency);
            3:  clk_period_3 = (1000000000 / new_frequency);
            default: begin
                $display("vm_clkgen - invalid clock number specified");
            end // default
        endcase
        $display("vm_clkgen - Clock period %1d set to %6d", clk_num, new_frequency);
    end endtask // set_freq

    function integer get_freq;
        input integer clk_num;
    begin
        case (clk_num)
            0:  get_freq = 1000000000 / clk_period_0; 
            1:  get_freq = 1000000000 / clk_period_1; 
            2:  get_freq = 1000000000 / clk_period_2; 
            3:  get_freq = 1000000000 / clk_period_3;
            default: $display("vm_clkgen - invalid clock number specified");
        endcase
    end endfunction // get_freq

endmodule // vm_clkgen