module PWM (
    input wire clk,
    input wire rst_n,
    input wire [20:0] duty_cycle, // duty cycle = period * duty_cycle / 2097152
    input wire [20:0] period, // clk_freq / pwm_freq = period
    output reg pwm_out
);

reg [31:0] counter;

always @(posedge clk) begin
    if (!rst_n) begin
        counter <= 32'h0;
        pwm_out <= 1'b0;
    end else begin
        if(counter < period - 1'b1) begin
            counter <= counter + 1'b1;
        end else begin
            counter <= 32'h0;
        end
    end

    if (counter < duty_cycle) begin
        pwm_out <= 1'b1;
    end else begin
        pwm_out <= 1'b0;
    end
end
    
endmodule