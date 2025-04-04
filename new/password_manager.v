module password_manager (
    input wire clk,                  // System clock
    input wire btn_confirm_fullpass, // Confirm entered password
    input wire btn_change_pass,      // Request to change password
    input wire [3:0] bcd0,           // Entered password digit 0
    input wire [3:0] bcd1,           // Entered password digit 1
    input wire [3:0] bcd2,           // Entered password digit 2
    input wire [3:0] bcd3,           // Entered password digit 3
    output reg match,                // Indicates if entered password matches stored password
    output reg allow_change,         // Indicates if password change is allowed
    output reg led_change_pass       // LED for change pass state
);

    // Stored password registers
    reg [3:0] pass0 = 4'd1;
    reg [3:0] pass1 = 4'd1;
    reg [3:0] pass2 = 4'd1;
    reg [3:0] pass3 = 4'd1;
    reg changing_pass; // Internal state register

    // Initialize outputs
    initial begin
        match = 1'b0;
        allow_change = 1'b0;
        changing_pass = 1'b0;
        led_change_pass = 1'b0;
    end

    // Password verification and change logic
    always @(posedge clk) begin
        if (btn_confirm_fullpass) begin
            if (!changing_pass) begin
                // Verify password
                match <= (bcd0 == pass0) && (bcd1 == pass1) && (bcd2 == pass2) && (bcd3 == pass3);
                allow_change <= (bcd0 == pass0) && (bcd1 == pass1) && (bcd2 == pass2) && (bcd3 == pass3);
            end else begin
                // Save new password and exit password change mode
                pass0 <= bcd0;
                pass1 <= bcd1;
                pass2 <= bcd2;
                pass3 <= bcd3;
                changing_pass <= 1'b0;
                allow_change <= 1'b0;
                led_change_pass <= 1'b0;
            end
        end

        if (btn_change_pass) begin
            if (allow_change) begin
                // Enter password change mode
                changing_pass <= 1'b1;
                allow_change <= 1'b0;
                led_change_pass <= 1'b1;
            end
        end
    end
endmodule
