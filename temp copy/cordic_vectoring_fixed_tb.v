`timescale 1ns/1ps

module cordic_vectoring_fixed_tb;

  // Parameters for the CORDIC module
  parameter wordLength = 16;
  parameter fractionLength = 12;
  parameter N =15;

  // Testbench signals
  reg signed [wordLength-1:0] x_in_tb, y_in_tb;
  reg clk_tb, rst_tb;
  wire signed [wordLength-1:0] x_out_tb, y_out_tb, theta_tb;
  wire done_tb;
  reg valid;
  wire capt = dut.capt;
  wire [wordLength-1:0] x = dut.x;
  wire [wordLength-1:0] y = dut.y;
  wire [wordLength-1:0] theta_internal = dut.theta_internal;
  wire [wordLength-1:0] K = dut.K;
  // Clock period definition (e.g., 10ns for a 100 MHz clock)
  localparam CLK_PERIOD = 10;

  // DUT instantiation
  cordic_vectoring_fixed #(.N(N), .wordLength(wordLength), .fractionLength(fractionLength)) dut (
    .x_in(x_in_tb),
    .y_in(y_in_tb),
    .x_out(x_out_tb),
    .y_out(y_out_tb),
    .theta(theta_tb),
    .clk(clk_tb),
    .rst(rst_tb),
    .done(done_tb),
    .valid(valid)
  );

  // Clock generation
  initial begin
    clk_tb = 0;
    forever #(5) clk_tb = ~clk_tb;
  end

// Reset generation
  initial begin
    rst_tb = 1;  // Apply reset
    #15 rst_tb = 0; // Release reset after 15 ns
        valid = 1;
    #20 rst_tb = 1; // Deassert reset after some time
  end

  // Stimulus process with input values applied after reset
  initial begin
    // Wait for reset de-assertion


    // Apply the first test case
    @(negedge clk_tb);
    x_in_tb = 16'b0001000000000000;  // Example vector (in fixed-point)
    y_in_tb = 16'b0001000000000000;  // Example vector (in fixed-point)

    // Wait for the done signal and allow time for waveforms
    @(posedge done_tb);

    // Apply a second test case
    x_in_tb = 16'b0001000000000000;  // Negative vector
    y_in_tb = 16'b0011000000000000;

    @(posedge done_tb);
    // Apply a 3rd test case
    x_in_tb = 16'b0011000000000000;  // Negative vector
    y_in_tb = 16'b0111000000000000;

    @(posedge done_tb);
    // Apply a 4th test case
    x_in_tb = 16'b0001000000000000;  // Negative vector
    y_in_tb = 16'b1111000000000000;

    @(posedge done_tb);
    // Apply a 4th test case
    x_in_tb = 16'b1111000000000000;  // Negative vector
    y_in_tb = 16'b0001000000000000;

    @(posedge done_tb);
    // Finish the simulation after a few cycles
    // Additional test cases can be added here

    // Finish simulation after sufficient time
    #200;
    $stop;
  end

  // Display the results of each test case
  initial begin
    $monitor("Time: %0t | x_in: %0d, y_in: %0d | x_out: %0d, y_out: %0d, theta: %0d", 
              $time, x_in_tb, y_in_tb, x_out_tb, y_out_tb, theta_tb);
  end
/*
  // Dump waveform
  initial begin
    $dumpfile("cordic_vectoring_fixed_tb.vcd");
    $dumpvars(0, cordic_vectoring_fixed_tb);
  end
*/
endmodule
