library verilog;
use verilog.vl_types.all;
entity cordic_rotation_fixed_tb is
    generic(
        N               : integer := 15;
        wordLength      : integer := 16;
        fractionLength  : integer := 12;
        tests           : integer := 100
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N : constant is 1;
    attribute mti_svvh_generic_type of wordLength : constant is 1;
    attribute mti_svvh_generic_type of fractionLength : constant is 1;
    attribute mti_svvh_generic_type of tests : constant is 1;
end cordic_rotation_fixed_tb;
