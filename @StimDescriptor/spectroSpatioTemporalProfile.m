function ctxM = spectroSpatioTemporalProfile(background, modulation, temporalEnvelope, spatialEnvelope)
    
    bandsNum = size(temporalEnvelope,1);
    tBins = size(temporalEnvelope,2);
    spatiotemporalEnvelope = zeros(bandsNum, tBins, size(spatialEnvelope,2), size(spatialEnvelope,1));

    for band = 1:bandsNum
        for tBin = 1:tBins
            spatiotemporalEnvelope(band, tBin,:,:) = temporalEnvelope(band,tBin) * spatialEnvelope;
        end
    end
    spatiotemporalEnvelope = reshape(spatiotemporalEnvelope, [bandsNum tBins*size(spatialEnvelope,1)*size(spatialEnvelope,2)]);
    ctxM = bsxfun(@times, background', 1+bsxfun(@times, modulation', spatiotemporalEnvelope));
end

