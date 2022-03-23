`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/09 20:02:27
// Design Name: 
// Module Name: PE
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


module PE(
        clk,
        reset_n,
        en,
        weight,
        up_i,
        left_i,
        right_o,
        down_o
    );

 input reset_n, clk, en;
 input wire [0:7] left_i,weight;
 input wire [0:15] up_i;
 output reg [0:7] right_o;
 output reg [0:15] down_o;

 always @(posedge clk)begin
    if(~reset_n || ~en) begin
      right_o = 0;
      down_o = 0;
    end
    else begin  
      down_o = left_i * weight + up_i;
      right_o = left_i;
    end
 end
 
endmodule
