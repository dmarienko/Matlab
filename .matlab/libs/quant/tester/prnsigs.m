function s = prnsigs(sigs, varargin)
    if isempty(sigs), error('Signals matrix is empty !'); end
    
    dateFormat = 'dd-mmm-yyyy';
    if nargin > 1 && ~isempty(varargin{1}), dateFormat = varargin{1}; end
    signals = num2cell([sigs(:,2:end)]);
    
    % remove NaNs for more pretty output
    signals(isnan(cell2mat(signals))) = cellstr(':::::');
    
    s = [cellstr(datestr(sigs(:,1), dateFormat)) signals];
    if nargout == 0
        disp(s);
    end
end