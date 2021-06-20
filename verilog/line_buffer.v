`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2021 01:55:12
// Design Name: 
// Module Name: line_buffer
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


module line_buffer(
input clk,
input rst,
input [7:0] pixel_input,
input input_valid,
input read_data,
output [23:0] pixel_output
    );
    reg [7:0] linebuffer [511:0];
    reg [8:0] wrt_ptr;
    reg [8:0] rd_ptr;
    
    assign pixel_output = {linebuffer[rd_ptr],linebuffer[rd_ptr+1],linebuffer[rd_ptr+2]};
    
    always @ (posedge clk)
    begin
        if(rst)
        begin
            rd_ptr <= 'b0;
            wrt_ptr <= 'b0;
        end    
    end
    
    
    always @ (posedge clk)
    begin
        if(input_valid)
        begin
            linebuffer[wrt_ptr] <= pixel_input;
            wrt_ptr <= wrt_ptr + 'b1;
        end
    end
    
    
    always @ (posedge clk)
    begin
        if(read_data)
            rd_ptr <= rd_ptr + 'b1;    
    end
endmodule
