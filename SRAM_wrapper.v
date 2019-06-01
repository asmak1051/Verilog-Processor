`timescale 1ns / 1ps
//slave=SRAM_wrapper
module SRAM_wrapper #(parameter N=4,W=4) (
    //for SRAM
    input cmd, //same as wr_en
    input [W-1:0] wr_data,
    input [A-1:0] addr,
    input clk,
    //input cs, //same as addr_val?
    output reg [W-1:0] rd_data,
   
    //sram is missing: 
    input addr_val,
    input cmd_val,
    input wr_val,
    input rd_rdy,
    output reg addr_rdy,
    output reg cmd_rdy,
    output reg wr_rdy,
    output reg rd_val
    );
    parameter A=$clog2(N);
    wire cs; //input for SRAM


    always
    begin
       wait(addr_val)
       //@ (posedge clk)
           #5 assign addr_rdy=1;
    end
    
        always
    begin
       wait(cmd_val)
       //@ (posedge clk)
           #5 assign cmd_rdy=1;
    end
    
    always
    begin
       wait(wr_val)
       //@ (posedge clk)
           #5 assign wr_rdy=1;
    end    
    
    always
    begin
       wait(rd_rdy)
       //@ (posedge clk)
           #5 assign rd_val=1;
    end
    /*
    begin
        wait(addr_val)
            //@ (posedge clk)
                #5 assign addr_rdy=1;
        wait(cmd_val)
            //@ (posedge clk)
                #5 assign cmd_rdy=1;
        wait(wr_val)
            //@posedge clk
                #5 assign wr_rdy=1;
        wait(rd_rdy)
            //@ (posedge clk)
                #5 assign rd_val=1;
    
    end
    */
    
    
    always
    begin
        if(addr_rdy&&addr_val) #5 addr_rdy<=0;
        if(cmd_rdy&&cmd_val) #5 cmd_rdy<=0;
        //only care about wr when cmd=on;=
        if(wr_rdy&&wr_val) #5 wr_rdy<=0;
        //only care about rd when cmd=off
        if(~cmd)
        begin
            if(rd_val&&rd_rdy) #5 rd_val<=0;
        end
    end
    assign cs = addr_val&&cmd_val&&(wr_val||rd_rdy);
    SRAM SRAM_inst(.wr_en(cmd),.wr_data(wr_data),.addr(addr),.clk(clk),.cs(cs),.rd_data(rd_data));
        
endmodule


    /*
    always @ (posedge clk)
    begin
        assign addr_rdy = (addr_val) ? 1:0;
        assign cmd_rdy = (cmd_val) ? 1:0;
        assign wr_rdy = (wr_val) ? 1:0;
        assign rd_val = (rd_rdy) ? 1:0;
    end
    */
    
    /*
        assign addr_rdy=1;
        assign cmd_rdy=1;
        assign wr_rdy=1;//and rd_val=0?
        assign rd_val=0;
        //assign rd_val=1; */