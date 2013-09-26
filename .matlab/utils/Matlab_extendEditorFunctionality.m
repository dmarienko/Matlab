function Matlab_extendEditorFunctionality(activateFlg)
% One-line description here, please.
%
% INVOKING: outputpara = Matlab_extendEditorFunctionality(inputpara)
%
% CATEGORY: Aid — D:\sds\tools\DA\MatlabM\Tools
%
%% DESCRIPTION
%   
%
%% INPUT
%     activateFlg ... (true|{false})-(set|{reset}) Keytypedcallback
%
%% OUTPUT
%    outputpara ... 
%
%% EXAMPLES
%{

a = matlab.desktop.editor.EditorUtils.getJavaEditorApplication
b = a.getActiveEditor.getComponent.getComponent(0).getComponent(0).getComponent(0).getComponent(0).getComponent(1).getComponent(0).getComponent(0)
uiinspect(b)

cb = handle(b,'CallbackProperties')
set(cb,'KeyTypedCallback',@(src, evnt) disp(evnt.toString))
set(cb,'KeyTypedCallback',@(src, evnt) disp(src.toString)))

%}  
%% VERSIONING
%             Author: Andreas J*****, ****-***, ** ** *** ** ** *** **-*
%      Creation date: 2013-03-22
%             Matlab: 8.0.0.783 (R2012b)
%  Required Products: -
%            Version: 1.3
%
%% REVISIONS
%
% V1.0 | 2013-03-22 |    Andreas J***** | Ersterstellung
% V1.1 | 2013-03-24 |    Andreas J***** | Automatische ertstellung eines Kommentar blocks
% V1.2 | 2013-09-05 |    Andreas J***** | operatoren +=, -=, \=, *= hinzugefügt incl. autovervollfständigung
% V1.3 | 2013-09-23 |    Andreas J***** | R2013a support
% V1.4 | 2013-09-24 |    Andreas Justin | Breakpointbar wird colorisiert wenn edit aktiv ist
%
% See also 

%#ok<*NASGU>
%#ok<*AGROW>
%% --------------------------------------------------------------------------------------------
colorOff = [0.3,0.3,0.3,1];
colorOn =  [40/255, 50/255, 40/255, 1];
jMainPane = [];
jEditor = com.mathworks.mde.desk.MLDesktop.getInstance.getGroupContainer('Editor');
if ~isempty(jEditor)
    for childIdx = 1 : jEditor.getComponentCount
        componentClassName = regexprep(jEditor.getComponent(childIdx-1).class,'.*\.','');
        if any(strcmp(componentClassName,{'DTMaximizedPane','DTFloatingPane','DTTiledPane'}))
            jMainPane = jEditor.getComponent(childIdx-1);
            break;
        end
    end
else
    return
end
if isa(jMainPane,'com.mathworks.mwswing.desk.DTFloatingPane')
    jMainPane = jMainPane.getComponent(0);  % a com.mathworks.mwswing.desk.DTFloatingPane$2 object
end
if verLessThan('matlab','8.2')
    for jj = 1:jMainPane.getComponentCount
        hEditorPane = [];
        
        jSyntaxTextPaneView = getDescendent(jMainPane.getComponent(jj-1),[0,0,1,0,0,0,0]);
        
        if isa(jSyntaxTextPaneView,'com.mathworks.widgets.SyntaxTextPaneMultiView$1')
            % cprintf('Comment','Found\n')
            hEditorPane(1) = handle(getDescendent(jSyntaxTextPaneView.getComponent(1),[1,0,0]),'CallbackProperties');
            hEditorPane(2) = handle(getDescendent(jSyntaxTextPaneView.getComponent(2),[1,0,0]),'CallbackProperties');
        else
            % cprintf('Keywords','Found alternativ\n')
            jEditorPane = getDescendent(jSyntaxTextPaneView,[1,0,0]);
            hEditorPane = handle(jEditorPane,'CallbackProperties');
        end
        
        if activateFlg
            set(hEditorPane ,'KeyTypedCallback',@(src,evnt)Editor_KeyTypedCallback(src,evnt))
            colorizeBreakPointBar(jMainPane,jj-1,colorOn)
        else
            set(hEditorPane ,'KeyTypedCallback','')
            colorizeBreakPointBar(jMainPane,jj-1,colorOff)
        end
        hEditorPaneArray(jj) = hEditorPane;
    end
