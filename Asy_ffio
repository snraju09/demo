// Asynchronous FIFO using Gray code pointer synchronization
// Parameters: DATA_WIDTH, ADDR_WIDTH (depth = 2^ADDR_WIDTH)
i am editing hereeeeeeeeeeeeeeeee
I’ve seen those changes.
module async_fifo #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
) (
    // Write domain
    input  wire                  wr_clk,
    input  wire                  wr_rst_n,
    input  wire                  wr_en,
    input  wire [DATA_WIDTH-1:0] wr_data,
    output wire                  full,

    // Read domain
    input  wire                  rd_clk,
    input  wire                  rd_rst_n,
    input  wire                  rd_en,
    output wire [DATA_WIDTH-1:0] rd_data,
    output wire                  empty
);

    localparam DEPTH = 1 << ADDR_WIDTH;

    // Dual-port RAM
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Binary pointers (one extra bit for full/empty distinction)
    reg [ADDR_WIDTH:0] wr_ptr_bin, rd_ptr_bin;

    // Gray code pointers
    reg [ADDR_WIDTH:0] wr_ptr_gray, rd_ptr_gray;

    // Synchronized gray pointers (two FF stages)
    reg [ADDR_WIDTH:0] rd_gray_sync1, rd_gray_sync2;
    reg [ADDR_WIDTH:0] wr_gray_sync1, wr_gray_sync2;

    // -------------------------------------------------------------------------
    // Write domain
    // -------------------------------------------------------------------------
    wire [ADDR_WIDTH:0] wr_ptr_bin_next  = wr_ptr_bin + (wr_en & ~full);
    wire [ADDR_WIDTH:0] wr_ptr_gray_next = (wr_ptr_bin_next >> 1) ^ wr_ptr_bin_next;

    always @(posedge wr_clk or negedge wr_rst_n) begin
        if (!wr_rst_n) begin
            wr_ptr_bin  <= 0;
            wr_ptr_gray <= 0;
        end else begin
            wr_ptr_bin  <= wr_ptr_bin_next;
            wr_ptr_gray <= wr_ptr_gray_next;
        end
    end

    always @(posedge wr_clk) begin
        if (wr_en && !full)
            mem[wr_ptr_bin[ADDR_WIDTH-1:0]] <= wr_data;
    end

    // Sync rd_ptr_gray into write domain
    always @(posedge wr_clk or negedge wr_rst_n) begin
        if (!wr_rst_n) begin
            rd_gray_sync1 <= 0;
            rd_gray_sync2 <= 0;
        end else begin
            rd_gray_sync1 <= rd_ptr_gray;
            rd_gray_sync2 <= rd_gray_sync1;
        end
    end

    // Full when upper two bits differ, rest equal (Gray code comparison)
    assign full = (wr_ptr_gray == {~rd_gray_sync2[ADDR_WIDTH:ADDR_WIDTH-1],
                                    rd_gray_sync2[ADDR_WIDTH-2:0]});

    // -------------------------------------------------------------------------
    // Read domain
    // -------------------------------------------------------------------------
    wire [ADDR_WIDTH:0] rd_ptr_bin_next  = rd_ptr_bin + (rd_en & ~empty);
    wire [ADDR_WIDTH:0] rd_ptr_gray_next = (rd_ptr_bin_next >> 1) ^ rd_ptr_bin_next;

    always @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) begin
            rd_ptr_bin  <= 0;
            rd_ptr_gray <= 0;
        end else begin
            rd_ptr_bin  <= rd_ptr_bin_next;
            rd_ptr_gray <= rd_ptr_gray_next;
        end
    end

    assign rd_data = mem[rd_ptr_bin[ADDR_WIDTH-1:0]];

    // Sync wr_ptr_gray into read domain
    always @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) begin
            wr_gray_sync1 <= 0;
            wr_gray_sync2 <= 0;
        end else begin
            wr_gray_sync1 <= wr_ptr_gray;
            wr_gray_sync2 <= wr_gray_sync1;
        end
    end

    // Empty when pointers are equal
    assign empty = (rd_ptr_gray == wr_gray_sync2);

endmodule
