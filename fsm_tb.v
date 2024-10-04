`timescale 1ns/1ps

module cordic_top_tb;

// Parameters
parameter wordLength = 16;

// Inputs
reg clk;
reg reset;
reg valid;
reg [wordLength-1:0] a_in, b_in, c_in, d_in, e_in, f_in, g_in, h_in, i_in;

// Outputs
wire [wordLength-1:0] out_inv11, out_inv12, out_inv13;
wire [wordLength-1:0] out_inv21, out_inv22, out_inv23;
wire [wordLength-1:0] out_inv31, out_inv32, out_inv33;
wire done;
wire Error;
// test signal
wire [wordLength-1:0] R_inv11 = dut.uut.inv_a11   , R_inv12 = dut.uut.inv_a12   , R_inv13 = dut.uut.inv_a13   ;
wire [wordLength-1:0]R_inv22 = dut.uut.inv_a22   , R_inv23 = dut.uut.inv_a23   ;
wire [wordLength-1:0] R_inv33 = dut.uut.inv_a33   ;
wire [4:0] i = dut.uut.DUT1.i;
wire [15:0] z = dut.uut.DUT1.quotient;
wire [15:0] z2 = dut.uut.quotient1;
wire  done1 = dut.uut.done1;
wire  done2 = dut.uut.done2;
wire  done3 = dut.uut.done3;
wire [1:0] calc = dut.uut.calc;
wire [3:0] state = dut.dut.state;
wire [16-1:0] cordic_rotate_in1 =  dut.dut.cordic_rotate_in1;
    wire [16-1:0] cordic_vector_in2 =  dut.dut.cordic_vector_in2;
// Instantiate the DUT (Device Under Test)
cordic_top dut (
    .clk(clk),
    .reset(reset),
    .valid(valid),
    .a_in(a_in),
    .b_in(b_in),
    .c_in(c_in),
    .d_in(d_in),
    .e_in(e_in),
    .f_in(f_in),
    .g_in(g_in),
    .h_in(h_in),
    .i_in(i_in),
    .out_inv11(out_inv11),
    .out_inv12(out_inv12),
    .out_inv13(out_inv13),
    .out_inv21(out_inv21),
    .out_inv22(out_inv22),
    .out_inv23(out_inv23),
    .out_inv31(out_inv31),
    .out_inv32(out_inv32),
    .out_inv33(out_inv33),
    .donem3(done),
    .Error(Error)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100 MHz clock, period 10ns
end

// Test sequence
initial begin
    // Initialize inputs
    reset = 1;
    valid = 0;
    a_in = 16'h0000;
    b_in = 16'h0000;
    c_in = 16'h0000;
    d_in = 16'h0000;
    e_in = 16'h0000;
    f_in = 16'h0000;
    g_in = 16'h0000;
    h_in = 16'h0000;
    i_in = 16'h0000;

    // Apply reset
    #10;
    reset = 0;
    #10
    // Apply test inputs
    #20;
    reset = 1;
    valid = 0;
    a_in = 16'h1000; // Example input values
    b_in = 16'h1000;
    c_in = 16'h1000;
    d_in = 16'h0000;
    e_in = 16'h1000;
    f_in = 16'h1000;
    g_in = 16'h1000;
    h_in = 16'h1000;
    i_in = 16'h5000;
#50
i_in = 16'h0000;
#50
valid = 1;
#10
valid = 0;

    // Wait for the DUT to process
    wait (done);

    // Check the outputs
    #10;
    $display("Output Inverse Matrix:");
    $display("out_inv11 = %h, out_inv12 = %h, out_inv13 = %h", out_inv11, out_inv12, out_inv13);
    $display("out_inv21 = %h, out_inv22 = %h, out_inv23 = %h", out_inv21, out_inv22, out_inv23);
    $display("out_inv31 = %h, out_inv32 = %h, out_inv33 = %h", out_inv31, out_inv32, out_inv33);

    // Finish simulation
    #50;
    $stop;
end

endmodule

/*
module cordic_fsm_tb;

    // Testbench Parameters
    parameter N = 15;
    parameter wordLength = 16;
    parameter fractionLength = 12;
    parameter size = 3;
    // Inputs to the DUT
    reg clk;
    reg reset;
    reg [wordLength-1:0] a_in, d_in, g_in, b_in, e_in, h_in, c_in, f_in, i_in;
    reg valid;
    wire doneq;
    
    // Outputs from the DUT
    wire [wordLength-1:0] a_out, b_out, c_out, d_out, e_out, f_out, g_out, h_out, i_out;
    wire [wordLength-1:0] a = dut.a, b = dut.b, c = dut.c, d = dut.d, e = dut.e, f = dut.f, g = dut.g, h = dut.h, i = dut.i;
    wire done;
    wire [wordLength-1:0] sin1,sin2,sin3;
    wire [wordLength-1:0] cos1,cos2,cos3;

    // Outputs from the DUTQ1
    wire [wordLength-1:0] m11, m12, m13;
    wire [wordLength-1:0] m21, m22, m23;
    wire [wordLength-1:0] m31, m32, m33;

     // Outputs from the DUTQ2
    wire [wordLength-1:0] Q11, Q12, Q13;
    wire [wordLength-1:0] Q21, Q22, Q23;
    wire [wordLength-1:0] Q31, Q32, Q33;

     // Outputs from the DUTQ3
    wire [wordLength-1:0] P11, P12, P13;
    wire [wordLength-1:0] P21, P22, P23;
    wire [wordLength-1:0] P31, P32, P33;

    // Outputs from the DUTQ3
    wire [wordLength-1:0] T11, T12, T13;
    wire [wordLength-1:0] T21, T22, T23;
    wire [wordLength-1:0] T31, T32, T33;

    // Outputs from the DUTQ3
    wire [wordLength-1:0] H11, H12, H13;
    wire [wordLength-1:0] H21, H22, H23;
    wire [wordLength-1:0] H31, H32, H33;

    // Outputs from the DUTQ3
    wire [wordLength-1:0] Qt11, Qt12, Qt13;
    wire [wordLength-1:0] Qt21, Qt22, Qt23;
    wire [wordLength-1:0] Qt31, Qt32, Qt33;

    // Outputs from the DUTQ3
    wire [wordLength-1:0] out_inv11, out_inv12, out_inv13;
    wire [wordLength-1:0] out_inv21, out_inv22, out_inv23;
    wire [wordLength-1:0] out_inv31, out_inv32, out_inv33;


    wire signed [15:0] inv_a11, inv_a12, inv_a13;
    wire signed [15:0] inv_a22, inv_a23;
    wire signed [15:0] inv_a33;
    wire signed [31:0] S12 = m2.S12;

    rotation_matrix1 DUTQ1(
        .cos1, .sin1, // cos(θ1), sin(θ1)
        .m11, .m12, .m13,  // First row of the matrix
        .m21, .m22, .m23,  // Second row of the matrix
        .m31, .m32, .m33   // Third row of the matrix
    );

    rotation_matrix2 DUTQ2(
        .cos2, .sin2, // cos(θ1), sin(θ1)
        .Q11, .Q12, .Q13,  // First row of the Qatrix
        .Q21, .Q22, .Q23,  // Second row of the Qatrix
        .Q31, .Q32, .Q33   // Third row of the Qatrix
    );

    rotation_matrix3 DUTQ3(
        .cos3, .sin3, // cos(θ1), sin(θ1)
        .P11, .P12, .P13,  // First row of the Patrix
        .P21, .P22, .P23,  // Second row of the Patrix
        .P31, .P32, .P33   // Third row of the Patrix
    );

    matrix_multiply m1(
        .Q11(m11), .Q12(m12), .Q13(m13), .Q21(m21), .Q22(m22), .Q23(m23), .Q31(m31), .Q32(m32), .Q33(m33),  
        .P11(Q11), .P12(Q12), .P13(Q13), .P21(Q21), .P22(Q22), .P23(Q23), .P31(Q31), .P32(Q32), .P33(Q33),  
        .R11(T11), .R12(T12), .R13(T13), .R21(T21), .R22(T22), .R23(T23), .R31(T31), .R32(T32), .R33(T33) 
    );

    matrix_multiply m2(
        .Q11(T11), .Q12(T12), .Q13(T13), .Q21(T21), .Q22(T22), .Q23(T23), .Q31(T31), .Q32(T32), .Q33(T33),  
        .P11(P11), .P12(P12), .P13(P13), .P21(P21), .P22(P22), .P23(P23), .P31(P31), .P32(P32), .P33(P33),  
        .R11(H11), .R12(H12), .R13(H13), .R21(H21), .R22(H22), .R23(H23), .R31(H31), .R32(H32), .R33(H33) 
    );

    transpose_3x3 t(
    .a11(H11), .a12(H12), .a13(H13),  // Row 1
    .a21(H21), .a22(H22), .a23(H23),  // Row 2
    .a31(H31), .a32(H32), .a33(H33),  // Row 3
    .at11(Qt11), .at12(Qt12), .at13(Qt13),  
    .at21(Qt21), .at22(Qt22), .at23(Qt23),  
    .at31(Qt31), .at32(Qt32), .at33(Qt33)
);

matrix_multiply m3(
    .Q11(inv_a11), .Q12(inv_a12), .Q13(inv_a13), .Q21(0), .Q22(inv_a22), .Q23(inv_a23), .Q31(0), .Q32(0), .Q33(inv_a33),  // Qatrix
    .P11(Qt11), .P12(Qt12), .P13(Qt13), .P21(Qt21), .P22(Qt22), .P23(Qt23), .P31(Qt31), .P32(Qt32), .P33(Qt33),  // Patrix
    .R11(out_inv11), .R12(out_inv12), .R13(out_inv13), .R21(out_inv21), .R22(out_inv22), .R23(out_inv23), .R31(out_inv31), .R32(out_inv32), .R33(out_inv33) // .Result matrix
);

    // Instantiate the Unit Under Test (UUT)
    inv_3x3_upper_triangular uut (
        //.clk(clk),
        //.reset(reset),
        .a11(a_out), 
        .a12(b_out), 
        .a13(c_out), 
        .a22(e_out), 
        .a23(f_out), 
        .a33(i_out), 
        .inv_a11(inv_a11), 
        .inv_a12(inv_a12), 
        .inv_a13(inv_a13), 
        .inv_a22(inv_a22), 
        .inv_a23(inv_a23), 
        .inv_a33(inv_a33)
    );

    // internal signal for text
    wire [wordLength-1:0] cordic_vector_out1 = dut.cordic_vector_out1;
    wire [wordLength:0] xcv = dut.dutcv.x;
    wire [wordLength:0] xcr = dut.dutcr.x;
    wire [wordLength:0] ycr = dut.dutcr.y;
    wire donecv = dut.dutcv.done;
    wire donecr = dut.dutcr.done;
    wire [3:0] state = dut.state , next_state = dut.next_state ;
    wire validcr = dut.rotating_start;
    // Instantiate the DUT
    cordic_fsm #(.N(N), .wordLength(wordLength), .fractionLength(fractionLength)) dut (
        .clk(clk),
        .reset(reset),
        .a_in(a_in),
        .b_in(b_in),
        .c_in(c_in),
        .d_in(d_in),
        .e_in(e_in),
        .f_in(f_in),
        .g_in(g_in),
        .h_in(h_in),
        .i_in(i_in),
        .a_out(a_out),
        .b_out(b_out),
        .c_out(c_out),
        .d_out(d_out),
        .e_out(e_out),
        .f_out(f_out),
        .g_out(g_out),
        .h_out(h_out),
        .i_out(i_out),
        .done(done),
        .valid(valid),
        .sin1(sin1),
        .sin2(sin2),
        .sin3(sin3),
        .cos1(cos1),
        .cos2(cos2),
        .cos3(cos3)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock period (10 ns)
    end

    // Stimulus: Initialize inputs and apply reset
    initial begin
        // Monitor outputs
        $monitor("Time: %0t | done: %b | a_out: %h | b_out: %h | c_out: %h | d_out: %h | e_out: %h | f_out: %h | g_out: %h | h_out: %h | i_out: %h",
                  $time, done, a_out, b_out, c_out, d_out, e_out, f_out, g_out, h_out, i_out);

        // Apply reset
        reset = 0;
        
        // Test case 1: Apply initial matrix inputs (random values)
        a_in = 16'h1000; // 1.0 in Q12.4 format
        b_in = 16'h0000; // 0.5 in Q12.4 format
        c_in = 16'h0000; // 0.25 in Q12.4 format
        d_in = 16'h0000; // 0.125 in Q12.4 format
        e_in = 16'h1000; // 0.0625 in Q12.4 format
        f_in = 16'h0000; // 0.03125 in Q12.4 format
        g_in = 16'h0000; // 0.015625 in Q12.4 format
        h_in = 16'h0000; // 0.0078125 in Q12.4 format
        i_in = 16'h1000; // 0.00390625 in Q12.4 format
        #10 reset = 1;
            valid = 1;
        // Wait for done signal
        wait(done == 1);
        valid = 0;
        // Test case 2: Apply a different set of inputs
        a_in = 16'h2000; // 2.0 in Q12.4 format
        b_in = 16'h1800; // 1.5 in Q12.4 format
        c_in = 16'h1000; // 1.0 in Q12.4 format
        d_in = 16'h0800; // 0.5 in Q12.4 format
        e_in = 16'h0400; // 0.25 in Q12.4 format
        f_in = 16'h0200; // 0.125 in Q12.4 format
        g_in = 16'h0100; // 0.0625 in Q12.4 format
        h_in = 16'h0080; // 0.03125 in Q12.4 format
        i_in = 16'h0040; // 0.015625 in Q12.4 format

        // Wait for done signal
        wait(done == 1);
        #20;

        // Finish simulation
        $stop;
    end
endmodule
*/