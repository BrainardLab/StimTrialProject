function theStimDescriptor = spdStimDescriptor(visualize)
    % Temporal stim params
    dt = 100/1000; nSamples = 20;
    timeBase = (0:(nSamples-1))*dt + dt/2;
    timeBase = timeBase - mean(timeBase);
    temporalFrequencyHz = 0.5;
    
    % Chromatic (spd) params
    waveAxis = 380:10:780;
    backgroundSPD = 0.05 + ones(1, numel(waveAxis));
    modulatedSPD = (0:(numel(waveAxis)-1))/numel(waveAxis);
    
    % Specify time courses for all color channels
    timeEnvelope = zeros(numel(waveAxis), numel(timeBase));
    for waveIndex = 1:numel(waveAxis)
        timeEnvelope(waveIndex,:) = 0.5 + 0.5*cos(2*pi*temporalFrequencyHz*timeBase+0.03*pi*waveIndex).*exp(-0.5*(timeBase/0.50).^2);  % modulation envelope for waveIndex
    end
    
    % Make the stimDescriptor struct
    theStimDescriptor = StimDescriptor(...
        'colorDescriptor', waveAxis, ...
        'background', backgroundSPD, ... 
        'modulation', modulatedSPD, ...
        'temporalSupport',  timeBase, ...                
        'temporalEnvelope', timeEnvelope ...  
    );
    if (visualize)
        theStimDescriptor.visualize();
    end
end