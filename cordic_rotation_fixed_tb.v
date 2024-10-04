`timescale 1ns / 1ps

module cordic_rotation_fixed_tb;

    // Parameters
    parameter N = 15;
    parameter wordLength = 16;
    parameter fractionLength = 12;
    parameter tests = 100;
    // Inputs
    reg signed [wordLength-1:0] x_in, y_in, theta_in;
    reg clk, rst;
    reg valid;
    // Outputs
    wire signed [wordLength-1:0] x_out, y_out;
    wire signed [2*wordLength-1:0] x_out1 = dut.x, y_out1= dut.y;
    wire done;
    
    // Instantiate the CORDIC rotation module
    cordic_rotation_fixed #(N, wordLength, fractionLength) dut (
        .x_in(x_in),
        .y_in(y_in),
        .theta_in(theta_in),
        .x_out(x_out),
        .y_out(y_out),
        .clk(clk),
        .done(done),
        .valid(valid),
        .rst(rst)
    );

    // Memory arrays for input/output data
    reg signed [wordLength-1:0] theta_data [0:tests-1];
    reg signed [wordLength-1:0] x_data [0:tests-1];
    reg signed [wordLength-1:0] y_data [0:tests-1];
    reg signed [wordLength-1:0] x_expected [0:tests-1];
    reg signed [wordLength-1:0] y_expected [0:tests-1];

    // File handlers
    integer i;

    // Clock generation
    always #5 clk = ~clk;  // 10 ns clock period (100 MHz)

    // Test process
    initial begin
        // Initialize inputs
        rst = 1;
        valid = 1 ;

        #10
        clk = 0;
        rst = 0;
        x_in = 0;
        y_in = 0;
        
        theta_in = 0;
        #10
        rst = 1;
        /*
        // Load input and expected output data from hex files
        $readmemh("cordic_inputtheta_in.txt", theta_data);
        $readmemh("cordic_inputx_in.hex", x_data);
        $readmemh("cordic_inputy_in.hex", y_data);
        $readmemh("cordic_outputx.hex", x_expected);
        $readmemh("cordic_outputy.hex", y_expected);
*/
        // Wait for reset deassertion
        theta_in = 16'b0010000000000000;
        x_in = 'h1000;
        y_in = 'h0;
        @(dut.done)

        theta_in = 16'b0000010000000000;
        x_in = 'h1000;
        y_in = 'h3000;
        @(dut.done)
        /*
        // Iterate through all test cases
        for (i = 0; i < tests; i = i + 1) begin
            // Apply test inputs
            theta_in = theta_data[i];
            x_in = x_data[i];
            y_in = y_data[i];

            // Wait for the result to propagate (assumes result is ready in the next clock cycle)
            #150;
            // Check the outputs
            if (x_out !== x_expected[i]) begin
                $display("Mismatch at index %0d: x_out = %h, expected = %h", i, x_out, x_expected[i]);
            end else if (y_out !== y_expected[i]) begin
                $display("Mismatch at index %0d: y_out = %h, expected = %h", i, y_out, y_expected[i]);
            end else begin
                $display("Test passed for index %0d: x_out = %h, y_out = %h", i, x_out, y_out);
            end

            // Wait for next test case
            
        end
*/
#200
        // Finish simulation
        $stop;
    end

endmodule
