function runExperiment
    close all
    
    % Generate high-level stimulus descriptors
    visualize = true;
    stimDescriptor{1} = xyYStimDescriptor(visualize);
    stimDescriptor{2} = cLcMcSStimDescriptor(visualize);
    stimDescriptor{3} = spdStimDescriptor(visualize);
    
    % Initialize an RGBdisplayTrial object for 
    % realizing stimuli on an RGB display device (ViewSonicProbe)
    RGBDisplayCalFile = 'ViewSonicProbe';
    rgbTrialOBJ = RGBdisplayTrial(RGBDisplayCalFile, ...
        'lazyDeviceInit', true, ...
        'screenIndex', 2, ...           % secondary display
        'engine', 'PsychImaging', ...
        'verbosity', 'max' ...
        );
    
    %% Pre-generate device stimuli from all the stimuli to be tested
    devStim = cell(1,numel(stimDescriptor));
    for k = 1:numel(stimDescriptor)
        
        [rgbTrialOBJ, devStim{k}] = ...
            rgbTrialOBJ.deviceStimulusFromStimDescriptor(stimDescriptor{k});
        
        if (~isempty(devStim{k})) &&  (visualize)
            % Visualize the derived primaries and settings
            rgbTrialOBJ.visualizeSettingsAndPrimaries();
        end
    end

    %% Initialize the display device (or wait for lazy initialization)
    %rgbTrialOBJ = rgbTrialOBJ.openDevice();
    
    %% Present the generated device stimuli 
    for k = 1:numel(devStim)
        % Check if deviceStim is OK
        if (isempty(devStim{k}))
            fprintf('Stimulus #%d is empty. Skipping.\n', k); continue;
        end
        
        % Submit to device for presentation
        [rgbTrialOBJ, status] = rgbTrialOBJ.show(devStim{k});
        
        % Handle any errors that might occur during the presentation
        if (~isempty(status))
            rgbTrialOBJ = cleanUp(errorMessage, rgbTrialOBJ); return;
        end
    end
    
    % Close the RGBdisplay device
    rgbTrialOBJ = rgbTrialOBJ.closeDevice();
end

function trialOBJ = cleanUp(errorMessage, trialOBJ)
    fprintf('Closing experiment due to error: %s\n', errorMessage);
    trialOBJ = trialOBJ.closeDevice();
end