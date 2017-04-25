% Method to import an RGBdisplay-specific calibration
function cal = importCal(obj, calFile)
    obj.consoleMessage(sprintf('Importing cal from %s.', calFile), 'max');
    dir = '/Users/nicolas/Documents/MATLAB/toolboxes/PsychCalLocalData/trunk/ViewSonicProbe';
    dir = '/Users/nicolas/Documents/MATLAB/toolboxes/PsychCalLocalData/ViewSonicProbe';
    cal = LoadCalFile(calFile, [], dir); 
    assert(~isempty(cal), 'Empty cal.');
end

