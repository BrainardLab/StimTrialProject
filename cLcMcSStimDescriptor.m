% Method to generate an cLcMcS-based stimDescriptor
function theStimDescriptor = cLcMcSStimDescriptor(visualize)
    % Temporal stim params
    dt = 50/1000; nSamples = 200; sigmaTau = 2000/1000;
    timeBase = (0:(nSamples-1))*dt + dt/2;
    timeBase = timeBase - mean(timeBase);
    temporalFrequencyHz = 1.0;
    
    % Spatial stim params
    center = [1024/2 768/2]; sigma = 40;
    xAxis = center(1) + (-120:120);
    yAxis = center(2) + (-120:120);
    [X,Y] = meshgrid(xAxis, yAxis);
    X = X - center(1);
    Y = Y - center(2);
    spatialFreq = 8/1024;
    spatialEnvelope = exp(-0.5*((X/sigma).^2+(Y/sigma).^2)).* ...
        cos(2.0*pi*spatialFreq*(X-Y));
    spatialEnvelope = spatialEnvelope/max(abs(spatialEnvelope(:)));
    
    % Chromatic (LMS cone contrast)  params
    descriptor  = 'cLcMcS';
    background = 2*[0.06 0.051 0.035];                                               % cone excitation for the background
    modulation = [0.07 -0.07 0.3];
    
    % Specify identical time courses for all color channels
    timeEnvelope(1,:) = cos(2*pi*temporalFrequencyHz*timeBase).*exp(-0.5*(timeBase/sigmaTau).^2);
    timeEnvelope(2,:) = cos(2*pi*temporalFrequencyHz*timeBase).*exp(-0.5*(timeBase/sigmaTau).^2);
    timeEnvelope(3,:) = cos(2*pi*temporalFrequencyHz/4*timeBase).*exp(-0.5*(timeBase/sigmaTau).^2);
    timeEnvelope = timeEnvelope / max(abs(timeEnvelope(:)));
    
    % Make the stimDescriptor struct
    theStimDescriptor= StimDescriptor(...
        'colorDescriptor', descriptor, ...
        'background', background, ... 
        'modulation', modulation, ...
        'temporalSupport',  timeBase, ...                
        'temporalEnvelope', timeEnvelope, ...  
        'spatialSupport', {xAxis(:) yAxis(:)}, ...
        'spatialEnvelope', spatialEnvelope ...   
    );
    if (visualize)
        theStimDescriptor.visualize();
    end
end