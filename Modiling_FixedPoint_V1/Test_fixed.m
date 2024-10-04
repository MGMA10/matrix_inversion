wordLength = 16;
fractionLength = 12;
% Test matrix A
disp('Input Matrix');
A = fi(rand(3)* 4 , 1,wordLength,fractionLength);
% A=[6 3 2;1 3 1 ;0 2 4]
% A = double(A);
% Compute the inverse using the CORDIC QR decomposition method
disp('Outout Upper (triangle , Rotational) Matrix');
[Qt,Rt] = matrix_inversion_qr_cordic_fixed(A,wordLength, fractionLength);
A_inv = matrix_inverse_custom(Qt, Rt,wordLength, fractionLength);
disp('MATLAB built-in Upper (triangle , Rotational) Matrix:');
[Q,R] = qr(A);
Q = fi(Q, 1,wordLength,fractionLength);
R = fi(R, 1,wordLength,fractionLength);
% Compare with MATLAB's built-in inverse 
A_builtin_inv = fi(inv(A), 1,wordLength,fractionLength);

% Check the error
error = norm(double(A_inv) - double(A_builtin_inv))/9;
disp(['Error for the inverse total: ', num2str(100 * error/mean(mean(A_builtin_inv))) , '%']);

% Display the results
disp('CORDIC-based Inverse:');
disp(A_inv);

disp('MATLAB built-in Inverse:');
disp(A_builtin_inv);

disp('Outputs in HEX:');
R_Matrix =fi(Rt,1,16,12).hex
Q_Matrix =fi(Qt,1,16,12).hex
A=A
disp(hex(A_builtin_inv));
Inverse_of_A =fi(A_inv,1,16,12).hex

% Check the error
error = norm(double(A_inv) - double(A_builtin_inv))/9;
disp(['Error for the inverse total: ', num2str(100 * error/mean(mean(A_builtin_inv))) , '%']);

% Check the error
error = norm(double(A_inv) - double(A_builtin_inv))/9;
disp(['Error for the inverse total: ', num2str(error)]);

% Check the QR error
error = norm(double(abs(Rt)) - double(abs(R)))/9;
disp(['Error for R Matrix: ', num2str(error)]);

error = norm(double(abs(Qt)) - double(abs(Q)))/9;
disp(['Error for Q Matrix: ', num2str(error)]);

% 
% % Check the QR error
% error = norm(double(abs(Rt)) - abs(R))/9;
% disp(['Error for R Matrix: ', num2str(100 * error/mean(mean(R))) , '%']);
% 
% error = norm(double(abs(Qt)) - abs(Q))/9;
% disp(['Error for Q Matrix: ', num2str(100 * error/mean(mean(Q))) , '%']);




% clear;
% clc;
% % Test matrix A
% A = [4 2 1; 3 5 2; 1 1 3];
% wordLength = 16;
% fractionLength = 12;
% 
% error_A_inv = ones(30)* Inf;
% error_R = ones(30)*Inf;
% error_Q = ones(30)*Inf;
% 
% for i = 2 : 30
%     for m = 1:i
%         wordLength = i;
%         fractionLength = m;
% % Compute the inverse using the CORDIC QR decomposition method
% [Qt,Rt] = matrix_inversion_qr_cordic_fixed(A,wordLength,fractionLength);
% A_inv = matrix_inverse_custom(Qt, Rt,wordLength,fractionLength);
% [Q,R] = qr(A);
% % Compare with MATLAB's built-in inverse 
% A_builtin_inv = inv(A);
% 
% % Display the results
% % disp('CORDIC-based Inverse:');
% % disp(A_inv);
% 
% % disp('MATLAB built-in Inverse:');
% % disp(A_builtin_inv);
% 
% % Check the error
% error = norm(double(A_inv) - (A_builtin_inv));
% % disp(['Error for the inverse total: ', num2str(100 * error/mean(mean(A_builtin_inv))) , '%']);
% 
% error_A_inv(i,m) = (100 * error/mean(mean(A_builtin_inv)));
% 
% % Check the QR error
% error = norm(double(abs(Rt)) - abs(R));
% % disp(['Error for R Matrix: ', num2str(100 * error/mean(mean(R))) , '%']);
% error_R(i,m) = (100 * error/mean(mean(R)));
% 
% error = norm(double(abs(Qt)) - abs(Q));
% % disp(['Error for Q Matrix: ', num2str(100 * error/mean(mean(Q))) , '%']);
% error_Q(i,m) = (100 * error/mean(mean(Q)));
%     end
% end
% % A * A_inv;


