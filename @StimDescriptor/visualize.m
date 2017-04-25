% Method to visualize the stimDescriptor
function visualize(obj, varargin)
    p = inputParser;
    p.addParameter('exportToPDF', false, @islogical);
    p.parse(varargin{:});
    
    visualizeTemporalStimulus(obj, p.Results.exportToPDF);
    visualizeSpatialStimulus(obj, p.Results.exportToPDF);
end

function visualizeSpatialStimulus(obj, exportToPDF)
    if (isempty(obj.spatialEnvelope))
        return;
    else
        xSupport = obj.spatialSupport{1};
        ySupport = obj.spatialSupport{2};
        hFig = figure(); clf;
        set(hFig, 'Color', [1 1 1]);
        imagesc(xSupport, ySupport, obj.spatialEnvelope);
        hold on;
        plot(mean(xSupport)*[1 1], [min(ySupport) max(ySupport)], 'r-');
        plot([min(xSupport) max(xSupport)], mean(ySupport)*[1 1], 'r-');
        hold off
        axis 'image';
        set(gca, 'CLim', [-1 1], 'FontSize', 12);
        colormap(gray(1024));
    end
    
    if (exportToPDF)
        if (ischar(obj.colorDescriptor))
        	preFix = obj.colorDescriptor;
        else
            preFix = 'spectral';
        end
        NicePlot.exportFigToPDF(sprintf('%s-spatial.pdf', preFix), hFig, 300);
    end
    
end

function visualizeTemporalStimulus(obj, exportToPDF)

    spectroTemporalProfile = StimDescriptor.spectroTemporalProfile(obj.background, obj.modulation, obj.temporalEnvelope);
        
    legends = {};
    if (ischar(obj.colorDescriptor))
        switch (obj.colorDescriptor)
            case 'xyY'
                legends = {'x', 'y', 'Y'};
            case 'cLcMcS'
                legends = {'cL', 'cM', 'cS'};
        end
    else
        for k = 1:numel(obj.colorDescriptor)
            legends{numel(legends)+1} = sprintf('%2.1f', obj.colorDescriptor(k));
        end
    end
    
    hFig = figure(); clf;
    set(hFig, 'Color', [1 1 1], 'Position', [10 10 700 950]);
    
    if (strcmp(obj.colorDescriptor, 'xyY')) || (strcmp(obj.colorDescriptor, 'cLcMcS'))
        if (strcmp(obj.colorDescriptor, 'xyY'))
            colors = [1 0 0; 0 0 1; 0 0 0];
        else
            colors = [1 0.2 0.5; 0.2 1.0 0.5; 0.3 0.5 1.0];
        end

        for colorBand = 1:size(obj.temporalEnvelope,1)
            subplot(3,1,colorBand);
            stepPlot(obj.temporalSupport, spectroTemporalProfile(colorBand,:), squeeze(colors(colorBand,:)));
            ylabel(legends{colorBand}, 'FontWeight', 'b');
            if (colorBand == 3)
                xlabel('time (seconds)', 'FontWeight', 'b');
            end
            set(gca, 'FontSize', 14);
            grid on; box off;
        end
    else
        colors = jet(round(size(obj.temporalEnvelope,1)*1.5));
        hold on;
        for colorBand = 1:size(obj.temporalEnvelope,1)
            stepPlot(obj.temporalSupport, spectroTemporalProfile(colorBand,:), squeeze(colors(colorBand,:)));
        end
    
        if (~isempty(legends))
            legend(legends, 'Location', 'eastoutside');
        end
        ylabel('activation', 'FontWeight', 'b');
        xlabel('time (seconds)', 'FontWeight', 'b');
        set(gca, 'FontSize', 14);
        grid on; box off;
    end
    
    if (exportToPDF)
        if (ischar(obj.colorDescriptor))
        	preFix = obj.colorDescriptor;
        else
            preFix = 'spectral';
        end
        NicePlot.exportFigToPDF(sprintf('%s-temporal.pdf', preFix), hFig, 300);
    end
end

function stepPlot(x,y, color)
    xx = x(1);
    yy = y(1);
    
    for k = 1:numel(x)-1
        xx = cat(1,xx, x(k+1));
        yy = cat(1,yy, y(k));
        xx = cat(1,xx, x(k+1));
        yy = cat(1,yy, y(k+1));
    end
    plot(xx,yy, '-', 'Color', color, 'LineWidth', 1.5);
end

