module PWM (
    input  logic clk,
    input  logic rst_n,
    input  logic [20:0] duty_cycle, // duty cycle = period * duty_cycle / 2097152
    input  logic [20:0] period, // clk_freq / pwm_freq = period
    output logic pwm_out
);

logic [31:0] counter;

always_ff @(posedge clk or negedge rst_n) begin
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