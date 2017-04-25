% Method to generate an xyY-based stimDescriptor
function theStimDescriptor = xyYStimDescriptor(visualize)
    
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
spatialFreq = 0/1024;
spatialEnvelope = exp(-0.5*((X/sigma).^2+(Y/sigma).^2)).* ...
    cos(2.0*pi*spatialFreq*(X-Y));
spatialEnvelope = spatialEnvelope/max(abs(spatialEnvelope(:)));

% Chromatic (xyY) params
descriptor = 'xyY';
background = [0.3 0.3 40];
modulation = [0.2 0.0 0.0];                                                 % only modulate the luma channel (10%)

% Specify time courses for all color channels
timeEnvelope = repmat(cos(2*pi*temporalFrequencyHz*timeBase).*exp(-0.5*(timeBase/sigmaTau).^2), [3 1]);
timeEnvelope = timeEnvelope / max(abs(timeEnvelope(:)));

% Make the stimDescriptor struct
theStimDescriptor = StimDescriptor(...
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

