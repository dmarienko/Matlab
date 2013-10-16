function s = prnsigs(sigs, varargin)
    if isempty(sigs), error('Signals matrix is empty !'); end
    
    dateFormat = 'dd-mmm-yyyy';
    if nargin > 1 && ~isempty(varargin{1}), dateFormat = varargin{1}; end
    
    s = [cellstr(datestr(sigs(:,1), dateFormat)) num2cell([sigs(:,2:end)])];
    if nargout == 0
        disp(s);
    end
end