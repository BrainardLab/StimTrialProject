classdef RGBdisplayTrial < StimulusTrial
    
    % Public read-write
    properties
    end
    
    properties (SetAccess = private) 
        % calibration file name
        calFile;
        
        % Screen id to present stimuli on
        screenIndex;
        
        % RGBdisplay-graphics engine
        engine;
    end
    
    properties (Constant)
        % Device identifier
        deviceType = 'RGBDisplay';
        
        % Color descriptors that the RGBDisplay undestands
        validColorDescriptors = {'cLcMcS', 'xyY'};
        
        % stimDescriptor fields required not to be empty
        requiredStimDescriptorFields = {'spatialSupport', 'spatialEnvelope'};
    end
    
    properties (Access = private)
        lazyDeviceInit;
    end
    
    % Public methods
    methods
        function obj = RGBdisplayTrial(calFile, varargin)       
            % Instantiate the super-class by calling its constructor.
            obj = obj@StimulusTrial(varargin{:});
            
            % Parse required input as well as the list of 
            % un-consumed (by the superclass) options
            p = inputParser;
            p.addRequired('calFile');
            p.addParameter('lazyDeviceInit', true, @islogical);
            p.addParameter('screenIndex', [], @isnumeric);
            p.addParameter('engine', 'PsychImaging', @(x)ismember(x, {'PsychImaging', 'MGL'}));
            p.parse(calFile, obj.unconsumedInitializerProperties);
            
            % Initialize our own properties
            obj.calFile = p.Results.calFile;
            obj.screenIndex = p.Results.screenIndex;
            obj.engine = p.Results.engine;
            obj.lazyDeviceInit = p.Results.lazyDeviceInit;
            
            % Initialize superclass properties
            obj.cal = obj.importCal(obj.calFile);
            
            % If we are not doing lazy device initialization, initialize now
            if (~p.Results.lazyDeviceInit)
                % Open display device and set the display's deviceHandle 
                obj = obj.openDevice();
            end
        end
    end
    
    % Implementations of required public methods defined as abstract in the @StimulusTrial interface   
    methods    
        % Method to visualize the derived primaries and settings
        visualizeSettingsAndPrimaries(obj);
    
        % Method to realize an RGBdisplay-specific stimulus to an actual RGBdisplay device
        [obj, status] = show(obj, deviceStimulus)
        
        % Method to open the RGBdisplay device
        obj = openDevice(obj);
        
        % Method to close the RGBdisplay device
        obj = closeDevice(obj);
    end
    
    % Implementations of required protected methods defined as abstract in the @StimulusTrial interface   
    methods (Access = protected)  
        % Method to check the RGBDisplay device-specific validity of the user-supplied stimDescriptor
        isValid = validateStimDescriptor(obj, stimDescriptor);
        
        % Method to import an RGBdisplay device - specific calibration
        cal = importCal(obj, calFile);
        
        % Method to compute device stimulus for the current stimulusDescriptor
        deviceStimulus = deviceStimulusForCurrentStimDescriptor(obj);
        
        % Method to return the device SPDs and their sampling
        deviceSPDs = deviceSPDs(obj);
    end
    
    methods (Access = private)
        stimulusSettings = stimulusSettingsValuesFromPrimaries(obj, stimulusPrimaries);
    end
end