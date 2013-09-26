function y2=filterfft(f, y, cutoff, wins)
    nf = length(f);
    ny = length(y);
    if ~(ny/2+1 == nf),
        disp('unexpected dimensions of input vectors!')
        y2=-1;
        return
    end

    % cutoff filter
    y2 = zeros(1,ny);
    if ~isempty(cutoff)
        ind1=find(f<=cutoff);
        y2(ind1) = y(ind1); % insert required elements
    else
        y2=y;
    end

    % dominant freqs filter
    if ~isempty(wins),
        temp = abs(y2(1:nf));
        y2 = zeros(1,ny);
        for k = 1:wins,   % number of freqs that I want
            [tmax, tmaxi] = max(temp);
            y2(tmaxi) = y(tmaxi); % insert required element
            temp(tmaxi) = 0; % eliminate candidate from list
        end
    end

    % create a conjugate symmetric vector of amplitudes
    for k=nf+1:ny,
        y2(k) = conj(y2(mod(ny-k+1,ny)+1)); % formula from the help of ifft
    end
return