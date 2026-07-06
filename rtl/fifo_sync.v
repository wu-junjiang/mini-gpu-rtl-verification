// =============================================================================
// Module: fifo_sync
// Description: Parameterizable synchronous FIFO (single clock domain)
// Author: [Your Name]
// Week 2 goal: full/empty edge cases + simultaneous read+write verified
// =============================================================================

module fifo_sync #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 16,                      // must be a power of 2
    parameter ADDR_WIDTH = $clog2(DEPTH)
) (
    input  wire                    clk,
    input  wire                    rst_n,      // active-low synchronous reset

    // Write port
    input  wire                    wr_en,
    input  wire [DATA_WIDTH-1:0]   wr_data,
    output wire                    full,

    // Read port
    input  wire                    rd_en,
    output reg  [DATA_WIDTH-1:0]   rd_data,
    output wire                    empty
);

    // Memory array
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // One extra bit on pointers so we can distinguish full vs empty
    reg [ADDR_WIDTH:0] wr_ptr;
    reg [ADDR_WIDTH:0] rd_ptr;

    wire [ADDR_WIDTH-1:0] wr_addr = wr_ptr[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] rd_addr = rd_ptr[ADDR_WIDTH-1:0];

    // Full: pointers equal except for the MSB (wrapped around)
    assign full  = (wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]) &&
                   (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]);

    // Empty: pointers fully equal
    assign empty = (wr_ptr == rd_ptr);

    // Write logic
    always @(posedge clk) begin
        if (!rst_n) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            mem[wr_addr] <= wr_data;
            wr_ptr       <= wr_ptr + 1'b1;
        end
    end

    // Read logic
    always @(posedge clk) begin
        if (!rst_n) begin
            rd_ptr  <= 0;
            rd_data <= 0;
        end else if (rd_en && !empty) begin
            rd_data <= mem[rd_addr];
            rd_ptr  <= rd_ptr + 1'b1;
        end
    end

    // -------------------------------------------------------------------
    // TODO (Week 4): add SVA assertions here, e.g.
    //   assert property (@(posedge clk) disable iff (!rst_n) !(full && empty));
    // -------------------------------------------------------------------

endmodule