else % matlab R2013a
    a = matlab.desktop.editor.EditorUtils.getJavaEditorApplication;
    for jj = 0:a.getOpenEditors.size-1
%     for jj = 1:jMainPane.getComponentCount-1
%         hEditorPane = jMainPane...               % DTMaximizedPane
%                             .getComponent(jj)... % DTClientFrame %%% !!!nicht 0 da dort DTDocumentTabs ist (welche offen sind mit close button)
%                             .getComponent(0)...  % RootPane
%                             .getComponent(0)...  % JPanel
%                             .getComponent(1)...  % EditorViewClient
%                             .getComponent(0)...  % EditorViewContainer
%                             .getComponent(0)...  % EditorView
%                             .getComponent(0)...  % MJPanel
%                             .getComponent(0)...  % MJPanel
%                             .getComponent(1)...  % MJScrollPane
%                             .getViewport...      % JViewport
%                             .getView;            % editor for callback

%         if activateFlg
%             set(hEditorPane ,'KeyTypedCallback',@(src,evnt)Editor_KeyTypedCallback(src,evnt))
%         else
%             set(hEditorPane ,'KeyTypedCallback','')
%         end
b = a.getOpenEditors.get(jj).getComponent.getComponent(0).getComponent(0).getComponent(0).getComponent(0).getComponent(1).getComponent(0).getComponent(0);
        hEditorPane = handle(b,'CallbackProperties');
        if activateFlg
            set(hEditorPane,'KeyTypedCallback',@(src,evnt)Editor_KeyTypedCallback(src,evnt));
            colorizeBreakPointBar(jMainPane,jj+1,colorOn)
        else
            set(hEditorPane,'KeyTypedCallback','');
            colorizeBreakPointBar(jMainPane,jj+1,colorOff)
        end

        hEditorPaneArray(jj+1) = hEditorPane;
    end
end


function child = getDescendent(child,listOfChildrenIdx)
if ~isempty(listOfChildrenIdx)
%     if listOfChildrenIdx(1) >= (child.getComponentCount-1)
%         child = child;
%         disp('notFound')
%         disp(child)
%     else
        child = getDescendent(child.getComponent(listOfChildrenIdx(1)),listOfChildrenIdx(2:end));
%     end
end

function putIn = getPutIn(inPut,entireText,cursorPos,offset)
switch inPut
    case '('
        putIn = ')';
    case '"'
        putIn = '"';
    case '['
        putIn = ']';
    case '{'
        putIn = '}';
    case ''''
        putIn = '''';
    case '='
        putIn = '=';
