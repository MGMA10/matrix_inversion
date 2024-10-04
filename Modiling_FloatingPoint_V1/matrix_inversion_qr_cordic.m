function [Q,R] = matrix_inversion_qr_cordic(A)
    % QR decomposition for a 3x3 matrix using CORDIC with 15 iterations
    % A is a 3x3 input matrix
    % R is the upper triangular++ matrix
    % Q is the orthogonal matrix
    
    N = 15;  % Number of CORDIC iterations
    
    % Extract elements from the input matrix A
    a = A(1, 1); b = A(1, 2); c = A(1, 3);
    d = A(2, 1); e = A(2, 2); f = A(2, 3);
    g = A(3, 1); h = A(3, 2); i = A(3, 3);
    
    %% First pivot: a, to be nulled: d
    % Step 1: Null d using vectoring CORDIC
    [a, d, theta1] = cordic_vectoring(a, d, N);
    
    % Step 2: Use b and e, c and f in rotational CORDIC to update
    [b, e] = cordic_rotation(b, e, theta1, N);
    [c, f] = cordic_rotation(c, f, theta1, N);
    
    % Step 3: Update matrix R and Q with cos and sin of theta1
    Q1 = build_rotation_matrix(theta1, 3, 1, 2);
    
    %% Second pivot: a, to be nulled: g
    % Step 1: Null g using vectoring CORDIC
    [a, g, theta2] = cordic_vectoring(a, g, N);
    
    % Step 2: Use b and h, c and i in rotational CORDIC to update
    [b, h] = cordic_rotation(b, h, theta2, N);
    [c, i] = cordic_rotation(c, i, theta2, N);
    
    % Step 3: Update matrix R and Q with cos and sin of theta2
    Q2 = build_rotation_matrix(theta2, 3, 1, 3);
    
    %% Third pivot: e, to be nulled: h
    % Step 1: Null h using vectoring CORDIC
    [e, h, theta3] = cordic_vectoring(e, h, N);
    
    % Step 2: Use f and i in rotational CORDIC to update
    [f, i] = cordic_rotation(f, i, theta3, N);
    
    % Step 3: Update matrix R and Q with cos and sin of theta3
    Q3 = build_rotation_matrix(theta3, 3, 2, 3);
    
    %% Compute the final R and Q matrices
    R = [a, b, c; 0, e, f; 0, 0, i];
    Q = Q1 * Q2 * Q3;  % Q is the product of the individual rotations
end
