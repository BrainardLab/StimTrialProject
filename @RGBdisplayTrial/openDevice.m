% Method to open the RGBdisplay device
function obj = openDevice(obj)
    
    switch (obj.engine)
        case 'PsychImaging'
            obj.deviceHandle = openPsychImagingDevice(obj);
        otherwise
            error('Unknown engine: ''%s''\n', obj.engine);
    end   
    
    obj.displayInfo.screenRect = obj.deviceHandle.screenRect;
end

function displayHandle = openPsychImagingDevice(obj)
    % Disable syncing tests, we do not care for this kind of calibration
    Screen('Preference', 'SkipSyncTests', 1);
    % No red triangle
    Screen('Preference', 'VisualDebugLevel', 0);
    switch (obj.verbosity)
        case 'min'
            Screen('Preference', 'Verbosity', 0);
        case 'normal'
            Screen('Preference', 'Verbosity', 3);
        case 'max'
            Screen('Preference', 'Verbosity', 5);
    end
    
    % Start PsychImaging
    PsychImaging('PrepareConfiguration');
    
    backgroundColor = 255 * [0.5 0.5 0.5];
    pixelSize = 24;
    [masterWindowPtr, screenRect] = ...
        PsychImaging('OpenWindow', obj.screenIndex-1, backgroundColor, [], pixelSize, [], []);
    LoadIdentityClut(masterWindowPtr);
    Screen('Flip', masterWindowPtr);
    
    displayHandle.windowPtr  = masterWindowPtr;
    displayHandle.screenRect = screenRect;
end

