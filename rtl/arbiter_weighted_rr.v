// =============================================================================
// Module: arbiter_weighted_rr
// Description: N-input weighted round-robin arbiter. Each requester gets a
//              programmable number of consecutive-cycle "credits" per turn
//              before priority rotates to the next requester.
// Week 3 goal: verify each requester receives grants proportional to its
//              assigned weight over a full arbitration cycle
// =============================================================================

module arbiter_weighted_rr #(
    parameter N          = 4,
    parameter W          = 4,          // bits per weight counter
    parameter [N*W-1:0] WEIGHTS = {4'd1, 4'd1, 4'd2, 4'd4}  // requester 3 gets 4x, etc.
) (
    input  wire         clk,
    input  wire         rst_n,
    input  wire [N-1:0] req,
    output reg  [N-1:0] grant
);

    reg [$clog2(N)-1:0] current;      // requester currently holding priority
    reg [W-1:0]         credits_left; // credits remaining for `current` this turn

    function [W-1:0] weight_of(input [$clog2(N)-1:0] idx);
        weight_of = WEIGHTS[idx*W +: W];
    endfunction

    // Combinational grant: grant `current` if it's requesting, else search
    // forward for the next requester with an active request (no credit spent
    // on requesters who aren't asking for the bus).
    integer i;
    reg [$clog2(N)-1:0] search_idx;
    always @(*) begin
        grant = {N{1'b0}};
        if (req[current]) begin
            grant[current] = 1'b1;
        end else begin
            for (i = 1; i < N; i = i + 1) begin
                search_idx = (current + i) % N;
                if (req[search_idx] && grant == {N{1'b0}}) begin
                    grant[search_idx] = 1'b1;
                end
            end
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            current      <= 0;
            credits_left <= weight_of(0);
        end else if (grant != {N{1'b0}}) begin
            if (credits_left <= 1) begin
                // move to next requester in round-robin order, reload credits
                current      <= (current + 1) % N;
                credits_left <= weight_of((current + 1) % N);
            end else begin
                credits_left <= credits_left - 1'b1;
            end
        end
    end

    // TODO (Week 8): formal/simulation check - over a long run with all
    // requesters always asserted, grant count ratio should match WEIGHTS ratio

endmodule
