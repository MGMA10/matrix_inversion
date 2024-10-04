clear;
clc;
% Test matrix A
A = rand(3)*8
% h6000_3000_2000_1000_3000_1000_0000_2000_4000
% Compute the inverse using the CORDIC QR decomposition method
[Qt,Rt] = matrix_inversion_qr_cordic(A)
A_inv = matrix_inverse_custom(Qt, Rt);
[Q,R] = qr(A)
% Compare with MATLAB's built-in inverse 
A_builtin_inv = inv(A);

% Display the results
disp('CORDIC-based Inverse:');
disp(A_inv);

disp('MATLAB built-in Inverse:');
disp(A_builtin_inv);

% Check the error
error = norm(A_inv - A_builtin_inv);
disp(['Error for the inverse total: ',  num2str(error) ]);

% Check the QR error
error = norm(abs(Rt) - abs(R));
disp(['Error for R Matrix: ', num2str(error) ]);

error = norm(abs(Qt) - abs(Q));
disp(['Error for Q Matrix: ',  num2str(error)]);

A * A_inv