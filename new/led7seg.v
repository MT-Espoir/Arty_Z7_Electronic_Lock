`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2024 01:39:58 PM
// Design Name: 
// Module Name: led7seg
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


module keypad_to_seven_seg (
    input wire clk,             // System clock
    input wire [3:0] key,       // Keypad value
    input wire key_valid,       // Key valid signal
    output reg [3:0] bcd0,      // BCD for 7-segment 0
    output reg [3:0] bcd1,      // BCD for 7-segment 1
    output reg [3:0] bcd2,      // BCD for 7-segment 2
    output reg [3:0] bcd3       // BCD for 7-segment 3
);

    // Internal shift register to hold keypad values
    reg [15:0] shift_register;
    reg [3:0] decoded_key;

    // Decode keypad value to BCD (optional for display-specific mapping)
    always @(*) begin
        case (key)
            4'b0001: decoded_key = 4'b0001; // '1'
            4'b0010: decoded_key = 4'b0010; // '2'
            4'b0011: decoded_key = 4'b0011; // '3'
            4'b0100: decoded_key = 4'b0100; // '4'
            4'b0101: decoded_key = 4'b0101; // '5'
            4'b0110: decoded_key = 4'b0110; // '6'
            4'b0111: decoded_key = 4'b0111; // '7'
            4'b1000: decoded_key = 4'b1000; // '8'
            4'b1001: decoded_key = 4'b1001; // '9'
            4'b1010: decoded_key = 4'b1010; // '*'
            4'b1011: decoded_key = 4'b0000; // '0'
            4'b1100: decoded_key = 4'b1100; // '#'
            default: decoded_key = 4'b1111; // Invalid key
        endcase
    end

    always @(posedge clk) begin
        if (key_valid) begin
            // Shift new decoded key value into register
            shift_register <= {shift_register[11:0], decoded_key};
        end
    end

    // Assign BCD outputs
    always @(posedge clk) begin
        bcd0 <= shift_register[3:0];
        bcd1 <= shift_register[7:4];
        bcd2 <= shift_register[11:8];
        bcd3 <= shift_register[15:12];
    end

endmodule
