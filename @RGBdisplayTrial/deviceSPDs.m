% Method to return the device SPDs and their sampling
function devSPDs = deviceSPDs(obj)
    % Extract needed information from the device cal
    devSPDs.SPDs = obj.cal.processedData.P_device;
    devSPDs.S = obj.cal.rawData.S;
end

