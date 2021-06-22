`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2021 15:34:56
// Design Name: 
// Module Name: ip_tb
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

`define headerSize 1080
`define total_image_size 512*512

module ip_tb(
    );

reg clk;
reg rst;
reg [7:0] imgData;
integer f_input, f_output, i, sent_size;
reg img_data_valid;
wire intr;
wire [7:0] out_data;
wire out_data_valid;
integer received_data = 0;

initial
begin
    clk = 1'b0;
    forever
    begin
        #5 clk = ~clk;
    end
end

initial
begin
    rst = 0;
    sent_size = 0;
    img_data_valid = 0;
    #100;
    rst = 1;
    #100;
    f_input = $fopen("<name of the input image>", "rb");
    f_output = $fopen("<name of the output image>", "wb");
    for (i = 0;i < `headerSize;i = i+1)
    begin
        $fscanf(f_input, "%c", imgData);
        $fwrite(f_output, "%c", imgData);
    end
    
    for (i = 0; i < 4*512; i = i + 1)
    begin
        @ (posedge clk)
        $fscanf(f_input, "%c", imgData);
        img_data_valid <= 1'b1;
    end
    sent_size = 4*512;
    
    
    @ (posedge clk)
    img_data_valid <= 1'b0;
    
    while(sent_size < `total_image_size)
    begin
        @ (posedge intr);
        for (i = 0; i < 512; i = i + 1)
        begin
            @ (posedge clk)
            $fscanf(f_input, "%c", imgData);
            img_data_valid <= 1'b1;
        end
        @(posedge clk)
        img_data_valid <= 1'b0;
        sent_size = sent_size + 512;
    end
    
    @ (posedge clk)
    img_data_valid <= 1'b0;
    @ (posedge intr)
    for (i = 0; i < 512; i = i + 1)
    begin
        @ (posedge clk)
        imgData <= 0;
        img_data_valid <= 1'b1;
    end
    @ (posedge clk)
    img_data_valid <= 1'b0;
    @ (posedge intr)
    for (i = 0; i < 512; i = i + 1)
    begin
        @ (posedge clk)
        imgData <= 0;
        img_data_valid <= 1'b1;
    end
    @ (posedge clk)
    img_data_valid <= 1'b0;
    $fclose(f_input);
end

always @ (posedge clk)
begin
    if (out_data_valid)
    begin
        $fwrite(f_output, "%c", out_data);
        received_data = received_data + 1;
    end
    if (received_data == `total_image_size)
    begin
        $fclose(f_output);
        $stop;
    end
    
end

ip_top dut(
    .axi_clk(clk),
    .axi_rst(rst),
    .i_data_valid(img_data_valid),
    .i_data(imgData),
    .o_data_ready(),
    .o_data_valid(out_data_valid),
    .o_data(out_data),
    .i_data_ready(),
    .intr(intr)
    );

endmodule
