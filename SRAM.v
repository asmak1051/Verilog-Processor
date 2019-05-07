`timescale 1ns / 1ps

module SRAM(wr_en,wr_data,addr,clk,cs,rd_data);
    parameter N=4;
    parameter W=4;
    parameter A=$clog2(N);
    input wr_en;
    input [W-1:0] wr_data;
    input [A-1:0] addr;
    input clk;
    input cs;
    output reg [W-1:0] rd_data;
    reg [W-1:0] mem_array [N-1:0];
    //change to combinational, use assign
    //add setup time delay
    always @ (posedge clk)
    begin
        if(wr_en && cs) //means write NOT read
        begin
            mem_array[addr] <= wr_data;
        end
    end
    always @ (posedge clk)
    begin
        if(cs && ~wr_en)
        begin
           #5 assign rd_data = mem_array[addr]; //rd_data must be reg //#time
           //#5 rd_data <= mem_array[addr];
        end
        else
        begin
            rd_data <= 0;
        end
    end
endmodule
