module cordic_div #(parameter WORD_LENGTH = 16, FRACTION_LENGTH = 12, N = 15)
    (
        input clk,                                         // Clock signal
        input reset,                                       // Reset signal
        input start,                                       // Start signal
        input signed [WORD_LENGTH-1:0] numerator,          // Numerator input (signed fixed-point)
        input signed [WORD_LENGTH-1:0] denominator,        // Denominator input (signed fixed-point)
        output reg signed [WORD_LENGTH-1:0] quotient,      // Quotient output (signed fixed-point)
        output reg done,                                   // Done signal to indicate completion
        output reg Error                                   // Error signal for edge cases
    );
    
    // Internal signals and registers
    reg signed [2*WORD_LENGTH-1:0] y;                      // y = Denominator during iteration
    reg signed [WORD_LENGTH-1:0] z;                        // z = Quotient during iteration
    reg signed [WORD_LENGTH-1:0] x;                        // x = Numerator (absolute value)
    reg signed [WORD_LENGTH-1:0] abs_x;                    // Absolute value of numerator
    reg xsign;                                             // Sign of numerator
    reg [3:0] i;                                           // Iteration counter
    wire signed [WORD_LENGTH+3:0] step_size;               // Step size: abs(x)*2^(3-i)
    reg [1:0] state;                                       // State register
    
    // State encoding
    localparam IDLE = 2'b00, INIT = 2'b01, PROCESS = 2'b10, DONE = 2'b11;

    // Compute step size for the current iteration
    assign step_size = (abs_x <<< 3);                      // abs(x)*2^3

    // Main CORDIC process with state machine
    always @(posedge clk or negedge reset) begin
        
        if (!reset) begin
            // Reset state
            quotient <= 0;
            done <= 0;
            state <= IDLE;
            i <= 0;
            y <= 0;
            z <= 0;
            xsign <= 0;
            Error <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    // Wait for the start signal
                    if (start) begin
                        abs_x <= (numerator[WORD_LENGTH-1] == 1'b1) ? -numerator : numerator; // Absolute value of numerator
                        xsign <= (numerator[WORD_LENGTH-1] == 1'b1);                         // Sign of numerator
                        y <= { {WORD_LENGTH{denominator[WORD_LENGTH-1]}}, denominator };     // Extend denominator to 2*WORD_LENGTH
                        z <= 0;                                                              // Initialize quotient register
                        i <= 0;                                                              // Initialize iteration counter
                        done <= 0;                                                           // Reset done signal
                        Error <= (numerator == 0);                                         // Check for division by zero
                        state <= (numerator != 0) ? INIT : IDLE;                           // Move to INIT if denominator is non-zero
                    end
                end

                INIT: begin
                    // Prepare for processing
                    state <= PROCESS;
                end

                PROCESS: begin
                    // Perform the iterative CORDIC division algorithm
                    if (i < N-1) begin
                        if (y[2*WORD_LENGTH-1] == 1) begin
                            y <= y + (step_size >>> i);                // y = y + abs(x)*2^(3-i)
                            z <= z - (16'h8000 >>> (i));                    // z = z - 2^(3-i)
                        end else begin
                            y <= y - (step_size >>> i);                // y = y - abs(x)*2^(3-i)
                            z <= z + (16'h8000 >>> (i));                    // z = z + 2^(3-i)
                        end
                        i <= i + 1;                                    // Increment iteration counter
                    end else begin
                        state <= DONE;                                 // Move to DONE state
                    end
                end

                DONE: begin
                    // Finalize and output the result
                    quotient <= (xsign) ? -z : z;                      // Apply sign to the quotient
                    done <= 1;                                         // Set done signal high
                    state <= IDLE;                                     // Return to IDLE state
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule
