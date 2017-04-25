classdef StimDescriptor

    properties (SetAccess = private)
        colorDescriptor 
        background 
        modulation 
        temporalSupport            
        temporalEnvelope
        spatialSupport
        spatialEnvelope
    end
    
    properties (Constant) 
        defaults = struct(...
            'colorDescriptor', 'xyY', ...
            'background', [0.31 0.31 50], ... 
            'modulation', [0 0 0.15], ... 
            'temporalSupport', [0 100 200 500 600 1000]/1000, ...             
            'temporalEnvelope', [0 0 0 0 0 0; 0 0 0 0 0 0; 0 1 0 -0.5 0 0], ...
            'spatialSupport', [], ...
            'spatialEnvelope', []);
    end
    
    methods
        % Constructor
        function obj = StimDescriptor(varargin)
            % Parse input
            p = inputParser;
            fNames = fieldnames(StimDescriptor.defaults);
            for k = 1:numel(fNames) 
                p.addParameter(fNames{k}, StimDescriptor.defaults.(fNames{k}));
            end
			p.parse(varargin{:});
            pNames = fieldnames(p.Results);
            for k = 1:length(pNames)
                obj.(pNames{k}) = p.Results.(pNames{k}); 
            end
            
            % Check input consistency
            obj.checkInputConsistency();
        end % Constructor
        
        % Method to check the consistency of the input
        checkInputConsistency(obj);
        
        % Method to visualize the stimDescriptor
        visualize(obj, varargin);
    end 
    
    methods (Static)
        ctM = spectroTemporalProfile(background, modulation, temporalEnvelope);
        ctxM = spectroSpatioTemporalProfile(background, modulation, temporalEnvelope, spatialEnvelope);
    end
end % classef