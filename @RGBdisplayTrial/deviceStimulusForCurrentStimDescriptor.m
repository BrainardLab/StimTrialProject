% Method to compute RGBdisplay-specific settings for the current stimulusDescriptor
function deviceStimulus = deviceStimulusForCurrentStimDescriptor(obj)

    if (ischar(obj.stimDescriptor.colorDescriptor))
       s = sprintf('Will compute settings for device: ''%s'' from an ''%s'' colorDescriptor.\n', obj.deviceType, obj.stimDescriptor.colorDescriptor);
    else
       s = sprintf('Will compute settings for device: ''%s'' from a vectorized stimulus specification (SPD).\n', obj.deviceType);
    end
    obj.consoleMessage(s, 'max');
    
    % Call super-class method to compute primary values from the current stimulusDescriptor
    stimPrimaryValues = obj.stimulusPrimaryValuesForCurrentStimDescriptor();
    
    % Call RGBdisplay-specific method to compute settings values from primaryvalues
    stimSettingsValues = obj.stimulusSettingsValuesFromPrimaries(stimPrimaryValues); 
    
    % Generate the RGBdisplay-specific deviceStimulus struct
    deviceStimulus = struct();
    deviceStimulus.primaries = stimPrimaryValues;
    deviceStimulus.settings  = stimSettingsValues;
    deviceStimulus.settingsSpatialModulation  = stimSettingsValues;
    deviceStimulus.temporalSupport = obj.stimDescriptor.temporalSupport;
    deviceStimulus.spatialSupport  = obj.stimDescriptor.spatialSupport;
    deviceStimulus.spatialEnvelope = obj.stimDescriptor.spatialEnvelope;
end
