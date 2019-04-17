function Ai = getTransformMatrixDH(a, alpha, d, theta)
    Ai = Rot_z(theta)*Trans_z(d)*Trans_x(a)*Rot_x(alpha);
end