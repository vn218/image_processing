`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.06.2021 22:42:00
// Design Name: 
// Module Name: mac
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


module mac(
    input clk,
    input[71:0] pixel_data,
    input pixel_data_valid,
    output reg [7:0] o_pixel,
    output o_pixel_valid
    );

integer i;    
reg[7:0] kernel [8:0];
reg[15:0] mulData[8:0];
reg[15:0] sumDataInt;
reg[15:0] sumData;
reg o_pixel_valid;
reg mulDatavalid;
reg sumDatavalid;

initial
begin
    for (i=0;i<9;i=i+1)
    begin
        kernel[i] = 1;
    end
end

always @ (posedge clk) begin
    for (i=0;i<9;i=i+1)
    begin
        mulData[i] = kernel[i]*pixel_data[i*8+:8];
    end
    mulDatavalid <= pixel_data_valid;
end

always @ (*) begin
    sumDataInt = 0;
    for (i=0;i<9;i=i+1)
    begin
        sumDataInt = sumDataInt + mulData[i];
    end
end

always @ (posedge clk) begin
    sumData <= sumDataInt;
    sumDatavalid <= mulDatavalid;
end

always @ (posedge clk) begin
    o_pixel <= sumData/9;
    o_pixel_valid <= sumDatavalid;
end

endmodule

