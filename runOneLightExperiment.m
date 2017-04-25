function runOneLightExperiment
    close all
    
    % Generate high-level stimulus descriptors
    visualize = false;
    stimDescriptor{1} = xyYStimDescriptor(visualize);
    stimDescriptor{2} = cLcMcSStimDescriptor(visualize);
    stimDescriptor{3} = spdStimDescriptor(visualize);
    
    % Initialize an OneLightTrial object for 
    OLCalFile = 'someOLCalFile';
    olTrialOBJ = OneLightTrial(OLCalFile, ...
        'lazyDeviceInit', true, ...
        'verbosity', 'max' ...
        );
    
    %% Pre-generate device stimuli from all the stimuli to be tested
    deviceStim = cell(1,numel(stimDescriptor));
    for k = 1:numel(stimDescriptor)
        [olTrialOBJ, deviceStim{k}] = olTrialOBJ.deviceStimulusFromStimDescriptor(stimDescriptor{k});
        if (~isempty(deviceStim{k}))
            % Visualize the derived primaries and settings
            olTrialOBJ.visualizeSettingsAndPrimaries();
        end
    end
    
    %% Present the generated device stimuli 
    for k = 1:numel(deviceStim)
        % Check if deviceStim is OK
        if (isempty(deviceStim{k}))
            fprintf('Stimulus #%d is empty. Skipping.\n', k);
            continue;
        end
        
        % Submit to device for presentation
        [olTrialOBJ, status] = olTrialOBJ.show(deviceStim{k});
        
        % Handle any errors that might occur during the presentation
        if (~isempty(status))
            olTrialOB = cleanUp(errorMessage, olTrialOBJ);
            return;
        end
    end
    
    % Close the RGBdisplay device
    olTrialOBJ = olTrialOBJ.closeDevice();
end

function trialOBJ = cleanUp(errorMessage, trialOBJ)
    fprintf('Closing experiment due to error: %s\n', errorMessage);
    trialOBJ = trialOBJ.closeDevice();
end

