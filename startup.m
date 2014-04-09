% My dark colortheme for plot
axisColor = [0.45 0.45 0.45];
textColor = [0 0.5 0];
axesFontSize = 7;
titleFontSize = 15;
set(0, 'defaultfigurecolor', [0 0 0]);
set(0, 'defaultaxesygrid', 'on');
set(0, 'defaultaxesxgrid', 'on');
set(0, 'defaultaxescolor',  [0 0 0]);
set(0, 'defaultaxesxcolor', axisColor);
set(0, 'defaultaxesycolor', axisColor);
set(0, 'defaultaxeszcolor', axisColor);
set(0, 'defaultaxesGridLineStyle', ':');
set(0, 'defaultaxesfontsize', axesFontSize);
set(0, 'defaulttextcolor',  textColor);
set(0, 'defaulttextfontname', 'Arial');
set(0, 'defaulttextfontsize', titleFontSize);
set(0,'DefaultAxesColorOrder',[[142 196 250]/255; [12 170 12]/255; 0.9 0.9 0.9;  [248 12 12]/255; 0.7 0.7 0.7; 1 1 0; [250 146 250]/255;  0 1 1; ]);
set(0,'defaultlinelinewidth',1.5)
set(0,'DefaultLineLineSmoothing','on') % !!! 
clear axisColor textColor axesFontSize titleFontSize 

% My misc utilities
addpath('~/.matlab/utils/')
% Library from spatial-econometrics.com/
addpath(genpath('~/.matlab/libs/'), '-end')

try 
    EditorMacro('Escape', @GiveFocusEditor, 'run');
    EditorMacro('Alt v', 'select-word', 'run');
catch
end


% set off the ribbon alt hotkey to hell
com.mathworks.desktop.mnemonics.MnemonicsManagers.get.disable

myPath = '/home/dima/.matlab/';
if 1
	Matlab_extendEditorFunctionality(true)
	addpath(myPath,'-begin');
	fid = fopen(fullfile(myPath ,'edit.m'),'w');
	fprintf(fid,['function edit(str)',char(13), 'if nargin < 1 || isempty(str)',char(13),...
		'\tstr='''';',char(13),'end',char(13), 'rmpath(','''',myPath,'''',');',char(13),...
		'edit(str);',char(13), 'addpath(','''',myPath,'''',',''-begin'');',char(13),'Matlab_extendEditorFunctionality(true); FE;']);
	fclose(fid);
	clear fid
else
	w(1) = warning('off','MATLAB:rmpath:DirNotFound');
	w(2) = warning('off','MATLAB:DELETE:FileNotFound');
	Matlab_extendEditorFunctionality(false)
	rmpath(myPath);
	delete(fullfile(myPath,'edit.m'))
	warning(w)
end
clear('userWithEditorExtension', 'w', 'myPath');

try 
    disp('Loading workspace ...')
    load ~/workspace.mat;
    if ~isempty(PWD),
        disp(['Jumping to ' PWD]);
        cd(PWD);
        clear PWD;
    end
catch
    display('Can''t read saved workspace ...');
end

% --- Doing some stuff after heavy gui is started ---
t = timer;
t.TimerFcn = @Matlab_Coloring;
t.StartDelay = 1; %think it's enough
start(t);
clear t
