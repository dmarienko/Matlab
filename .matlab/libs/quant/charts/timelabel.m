function timelabel(scaleFix, fmt)
    %TIMELABEL Summary of this function goes here
    %   Detailed explanation goes here
    
    if nargin == 0, scaleFix = true; end
    if nargin == 1, fmt = 'HH:MM:SS.FFF'; end
    
    set(datacursormode(get(gca, 'Parent')), 'UpdateFcn', @dateTip);
    set(gca, 'UserData', fmt);
    ticklabelformat(gca, 'x', {@tick2datestr, 'x', fmt})
    
    if scaleFix,
        set(gca, 'Position', [0.05, 0.05, 0.91, 0.91])
    end
end

function tick2datestr(hProp,eventData,axName,dateformat)    %#ok<INUSL>
    hAxes = eventData.AffectedObject;
    tickValues = get(hAxes,[axName 'Tick']);
    tickLabels = arrayfun(@(x)datestr(x, dateformat), tickValues, 'UniformOutput', false);
    set(hAxes,[axName 'TickLabel'],tickLabels);
end


function output_txt = dateTip(gar, ev)    %#ok<INUSL>
    pos = ev.Position;
    fmt = get(gca,'UserData');
    if isempty(fmt), fmt = 'HH:MM:SS.FFF'; end
    output_txt = sprintf('X: %s\nY: %0.4g', datestr(pos(1), fmt), pos(2));
end



