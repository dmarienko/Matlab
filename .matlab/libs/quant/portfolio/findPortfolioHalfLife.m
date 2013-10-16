function halflife = findPortfolioHalfLife(P)
    resJohansen = johansen(P, 0, 1);
    yport = smartsum(repmat(resJohansen.evec(:, 1)', [size(P, 1) 1]) .* P, 2);
    ylag = lag(yport, 1);
    deltaY = yport - ylag;
    deltaY(1) = []; % remove 1'st NaN
    ylag(1) = [];
    regress_results = ols(deltaY, [ylag ones(size(ylag))]);
    halflife = -log(2)/regress_results.beta(1);
    
    if nargout == 0,
        prt(resJohansen);
        fprintf('-> Half Life : %f\n', halflife);
    end

    % --- simple method for 1 series ---
    % Ylag = lag(Y);
    % dY = Y - Ylag;
    % dY(1) = [];
    % Ylag(1) = [];
    % reg = ols(dY, [Ylag ones(size(Ylag))]); % Y(t)-Y(t-1) ~ λ*Y(t-1) + μ
    % hl = -log(2)/reg.beta(1);
end