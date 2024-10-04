function [Q, R] = matrix_inversion_qr_cordic_fixed(A,wordLength,fractionLength)
    %fi parameter to make it fixed

    % QR decomposition for a 3x3 matrix using CORDIC with 15 iterations and Fixed-Point
    N = 15;  % Number of CORDIC iterations

    % Convert elements of A to Fixed-Point
    a = fi(A(1, 1), 1, wordLength, fractionLength); 
    b = fi(A(1, 2), 1, wordLength, fractionLength); 
    c = fi(A(1, 3), 1, wordLength, fractionLength);
    d = fi(A(2, 1), 1, wordLength, fractionLength); 
    e = fi(A(2, 2), 1, wordLength, fractionLength); 
    f = fi(A(2, 3), 1, wordLength, fractionLength);
    g = fi(A(3, 1), 1, wordLength, fractionLength); 
    h = fi(A(3, 2), 1, wordLength, fractionLength); 
    i = fi(A(3, 3), 1, wordLength, fractionLength);

    %% First pivot: a, to be nulled: d
%     disp('First pivot: a, to be nulled: d');
    [a, d, theta1] = cordic_vectoring_fixed(a, d, N, wordLength, fractionLength);

    [b, e] = cordic_rotation_fixed(b, e, theta1, N, wordLength, fractionLength);
    [c, f] = cordic_rotation_fixed(c, f, theta1, N, wordLength, fractionLength);
    Q1 = build_rotation_matrix_fixed(theta1, 3, 1, 2, wordLength, fractionLength);
%     q1 = fi( Q1,1, wordLength, fractionLength).hex
    %% Second pivot: a, to be nulled: g
%      disp('Second pivot: a, to be nulled: g');
    [a, g, theta2] = cordic_vectoring_fixed(a, g, N, wordLength, fractionLength);

    [b, h] = cordic_rotation_fixed(b, h, theta2, N, wordLength, fractionLength);
    [c, i] = cordic_rotation_fixed(c, i, theta2, N, wordLength, fractionLength);
    Q2 = build_rotation_matrix_fixed(theta2, 3, 1, 3, wordLength, fractionLength);
%     q2 = fi( Q2,1, wordLength, fractionLength).hex
    %% Third pivot: e, to be nulled: h
%     disp('Third pivot: e, to be nulled: h');
    [e, h, theta3] = cordic_vectoring_fixed(e, h, N, wordLength, fractionLength);

    [f, i] = cordic_rotation_fixed(f, i, theta3, N, wordLength, fractionLength);
    Q3 = build_rotation_matrix_fixed(theta3, 3, 2,3, wordLength, fractionLength);
%     q3 = fi( Q3,1, wordLength, fractionLength).hex
    %% Compute the final R and Q matrices
%     disp('Compute the final R and Q matrices');
    R = [a, b, c; 0, e, f; 0, 0, i];
    Q = Q1 * Q2 * Q3 ;
%     q = fi( Q,1, wordLength, fractionLength).hex
    
end