`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.07.2021 02:47:29
// Design Name: 
// Module Name: mac_sharpen
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


module mac_sharpen(
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
    kernel[0] = 0;
    kernel[1] = -1;
    kernel[2] = 0;
    kernel[3] = -1;
    kernel[4] = 5;
    kernel[5] = -1;
    kernel[6] = 0;
    kernel[7] = -1;
    kernel[8] = 0;

end

always @ (posedge clk) begin
    for (i=0;i<9;i=i+1)
    begin
        mulData[i] = $signed(kernel[i])*$signed({1'b0,pixel_data[i*8+:8]});
    end
    mulDatavalid <= pixel_data_valid;
end

always @ (*) begin
    sumDataInt = 0;
    for (i=0;i<9;i=i+1)
    begin
        sumDataInt = sumDataInt + mulData[i];
    end
    if (sumDataInt[15] == 1)
        sumDataInt = 0;
    if (sumDataInt[14:0] > 255)
        sumDataInt = 255;    
end

always @ (posedge clk) begin
    sumData <= sumDataInt;
    sumDatavalid <= mulDatavalid;
end
always @ (posedge clk) begin
    o_pixel <= sumData;
    o_pixel_valid <= sumDatavalid;
end

endmodule