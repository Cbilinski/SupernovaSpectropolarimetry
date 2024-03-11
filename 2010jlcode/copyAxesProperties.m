function copyAxesProperties(newAxes, originalFig)
    % Copy font sizes, box property, and axis ranges from the original axes to the new axes
    originalAxes = get(originalFig, 'CurrentAxes');
    set(newAxes, 'FontSize', get(originalAxes, 'FontSize'));
    set(newAxes, 'Box', get(originalAxes, 'Box'));
    set(newAxes, 'XLim', get(originalAxes, 'XLim'));
    set(newAxes, 'YLim', get(originalAxes, 'YLim'));
    % Add other properties to copy as needed
end