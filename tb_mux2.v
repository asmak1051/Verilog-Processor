`timescale 1ns / 1ps

module tb_mux2 #(parameter N=4,W=3) (muxin,sel,muxout);
    input muxout;
    output sel;
    output muxin;
    reg [N*W-1:0] choicearray; //choicearray
    reg [$clog2(N)-1:0] sel; //sel
    reg [W-1:0] result; //result

    
    initial
    begin
        // $monitor ($time,, "Choicearray = %b Sel = %b result = %b",
        //choicearray,sel,result);
        
        //waveform
        //4 inputs, 3 bits wide
        choicearray = 12'b010000101110; sel = 2'b00;
        #10 sel = 2'b01;
        #10 sel = 2'b10;
        #10 sel = 2'b11;
        #100 $finish;
        end
endmodule