end
chk = any(strcmp(entireText(cursorPos-1+offset),{'(','[','{','''','"','='}));
if ~(numel(entireText) < cursorPos+offset)
    chk = chk && isempty(regexp(entireText(cursorPos+offset),['[a-zA-Z0-9\(\{\[\'''']'],'match'));     % rechts
end
if (cursorPos-2+offset > 0)
    chk = chk && isempty(regexp(entireText(cursorPos-2+offset),['[\.]'],'match'));  % links
    if strcmp(putIn,'''')
        chk = chk && isempty(regexp(entireText(cursorPos-2+offset),['[a-zA-Z0-9\)\}\]]'],'match'));
    end
end
if ~chk
    putIn = '';
end

function Editor_KeyTypedCallback(~,evnt, varargin)
% evnt;
keyChar = get(evnt,'keyChar');
modifiers = get(evnt,'modifiers');
keyCode = get(evnt,'keyCode');
if modifiers == 3 && keyCode == 56 % CTRL-SHIFT (
    Matlab_extendEditorFunctionality(false)
    return
end
operExpr = '(+|-|*|/)';
if strcmp(keyChar,'(') || strcmp(keyChar,'"') || ...
   strcmp(keyChar,'[') || strcmp(keyChar,'''') || ...
   strcmp(keyChar,'{') || strcmp(keyChar,'=')
    
    aE = matlab.desktop.editor.getActive;
    pos = aE.Selection;
    pos(2,1:4) = pos;
    cursorPos = matlab.desktop.editor.positionInLineToIndex(aE, pos(1,1),pos(1,2));
    putIn = getPutIn(keyChar,aE.Text,cursorPos,0);
    switch putIn
        case '}'
            allSpace = regexp(aE.Text(...
                matlab.desktop.editor.positionInLineToIndex(aE,pos(1,1),1):cursorPos-3),...
                '\S','match','once');
            if isempty(allSpace) && strcmp(aE.Text(cursorPos-2),'%')
                spaces = blanks(pos(1,2)-3);
                putIn = [char(13),spaces,'  ',char(13),spaces,'%}'];
                pos(2,1:2) = pos(2,1:2) + [1,0]; % moves the cursor in the line between the comment block
            end
        case '='
            o = regexp(aE.Text(cursorPos-2),operExpr,'match','once');
            if ~isempty(o)
                txt = [aE.Text(matlab.desktop.editor.positionInLineToIndex(aE,pos(1,1),1):cursorPos-1)];
                % [^\s]+?                   !space at least 1 times as much as possible lazy expression
                % [\s]*?                    can be space but don't has to
                % (?=(\(|\[|\{|\+|\-|\*|/)) lookahead from previous position and test if any of these are there
                % [^\+\-\/\*]*              any character but not these as much as possible
                % (?=\s*(\+|\-|\*|\/))      lookahead from previous position can be space followed by an operator
                var = regexp(txt,'[^\s]+?[\s]*?(?=(\(|\[|\{|\+|\-|\*|/))[^\+\-\/\*]*(?=\s*(\+|\-|\*|\/))','match','once');
                aE.Text(cursorPos-2:cursorPos-1) = '= ';
                putIn = [var,' ',o,' '];
                pos(2,2) = pos(2,2) + numel(putIn);
            else 
                putIn = '';
            end
    end

    % put in text and return to original position
    aE.insertTextAtPositionInLine(putIn,pos(1,1),pos(1,2));
    aE.goToPositionInLine(pos(2,1),pos(2,2));
end
% function CommandWindow_KeyTypedCallback(src,evnt)
% keyChar = get(evnt,'keyChar');
% modifiers = get(evnt,'modifiers');
% keyCode = get(evnt,'keyCode');
% 
% if strcmp(keyChar,'(') || ...
% ...%    strcmp(keyChar,'"') || ...  %endlos schleife
%    strcmp(keyChar,'[') || ...
% ...%        strcmp(keyChar,'''') || ... %endlos schleife
%    strcmp(keyChar,'{')
%    obj = evnt.getComponent;
%    cursorPos = obj.getCaretPosition;
%    
%    cmdWinDoc = com.mathworks.mde.cmdwin.CmdWinDocument.getInstance;
%    jString   = cmdWinDoc.getText(cmdWinDoc.getStartPosition.getOffset, ...
%        cmdWinDoc.getLength);
%    str = char(jString);
% 
%    putIn = getPutIn(keyChar,str,cursorPos,1);
%    Aid_doKeyboardActions(putIn)
%    Aid_doKeyboardActions('ARROW_LEFT');
% end
%{

%}
function colorizeBreakPointBar(jMainPane,jj,color)
    try % after startup java.awt.Color is needed
        %breakpoint bar
        jMainPane...               % DTMaximizedPane
            .getComponent(jj).getComponent(0)...
            .getComponent(0).getComponent(1).getComponent(0).getComponent(0).getComponent(0).getComponent(0)...
            .getComponent(1).getComponent(3).getComponent(0).getComponent(2).getComponent(0)...
            .set('background',color(1:3));
        
    catch
        %breakpoint bar
        jMainPane...               % DTMaximizedPane
            .getComponent(jj).getComponent(0)...  
            .getComponent(0).getComponent(1).getComponent(0).getComponent(0).getComponent(0).getComponent(0)...
            .getComponent(1).getComponent(3).getComponent(0).getComponent(2).getComponent(0)...
            .set('background',java.awt.Color(color(1),color(2),color(3),color(4)));
    end