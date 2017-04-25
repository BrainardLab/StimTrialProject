% Method to compute stimulus primary values for current stimDescriptor
function stimulusPrimaryValues = stimulusPrimaryValuesForCurrentStimDescriptor(obj)
    % Compute spectro-temporal profile
    
    if (isempty(obj.stimDescriptor.spatialEnvelope))
        spectroTemporalProfile = StimDescriptor.spectroTemporalProfile(...
        obj.stimDescriptor.background, obj.stimDescriptor.modulation, obj.stimDescriptor.temporalEnvelope);
    
    else
        spectroTemporalProfile = StimDescriptor.spectroSpatioTemporalProfile( ...
        obj.stimDescriptor.background, obj.stimDescriptor.modulation, obj.stimDescriptor.temporalEnvelope, obj.stimDescriptor.spatialEnvelope);
    end
    
    switch (obj.stimDescriptor.colorDescriptor)
        case 'xyY'
            XYZ_spectroTemporalProfile = xyYToXYZ(spectroTemporalProfile);
        case 'cLcMcS'
            XYZ_spectroTemporalProfile = obj.m_conesSS2degToXYZ() * spectroTemporalProfile;
        otherwise
            error('Unknown colorDescriptor: ''%s''.\n', obj.stimDescriptor.colorDescriptor);
    end % switch (stimulus.colorSpec)
    
    % Convert to device primaries spectro-temporal profile
    stimulusPrimaryValues = obj.m_XYZToPrimaries() * XYZ_spectroTemporalProfile;
end