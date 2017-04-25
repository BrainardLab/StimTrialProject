% Method to print a console message depending on the set verbosity level
function consoleMessage(obj, message, minVerbosity)

    if (strcmp(obj.verbosity, 'max'))
        fprintf('%s\n', message);
    end
    
end
