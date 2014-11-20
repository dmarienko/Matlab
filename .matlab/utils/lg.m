function lg(varargin)
	fsprog, global iif
	BMFILE = '~/.matlab/bookmarks.mat';
	if exist(BMFILE, 'file')
		load(BMFILE, 'bmtable')
		fprintf(' .----- (''%s'') ---------------\n',pwd());
		N = numel(bmtable);
		for i = 1 : N
			name = iif(isempty(bmtable(i).mark), int2str(i), bmtable(i).mark);
			fprintf(' %s- - - [%s]\t\t%s\n', iif(i==N,'`','+'), name, bmtable(i).path);
		end
	end
end