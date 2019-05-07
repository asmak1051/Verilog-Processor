`timescale 1ns / 1ps

//mux
module mux (choicearray,sel,result);
    parameter N=4; //number of choices
    parameter W=3; //w bits wide inputs
    input [N*W-1:0] choicearray;
    input [$clog2(N)-1:0] sel; //wire?
    output [W-1:0] result;

    assign result = choicearray[sel*W+:W];
endmodule



