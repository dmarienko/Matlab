function S = retrieveData(symbs, from, to, datasource, frame)
    if ~iscell(symbs), symbs = {symbs}; end
    
    if nargin < 4, datasource = 'yahoo.a'; end
    if nargin < 5, frame = Helper.D; end
    
    % Collect series data
    S = struct('Name',[], 'Tm', [], 'Op', [], 'Hi', [], 'Lo', [], 'Cl', [], 'Vo', []);
    
    k = 1;
    for i = {symbs{:}}
        d = getData(char(i), datasource, frame, from, to);
        if ~isempty(d)
            S(k).Name = char(i);
            S(k).Tm = d(:,1);
            S(k).Op = d(:,2);
            S(k).Hi = d(:,3);
            S(k).Lo = d(:,4);
            S(k).Cl = d(:,5);
            S(k).Vo = d(:,6);
            k = k + 1;
        end
    end
end

function s = getData(symb, datasource, frame, from, to)
    try 
        s = Helper.fetch(datasource, symb, frame, from, to);
        s = s.toMat(1);
    catch
        s = [];
    end
end
