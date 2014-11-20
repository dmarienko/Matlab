function rg(varargin)
	fsprog, global iif
	BMFILE = '~/.matlab/bookmarks.mat';
	if nargin == 0, error('(rg) No bmarks specified to remove'); end

	if exist(BMFILE, 'file')
		load(BMFILE, 'bmtable')
		N = numel(bmtable);
		toRemove = [];
		for i = 1 : N
			mrk = iif(isempty(bmtable(i).mark), int2str(i), bmtable(i).mark);
			if any(strcmp(mrk, varargin))
				fprintf(' -(remove)-> ''%s''\n', mrk)
				toRemove = [toRemove i];
			end
		end

		if ~isempty(toRemove)
			bmtable(toRemove) = [];
			save(BMFILE, 'bmtable')
			lg();
		end
	else
		disp('(rg) No stored bookmarks. Try use ag first');
	end

end