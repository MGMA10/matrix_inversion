function Q = build_rotation_matrix_fixed(theta, size, i, j, wordLength, fractionLength)
    % Build a rotation matrix Q of a given size, rotating rows i and j by theta
    Q = eye(size);
%     disp('************Build a rotation matrix Q*******************');
    [cos_theta,sin_theta] = cordic_rotation_fixed (1,0,-theta,15, wordLength, fractionLength); 
%     cos_theta.hex
%     sin_theta.hex
    Q(i, i) = cos_theta;
    Q(i, j) = -sin_theta;
    Q(j, i) = sin_theta;
    Q(j, j) = cos_theta;
end
