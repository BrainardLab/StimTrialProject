function [obj, status] = show(obj, deviceStimulus)

    status = [];
    if ((isempty(obj.deviceHandle)) && (obj.lazyDeviceInit))
        % Open display device now
        obj.consoleMessage('Lazy device opening', 'max');
        obj = obj.openDevice();
    end
    
    % Generate background texture
    horizontalPixels = obj.displayInfo.screenRect(3);
    verticalPixels = obj.displayInfo.screenRect(4);
    stimVerticalPixels = numel(deviceStimulus.spatialSupport{2});
    stimHorizontalPixels = numel(deviceStimulus.spatialSupport{1});

    backgroundRGBstimMatrix = zeros(verticalPixels, horizontalPixels, 3);
    foregroundRGBstimMatrix = zeros(stimVerticalPixels, stimHorizontalPixels, 3);
    
    timeBinsNum = numel(deviceStimulus.temporalSupport);
    texturePointersBackground = zeros(1,timeBinsNum);
    texturePointersForeground = zeros(1,timeBinsNum);
    
    
    settings = reshape(deviceStimulus.settings, [3, timeBinsNum stimVerticalPixels*stimHorizontalPixels]);
    for timeBinIndex = 1:timeBinsNum
        for k = 1:3
            frame = squeeze(settings(k, timeBinIndex,:));
            backgroundRGBstimMatrix(:,:,k) = 127.5*(1+squeeze(settings(k, 1,1)));
            foregroundRGBstimMatrix(:,:,k) = 127.5*(1+reshape(frame, [stimVerticalPixels stimHorizontalPixels]));
        end
        texturePtrBackground = Screen('MakeTexture', obj.deviceHandle.windowPtr, backgroundRGBstimMatrix, [], [], []);
        texturePtrForeground = Screen('MakeTexture', obj.deviceHandle.windowPtr, foregroundRGBstimMatrix, [], [], []);
        % update the list of existing texture pointers
        texturePointersBackground(timeBinIndex) = texturePtrBackground;
        texturePointersForeground(timeBinIndex) = texturePtrForeground;
    end
    
    obj.consoleMessage('Now showing stimulus in device', 'max');
    refresh = Screen('GetFlipInterval', obj.deviceHandle.windowPtr);
    waitRefreshCycles = 1;
    LoadIdentityClut(obj.deviceHandle.windowPtr);
    vbl = Screen('Flip', obj.deviceHandle.windowPtr);
    
    for timeBinIndex = 1:timeBinsNum
        texturePtrBackground = texturePointersBackground(timeBinIndex);
        texturePtrForeground = texturePointersForeground(timeBinIndex);
        % Draw Background texture
        sourceRect = []; destRect = []; globalAlpha = 1.0;
        Screen('DrawTexture', obj.deviceHandle.windowPtr, texturePtrBackground, sourceRect, destRect, 0, [], globalAlpha); 
        Screen('DrawTexture', obj.deviceHandle.windowPtr, texturePtrForeground, sourceRect, destRect, 0, [], globalAlpha);
        
        % Flip master display
        vbl = Screen('Flip', obj.deviceHandle.windowPtr, vbl + (waitRefreshCycles-0.5) * refresh);
    end
    
    % Clear memory
    for k = 1:numel(texturePointersBackground)
        Screen('Close', texturePointersBackground(k))
    end
end

