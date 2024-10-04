module tb_parallel_to_serial_interface;

    // Testbench signals
    reg clk;
    reg rst;
    reg start;
    reg [15:0] out_inv11, out_inv12, out_inv13;
    reg [15:0] out_inv21, out_inv22, out_inv23;
    reg [15:0] out_inv31, out_inv32, out_inv33;
    wire [7:0] serial_out;
    wire done;

    // Instantiate the DUT (Device Under Test)
    parallel_to_serial_interface dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .out_inv11(out_inv11), .out_inv12(out_inv12), .out_inv13(out_inv13),
        .out_inv21(out_inv21), .out_inv22(out_inv22), .out_inv23(out_inv23),
        .out_inv31(out_inv31), .out_inv32(out_inv32), .out_inv33(out_inv33),
        .serial_out(serial_out),
        .done(done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period, 100 MHz
    end

    // Stimulus process
    initial begin
        // Initialize signals
        rst = 1;
        start = 0;
        out_inv11 = 16'h1234;  out_inv12 = 16'h5678;  out_inv13 = 16'h9ABC;
        out_inv21 = 16'hDEF0;  out_inv22 = 16'h1111;  out_inv23 = 16'h2222;
        out_inv31 = 16'h3333;  out_inv32 = 16'h4444;  out_inv33 = 16'h5555;

        // Apply reset
        #10 rst = 0;

        // Start the serialization process
        #10 start = 1;

        // Wait for done signal
        wait(done == 1'b1);

        // Test done, stop simulation
        #10 $stop;
    end

    // Monitor the output to see the serialized data
    initial begin
        $monitor("Time = %0t, serial_out = %h, done = %b",
                 $time, serial_out, done);
    end
endmodule
