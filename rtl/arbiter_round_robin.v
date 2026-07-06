// =============================================================================
// Module: arbiter_round_robin
// Description: N-input round-robin arbiter. Priority rotates after each grant
//              so no single requester can starve the others.
// Week 3 goal: verify fairness - every requester eventually gets granted
//              under sustained back-to-back requests
// =============================================================================

module arbiter_round_robin #(
    parameter N = 4
) (
    input  wire             clk,
    input  wire             rst_n,
    input  wire [N-1:0]     req,
    output reg  [N-1:0]     grant
);

    // Points to the highest-priority requester for THIS cycle's arbitration
    reg [N-1:0] priority_ptr;

    // Double-width request vector lets us "rotate" priority without a
    // separate barrel shifter - a common, interview-relevant trick.
    wire [2*N-1:0] req_double = {req, req};
    reg  [2*N-1:0] grant_double;

    integer i;
    integer idx;

    always @(*) begin
        grant_double = {2*N{1'b0}};
        // Find pointer's bit position
        idx = 0;
        for (i = 0; i < N; i = i + 1) begin
            if (priority_ptr[i]) idx = i;
        end

        // Scan starting from idx, wrapping via the doubled request vector
        for (i = 0; i < N; i = i + 1) begin
            if (req_double[idx + i] && grant_double == {2*N{1'b0}}) begin
                grant_double[idx + i] = 1'b1;
            end
        end
        grant = grant_double[N-1:0] | grant_double[2*N-1:N];
    end

    // Advance the pointer to just after whoever was granted this cycle
    always @(posedge clk) begin
        if (!rst_n) begin
            priority_ptr <= {{(N-1){1'b0}}, 1'b1};   // start pointing at requester 0
        end else if (grant != {N{1'b0}}) begin
            priority_ptr <= {grant[N-2:0], grant[N-1]};  // rotate left by 1
        end
    end

    // TODO (Week 8): formal property for fairness - e.g. "if req[k] stays
    // asserted continuously, grant[k] must eventually assert within N cycles"

endmodule
