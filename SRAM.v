`timescale 1ns / 1ps

module SRAM #(parameter N=4,W=4) (wr_en,wr_data,addr,clk,cs,rd_data);
    //parameter N=4;
    //parameter W=4;
    parameter A=$clog2(N);
    input wr_en;
    input [W-1:0] wr_data;
    input [A-1:0] addr;
    input clk;
    input cs;
    output [W-1:0] rd_data;
    reg [W-1:0] mem_array [N-1:0];
    reg [A-1:0] addr_q;
    //change to combinational, use assign
    //add setup time delay
    //assign mem_array[addr] = (wr_en&&cs) ? wr_data : 0;
    
    assign #5 rd_data = mem_array[addr_q];
    
    
    always @ (posedge clk)
    begin
        if(cs)
        begin
            addr_q<=addr;
        end
        if(wr_en && cs) //means write NOT read
        begin
            mem_array[addr] <= wr_data;
        end
    end

endmodule
