`timescale 1ns / 1ps

//mux
module mux #(parameter N=4,W=3) (muxin,sel,muxout);
    //parameter N=4; //number of inputs
    //parameter W=3; //w bits wide inputs
    input [N*W-1:0] muxin;
    input [$clog2(N)-1:0] sel; //wire?
    output [W-1:0] muxout;

    assign muxout = muxin[sel*W+:W];
endmodule
