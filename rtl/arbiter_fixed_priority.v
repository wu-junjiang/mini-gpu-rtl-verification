// =============================================================================
// Module: arbiter_fixed_priority
// Description: N-input fixed-priority arbiter. Lower index = higher priority.
// Week 3 goal: grant behaviour verified for all requester combinations
// =============================================================================

module arbiter_fixed_priority #(
    parameter N = 4
) (
    input  wire [N-1:0] req,     // request lines, one per client
    output reg  [N-1:0] grant    // one-hot grant, at most one bit set
);

    integer i;

    always @(*) begin
        grant = {N{1'b0}};
        // Scan from highest priority (index 0) downward; grant the first
        // requester found and stop (fixed priority = lowest index always wins).
        for (i = 0; i < N; i = i + 1) begin
            if (req[i] && grant == {N{1'b0}}) begin
                grant[i] = 1'b1;
            end
        end
    end

    // TODO (Week 8): add a formal property here — e.g. "at most one grant bit
    // is ever set" and "if req[0] is asserted, grant[0] is asserted" (since
    // index 0 is always highest priority).

endmodule
