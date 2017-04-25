% Convenience method to return the Stockman-Sharpe 2deg cone fundamentals
function T_cones = loadStockmanSharpe2degConeFundamentals(S_device)
    a = load('T_cones_ss2', 'T_cones_ss2', 'S_cones_ss2');
    T_cones = a.T_cones_ss2;
    S_cones = a.S_cones_ss2;
    
    % Spline to spectral sampling using in the calibration
    T_cones = SplineCmf(S_cones, T_cones, S_device);
end

