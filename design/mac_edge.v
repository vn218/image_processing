`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.07.2021 14:41:26
// Design Name: 
// Module Name: mac_edge
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


module mac_edge(
    input clk,
    input[71:0] pixel_data,
    input pixel_data_valid,
    output reg [7:0] o_pixel,
    output o_pixel_valid
    );

integer i;    
reg[7:0] kernel_x [8:0];
reg[7:0] kernel_y [8:0];
reg[15:0] mulData_x[8:0];
reg[15:0] mulData_y[8:0];
reg[15:0] sumDataInt_x;
reg[15:0] sumDataInt_y;
reg[15:0] sumData;
reg o_pixel_valid;
reg mulDatavalid;
reg sumDatavalid;

initial
begin
    kernel_x[0] = -1;
    kernel_x[1] = 0;
    kernel_x[2] = 1;
    kernel_x[3] = -2;
    kernel_x[4] = 0;
    kernel_x[5] = 2;
    kernel_x[6] = -1;
    kernel_x[7] = 0;
    kernel_x[8] = 1;
    
    kernel_y[0] = 1;
    kernel_y[1] = 2;
    kernel_y[2] = 1;
    kernel_y[3] = 0;
    kernel_y[4] = 0;
    kernel_y[5] = 0;
    kernel_y[6] = -1;
    kernel_y[7] = -2;
    kernel_y[8] = -1;
    
end

always @ (posedge clk) begin
    for (i=0;i<9;i=i+1)
    begin
        mulData_x[i] = $signed(kernel_x[i])*$signed({1'b0,pixel_data[i*8+:8]});
        mulData_y[i] = $signed(kernel_y[i])*$signed({1'b0,pixel_data[i*8+:8]});
    end
    mulDatavalid <= pixel_data_valid;
end

always @ (*) begin
    sumDataInt_x = 0;
    sumDataInt_y = 0;
    for (i=0;i<9;i=i+1)
    begin
        sumDataInt_x = sumDataInt_x + mulData_x[i];
        sumDataInt_y = sumDataInt_y + mulData_y[i];
    end
    if (sumDataInt_x[15] == 1)
        sumDataInt_x = -sumDataInt_x;
    if (sumDataInt_y[15] == 1)
        sumDataInt_y = -sumDataInt_y;    
end

always @ (posedge clk) begin
    sumData <= sumDataInt_x + sumDataInt_y;
    sumDatavalid <= mulDatavalid;
end

always @ (posedge clk) begin
    o_pixel <= sumData/4;
    o_pixel_valid <= sumDatavalid;
end

endmodule