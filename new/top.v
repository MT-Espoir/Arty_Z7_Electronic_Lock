module top (
    input wire clk,                     // System clock
    input wire btn_inc_raw,             // Raw button to increment current BCD digit
    input wire btn_confirm_raw,         // Raw button to confirm and move to next digit
    input wire btn_change_pass_raw,     // Raw button to change password
    input wire btn_confirm_fullpass_raw,// Raw button to confirm entered password
    output [3:0] bcd0,                  // BCD output for 7-segment LED 0
    output [3:0] bcd1,                  // BCD output for 7-segment LED 1
    output [3:0] bcd2,                  // BCD output for 7-segment LED 2
    output [3:0] bcd3,                  // BCD output for 7-segment LED 3
    output led_match,                   // LED for password match indication
    output led_change_pass,             // LED for change pass state
    output led_lock                     // LED for lock state
);

    wire clk_slow;                  // Slow clock signal
    wire btn_inc, btn_confirm;      // Debounced button signals
    wire btn_change_pass, btn_confirm_fullpass;
    wire match, allow_change, locked; // Signals for password match, lock, and allow change

    // Instantiate clock divider
    clk_divider #(.DIV(125000)) clk_div_inst (
        .clk(clk),
        .reset(1'b0),
        .clk_out(clk_slow)
    );

    // Instantiate debounce for buttons
    debounce btn_inc_debounce (
        .clk(clk_slow),
        .btn_in(btn_inc_raw),
        .btn_out(btn_inc)
    );
    debounce btn_confirm_debounce (
        .clk(clk_slow),
        .btn_in(btn_confirm_raw),
        .btn_out(btn_confirm)
    );
    debounce btn_change_pass_debounce (
        .clk(clk_slow),
        .btn_in(btn_change_pass_raw),
        .btn_out(btn_change_pass)
    );
    debounce btn_confirm_fullpass_debounce (
        .clk(clk_slow),
        .btn_in(btn_confirm_fullpass_raw),
        .btn_out(btn_confirm_fullpass)
    );

    // Signals to control button inputs based on lock state
    wire btn_inc_allowed = btn_inc & ~locked;
    wire btn_confirm_allowed = btn_confirm & ~locked;
    wire btn_confirm_fullpass_allowed = btn_confirm_fullpass & ~locked;

    // Instantiate button counter demo (disabled when locked)
    button_counter_demo counter_inst (
        .clk_slow(clk_slow),
        .btn_inc(btn_inc_allowed),       // Disable increment if locked
        .btn_confirm(btn_confirm_allowed), // Disable confirm if locked
        .bcd0(bcd0),
        .bcd1(bcd1),
        .bcd2(bcd2),
        .bcd3(bcd3)
    );

    // Instantiate password manager
    password_manager pass_manager_inst (
        .clk(clk_slow),
        .btn_confirm_fullpass(btn_confirm_fullpass_allowed), // Disabled when locked
        .btn_change_pass(btn_change_pass),
        .bcd0(bcd0),
        .bcd1(bcd1),
        .bcd2(bcd2),
        .bcd3(bcd3),
        .match(match),
        .allow_change(allow_change),
        .led_change_pass(led_change_pass)
    );

    // Instantiate password lock manager
    password_lock_manager lock_manager_inst (
        .clk(clk_slow),
        .reset(1'b0), // Replace with an external reset if needed
        .match(match),
        .btn_confirm_fullpass(btn_confirm_fullpass),
        .locked(locked),
        .fail_count(), // Optional output for debugging
        .led_lock(led_lock)
    );

    // Assign LED outputs
    assign led_match = match;

endmodule
