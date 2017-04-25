function unitTestStimDescriptor()
sd1 = StimDescriptor();
sd1.visualize('exportToPDF', true);


% Spatial stim params
center = [1024/2 768/2]; sigma = 40;
xAxis = center(1) + (-120:120);
yAxis = center(2) + (-120:120);
[X,Y] = meshgrid(xAxis, yAxis);
X = X - center(1);
Y = Y - center(2);
spatialFreq = 14/1024;
spatialEnvelope = 0.5*(1+exp(-0.5*((X/sigma).^2+(Y/sigma).^2)).* ...
    cos(2.0*pi*spatialFreq*(X-Y)));
spatialEnvelope = spatialEnvelope/max(spatialEnvelope(:));
    
% Temporal stim params
dt = 100/1000; nSamples = 20;
t = (0:(nSamples-1))*dt + dt/2;
t = t - mean(t);
tf = 0.7;
temporalModulation=0.5*(1+cos(2*pi*tf*t).*exp(-0.5*(t/0.30).^2));
        
sd2 = StimDescriptor(...
  'colorDescriptor', 'cLcMcS', ...
  'background', [0.1 0.1 0.5], ...
  'modulation', [-0.05 0.05 0.0], ...
  'temporalSupport',  t, ...                
  'temporalEnvelope', repmat(temporalModulation, [3 1]), ...  
  'spatialSupport', {xAxis(:) yAxis(:)}, ...
  'spatialEnvelope',  spatialEnvelope);  	
sd2.visualize('exportToPDF', true);
    


% Chromatic (spd) params
waveAxis = 380:10:780;
backgroundSPD = 0.05 + ones(1, numel(waveAxis));
modulatedSPD = (0:numel(waveAxis))/numel(waveAxis);

% Temporal stim params
dt = 100/1000; nSamples = 20;
t = (0:(nSamples-1))*dt + dt/2;
t = t - mean(t);
tf = 0.5;

% Specify separate time courses for each color channels
timeEnvelope = zeros(numel(waveAxis), numel(t));
for w = 1:numel(waveAxis)
 timeEnvelope(w,:) = 0.5*(1+cos(2*pi*tf*t+0.03*pi*w).*exp(-0.5*(t/0.50).^2));
end

% Make the stimDescriptor struct
sd = StimDescriptor(...
 'colorDescriptor', waveAxis, ...
 'background', backgroundSPD, ... 
 'modulation', modulatedSPD, ...
 'temporalSupport',  t, ...                
 'temporalEnvelope', timeEnvelope);

% Visualize
sd.visualize('exportToPDF', true);
    
        
end

