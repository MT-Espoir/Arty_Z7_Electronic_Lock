`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2024 03:20:17 PM
// Design Name: 
// Module Name: button_counter
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


module button_counter_demo (
    input wire clk_slow,        // Slow clock input
    input wire btn_inc,         // Debounced button to increment current BCD digit
    input wire btn_confirm,     // Debounced button to confirm and move to next digit
    output reg [3:0] bcd0,      // BCD output for 7-segment LED 0
    output reg [3:0] bcd1,      // BCD output for 7-segment LED 1
    output reg [3:0] bcd2,      // BCD output for 7-segment LED 2
    output reg [3:0] bcd3       // BCD output for 7-segment LED 3
);
    reg [1:0] active_digit;     // Tracks the active BCD digit (0 to 3)

    initial begin
        bcd0 = 4'b0000;
        bcd1 = 4'b0000;
        bcd2 = 4'b0000;
        bcd3 = 4'b0000;
        active_digit = 2'b00;
    end

    always @(posedge clk_slow) begin
        if (btn_inc) begin
            // Increment the current active BCD digit
            case (active_digit)
                2'b00: bcd0 <= (bcd0 == 4'd9) ? 4'd0 : bcd0 + 1;
                2'b01: bcd1 <= (bcd1 == 4'd9) ? 4'd0 : bcd1 + 1;
                2'b10: bcd2 <= (bcd2 == 4'd9) ? 4'd0 : bcd2 + 1;
                2'b11: bcd3 <= (bcd3 == 4'd9) ? 4'd0 : bcd3 + 1;
            endcase
        end

        if (btn_confirm) begin
            // Move to the next BCD digit
            active_digit <= (active_digit == 2'b11) ? 2'b00 : active_digit + 1;
        end
    end

endmodule

