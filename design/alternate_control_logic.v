`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.07.2021 20:32:21
// Design Name: 
// Module Name: alternate_control_logic
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


module alternate_control_logic(
input clk,
input rst,
input [7:0] pixel_input,
input input_pixel_valid,
output reg output_pixel_valid,
output [71:0] output_pixel_data,
output reg output_intr
    );

reg [7:0] shift_register [1026:0];
integer i;
always @ (posedge clk)
    output_pixel_valid <= input_pixel_valid & !rst;

always @ (posedge clk)
begin
if (rst)
    begin
    for (i = 0 ; i < 1027; i = i+1)
        shift_register[i] <= 0;
    end
else
    begin
    if (input_pixel_valid)
        begin
        shift_register[0] <= pixel_input;
        for (i = 0 ; i < 1026; i = i+1)
            shift_register[i+1] <= shift_register[i];
        end
    end        
end

assign output_pixel_data = {shift_register[1026],shift_register[1024],shift_register[1023],shift_register[514],shift_register[513],shift_register[512],shift_register[2],shift_register[1],shift_register[0]};

endmodule




