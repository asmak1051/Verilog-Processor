`timescale 1ns / 1ps


//parameter A width of address
//parameter W width of data
//M=number of masters
//S=number of slaves
//number of crossbar outputs = 
//number of slave inputs per slave = 7
//number of master inputs per master = 5
//1 mux for each crossbar output
//number of crossbar outputs = 7*S + 5*M
//number of muxes = 7*S+5*M
//let MI=#masterinputs=5
//SI=#slaveinputs=7
//number muxes = M*MI+S*SI

module crossbar # (parameter A=1,W=1,M=3,S=2,MI=5,SI=7) (
m_sel_array,s_sel_array,
m_addr,m_addr_val,m_cmd,m_cmd_val,m_wr_data,m_wr_val,m_rd_rdy, //master outputs
m_addr_rdy,m_cmd_rdy,m_wr_rdy,m_rd_data,m_rd_val, //master inputs
s_addr_rdy,s_cmd_rdy,s_wr_rdy,s_rd_data,s_rd_val, //slave outputs
s_addr,s_addr_val,s_cmd,s_cmd_val,s_wr_data,s_wr_val,s_rd_rdy //slave inputs
);
//input array has all master and slave inputs

//we need one of each master output for each master
//one of each slave output
//use master array to hold all
//use slave array


//first selectarray
//input [M+S-1:0] sel_array; this doesn't work because we need to take into account width of select
//width needed to select a master = [$clog2(M)-1:0]
//select a slave width = [$clog2(S)-1:0]
//note: make sure to check $clog2 rounds up to the nealest whole number as it claims to do
//select a master for a slave
input [$clog2(M)-1:0] m_sel_array [S-1:0];
//select a slave for a master
input [$clog2(S)-1:0] s_sel_array [M-1:0];

//what is in input list:
//master outputs
input [A-1:0] m_addr [M-1:0]; //A bit wide address, M number of them
input [W-1:0] m_wr_data [M-1:0];
//rest of master outputs are 1 bit wide
input m_addr_val [M-1:0]; //1 bit wide, M addr_vals
input m_cmd [M-1:0];
input m_cmd_val [M-1:0];
input m_wr_val [M-1:0];
input m_rd_rdy [M-1:0]; //1 bit
//slave outputs
input [W-1:0] s_rd_data [S-1:0];
//rest slave outputs are 1 bit wide
input s_addr_rdy [S-1:0];
input s_cmd_rdy [S-1:0];
input s_wr_rdy [S-1:0];
input s_rd_val [S-1:0];

// all outputs of crossbar
//inputs of slave 
output [A-1:0] s_addr [S-1:0];
output [W-1:0] s_wr_data [S-1:0];
//rest 1 bit
output s_addr_val [S-1:0];
output s_cmd [S-1:0];
output s_cmd_val [S-1:0];
output s_wr_val [S-1:0];
output s_rd_rdy [S-1:0];
//master inputs
output [W-1:0] m_rd_data [M-1:0];
//1 bit
output m_addr_rdy [M-1:0];
output m_cmd_rdy [M-1:0];
output m_wr_rdy [M-1:0];
output m_rd_val [M-1:0];

//number muxes = M*MI+S*SI
//first do all crossbar outputs that go to master (master inputs)
//reg [$clog2(S)-1:0] s_sel;
genvar i;
generate
for(i=0;i<M;i=i+1) //for each master
begin
    //s_sel = s_sel_array[i];
    //note same select goes to each mux (MI number of muxes)
    //note change mux to be 2D instead of long 1D
    mux2 #(.N(S),.W(W)) m_rd_data_mux(.muxin(s_rd_data),.sel(s_sel_array[i]),.muxout(m_rd_data[i]));
    mux2 #(.N(S),.W(1)) m_addr_rdy_mux(.muxin(s_addr_rdy),.sel(s_sel_array[i]),.muxout(m_addr_rdy[i]));
    mux2 #(.N(S),.W(1)) m_cmd_rdy_mux(.muxin(s_cmd_rdy),.sel(s_sel_array[i]),.muxout(m_cmd_rdy[i]));
    mux2 #(.N(S),.W(1)) m_wr_rdy_mux(.muxin(s_wr_rdy),.sel(s_sel_array[i]),.muxout(m_wr_rdy[i]));
    mux2 #(.N(S),.W(1)) m_rd_val_mux(.muxin(s_rd_val),.sel(s_sel_array[i]),.muxout(m_rd_val[i]));
end
endgenerate

//do all crossbar outputs that go to slaves (slave inputs)
genvar j;
generate
for(j=0;j<S;j=j+1) //for slave
begin
    //m_sel = m_sel_array[i];
    mux2 #(.N(M),.W(A)) s_addr_mux(.muxin(m_addr),.sel(m_sel_array[j]),.muxout(s_addr[j]));
    mux2 #(.N(M),.W(W)) s_wr_data_mux(.muxin(m_wr_data),.sel(m_sel_array[j]),.muxout(s_wr_data[j]));
    mux2 #(.N(M),.W(1)) s_addr_val_mux(.muxin(m_addr_val),.sel(m_sel_array[j]),.muxout(s_addr_val[j]));
    mux2 #(.N(M),.W(1)) s_cmd_mux(.muxin(m_cmd),.sel(m_sel_array[j]),.muxout(s_cmd[j]));
    mux2 #(.N(M),.W(1)) s_cmd_val_mux(.muxin(m_cmd_val),.sel(m_sel_array[j]),.muxout(s_cmd_val[j]));
    mux2 #(.N(M),.W(1)) s_wr_val_mux(.muxin(m_wr_val),.sel(m_sel_array[j]),.muxout(s_wr_val[j]));
    mux2 #(.N(M),.W(1)) s_rd_rdy_mux(.muxin(m_rd_rdy),.sel(m_rd_rdy[j]),.muxout(s_rd_rdy[j]));
end
endgenerate


endmodule


/*
input [$clog2(M)-1:0] m_sel_array [S-1:0],
//select a slave for a master
input [$clog2(S)-1:0] s_sel_array [M-1:0],

//what is in input list:
//master outputs
input [A-1:0] m_addr [M-1:0], //A bit wide address, M number of them
input [W-1:0] m_wr_data [M-1:0],
//rest of master outputs are 1 bit wide
input m_addr_val [M-1:0], //1 bit wide, M addr_vals
input m_cmd [M-1:0],
input m_cmd_val [M-1:0],
input m_wr_val [M-1:0],
input m_rd_rdy [M-1:0], //1 bit
//slave outputs
input [W-1:0] s_rd_data [S-1:0],
//rest slave outputs are 1 bit wide
input s_addr_rdy [S-1:0],
input s_cmd_rdy [S-1:0],
input s_wr_rdy [S-1:0],
input s_rd_val [S-1:0],

// all outputs of crossbar
//inputs of slave 
output [A-1:0] s_addr [S-1:0],
output [W-1:0] s_wr_data [S-1:0],
//rest 1 bit
output s_addr_val [S-1:0],
output s_cmd [S-1:0],
output s_cmd_val [S-1:0],
output s_wr_val [S-1:0],
output s_rd_rdy [S-1:0],
//master inputs
output [W-1:0] m_rd_data [M-1:0],
//1 bit
output m_addr_rdy [M-1:0],
output m_cmd_rdy [M-1:0],
output m_wr_rdy [M-1:0],
output m_rd_val [M-1:0]
*/