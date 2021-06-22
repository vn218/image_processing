`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2021 15:06:29
// Design Name: 
// Module Name: ip_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ip_top(
    input axi_clk,
    input axi_rst,
    input i_data_valid,
    input [7:0] i_data,
    output o_data_ready,
    output o_data_valid,
    output [7:0] o_data,
    input i_data_ready,
    output intr
    );

wire [71:0] pixel_data;
wire pixel_data_valid;
wire axis_prog_full;
wire [7:0] convoulved_data;
wire convoulved_data_valid;

assign o_data_ready = !axis_prog_full;
    
control_logic IC(
    .clk(axi_clk),
    .rst(!axi_rst),
    .pixel_input(i_data),
    .input_pixel_valid(i_data_valid),
    .output_pixel_valid(pixel_data_valid),
    .output_pixel_data(pixel_data),
    .output_intr(intr)
    );
    
mac mac(
    .clk(axi_clk),
    .pixel_data(pixel_data),
    .pixel_data_valid(pixel_data_valid),
    .o_pixel(convoulved_data),
    .o_pixel_valid(convoulved_data_valid)
    );

outputBuffer outputBuffer (
  .wr_rst_busy(),        // output wire wr_rst_busy
  .rd_rst_busy(),        // output wire rd_rst_busy
  .s_aclk(axi_clk),                  // input wire s_aclk
  .s_aresetn(axi_rst),            // input wire s_aresetn
  .s_axis_tvalid(convoulved_data_valid),    // input wire s_axis_tvalid
  .s_axis_tready(),    // output wire s_axis_tready
  .s_axis_tdata(convoulved_data),      // input wire [7 : 0] s_axis_tdata
  .m_axis_tvalid(o_data_valid),    // output wire m_axis_tvalid
  .m_axis_tready(i_data_ready),    // input wire m_axis_tready
  .m_axis_tdata(o_data),      // output wire [7 : 0] m_axis_tdata
  .axis_prog_full(axis_prog_full)  // output wire axis_prog_full
);

endmodule
