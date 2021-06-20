`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.06.2021 01:22:11
// Design Name: 
// Module Name: control_logic
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


module control_logic(
input clk,
input rst,
input [7:0] pixel_input,
input input_pixel_valid,
output output_pixel_valid,
output reg [71:0] output_pixel_data,
output reg output_intr
    );

reg [1:0] current_wr_line_buffer;
reg [1:0] current_rd_line_buffer;
reg [8:0] pixel_wr_counter; 
reg [8:0] pixel_rd_counter;
reg [10:0] total_pixel_counter;
reg read_data;
reg [3:0] line_buffer_read;
reg [23:0] line_buffer0_data;
reg [23:0] line_buffer1_data;
reg [23:0] line_buffer2_data;
reg [23:0] line_buffer3_data;
reg read_state;

localparam IDLE = 'b0,
    RD_BUFFER = 'b1;

// read_state state change logic
always @ (posedge clk)
begin
    if (rst)
        begin
        read_state <= IDLE;
        output_intr <= 'b0;
        end
    else
        case (read_state)
            IDLE:
            begin
            output_intr <= 'b0;
            if (total_pixel_counter >= 1536)
                read_state <= RD_BUFFER;
            end 
            RD_BUFFER:
            begin
            if (pixel_rd_counter == 511)
                begin
                read_state <= IDLE;
                output_intr <= 'b1;
                end
            end
        endcase         
end

//read_state output
always @ (read_state)
begin
    case (read_state)
        IDLE: read_data = 'b0;
        RD_BUFFER: read_data = 'b1;
    endcase    
end

assign output_pixel_valid = read_state;

//write counters
always @ (posedge clk)
begin
    if (rst)
        begin
        current_wr_line_buffer <= 'd0;
        pixel_wr_counter <= 'd0;
        end
    else
        if (input_pixel_valid)
            pixel_wr_counter <= pixel_wr_counter + 1;
        if (pixel_wr_counter == 511 && input_pixel_valid)
            current_wr_line_buffer <= current_wr_line_buffer + 1;
end                         

//read counters
always @ (posedge clk)
begin
    if (rst)
        begin
        current_rd_line_buffer <= 'd0;
        pixel_rd_counter <= 'd0;
        end
    else
        if (read_data)
            pixel_rd_counter <= pixel_rd_counter + 1;
        if (pixel_rd_counter == 511 && read_data)
            current_rd_line_buffer <= current_rd_line_buffer + 1;
end

//total pixel counter
always @ (posedge clk)
begin
    if (rst)
        total_pixel_counter <= 'd0;
    else
        if (read_data && !input_pixel_valid)
            total_pixel_counter <= total_pixel_counter - 1;                              
        else if ( !read_data && input_pixel_valid)
            total_pixel_counter <= total_pixel_counter + 1;
end

//pixel output logic
always @ (*)
begin
    case (current_rd_line_buffer)
        0: 
        begin 
        output_pixel_data = {line_buffer0_data,line_buffer1_data,line_buffer2_data};    
        line_buffer_read = 4'b0111;
        end
        1:
        begin
        output_pixel_data = {line_buffer1_data,line_buffer2_data,line_buffer3_data};    
        line_buffer_read = 4'b1110;
        end
        2: 
        begin
        output_pixel_data = {line_buffer2_data,line_buffer3_data,line_buffer0_data};
        line_buffer_read = 4'b1101;
        end
        3: 
        begin
        output_pixel_data = {line_buffer3_data,line_buffer0_data,line_buffer1_data};
        line_buffer_read = 4'b1011;
        end    
    endcase            
end            



line_buffer line_buffer0(
.clk(clk),
.rst(rst),
.pixel_input(pixel_input),
.input_valid(input_pixel_valid),
.read_data(line_buffer_read[0]),
.pixel_output(line_buffer0_data)
    );    

line_buffer line_buffer1(
.clk(clk),
.rst(rst),
.pixel_input(pixel_input),
.input_valid(input_pixel_valid),
.read_data(line_buffer_read[1]),
.pixel_output(line_buffer1_data)
    );

line_buffer line_buffer2(
.clk(clk),
.rst(rst),
.pixel_input(pixel_input),
.input_valid(input_pixel_valid),
.read_data(line_buffer_read[2]),
.pixel_output(line_buffer2_data)
    );   

line_buffer line_buffer3(
.clk(clk),
.rst(rst),
.pixel_input(pixel_input),
.input_valid(input_pixel_valid),
.read_data(line_buffer_read[3]),
.pixel_output(line_buffe3_data)
    );


endmodule
