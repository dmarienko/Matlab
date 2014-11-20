function go(varargin)
	fsprog, global iif
	BMFILE = '~/.matlab/bookmarks.mat';
	if nargin == 1, bm = varargin{1}; else error('(go) Destination bookmark label is not specified'); end

	if exist(BMFILE, 'file')
		load(BMFILE, 'bmtable')
		N = numel(bmtable);
		for i = 1 : N
			mrk = iif(isempty(bmtable(i).mark), int2str(i), bmtable(i).mark);
			if strcmp(mrk, bm)
				cd(bmtable(i).path);
				fprintf(' -(jumped)-> ''%s''\n', pwd())
				break
			end
		end
	else
		disp('(go) No stored bookmarks. Try use ag first');
	end
end