function lg(varargin)
	fsprog, global iif xmap first nth
	BMFILE = '~/.matlab/bookmarks.mat';
	if exist(BMFILE, 'file')
		load(BMFILE, 'bmtable')
		fprintf(' .----- (''%s'') ---------------\n',pwd());
		N = numel(bmtable);
		[~,si] = sort({bmtable.mark});
		k = 1;
		for i = si
			name = iif(isempty(bmtable(i).mark), int2str(i), bmtable(i).mark);
			spaces = 10 - numel(name);
			[ps, n] = fileparts(bmtable(i).path);

			xx = arrayfun(@(x) nth(cell2mat(x),1), strsplit(ps,'/'),'UniformOutput', false);
			ps = strjoin(xx(find(cell2mat(xmap(@isempty, xx))==0)), '.');

			fprintf(' %s- - - ''%s''%s%% - %s/%s\n', iif(k==N,'`','+'), name, repmat(' ',[1 spaces]), ps, n);
			k = k + 1;
		end
	end
end