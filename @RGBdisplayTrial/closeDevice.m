% Method to close the RGBdisplay device
function obj = closeDevice(obj)
    switch (obj.engine)
        case 'PsychImaging'
            % Close PTB
            sca;
            % Init device handle
            obj.deviceHandle = [];
            obj.displayInfo = [];
        otherwise
            error('Unknown engine: ''%s''\n', obj.engine);
    end
end

