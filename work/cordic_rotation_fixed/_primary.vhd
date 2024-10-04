library verilog;
use verilog.vl_types.all;
entity cordic_rotation_fixed is
    generic(
        N               : integer := 15;
        wordLength      : integer := 16;
        fractionLength  : integer := 12
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        valid           : in     vl_logic;
        x_in            : in     vl_logic_vector;
        y_in            : in     vl_logic_vector;
        theta_in        : in     vl_logic_vector;
        x_out           : out    vl_logic_vector;
        y_out           : out    vl_logic_vector;
        done            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N : constant is 1;
    attribute mti_svvh_generic_type of wordLength : constant is 1;
    attribute mti_svvh_generic_type of fractionLength : constant is 1;
end cordic_rotation_fixed;
