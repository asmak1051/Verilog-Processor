`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2019 04:07:19 PM
// Design Name: 
// Module Name: counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module counter(init,clk,en,rst_n,done,count);
parameter M=6;
input clk;
input en;
input rst_n;
input [$clog2(M):0] init;
output reg [$clog2(M):0] count;
output reg done;

always @ (posedge clk or negedge rst_n) //sequential
begin
    if(~rst_n)
    begin
        done <= 0;
        count <= init;
        //done <= 0;
    end
    else
    begin
        if(en) 
        begin
            if (count>0)
            begin
                count <= count -1;
            end
            else
            begin
                count <=init;
            end
            if (count==1)
            begin
                done<=1;
            end
            else
            begin
                done <=0;
            end
        end        
    end
end

endmodule
