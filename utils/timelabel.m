function timelabel
    %TIMELABEL Summary of this function goes here
    %   Detailed explanation goes here
    set(datacursormode(get(gca, 'Parent')), 'UpdateFcn', @dateTip);
    ticklabelformat(gca, 'x', {@tick2datestr, 'x', 'HH:MM:SS.FFF'})
    set(gca, 'Position', [0.05, 0.05, 0.91, 0.91])
end

function tick2datestr(hProp,eventData,axName,dateformat)    %#ok<INUSL>
    hAxes = eventData.AffectedObject;
    tickValues = get(hAxes,[axName 'Tick']);
    tickLabels = arrayfun(@(x)datestr(x, dateformat), tickValues, 'UniformOutput', false);
    set(hAxes,[axName 'TickLabel'],tickLabels);
end


function output_txt = dateTip(gar, ev)    %#ok<INUSL>
    pos = ev.Position;
    output_txt = sprintf('X: %s\nY: %0.4g', datestr(pos(1),'HH:MM:SS.FFF'), pos(2));
end



