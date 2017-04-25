function ctM = spectroTemporalProfile(background, modulation, temporalEnvelope)
    ctM = bsxfun(@times, background', 1+bsxfun(@times, modulation', temporalEnvelope));
end

