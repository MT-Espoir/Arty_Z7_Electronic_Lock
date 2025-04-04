module password_lock_manager (
    input wire clk,                   // System clock (500 Hz from clk_divider)
    input wire reset,                 // Reset signal
    input wire match,                 // Password match signal
    input wire btn_confirm_fullpass,  // Button to confirm full password
    output reg locked,                // Locked state output
    output reg [3:0] fail_count,      // Failure count output (optional for debugging)
    output reg led_lock               // LED to indicate lock state
);

    reg [31:0] lock_timer;            // Timer for lock duration
    reg [31:0] lock_duration;         // Current lock duration
    localparam LOCK_5S  = 32'd50000;   // 5 seconds lock (500 Hz clock)
    localparam LOCK_10S = 32'd100000;   // 10 seconds lock  // 30 seconds lock

    // Initialize the module's state
    initial begin
        locked = 0;
        lock_timer = 0;
        lock_duration = 0;
        fail_count = 0;
        led_lock = 0;
    end

    always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset all states
        locked <= 0;
        lock_timer <= 0;
        lock_duration <= 0;
        fail_count <= 0;
        led_lock <= 0;
    end else begin
        if (locked) begin
            // Countdown timer while locked
            if (lock_timer > 0) begin
                lock_timer <= lock_timer - 1;
            end else begin
                // Unlock when timer expires
                locked <= 0;
                led_lock <= 0;
            end
        end else if (btn_confirm_fullpass && !match) begin
            // Incorrect password attempt
            fail_count <= fail_count + 1;
            locked <= 1;
            led_lock <= 1;

            // Set lock duration based on fail count
            case (fail_count)
                4'd1: lock_duration <= LOCK_5S;  // 5 seconds for first fail
                4'd2: lock_duration <= LOCK_10S; // 10 seconds for second fail
                default: lock_duration <= LOCK_5S; // Default to 5 seconds
            endcase

            // Always reset lock_timer with the new lock_duration
            lock_timer <= lock_duration;
        end else if (match) begin
            // Reset fail count on correct password
            fail_count <= 0;
        end
    end
end

endmodule
