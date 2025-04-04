`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2024 03:20:17 PM
// Design Name: 
// Module Name: debounce
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


module debounce (
    input wire clk,             // Slow clock for debounce
    input wire btn_in,          // Raw button input
    output reg btn_out          // Debounced button output
);
    reg [2:0] btn_sync;

    always @(posedge clk) begin
        // Shift register to synchronize and debounce the button input
        btn_sync <= {btn_sync[1:0], btn_in};
        btn_out <= btn_sync[2] & ~btn_sync[1]; // Detect rising edge
    end
endmodule
