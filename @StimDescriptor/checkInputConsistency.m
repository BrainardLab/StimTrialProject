function checkInputConsistency(obj)

    assert(any((size(obj.background)==size(obj.modulation))), 'size of background does not match size of modulation');
    assert(numel(obj.background)==size(obj.temporalEnvelope,1), 'temporalEnvelope rows does not match the number of color bands');
    assert(numel(obj.temporalSupport)==size(obj.temporalEnvelope,2), 'temporalEnvelope columns does not match the number of time samples');

    if ((isempty(obj.spatialSupport)) && (isempty(obj.spatialEnvelope)))
        return;
    end
    
    if (~isempty(obj.spatialSupport))
        assert(~isempty(obj.spatialEnvelope), 'spatialSupport is non empty while spatialEnvelope is empty.\n');
    end
    
    if (~isempty(obj.spatialEnvelope))
        assert(~isempty(obj.spatialSupport), 'spatialEnvelope is non empty while spatialSupport is empty!.\n');
    end
    
    assert(iscell(obj.spatialSupport), 'spatialSupport is not a cell array');
    assert((numel(obj.spatialSupport) == 2), 'spatialSupport does not have 2 elements');
    ySpatialSupport = obj.spatialSupport{2};
    xSpatialSupport = obj.spatialSupport{1};
    assert(numel(ySpatialSupport)==size(obj.spatialEnvelope,1), 'spatialEnvelope rows does not match the Y-spatial support');
    assert(numel(xSpatialSupport)==size(obj.spatialEnvelope,2), 'spatialEnvelope columns does not match the X-spatial support');
end

