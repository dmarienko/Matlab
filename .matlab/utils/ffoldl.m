function folded = ffoldl(fxn, x0, xs, varargin)
    if isempty(xs)
        folded = x0;
        return;
    end
     
    p = inputParser;
    addParamValue(p, 'ErrorHandler', @defaultErrHandler, @isfunc);
    parse(p, varargin{:})
    handle = p.Results.ErrorHandler;
    ifthenelse = @(b, varargin) varargin{2-b}(); % b ? f : g

    hasInitialValue = ~isempty(x0);
    x0 = ifthenelse(hasInitialValue, @() x0, @() hd(xs));
    xs = ifthenelse(hasInitialValue, @() xs, @() tl(xs));
 
    xsIsCellArray = iscell(xs);
    x0IsCellArray = iscell(x0);
    x0IsSingleton = length(x0) == 1;
    % below is to handle the case where the initial value is given in a
    % singleton cell.
    if x0IsCellArray && x0IsSingleton
        x0 = x0{:};
    end
     
    if(nargin(fxn) == 2) % fxn(datum1, datum2)
        i = 0;
        try
            if xsIsCellArray
                for i = 1:numel(xs)
                    x0 = fxn(x0, xs{i});
                    if(iscell(x0))
                        x0 = flatten(x0);
                    end
                end
            else
                for i = 1:numel(xs)
                    x0 = fxn(x0, xs(i));
                    if(iscell(x0))
                        x0 = flatten(x0);
                    end
                end
            end
        catch e
            if xsIsCellArray
                xsi  = xs{i};
            else
                xsi  = xs(i);
            end
            handle(e, i, x0, xsi);
        end   
    elseif(nargin(fxn) == 4) % fxn(datum1, index1, datum2, index2)
        i = 0;
        try
            if xsIsCellArray
                for i = 1:numel(xs)
                    x0 = fxn(x0, i, xs{i}, i+1);
                end
            else
                for i = 1:numel(xs)
                    x0 = fxn(x0, i, xs(i), i+1);
                end
            end
        catch e
            if xsIsCellArray
                xsi  = xs{i};
            else
                xsi  = xs(i);
            end
            handle(e, i, x0, xsi);
        end
    end
 
    folded = x0;
     
    % default error handler, just rethrow the error
    function defaultErrHandler(err, varargin)
        rethrow(err);
    end
end