function Q = build_rotation_matrix(theta, size, i, j)
    % Build a rotation matrix Q of a given size, rotating rows i and j by theta
    Q = eye(size);
    N = 15;
%     cos_theta = cos(theta);
%     sin_theta = sin(theta);
    [cos_theta, sin_theta] = cordic_rotation(1, 0, -theta, N);
    Q(i, i) = cos_theta;
    Q(i, j) = -sin_theta;
    Q(j, i) = sin_theta;
    Q(j, j) = cos_theta;
end
