% Convenience method to return the 1964 XYZ color matching functions
function T_xyz = loadXYZ1964(S_device) 
    a = load('T_xyz1964', 'T_xyz1964', 'S_xyz1964');
    
    T_xyz = 683*a.T_xyz1964;
    S_xyz = a.S_xyz1964;
    
    % Spline to spectral sampling using in the calibration
    T_xyz = SplineCmf(S_xyz, T_xyz, S_device);
end
