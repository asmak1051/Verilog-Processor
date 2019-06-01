`timescale 1ns / 1ps

module master #(parameter W=1,A=1) (
    input clk,
    input addr_rdy,
    input cmd_rdy,
    input wr_rdy,
    input [W-1:0] rd_data,
    input rd_val,
    output reg [A-1:0] addr,
    output reg addr_val,
    output reg cmd,
    output reg cmd_val,
    output reg [W-1:0] wr_data,
    output reg wr_val,
    output reg rd_rdy
    );
    reg test_passed;
    //
    task write;
    input address;
    input data;
    begin
        @ (posedge clk)
        begin
            addr_val <= #1 1;
            addr <= #1 address;
            cmd <= #1 1;
            cmd_val <= #1 1;
            wr_val <= #1 1;
            wr_data <= #1 data;
        end
        fork
            begin
                wait(addr_rdy);
                @ (posedge clk)
                    begin
                        addr_val <= #1 0;
                        addr <= #1 'bx; //check
                    end
                        
            end
            
            begin
                wait(cmd_rdy);
                @ (posedge clk)
                    begin
                        cmd_val <= #1 0;
                        cmd <= #1 'bx; //check
                    end
                        
            end    
                    
            begin
                wait(wr_rdy);
                @ (posedge clk)
                    begin
                        wr_val <= #1 0;
                        wr_data <= #1 'bx; //check
                    end
                        
            end
        join
        
            /*
            if(addr_rdy) 
            begin
                addr<=address; 
                addr_val<=1;
            end
            if(cmd_rdy)
                cmd<=1;
                cmd_val<=1;
            if(wr_rdy)
            begin
                wr_data<=data;
                wr_val<=1; 
            end
            //if(rd_val) rd_rdy<=0;
        end*/
    end
        
    endtask
    
    
    
    task readcompare;
    input address;
    input expected;
    
    begin
        @ (posedge clk)
        begin
            if(addr_rdy) 
            begin
                addr<=address; 
                addr_val<=1;
            end
            if(cmd_rdy)
                cmd<=0; //read
                cmd_val<=1;
            if(rd_val)
            begin
                rd_rdy<=1; 
            end
        end
        
        if(expected==rd_data)
        begin
            test_passed=test_passed+1;
        end
    end
    endtask
        
endmodule
