function stimulusSettings = stimulusSettingsValuesFromPrimaries(obj, stimulusPrimaries)
    gammaMethod = 1;
    cal = SetGammaMethod(obj.cal, gammaMethod);
    [stimulusSettings, badIndex] = PrimaryToSettings(cal, stimulusPrimaries);
    badIndicesNum = numel(find(badIndex> 0));
    if (badIndicesNum>0)
        fprintf('Out-of-gamut points = %d\n', badIndicesNum);
    end
end
