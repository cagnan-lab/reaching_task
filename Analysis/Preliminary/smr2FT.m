function ftdata = smr2FT(sp2data)
ftdata.fsample = 1./prod(sp2data(4).hdr.adc.SampleInterval);
ftdata.time{1} = linspace(0,sp2data(1).hdr.adc.Npoints/ftdata.fsample,sp2data(1).hdr.adc.Npoints);
for ch = 1:numel(sp2data)-1
    ftdata.label{ch} = sp2data(ch).hdr.title;
    ftdata.trial{1}(ch,:) = sp2data(ch).imp.adc;
end
  ftdata.label = ftdata.label';