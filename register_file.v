`timescale 1ns / 1ps


module register_file(wr_data1,wr_en1,wr_addr1,wr_data2,wr_en2,wr_addr2,rd_data1,rd_addr1,rd_data2,rd_addr2,clk,rst_n);
    parameter W=1;
    parameter N=1; //number of register in rf
    parameter A=$clog2(N);
    input [W-1:0] wr_data1;
    input [A-1:0] wr_addr1;
    input wr_en1;
    input [W-1:0] wr_data2;
    input [A-1:0] wr_addr2;
    input wr_en2;
    input clk;
    input rst_n;
    input [A-1:0] rd_addr1;    
    input [A-1:0] rd_addr2;
    output [W-1:0] rd_data1;
    output [W-1:0] rd_data2;

    reg [W-1:0] reg_array [N-1:0];
    integer i;
    /*
    always @ (posedge clk or negedge rst_n)
    begin
        if(rst_n)
        begin
            
        end
        else
        begin
            rd_data1 <= 0; //make combinational
            rd_data2 <= 0;
        end
    end
    */
    assign rd_data1 = reg_array[rd_addr1];
    assign rd_data2 = reg_array[rd_addr2];
    
    always @ (posedge clk or negedge rst_n)
    begin
        if(~rst_n) //clear reg_array
        begin
            for(i=0;i<N;i=i+1)
            begin
                reg_array[i] <= 0;
            end
        end
        
        else //write data
        begin
            if(wr_en1 & wr_en2 & (wr_addr1==wr_addr2))
            begin
                //mux([wr_data1,wr_data2],0,resultingdata)
                reg_array[wr_addr1] <= wr_data1;
            end
            else
            begin
                if(wr_en1)
                begin
                    reg_array[wr_addr1] <= wr_data1;
                end
                if(wr_en2)
                begin
                    reg_array[wr_addr2] <= wr_data2;
                end
            end
        end  
    end
endmodule
