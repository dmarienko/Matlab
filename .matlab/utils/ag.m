function ag(varargin)
	BMFILE = '~/.matlab/bookmarks.mat';

	bm = '';
	if nargin == 1, bm = varargin{1}; end
	cdir = pwd;

	if exist(BMFILE, 'file')
		load(BMFILE, 'bmtable')

		if ~isempty(bm)
			N = numel(bmtable);
			used = false;
			for i = 1 : N
				if strcmp(bmtable(i).mark, bm)
					bmtable(i) = struct('path',cdir,'mark',bm);
					used = true;
					break;
				end
			end
			if ~used
				bmtable = [bmtable struct('path',cdir,'mark',bm)];
			end
		else
			bmtable = [bmtable struct('path',cdir,'mark',bm)];
		end
	else
		bmtable = struct('path',cdir,'mark',bm);
	end
	save(BMFILE, 'bmtable')
	lg()
end