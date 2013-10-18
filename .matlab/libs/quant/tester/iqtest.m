function [eqty, sharpe, dd, ret] = iqtest(P, signals, intiDeposit)
	% iqtest(P, signals) process trading signals
    if size(P, 2) < 2, error('Price matrix must contain at least 2 colums (Time and Price)'); end
    if size(signals, 2) < 2, error('Signal''s matrix must contain at least 2 colums (Time and signal)'); end
    if size(signals, 2) > size(P, 2), error('Wrong price matrix num colums'); end
    
    nInstrs = size(signals,2) - 1;
    poses = Position.empty(nInstrs, 0);
    for i = 1 : nInstrs, poses(i) = Position; end
  
    % Main cycle
    ret = [signals(1, 1) 0];
    for i = 1 : size(signals, 1)
        ti = signals(i, 1);
               
        if ischar(ti), ti = datenum(ti); end
        
        prices = P(P(:,1)==ti, 2:end);
        if isempty(prices), error(['Can''t find prices for signal at ' datestr(ti)]); end
        
        pnl = 0;
        % dbg = [];
        for j = 1 : nInstrs
            signal = signals(i, j+1);
            if ~isnan(signal) % skip NaN signals
                pnl = pnl + poses(j).changePosition(prices(j), signal);
                % dbg = [dbg sprintf('%d(%.02f) ', signals(i, j+1), prices(j))];
            end
        end
        
        if pnl ~= 0
            ret =[ret; [ti pnl];];
            % -- Debug stuff --
            %   fprintf('Exit [%s] %s ~> %0.2f\n', datestr(ti, 'dd.mm.yyyy'), dbg, pnl);
            % else
            %   fprintf('Entr [%s] %s ~> %0.2f\t', datestr(ti, 'dd.mm.yyyy'), dbg);
        end

    end
    
    % finally close opened positions ???
    prices = P(end, 2:end);
    pnl = 0;
    for j = 1 : nInstrs
        pnl = pnl + poses(j).changePosition(prices(j), 0);
    end
    if pnl ~= 0,
        ret =[ret; [P(end, 1) pnl];];
    end
    
    % statistic
    eqty = intiDeposit + cumsum(ret(:,2));
    rets = eqty(2:end)./eqty(1:end-1) - 1; % - 0.04/252;
    sharpe = sqrt(252)*mean(rets)/std(rets);
    dd = maxdd(eqty);
end
