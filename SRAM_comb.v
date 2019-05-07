`timescale 1ns / 1ps

module SRAM_comb(wr_en,wr_data,addr,clk,cs,rd_data);
    parameter N=4;
    parameter W=4;
    parameter A=$clog2(N);
    input wr_en;
    input [W-1:0] wr_data;
    input [A-1:0] addr;
    input clk;
    input cs;
    output [W-1:0] rd_data;
    reg [W-1:0] mem_array [N-1:0];
    //change to combinational, use assign
    //add setup time delay
    //assign mem_array[addr] = (wr_en&&cs) ? wr_data : 1'b0;
    assign rd_data = (cs&&~wr_en) ? mem_array[addr] : 0;
    /*
    always @ (posedge clk)
    begin
        if(wr_en && cs) //means write NOT read
        begin
            mem_array[addr] <= wr_data;
        end
    end
*/
endmodule
