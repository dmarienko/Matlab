function r = cropSeries(S, symbs, from, to, fieldName)
    % r = cropSeries(S, symbs, from, to, fieldName)
    % Fetches series for given symbols from 'S' structure
    % Make all fetched series of same dates/times set
    % if from/to agrs are not empty it also crops every series to these
    % boundaries
    % fieldName - what's field is used (Op, Cl, Hi, Lo, Vol). Cl is default
    if ~iscell(symbs), symbs = {symbs}; end
    
    %
    idxses = cell2mat(arrayfun(@(x) find(strcmp({S.Name}, x)), symbs, 'UniformOutput', false));
    times = {S(idxses).Tm};
    
    % for more than 1 series we must find intersect dates
    uniTimes = cell2mat(times(1));
    if size(times, 2) > 1
        for i = 2 : size(times,2)
            uniTimes = intersect(uniTimes, cell2mat(times(i)));
        end
    end
    
    if nargin >= 3 && ~isempty(from)
        if ischar(from), from = datenum(from); end
        uniTimes = uniTimes(uniTimes >= from);
    end
    
    if nargin >= 4 && ~isempty(to)
        if ischar(to), to = datenum(to); end
        uniTimes = uniTimes(uniTimes <= to);
    end
    
    % check what field name is requested, 'Close' by default
    if nargin < 5
        fieldName = 'Cl';
    else
        fieldName = fieldName(1:2);
    end
    
    % collect final matrix
    r = [uniTimes cell2mat(arrayfun(@(i) S(i).(fieldName)(ismember(S(i).Tm,uniTimes)), idxses, 'UniformOutput', false))];
end