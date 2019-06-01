`timescale 1ns / 1ps


module test_sequence();
parameter T=5; //number of addresses to test
reg clk;
reg [1:0] address;
reg [1:0] data;
reg [1:0] expected;
reg point;
include "master.v"

address={"0","1"};
data={'1','1'};
//initial
//begin

genvar i;
generate
for(i=0;i<T;i=i+1) //for each master
begin
    master.write(address[i],data[i]);
    master.readcompare(addresss[i],expected[i]);
    if(expected[i]==data[i])
    begin
        point=point+1;
    end
end
endgenerate

//end

always
#5 clk=~clk;


endmodule
