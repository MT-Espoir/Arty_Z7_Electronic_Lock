module clk_divider #(
    parameter DIV = 125000 // Default division factor (for 1ms period at 125 MHz)
)(
    input wire clk,
    input wire reset,
    output reg clk_out
);
    reg [31:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == (DIV - 1)) begin
                clk_out <= ~clk_out;
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule
