`timescale 1ns / 1ps

module register(D,Q,clk,en,rst_n);
    parameter N=1;
    input [N-1:0] D;
    input clk;
    input en;
    input rst_n;
    output reg [N-1:0] Q;
    
    always @ (posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            Q<=0;
        end
        else if(en)
        begin
            Q<=D;
        end
    end
    
endmodule
