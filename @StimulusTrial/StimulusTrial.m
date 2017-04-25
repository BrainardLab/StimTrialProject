classdef StimulusTrial
    %STIMULUSTRIAL Abstract class defining StimulusTrial
    %   Subclasses need to implement all abstract methods
    
    % Public properties (read/write)
    properties
        verbosity = 'none';
    end
    
    % Constant properties
    properties (Constant)
    end
    
    % Subclasses can read&write these properties, the user can only read-them
    properties (SetAccess = protected)            
        % Imported (by the sub-class) calibration
        cal; 
        
        % User-passed stimDescriptor 
        stimDescriptor;
    end
    
    properties (SetAccess = protected, Dependent=true)
        % XYZ CMFs -> Device Primaries matrix
        m_XYZToPrimaries;
        
        % Stockman-Sharpe2deg -> XYZ CMFs matrix
        m_conesSS2degToXYZ;
    end
    
    % Only subclasses can access these properties, i.e., they are totally invisible to the user
    properties (Access = protected)
        % List of initializer properties that this class can not consume
        unconsumedInitializerProperties = {};
        
        % Handle to the (open) device
        deviceHandle = [];
        
        % Display device info
        displayInfo = [];
        
        % Subclass-generated device-specific stimulus
        deviceStimulus;
    end
 
    % Public methods
    methods
        % Constructor
        function obj = StimulusTrial(varargin)
            % Parse input to make sure it is valid
            p = inputParser;
            p.KeepUnmatched = true;
            p.addParameter('verbosity', 'none', @(x)ismember(x,  {'none', 'min', 'max'}));
            p.parse(varargin{:});
            
            % Initialize consumable properties
            f = fieldnames(p.Results);
            for k = 1:numel(f)
                obj.(f{k}) = p.Results.(f{k});
            end % k
            
            % Return list of unmatched options. These are to be consumed
            % by the subclass and the subclass will throw an error if it 
            % cannot consume any of these.
            obj.unconsumedInitializerProperties = p.Unmatched;
        end 
        
        % Method to generate a display-specific stimulus from the user-supplied stimDescriptor
        [obj, devStimulus] = deviceStimulusFromStimDescriptor(obj, stimDescriptor);
    end % Public methods
    
    % Abstract, public methods. Each subclass *must* implenent 
    % its own version of all these functions. Users can directly
    % call these functions.
    methods(Abstract)   
        % Method to visualize device-specific stimulus primaries and settings
        visualizeSettingsAndPrimaries(obj);
        
        % Method to realize a device-specific stimulus to the specified device
        [obj, status] = show(obj, deviceStimulus);
        
        % Method to open display device
        obj = openDevice(obj);
        
        % Method to close an open display device
        obj = closeDevice(obj);
    end % Abstract methods
    
    % Abstract, protected methods. Each subclass *must* implenent 
    % its own version of all these functions. Users cannot directly
    % call these functions, only the superclass and the subclasses can.
    methods (Abstract, Access = protected)  
        % Method to check the device-specific validity of the user-supplied stimDescriptor
        isValid = validateStimDescriptor(obj, stimDescriptor);
        
        % Method to import a device - specific calibration
        cal = importCal(obj, calFile);
        
        % Method to compute a device stimulus for the current stimulusDescriptor
        deviceStimulus = deviceStimulusForCurrentStimDescriptor(obj);
        
        % Method to return the device SPDs and their sampling
        devSPDs = deviceSPDs(obj);
    end
    
    % Getter methods for dependent properties
    methods
        % Method to compute the XYZ CMFs -> Device Primaries matrix
        function val = get.m_XYZToPrimaries(obj)  
            % Get the device SPDs
            deviceSPD = obj.deviceSPDs();
            % Load 1964 color matching functions, sampled at the deviceS
            T_XYZ = StimulusTrial.loadXYZ1964(deviceSPD.S);
            % Compute matrix for obtaining devicePrimary values from XYZ values
            val = inv(T_XYZ * deviceSPD.SPDs);
        end
        
        % Method to compute the Stockman-Sharpe2deg -> XYZ CMFs matrix
        function val = get.m_conesSS2degToXYZ(obj)
            % Get the device SPDs
            deviceSPD = obj.deviceSPDs(); 
            % Load the 2deg Stockman-Sharpe cone fundamentals, sampled at the S
            T_cones = StimulusTrial.loadStockmanSharpe2degConeFundamentals(deviceSPD.S);
            % Load 1964 color matching functions, sampled at the deviceS
            T_XYZ = StimulusTrial.loadXYZ1964(deviceSPD.S);
            % Compute matrix for obtaining XYZ values from cone excitations
            val = inv(((T_XYZ')\(T_cones'))');
        end
    end % Getter methods for dependent properties
    
    % Methods accessible only by subclasses
    methods (Access = protected)
        % Method to print a console message depending on
        % the set verbosity level
        consoleMessage(obj, message, minVerbosity);
        
        % Method to compute stimulus primary values for current stimDescriptor
        stimPrimaryValues = stimulusPrimaryValuesForCurrentStimDescriptor(obj);
    end
    
    % Convenience methods
    methods (Static)
        % Convenience method to return the 1964 XYZ color matching functions
        T_xyz = loadXYZ1964(S_device);
        
        % Convenience method to return the Stockman-Sharpe 2deg cone fundamentals
        T_cones = loadStockmanSharpe2degConeFundamentals(S_device); 
    end
end

