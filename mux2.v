`timescale 1ns / 1ps

module mux2 #(parameter N=4,W=3) (muxin,sel,muxout);
    //parameter N=4; //number of inputs
    //parameter W=3; //w bits wide inputs
    input [W-1:0] muxin [N-1:0];
    input [$clog2(N)-1:0] sel; //wire?
    output [W-1:0] muxout;

    assign muxout = muxin[sel];
endmodule
