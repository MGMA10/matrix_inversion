% Function to calculate the inverse of a 3x3 matrix using the algorithm in the image
function A_inv = matrix_inverse_custom(Q, R,wordLength, fractionLength)
    % Input:
    % Q: Orthogonal matrix from QR decomposition
    % R: Upper triangular matrix from QR decomposition

    % Step 1: Calculate the determinant of R (|R|)
    det_R = R(1,1) * R(2,2) * R(3,3);
    
    % Step 2: Calculate the adjugate of R (adj(R))
    adj_R = [
        R(2,2)*R(3,3), -R(1,2)*R(3,3), R(1,2)*R(2,3) - R(1,3)*R(2,2);
        0, R(1,1)*R(3,3), -R(1,1)*R(2,3);
        0, 0, R(1,1)*R(2,2)
    ];
     R1i = cordic_div(R(1,1), 1, 15, 2*wordLength, fractionLength);
     R2i = cordic_div(R(2,2), 1, 15,2*wordLength, fractionLength);

     R3i = cordic_div(R(3,3), 1, 15,2*wordLength, fractionLength);
    
    % Step 3: Calculate the inverse of R (R^-1)
    R_inv = fi((R1i * R2i * R3i * adj_R), 1,3*wordLength, fractionLength);
%     R_inv.hex
    % Step 4: Calculate the inverse of A (A^-1 = R^-1 * Q^T)
    A_inv = R_inv * Q';
end
