module synchronizer_2ff (
    input  wire clk,       // destination clock
    input  wire rst_n,     // active-low reset
    input  wire async_in,  // asynchronous input signal
    output wire sync_out   // synchronized output
);

    reg ff1, ff2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ff1 <= 1'b0;
            ff2 <= 1'b0;
        end else begin
            ff1 <= async_in;
            ff2 <= ff1;
        end
    end

    assign sync_out = ff2;

endmodule
