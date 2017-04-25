% Method to check the RGBDisplay device-specific validity of the passed stimDescriptor
function isValid = validateStimDescriptor(obj, stimDescriptor)

    fNames = fieldnames(stimDescriptor);
    if (ischar(stimDescriptor.colorDescriptor)) && (ismember(stimDescriptor.colorDescriptor, obj.validColorDescriptors))
        
        % We can deal with this colorDescriptor
        isValid = true;
        
        % Now check that we have the required stimDescriptor fields
        if ((~ismember(obj.requiredStimDescriptorFields, fNames)))
            isValid = false;
            % Report which field(s) are missing
            missingFieldIndices = find(~ismember(obj.requiredStimDescriptorFields, fNames));
            for k = 1:numel(missingFieldIndices)
                fprintf(2,'StimDescriptor is not valid for an ''%s'' device. Required field: ''%s'' is missing from the specified stimDescriptor.\n', obj.deviceType, obj.requiredStimDescriptorFields{k});
            end
        else  % All required fields exist, make sure they are nonempty
            for k = 1:numel(obj.requiredStimDescriptorFields)
                if isempty(eval(sprintf('stimDescriptor.%s', obj.requiredStimDescriptorFields{k})))
                    isValid = false;
                    fprintf(2,'StimDescriptor is not valid for an ''%s'' device. Required field: ''%s'' is empty.\n', obj.deviceType, obj.requiredStimDescriptorFields{k});
                end
            end
        end
    else 
        % We do not know how to deal with this colorDescriptor
        if (ischar(stimDescriptor.colorDescriptor))
            fprintf(2, 'Invalid stimDescriptor.colorDescriptor (''%s'') for display ''%s''\n', stimDescriptor.colorDescriptor, obj.deviceType);
        elseif (isnumeric(stimDescriptor.colorDescriptor))
            fprintf(2, 'Invalid stimDescriptor.colorDescriptor (numeric with %d elements) for display ''%s''\n', numel(stimDescriptor.colorDescriptor), obj.deviceType);
        else
            fprintf(2, 'Invalid stimDescriptor.colorDescriptor (non-char, non-numeric) for display ''%s''\n', obj.deviceType);
        end
        isValid = false;
    end
end
