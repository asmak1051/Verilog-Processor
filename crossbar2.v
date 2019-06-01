`timescale 1ns / 1ps


//number of crossbar outputs = 
//number of slave inputs per slave = 7
//number of master inputs per master = 5
//1 mux for each crossbar output
//number of crossbar outputs = 7*S + 5*M
//number of muxes = 7*S+5*M
//number muxes = M*MI+S*SI

module crossbar2 # (
    parameter A=1, //parameter A width of address
    W=1, //parameter W width of data
    M=3, //M=number of masters
    S=2, //S=number of slaves
    MI=5, //let MI=#masterinputs=5
    SI=7
    ) //SI=#slaveinputs=7
    (   //crossbar port module

    //first selectarray
    //width needed to select a master = [$clog2(M)-1:0]
    //select a slave width = [$clog2(S)-1:0]
    //select a master for a slave
    input [$clog2(M)*S-1:0] m_sel_array,
    //select a slave for a master
    input [$clog2(S)*M-1:0] s_sel_array,
    //what is in input list:
    //master outputs
    input [A*M-1:0] m_addr, //A bit wide address, M number of them
    input [W*M-1:0] m_wr_data,
    //rest of master outputs are 1 bit wide
    input [M-1:0] m_addr_val, //1 bit wide, M addr_vals
    input [M-1:0] m_cmd,
    input [M-1:0] m_cmd_val,
    input [M-1:0] m_wr_val,
    input [M-1:0] m_rd_rdy, //1 bit
    //slave outputs
    input [W*S-1:0] s_rd_data,
    //rest slave outputs are 1 bit wide
    input [S-1:0] s_addr_rdy,
    input [S-1:0] s_cmd_rdy,
    input [S-1:0] s_wr_rdy,
    input [S-1:0] s_rd_val,
    
    // all outputs of crossbar
    //inputs of slave 
    output [A*S-1:0] s_addr,
    output [W*S-1:0] s_wr_data,
    //rest 1 bit
    output [S-1:0]s_addr_val,
    output [S-1:0] s_cmd,
    output [S-1:0] s_cmd_val,
    output [S-1:0] s_wr_val,
    output [S-1:0] s_rd_rdy,
    //master inputs
    output [W*M-1:0] m_rd_data,
    //1 bit
    output [M-1:0] m_addr_rdy,
    output [M-1:0] m_cmd_rdy,
    output [M-1:0] m_wr_rdy,
    output [M-1:0] m_rd_val

);

//number muxes = M*MI+S*SI
//first do all crossbar outputs that go to master (master inputs)
//reg [$clog2(S)-1:0] s_sel;
genvar i;
generate
for(i=0;i<M;i=i+1) //for each master
begin
    //s_sel = s_sel_array[i*$clog2(S)+:$clog2(S)];
    //note same select goes to each mux (MI number of muxes)
    //note change mux to be 2D instead of long 1D
    mux #(.N(S),.W(W)) m_rd_data_mux(.muxin(s_rd_data),.sel(s_sel_array[i*$clog2(S)+:$clog2(S)]),.muxout(m_rd_data[i*W+:W]));
    mux #(.N(S),.W(1)) m_addr_rdy_mux(.muxin(s_addr_rdy),.sel(s_sel_array[i*$clog2(S)+:$clog2(S)]),.muxout(m_addr_rdy[i]));
    mux #(.N(S),.W(1)) m_cmd_rdy_mux(.muxin(s_cmd_rdy),.sel(s_sel_array[i*$clog2(S)+:$clog2(S)]),.muxout(m_cmd_rdy[i]));
    mux #(.N(S),.W(1)) m_wr_rdy_mux(.muxin(s_wr_rdy),.sel(s_sel_array[i*$clog2(S)+:$clog2(S)]),.muxout(m_wr_rdy[i]));
    mux #(.N(S),.W(1)) m_rd_val_mux(.muxin(s_rd_val),.sel(s_sel_array[i*$clog2(S)+:$clog2(S)]),.muxout(m_rd_val[i]));
end
endgenerate

//do all crossbar outputs that go to slaves (slave inputs)
genvar j;
generate
for(j=0;j<S;j=j+1) //for slave
begin
    //m_sel = m_sel_array[*$clog2(M)+:$clog2(M)];
    mux #(.N(M),.W(A)) s_addr_mux(.muxin(m_addr),.sel(m_sel_array[j*$clog2(M)+:$clog2(M)]),.muxout(s_addr[j*A+:A]));
    mux #(.N(M),.W(W)) s_wr_data_mux(.muxin(m_wr_data),.sel(m_sel_array[j*$clog2(M)+:$clog2(M)]),.muxout(s_wr_data[j*W+:W]));
    mux #(.N(M),.W(1)) s_addr_val_mux(.muxin(m_addr_val),.sel(m_sel_array[j*$clog2(M)+:$clog2(M)]),.muxout(s_addr_val[j]));
    mux #(.N(M),.W(1)) s_cmd_mux(.muxin(m_cmd),.sel(m_sel_array[j*$clog2(M)+:$clog2(M)]),.muxout(s_cmd[j]));
    mux #(.N(M),.W(1)) s_cmd_val_mux(.muxin(m_cmd_val),.sel(m_sel_array[j*$clog2(M)+:$clog2(M)]),.muxout(s_cmd_val[j]));
    mux #(.N(M),.W(1)) s_wr_val_mux(.muxin(m_wr_val),.sel(m_sel_array[j*$clog2(M)+:$clog2(M)]),.muxout(s_wr_val[j]));
    mux #(.N(M),.W(1)) s_rd_rdy_mux(.muxin(m_rd_rdy),.sel(m_rd_rdy[j*$clog2(M)+:$clog2(M)]),.muxout(s_rd_rdy[j]));
end
endgenerate

endmodule

/*
m_sel_array,s_sel_array,
m_addr,m_addr_val,m_cmd,m_cmd_val,m_wr_data,m_wr_val,m_rd_rdy, //master outputs
m_addr_rdy,m_cmd_rdy,m_wr_rdy,m_rd_data,m_rd_val, //master inputs
s_addr_rdy,s_cmd_rdy,s_wr_rdy,s_rd_data,s_rd_val, //slave outputs
s_addr,s_addr_val,s_cmd,s_cmd_val,s_wr_data,s_wr_val,s_rd_rdy //slave inputs
*/
