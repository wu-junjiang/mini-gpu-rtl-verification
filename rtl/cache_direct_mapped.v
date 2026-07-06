// =============================================================================
// Module: cache_direct_mapped
// Description: Simple direct-mapped cache with valid bits and tag comparison.
//              Read-only lookup logic (no write-back/eviction policy needed
//              for a direct-mapped cache since each address maps to exactly
//              one line).
// Week 4 goal: hit/miss logic verified against a reference model
// =============================================================================

module cache_direct_mapped #(
    parameter ADDR_WIDTH  = 16,
    parameter DATA_WIDTH  = 32,
    parameter NUM_LINES   = 64,
    parameter INDEX_WIDTH = $clog2(NUM_LINES),
    parameter TAG_WIDTH   = ADDR_WIDTH - INDEX_WIDTH
) (
    input  wire                    clk,
    input  wire                    rst_n,

    // Lookup request
    input  wire                    req_valid,
    input  wire [ADDR_WIDTH-1:0]   req_addr,

    // Lookup result (registered, available one cycle after req_valid)
    output reg                     resp_hit,
    output reg  [DATA_WIDTH-1:0]   resp_data,

    // Fill port (used on a miss, e.g. after fetching from memory)
    input  wire                    fill_valid,
    input  wire [ADDR_WIDTH-1:0]   fill_addr,
    input  wire [DATA_WIDTH-1:0]   fill_data
);

    reg                     valid   [0:NUM_LINES-1];
    reg [TAG_WIDTH-1:0]     tag     [0:NUM_LINES-1];
    reg [DATA_WIDTH-1:0]    data    [0:NUM_LINES-1];

    wire [INDEX_WIDTH-1:0] req_index  = req_addr[INDEX_WIDTH-1:0];
    wire [TAG_WIDTH-1:0]   req_tag    = req_addr[ADDR_WIDTH-1:INDEX_WIDTH];

    wire [INDEX_WIDTH-1:0] fill_index = fill_addr[INDEX_WIDTH-1:0];
    wire [TAG_WIDTH-1:0]   fill_tag   = fill_addr[ADDR_WIDTH-1:INDEX_WIDTH];

    integer li;

    // Lookup (registered response, one cycle latency)
    always @(posedge clk) begin
        if (!rst_n) begin
            resp_hit  <= 1'b0;
            resp_data <= {DATA_WIDTH{1'b0}};
        end else if (req_valid) begin
            resp_hit  <= valid[req_index] && (tag[req_index] == req_tag);
            resp_data <= data[req_index];
        end
    end

    // Fill (on a miss, caller writes the correct line in)
    always @(posedge clk) begin
        if (!rst_n) begin
            for (li = 0; li < NUM_LINES; li = li + 1) begin
                valid[li] <= 1'b0;
            end
        end else if (fill_valid) begin
            valid[fill_index] <= 1'b1;
            tag[fill_index]   <= fill_tag;
            data[fill_index]  <= fill_data;
        end
    end

    // TODO (Week 4 stretch): extend to N-way set-associative by adding a
    // `way` dimension to valid/tag/data and a simple replacement policy
    // (e.g. LRU or round-robin victim selection).

endmodule
