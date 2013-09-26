function g = fig(id, nTitle, varargin)
    %FIG Custom figure function
    % 
    g = figure(id); 
    set(g, 'Name', nTitle);
    set(g, 'NumberTitle', 'off');
    if nargin> 2 && varargin{1}, set(g, 'WindowStyle', 'docked'); end
end

