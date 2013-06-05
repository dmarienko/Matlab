% My dark colortheme for plot
axisColor = [0.25 0.25 0.25];
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
clear axisColor textColor axesFontSize titleFontSize 

addpath('~/.matlab/utils/')
try 
    EditorMacro('Escape', @GiveFocusEditor, 'run');
    EditorMacro('Alt v', 'select-word', 'run');
catch
end

disp('Loading workspace ...')
load ~/workspace.mat; 
if ~isempty(PWD),
    disp(['Jumping to ' PWD]);
    cd(PWD);
    clear PWD;
end

