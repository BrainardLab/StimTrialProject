% Method to generate a device stimulus from the user-supplied stimDescriptor
function [obj, deviceStimulus] = deviceStimulusFromStimDescriptor(obj, stimDescriptor)    

    % Validate the stimDescriptor for use with an RGBDisplayTrial object
    if (obj.validateStimDescriptor(stimDescriptor))
        % All specs valid, save passed stimulus
        obj.stimDescriptor = stimDescriptor;
        
        % Compute device stimulus for the current stimDescriptor
        deviceStimulus = obj.deviceStimulusForCurrentStimDescriptor();
    else
        % Feedback to the user
        submitFeedbakToUSer(stimDescriptor);
        deviceStimulus = [];
    end
    
    % kepp a copy of the deviceStimulus
    obj.deviceStimulus = deviceStimulus;
end

function submitFeedbakToUSer(stimDescriptor)
    fNames = fieldnames(stimDescriptor);
    fprintf(2,'stimDescriptor fields found: \n');
    for k = 1:numel(fNames)
        fprintf('\t ''%s''\n', fNames{k});
    end
    fprintf(2, 'Device stimulus generation was not successful. Stimulus will be skipped.\n\n');
end