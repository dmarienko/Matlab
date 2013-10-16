function S = retrieveData(symbs, from, to)
    if ~iscell(symbs), symbs = {symbs}; end
    
    % Collect series data
    S = struct('Name',[], 'Tm', [], 'Op', [], 'Hi', [], 'Lo', [], 'Cl', [], 'Vo', []);
    
    k = 1;
    for i = {symbs{:}}
        d = getData(char(i), from, to);
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

function s = getData(symb, from, to)
    try 
        s = Helper.fetch('yahoo.a', symb, Helper.D, from, to);
        s = s.toMat(1);
    catch
        s = [];
    end
end
