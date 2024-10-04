module tb_serial_parallel_interface;

    // Testbench signals
    reg clk;
    reg rst;
    reg start;
    reg [7:0] serial_in;
    wire done;
    wire [15:0] a_in, b_in, c_in, d_in, e_in, f_in, g_in, h_in, i_in;

    // Instantiate the DUT (Device Under Test)
    serial_parallel_interface dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .serial_in(serial_in),
        .done(done),
        .a_in(a_in),
        .b_in(b_in),
        .c_in(c_in),
        .d_in(d_in),
        .e_in(e_in),
        .f_in(f_in),
        .g_in(g_in),
        .h_in(h_in),
        .i_in(i_in)
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
        serial_in = 8'b0;

        // Apply reset
        #10;
        rst = 0;

        // Start sequence after reset
        #10;
        start = 1;

        // Apply serial input data
        #10 serial_in = 8'hAA;  // Input for the first half of a_in
        #10 serial_in = 8'h55;  // Input for the second half of a_in
        #10 serial_in = 8'h12;  // Input for the first half of b_in
        #10 serial_in = 8'h34;  // Input for the second half of b_in
        #10 serial_in = 8'h56;  // Input for the first half of c_in
        #10 serial_in = 8'h78;  // Input for the second half of c_in
        #10 serial_in = 8'h9A;  // Input for the first half of d_in
        #10 serial_in = 8'hBC;  // Input for the second half of d_in
        #10 serial_in = 8'hDE;  // Input for the first half of e_in
        #10 serial_in = 8'hF0;  // Input for the second half of e_in
        #10 serial_in = 8'h11;  // Input for the first half of f_in
        #10 serial_in = 8'h22;  // Input for the second half of f_in
        #10 serial_in = 8'h33;  // Input for the first half of g_in
        #10 serial_in = 8'h44;  // Input for the second half of g_in
        #10 serial_in = 8'h55;  // Input for the first half of h_in
        #10 serial_in = 8'h66;  // Input for the second half of h_in
        #10 serial_in = 8'h77;  // Input for the first half of i_in
        #10 serial_in = 8'h88;  // Input for the second half of i_in

        // Wait for done signal
        #10;
        wait(done == 1'b1);

        // Test done, stop simulation
        #10;
        $stop;
    end

    // Monitor the output to see the values of the parallel data
    initial begin
        $monitor("Time = %0t, a_in = %h, b_in = %h, c_in = %h, d_in = %h, e_in = %h, f_in = %h, g_in = %h, h_in = %h, i_in = %h, done = %b",
                 $time, a_in, b_in, c_in, d_in, e_in, f_in, g_in, h_in, i_in, done);
    end
endmodule
