`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/09 18:19:06
// Design Name: 
// Module Name: Systolic_array
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


module Systolic_array(
        clk,
        reset_n,
        enable,
        weight_i,
        input_i,
        result_o
    );
    parameter IN_WORD_SIZE = 8;
    parameter OUT_WORD_SIZE = 16;
    parameter NUM_ROW = 16;
    parameter NUM_COL = 16;
    
    input clk,reset_n,enable;
    input wire [IN_WORD_SIZE*NUM_ROW*NUM_COL-1:0] weight_i; //2047
    input wire [IN_WORD_SIZE*NUM_ROW-1:0] input_i; //127
    output wire [OUT_WORD_SIZE*NUM_ROW-1:0] result_o; //255
    
    wire [7:0] right_wire[0:255];
    wire [15:0] down_wire[0:255];
    
    genvar row,col;
    generate
        for(row=0; row<NUM_ROW; row=row+1)
        begin:gen1
            for(col=0; col<NUM_COL; col=col+1)
            begin:gen2
                if( row==0 && col==0 ) begin
                    PE pe(
                        .clk(clk),
                        .reset_n(reset_n),
                        .en(enable),
                        .weight(weight_i[IN_WORD_SIZE*(col + NUM_ROW*row)+:8]),
                        .up_i( 16'b0000000000000000),
                        .left_i(input_i[7:0]),
                        .right_o(right_wire[row*16+col]),
                        .down_o(down_wire[row*16+col])
                    );
                end
                else if(row==0) begin
                    PE pe(
                        .clk(clk),
                        .reset_n(reset_n),
                        .en(enable),
                        .weight(weight_i[IN_WORD_SIZE*(col+ NUM_ROW*row)+:8]),
                        .up_i( 16'b0000000000000000),
                        .left_i(right_wire[row*16+col-1]),
                        .right_o(right_wire[row*16+col]),
                        .down_o(down_wire[row*16+col])
                    );
                end
                else if(col==0) begin
                    PE pe(
                        .clk(clk),
                        .reset_n(reset_n),
                        .en(enable),
                        .weight(weight_i[IN_WORD_SIZE*(col+ NUM_ROW*row)+:8]),
                        .up_i( down_wire[(row-1)*16+col]),
                        .left_i(input_i[row*IN_WORD_SIZE+:8]),
                        .right_o(right_wire[row*16+col]),
                        .down_o(down_wire[row*16+col])
                    );
                end
                else begin
                    PE pe(
                        .clk(clk),
                        .reset_n(reset_n),
                        .en(enable),
                        .weight(weight_i[IN_WORD_SIZE*(col+ NUM_ROW*row)+:8]),
                        .up_i( down_wire[(row-1)*16+col]),
                        .left_i(right_wire[row*16+col-1]),
                        .right_o(right_wire[row*16+col]),
                        .down_o(down_wire[row*16+col])
                    );
                end
            end
        end
    endgenerate
    
   
    generate
    genvar i;
        for(i=0;i<NUM_COL;i=i+1)
        begin:gen3
            assign result_o[OUT_WORD_SIZE*i+:16] = down_wire[240+i];
        end
    endgenerate

    
endmodule