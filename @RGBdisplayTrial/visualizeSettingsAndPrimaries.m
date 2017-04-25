% Method to visualize the derived primaries and settings
function visualizeSettingsAndPrimaries(obj)
    return;
    
    hFig = figure(10); clf;
    set(hFig, 'Position', [10 10 600 500], 'Color', [1 1 1]);
    
    subplot(1,2,1)
    for k = 1:3
        plot(obj.deviceStimulus.temporalSupport, obj.deviceStimulus.primaries(1,:), 'r-', 'LineWidth', 1.5);
        hold on;
        plot(obj.deviceStimulus.temporalSupport, obj.deviceStimulus.primaries(2,:), 'g-', 'LineWidth', 1.5);
        plot(obj.deviceStimulus.temporalSupport, obj.deviceStimulus.primaries(3,:), 'b-', 'LineWidth', 1.5);
        plot(obj.deviceStimulus.temporalSupport, zeros(1, numel(obj.deviceStimulus.temporalSupport)), 'k--');
        plot(obj.deviceStimulus.temporalSupport, ones(1, numel(obj.deviceStimulus.temporalSupport)), 'k--');
    end
    set(gca, 'YLim', [-0.1 1.1], 'YTick', [0 0.5 1.0], 'FontSize', 14);
    xlabel('time (seconds)','FontWeight', 'bold');
    ylabel('primaries', 'FontWeight', 'bold');
    
    subplot(1,2,2)
    for k = 1:3
        plot(obj.deviceStimulus.temporalSupport, obj.deviceStimulus.settings(1,:), 'r-', 'LineWidth', 1.5);
        hold on;
        plot(obj.deviceStimulus.temporalSupport, obj.deviceStimulus.settings(2,:), 'g-', 'LineWidth', 1.5);
        plot(obj.deviceStimulus.temporalSupport, obj.deviceStimulus.settings(3,:), 'b-', 'LineWidth', 1.5);
        plot(obj.deviceStimulus.temporalSupport, zeros(1, numel(obj.deviceStimulus.temporalSupport)), 'k--');
        plot(obj.deviceStimulus.temporalSupport, ones(1, numel(obj.deviceStimulus.temporalSupport)), 'k--');
    end
    set(gca, 'YLim', [-0.1 1.1], 'YTick', [0 0.5 1.0],  'FontSize', 14);
    xlabel('time (seconds)','FontWeight', 'bold');
    ylabel('settings', 'FontWeight', 'bold');
    drawnow
end

