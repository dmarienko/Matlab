function [bindingsList, actionsList] = EditorMacro(keystroke, macro, macroType)
% EditorMacro assigns a macro to a keyboard key-stroke in the Matlab-editor
%
% Syntax:
%    [bindingsList, actionsList] = EditorMacro(keystroke, macro, macroType)
%    [bindingsList, actionsList] = EditorMacro(bindingsList)
%
% Description:
%    EditorMacro assigns the specified MACRO to the requested keyboard
%    KEYSTROKE, within the context of the Matlab Editor and Command Window.
%
%    KEYSTROKE is a string representation of the keyboard combination.
%    Special modifiers (Alt, Ctrl or Control, Shift, Meta, AltGraph) are
%    recognized and should be separated with a space, dash (-), plus (+) or
%    comma (,). At least one of the modifiers should be specified, otherwise
%    very weird things will happen...
%    For a full list of supported keystrokes, see:
%    <a href="http://tinyurl.com/2s63e9">http://java.sun.com/javase/6/docs/api/java/awt/event/KeyEvent.html</a>
%    If KEYSTROKE was already defined, then it will be updated (overridden).
%
%    MACRO should be in one of Matlab's standard callback formats: 'string',
%    @FunctionHandle or {@FunctionHandle,arg1,...}, or any of several hundred
%    built-in editor action-names - read MACROTYPE below for a full
%    description. To remove a KEYSTROKE-MACRO definition, simply enter an
%    empty MACRO ([], {} or '').
%
%    MACROTYPE is an optional input argument specifying the type of action
%    that MACRO is expected to do:
%
%     - 'text' (=default value) indicates that if the MACRO is a:
%        1. 'string': this string will be inserted as-is into the current
%             editor caret position (or replace the selected editor text).
%             Multi-line strings can be set using embedded \n's (example: 
%             'Multi-line\nStrings'). This can be used to insert generic
%             comments or code templates (example: 'try \n catch \n end').
%        2. @FunctionHandle -  the specified function will be invoked with
%             two input arguments: the editorPane object and the eventData
%             object (the KEYSTROKE event details). FunctionHandle is
%             expected to return a string which will then be inserted into
%             the editor document as expained above.
%        3. {@FunctionHandle,arg1,...} - like #2, but the function will be
%             called with the specified arg1+ as input args #3+, following
%             the editorPane and eventData args.
%
%     - 'run' indicates that MACRO should be invoked as a Matlab command,
%             just like any regular Matlab callback. The accepted MACRO
%             formats and function input args are exactly like for 'text'
%             above, except that no output string is expected and no text
%             insertion/replacement will be done (unless specifically done
%             within the invoked MACRO command/function). This MACROTYPE is
%             useful for closing/opening files, moving to another document
%             position and any other non-textual action.
%
%             In addition, this MACROTYPE accepts all available (built-in)
%             editor action names. Valid action names can be listed by
%             requesting the ACTIONSLIST output argument.
%
%    BINDINGSLIST = EditorMacro returns the list of currently-defined
%    KEYSTROKE bindings as a 4-columned cell array: {keystroke, macro, type,
%    class}. The class information indicates a built-in action ('editor menu
%    action', 'editor native action', 'cmdwin native action' or 'cmdwin menu
%    action') or a user-defined action ('text' or 'user-defined macro').
%
%    BINDINGSLIST = EditorMacro(KEYSTROKE) returns the bindings list for
%    the specified KEYSTROKE as a 4-columned cell array: {keystroke, macro,
%    type, class}.
%
%    BINDINGSLIST = EditorMacro(KEYSTROKE,MACRO) returns the bindings list
%    after defining a specific KEYSTROKE-MACRO binding.
%
%    EditorMacro(BINDINGSLIST) can be used to set a bunch of key bindings
%    using a single command. BINDINGSLIST is the cell array returned from
%    a previous invocation of EditorMacro, or by manual construction (just
%    be careful to set the keystroke strings correctly!). Only non-native
%    bindings are updated in this bulk mode of operation.
%
%    [BINDINGSLIST, ACTIONSLIST] = EditorMacro(...) returns in ACTIONSLIST a
%    3-columned cell array of all available built-in actions and currently-
%    associated key-biding(s): {actionName, keyBinding(s), class}.
%
% Examples:
%    bindingsList = EditorMacro;  % get list of current key-bindings
%    bindingsList = EditorMacro('ctrl r');  % get list of bindings for <Ctrl>-R
%    [bindings,actions] = EditorMacro;  % get list of available built-in action-names
%    EditorMacro('Ctrl Shift C', '%%% Main comment %%%\n% \n% \n% \n');
%    EditorMacro('Alt-x', 'try\n  % Main code here\ncatch\n  % Exception handling here\nend');
%    EditorMacro('Ctrl-Alt C', @myCallbackFunction);  % myCallbackFunction returns a string to insert
%    EditorMacro('Alt control t', @(a,b)datestr(now), 'text');  % insert current timestamp
%    EditorMacro('Shift-Control d', {@computeDiameter,3.14159}, 'run');
%    EditorMacro('Alt L', 'to-lower-case', 'run') % Built-in action: convert text to lowercase
%    EditorMacro('ctrl D','open-selection','run') % Override default Command-Window action (=delete)
%                                                 % to behave as in the Editor (=open selected file)
%
% Known limitations (=TODO for future versions):
%    1. Multi-keystroke bindings (e.g., 'alt-U,L') are not supported
%    2. In Matlab 6, macro insertions are un-undo-able (ok in Matlab 7)
%    3. Key bindings are sometimes lost when switching between a one-document
%       editor and a two-document one (i.e., adding/closing the second doc)
%    4. Key bindings are not saved between editor sessions
%    5. In split-pane mode, when inserting a macro on the secondary (right/
%       bottom) pane, then both panes (and the actual document) are updated
%       but the secondary pane does not display the inserted macro (the
%       primary pane looks ok).
%    6. Native menu/editor/command-window actions cannot be updated in bulk
%       mode (EditorMacro(BINDINGSLIST)) - only one at a time.
%    7. Key-bindings may be fogotten when switching between docked/undocked
%       editor or between the Command-Window and other docked desktop panes
%       (such as Command History, Profiler etc.)
%    8. In Matlab 6, actions are not supported: only user-defined text/macro
%
% Bugs and suggestions:
%    Please send to Yair Altman (altmany at gmail dot com)
%
% Warning:
%    This code heavily relies on undocumented and unsupported Matlab
%    functionality. It works on Matlab 6 & 7+, but use at your own risk!
%
%    A technical description of the implementation can be found at:
%    <a href="http://undocumentedmatlab.com/blog/EditorMacro/">http://UndocumentedMatlab.com/blog/EditorMacro/</a>
%
% Change log:
%    2011-01-31: Fixes for R2011a
%    2009-10-26: Fixes for Matlab 6
%    2009-08-19: Support for command-window actions; use EDT for text replacement
%    2009-08-11: Several fixes; support for native/menu actions (idea by Perttu Ranta-aho)
%    2009-07-03: Fixed Matlab 6 edge-case; Automatically detect macro functions that do not accept the expected two input args
%    2009-07-01: First version posted on <a href="http://www.mathworks.com/matlabcentral/fileexchange/authors/27420">MathWorks File Exchange</a>

% Programmed by Yair M. Altman: altmany(at)gmail.com
% $Revision: 1.6 $  $Date: 2011/01/31 20:47:25 $

  persistent appdata
  try
      % Check input args
      if nargin == 2
          macroType = 'text';
      elseif nargin == 3 & ~ischar(macroType)  %#ok Matlab 6 compatibility
          myError('YMA:EditorMacro:badMacroType','MacroType must be ''text'', ''run'' or ''native''');
      elseif nargin > 3
          myError('YMA:EditorMacro:tooManyArgs','too many input argument');
      end

      % Try to get the editor's Java handle
      jEditor = getJEditor;

      % ...and the editor's main documents container handle
      jMainPane = getJMainPane(jEditor);
      hEditorPane = getEditorPane(jMainPane.getComponent(0));  % first document

      % ...and the desktop's Command Window handle
      try
          jCmdWin = [];
          %mde = jMainPane.getRootPane.getParent.getDesktop;
          mde = com.mathworks.mde.desk.MLDesktop.getInstance;  % different in ML6!!!
          hCmdWin = mde.getClient('Command Window');
          jCmdWin = hCmdWin.getComponent(0).getComponent(0).getComponent(0);  % com.mathworks.mde.cmdwin.XCmdWndView
          jCmdWin = handle(jCmdWin, 'CallbackProperties');
      catch
          % Maybe ML6 or... - never mind...
      end

      % Now try to get the persistent list of macros
      try
          appdata = getappdata(jEditor,'EditorMacro');
      catch
          % never mind - we will use the persistent object instead...
      end

      % If no EditorMacro has been set yet
      if isempty(appdata)
          % Set the initial binding hashtable
          appdata = {}; %java.util.Hashtable is better but can't extract {@function}...

          % Add editor native action bindings to the bindingsList
          edActionsMap = getAccelerators(hEditorPane); % =getAccelerators(hEditorPane.getActiveTextComponent);
          appdata.bindings = getBindings({},edActionsMap,'editor native action');

          % Add CW native action bindings to the bindingsList
          cwActionsMap = getAccelerators(jCmdWin);
          appdata.bindings = getBindings(appdata.bindings,cwActionsMap,'cmdwin native action');

          % Add editor menu action bindings to the bindingsList
          appdata.edMenusMap = getMenuShortcuts(jMainPane);
          appdata.bindings = getBindings(appdata.bindings,appdata.edMenusMap,'editor menu action');

          % Add CW menu action bindings to the bindingsList
          appdata.cwMenusMap = getMenuShortcuts(jCmdWin);
          appdata.bindings = getBindings(appdata.bindings,appdata.cwMenusMap,'cmdwin menu action');

          % Loop over all the editor's currently-open documents
          for docIdx = 1 : jMainPane.getComponentCount
              % Instrument these documents to catch user keystrokes
              instrumentDocument([],[],jMainPane.getComponent(docIdx-1),jEditor,appdata);
          end

          % Update the editor's ComponentAdded callback to also instrument new documents
          set(jMainPane,'ComponentAddedCallback',{@instrumentDocument,[],jEditor,appdata})
          if isempty(get(jMainPane,'ComponentAddedCallback'))
              pause(0.1);
              set(jMainPane,'ComponentAddedCallback',{@instrumentDocument,[],jEditor,appdata})
          end

          % Also instrument the CW to catch user keystrokes
          set(jCmdWin, 'KeyPressedCallback', {@keyPressedCallback,jEditor,appdata,jCmdWin});
      end

      % If any macro setting is requested
      if nargin
          % Update the bindings list with the new key binding
          if nargin > 1
              appdata = updateBindings(appdata,keystroke,macro,macroType,jMainPane,jCmdWin);
              setappdata(jEditor,'EditorMacro',appdata);
          elseif iscell(keystroke) & (isempty(keystroke) | size(keystroke,2)==4) %#ok Matlab 6 compatibility
              appdata = keystroke;  % passed updated bindingsList as input arg
              setappdata(jEditor,'EditorMacro',appdata);
          elseif ischar(keystroke) | isa(keystroke,'javax.swing.KeyStroke')  %#ok Matlab 6 compatibility
              setappdata(jEditor,'EditorMacro',appdata);
              keystroke = normalizeKeyStroke(keystroke);
              bindingIdx = strmatch(keystroke,appdata.bindings(:,1),'exact');
              appdata.bindings = appdata.bindings(bindingIdx,:);  % only return matching bindings
          else
              myError('YMA:EditorMacro:invalidBindingsList','invalid BINDINGSLIST input argument');
          end
      end

      % Check if output is requested
      if nargout
          if ~iscell(appdata.bindings)
              appdata.bindings = {};
          end
          bindingsList = appdata.bindings;

          % Return the available actionsList
          if nargout > 1
              % Start with the native editor actions
              actionsList = listActionsMap(hEditorPane);
              try [actionsList{:,3}] = deal('editor native action'); catch, end

              % ...add the desktop's CW native actions...
              cwActionsList = listActionsMap(jCmdWin);
              try [cwActionsList{:,3}] = deal('cmdwin native action'); catch, end
              actionsList = [actionsList; cwActionsList];

              % ...and finally add the menu actions
              try
                  menusList = appdata.edMenusMap(:,[2,1]);  % {action,keystroke}
                  try [menusList{:,3}] = deal('editor menu action'); catch, end
                  actionsList = [actionsList; menusList];
              catch
                  % never mind...
              end

              try
                  menusList = appdata.cwMenusMap(:,[2,1]);
                  try [menusList{:,3}] = deal('cmdwin menu action'); catch, end
                  actionsList = [actionsList; menusList];
              catch
                  % never mind...
              end
          end
      end

  % Error handling
  catch
      handleError;
  end

%% Get the current list of key-bindings
function bindings = getBindings(bindings,actionsMap,groupName)
  try
      for bindingIdx = 1 : size(actionsMap,1)
          ks = actionsMap{bindingIdx,1};
          if ~isempty(ks)
              actionName = actionsMap{bindingIdx,2};
              [bindings(end+1,:)] = {ks,actionName,'run',groupName};  %#ok grow
          end
      end
  catch
      % never mind...
  end

%% Modify native shortcuts
function bindingsList = nativeShortcuts(keystroke, macro, jMainPane)
  % Note: this function is unused
  hEditorPane = getEditorPane(jMainPane.getComponent(0));  % first document
  switch lower(keystroke(1:5))
      case 'listn'
          % List all active accelerators
          bindingsList = getAccelerators(hEditorPane.getActiveTextComponent);
          if ~nargout
              for ii = 1 : size(bindingsList,1)
                  disp(sprintf('%-35s %s',bindingsList{ii,:}))
              end
          end

      case 'lista'
          % List all available actions
          bindingsList = listActionsMap(hEditorPane,nargout);

      otherwise
          % Bind native action
          bindingsList = getNativeActions(hEditorPane);
          if ~ismember(macro,bindingsList) & ~isempty(macro)  %#ok Matlab 6 compatibility
              myError('YMA:EditorMacro:invalidNativeAction','invalid Native Action');
          end
          [keystroke,jKeystroke] = normalizeKeyStroke(keystroke);
          %jkeystroke = javax.swing.KeyStroke.getKeyStroke(keystroke);
          for docIdx = 1 : jMainPane.getComponentCount
              % Instrument these documents to catch user keystrokes
              hEditorPane = getEditorPane(jMainPane.getComponent(docIdx-1));
              inputMap = hEditorPane.getInputMap;
              removeShortcut(inputMap,jKeystroke);
              if ~isempty(macro)
                  action = hEditorPane.getActionMap.get(macro);
                  inputMap.put(jKeystroke,action);
              end
          end
          removeMenuShortcut(jMainPane,keystroke);
  end

%% Get/list all available key-bindings for all the possible actions
function bindingsList = listActionsMap(hEditorPane,nargoutFlag)
  try
      bindingsList  = getNativeActions(hEditorPane);
      try
          % Editor accelerators are stored in the activeTextComponent
          accellerators = getAccelerators(hEditorPane.getActiveTextComponent);
      catch
          % The CW doesn't have an activeTextComponent...
          accellerators = getAccelerators(hEditorPane);
      end
      for ii = 1 : size(bindingsList,1)
          actionKeys = accellerators(strcmpi(accellerators(:,2),bindingsList{ii}),1);
          if numel(actionKeys)==1
              actionKeys = actionKeys{1};
              keysStr = actionKeys;
          elseif isempty(actionKeys)
              actionKeys = [];
              keysStr = '  [not assigned]';
          else  % multiple keys assigned
              keysStr = strcat(char(actionKeys),',')';
              keysStr = keysStr(:)';  % =reshape(keysStr,1,numel(keysStr));
              keysStr = strtrim(strrep(keysStr,',',', '));
              keysStr = regexprep(keysStr,'\s+',' ');
              keysStr = keysStr(1:end-1);  % remove trailing ','
          end
          bindingsList{ii,2} = actionKeys;
          if nargin > 1 & ~nargoutFlag  %#ok Matlab 6 compatibility
              %disp(bindingsList)
              disp(sprintf('%-35s %s',bindingsList{ii,1},keysStr))
          end
      end
  catch
      % never mind...
  end

%% Get all available actions (even those without any key-binding)
function actionNames = getNativeActions(hEditorPane)
  try
      actionNames = {};
      actionKeys = hEditorPane.getActionMap.allKeys;
      actionNames = cellfun(@char,cell(actionKeys),'UniformOutput',false);
      actionNames = sort(actionNames);
  catch
      % never mind...
  end

%% Get all active native shortcuts
function accelerators = getAccelerators(hEditorPane)
  try
      accelerators = cell(0,2);
      inputMap = hEditorPane.getInputMap;
      inputKeys = inputMap.allKeys;
      accelerators = cell(numel(inputKeys),2);
      for ii = 1 : numel(inputKeys)
          accelerators(ii,:) = {char(inputKeys(ii)), char(inputMap.get(inputKeys(ii)))};
      end
      accelerators = sortrows(accelerators,1);
  catch
      % never mind...
  end

%% Remove shortcut from inputMap
function removeShortcut(inputMap,keystroke)
    if ~isa(keystroke,'javax.swing.KeyStroke')
        keystroke = javax.swing.KeyStroke.getKeyStroke(keystroke);
    end
    inputMap.remove(keystroke);
    %keys = inputMap.allKeys;
    %for ii = 1:length(keys)
    %    if keys(ii) == keystroke
    %        % inputMap.remove(keystroke);
    %        inputMap.put(keystroke,[]); %,null(1));
    %        return
    %    end
    %end
    try
        % keystroke not found - try to find it in the parent inputMap...
        removeShortcut(inputMap.getParent,keystroke)
    catch
        % Never mind
    end

%% Get the list of all menu actions
function menusMap = getMenuShortcuts(jMainPane)
    try
        menusMap = {};
        jRootPane = jMainPane.getRootPane;
        jMenubar = jRootPane.getMenuBar; %=jRootPane.getComponent(1).getComponent(1);
        for menuIdx = 1 : jMenubar.getMenuCount
            % top-level menus should be treated differently than sub-menus
            jMenu = jMenubar.getMenu(menuIdx-1);
            menusMap = getMenuShortcuts_recursive(jMenu,menusMap);
        end
    catch
        % Never mind
    end

%% Recursively get the list of all menu actions
function menusMap = getMenuShortcuts_recursive(jMenu,menusMap)
    try
        numMenuComponents = getNumMenuComponents(jMenu);
        for child = 1 : numMenuComponents
            menusMap = getMenuShortcuts_recursive(jMenu.getMenuComponent(child-1),menusMap);
        end
    catch
        % Probably a simple menu item, not a sub-menu - add it to the menusMap
        try
            accelerator = char(jMenu.getAccelerator);
            if isempty(accelerator)
                accelerator = [];  % ''=>[]
            end
            [menusMap(end+1,:)] = {accelerator, char(jMenu.getActionCommand), jMenu};
        catch
            % maybe a separator or something strange... - ignore
        end
    end

%% Remove shortcut from Menu items inputMap
function menusMap = removeMenuShortcut(menusMap,keystroke)
    try
        keystroke = normalizeKeyStroke(keystroke);
        map = cellfun(@char,menusMap(:,1),'un',0);
        oldBindingIdx = strmatch(keystroke,map,'exact');
        if ~isempty(oldBindingIdx)
            menusMap{oldBindingIdx,1} = '';
            menusMap{oldBindingIdx,3}.setAccelerator([]);
        end
    catch
        % never mind...
    end

%% Remove shortcut from Menu items inputMap
function removeMenuShortcut_old(jMainPane,keystroke)
    % Note: this function was replaced by removeMenuShortcut()
    try
        % Try to remove any corresponding menu-item accelerator
        jRootPane = jMainPane.getRootPane;
        jMenubar = jRootPane.getMenuBar; %=jRootPane.getComponent(1).getComponent(1);
        if ~isa(keystroke,'javax.swing.KeyStroke')
            keystroke = javax.swing.KeyStroke.getKeyStroke(keystroke);
        end
        for menuIdx = 1 : jMenubar.getMenuCount
            % top-level menus should be treated differently than sub-menus
            jMenu = jMenubar.getMenu(menuIdx-1);
            if removeMenuShortcut_recursive(jMenu,keystroke)
                return;
            end
        end
    catch
        % never mind...
    end

%% Recursively remove shortcut from Menu items inputMap
function found = removeMenuShortcut_recursive(jMenu,keystroke)
    try
        % Try to remove any corresponding menu-item accelerator
        found = 0;
        if ~isempty(jMenu.getActionForKeyStroke(keystroke))
            jMenu.setAccelerator([]);
            found = 1;
            return;
        end

        % Not found - try to dig further
        try
            numMenuComponents = getNumMenuComponents(jMenu);
            for child = 1 : numMenuComponents
                found = removeMenuShortcut_recursive(jMenu.getMenuComponent(child-1),keystroke);
                if found
                    return;
                end
            end
        catch
            % probably a simple menu item, not a sub-menu - ignore
            %a=1;  % debuggable breakpoint...
        end
    catch
        % never mind...
    end

%% Get the number of menu sub-elements
function numMenuComponents  = getNumMenuComponents(jcontainer)

    % The following line will raise an Exception for anything except menus
    numMenuComponents = jcontainer.getMenuComponentCount;

    % No error so far, so this must be a menu container...
    % Note: Menu subitems are not visible until the top-level (root) menu gets initial focus...
    % Try several alternatives, until we get a non-empty menu (or not...)
    % TODO: Improve performance - this takes WAY too long...
    if jcontainer.isTopLevelMenu & (numMenuComponents==0)
        jcontainer.requestFocus;
        numMenuComponents = jcontainer.getMenuComponentCount;
        if (numMenuComponents == 0)
            drawnow; pause(0.001);
            numMenuComponents = jcontainer.getMenuComponentCount;
            if (numMenuComponents == 0)
                jcontainer.setSelected(true);
                numMenuComponents = jcontainer.getMenuComponentCount;
                if (numMenuComponents == 0)
                    drawnow; pause(0.001);
                    numMenuComponents = jcontainer.getMenuComponentCount;
                    if (numMenuComponents == 0)
                        jcontainer.doClick;  % needed in order to populate the sub-menu components
                        numMenuComponents = jcontainer.getMenuComponentCount;
                        if (numMenuComponents == 0)
                            drawnow; %pause(0.001);
                            numMenuComponents = jcontainer.getMenuComponentCount;
                            jcontainer.doClick;  % close menu by re-clicking...
                            if (numMenuComponents == 0)
                                drawnow; %pause(0.001);
                                numMenuComponents = jcontainer.getMenuComponentCount;
                            end
                        else
                            % ok - found sub-items
                            % Note: no need to close menu since this will be done when focus moves to another window
                            %jcontainer.doClick;  % close menu by re-clicking...
                        end
                    end
                end
                jcontainer.setSelected(false);  % de-select the menu
            end
        end
    end

%% Get the Java editor component handle
function jEditor = getJEditor
  jEditor = [];
  try
      % Matlab 7
      jEditor = com.mathworks.mde.desk.MLDesktop.getInstance.getGroupContainer('Editor');
  catch
      % Matlab 6
      try
          %desktop = com.mathworks.ide.desktop.MLDesktop.getMLDesktop; % no use - can't get to the editor from here...
          openDocs = com.mathworks.ide.editor.EditorApplication.getOpenDocuments;  % a java.util.Vector
          firstDoc = openDocs.elementAt(0);  % a com.mathworks.ide.editor.EditorViewContainer object
          jEditor = firstDoc.getParent.getParent.getParent;  % a com.mathworks.mwt.MWTabPanel or com.mathworks.ide.desktop.DTContainer object
      catch
          myError('YMA:EditorMacro:noEditor','Cannot retrieve the Matlab editor handle - possibly no open editor');
      end
  end
  if isempty(jEditor)
      myError('YMA:EditorMacro:noEditor','Cannot retrieve the Matlab editor handle - possibly no open editor');
  end
  try
      jEditor = handle(jEditor,'CallbackProperties');
  catch
      % never mind - might be Matlab 6...
  end

%% Get the Java editor's main documents container handle
function jMainPane = getJMainPane(jEditor)
  jMainPane = [];
  try
      v = version;
      if (v(1) >= '7')
          for childIdx = 1 : jEditor.getComponentCount
              componentClassName = regexprep(jEditor.getComponent(childIdx-1).class,'.*\.','');
              if any(strcmp(componentClassName,{'DTMaximizedPane','DTFloatingPane','DTTiledPane'}))
                  jMainPane = jEditor.getComponent(childIdx-1);
                  break;
              end
          end
          if isa(jMainPane,'com.mathworks.mwswing.desk.DTFloatingPane')
              jMainPane = jMainPane.getComponent(0);  % a com.mathworks.mwswing.desk.DTFloatingPane$2 object
          end
      else
          for childIdx = 1 : jEditor.getComponentCount
              if isa(jEditor.getComponent(childIdx-1),'com.mathworks.mwt.MWGroupbox') | ... 
                 isa(jEditor.getComponent(childIdx-1),'com.mathworks.ide.desktop.DTClientFrame') %#ok Matlab 6 compatibility
                  jMainPane = jEditor.getComponent(childIdx-1);
                  break;
              end
          end
      end
  catch
      % Matlab 6 - ignore for now...
  end
  if isempty(jMainPane)
      myError('YMA:EditorMacro:noMainPane','Cannot find the Matlab editor''s main document pane');
  end
  try
      jMainPane = handle(jMainPane,'CallbackProperties');
  catch
      % never mind - might be Matlab 6...
  end

%% Get EditorPane
function hEditorPane = getEditorPane(jDocPane)
  try
      % Matlab 7   TODO: good for ML 7.1-7.7: need to check other versions
      jSyntaxTextPaneView = getDescendent(jDocPane,[0,0,1,0,0,0,0]);
      if isa(jSyntaxTextPaneView,'com.mathworks.widgets.SyntaxTextPaneMultiView$1')
          hEditorPane(1) = handle(getDescendent(jSyntaxTextPaneView.getComponent(1),[1,0,0]),'CallbackProperties');
          hEditorPane(2) = handle(getDescendent(jSyntaxTextPaneView.getComponent(2),[1,0,0]),'CallbackProperties');
      else
          jEditorPane = getDescendent(jSyntaxTextPaneView,[1,0,0]);
          hEditorPane = handle(jEditorPane,'CallbackProperties');
      end
  catch
      % Matlab 6
      hEditorPane = getDescendent(jDocPane,[0,0,0,0]);
      if isa(hEditorPane,'com.mathworks.mwt.MWButton')  % edge case
          hEditorPane = getDescendent(jDocPane,[0,1,0,0]);
      end
  end

%% Internal error processing
function myError(id,msg)
  v = version;
  if (v(1) >= '7')
      error(id,msg);
  else
      % Old Matlab versions do not have the error(id,msg) syntax...
      error(msg);
  end

%% Error handling routine
function handleError
      v = version;
      if v(1)<='6'
          err.message = lasterr;  %#ok no lasterror function...
      else
          err = lasterror;  %#ok
      end
      try
          err.message = regexprep(err.message,'Error .* ==> [^\n]+\n','');
      catch
          try
              % Another approach, used in Matlab 6 (where regexprep is unavailable)
              startIdx = findstr(err.message,'Error using ==> ');
              stopIdx = findstr(err.message,char(10));
              for idx = length(startIdx) : -1 : 1
                  idx2 = min(find(stopIdx > startIdx(idx)));  %#ok ML6
                  err.message(startIdx(idx):stopIdx(idx2)) = [];
              end
          catch
              % never mind...
          end
      end
      if isempty(findstr(mfilename,err.message))
          % Indicate error origin, if not already stated within the error message
          err.message = [mfilename ': ' err.message];
      end
      if v(1)<='6'
          while err.message(end)==char(10)
              err.message(end) = [];  % strip excessive Matlab 6 newlines
          end
          error(err.message);
      else
          rethrow(err);
      end

%% Main keystroke callback function
function instrumentDocument(jObject,jEventData,jDocPane,jEditor,appdata)  %#ok jObject is unused
  try
      if isempty(jDocPane)
          % This happens when we get here via the jEditor's ComponentAddedCallback
          % (when adding a new document pane)
          try
              % Matlab 7
              jDocPane = jEventData.getChild;
          catch
              % Matlab 6
              eventData = get(jObject,'ComponentAddedCallbackData');
              jDocPane = eventData.child;
          end
      end
      hEditorPane = getEditorPane(jDocPane);

      % Note: KeyTypedCallback is called less frequently (i.e. better),
      % ^^^^  but unfortunately it does not catch alt/ctrl combinations...
      %set(hEditorPane, 'KeyTypedCallback', {@keyPressedCallback,jEditor,appdata,hEditorPane});
      set(hEditorPane, 'KeyPressedCallback', {@keyPressedCallback,jEditor,appdata,hEditorPane});
      pause(0.01);  % needed in Matlab 6...
  catch
      % never mind - might be Matlab 6...
  end

%% Recursively get the specified children
function child = getDescendent(child,listOfChildrenIdx)
  if ~isempty(listOfChildrenIdx)
      child = getDescendent(child.getComponent(listOfChildrenIdx(1)),listOfChildrenIdx(2:end));
  end

%% Update the bindings list
function appdata = updateBindings(appdata,keystroke,macro,macroType,jMainPane,jCmdWin)

  [keystroke,jKeystroke] = normalizeKeyStroke(keystroke);
  %jKeystroke = javax.swing.KeyStroke.getKeyStroke(keystroke);
  %appdata.put(keystroke,macro);  %using java.util.Hashtable is better but can't extract {@function}...
  try
      oldBindingIdx = strmatch(keystroke,appdata.bindings(:,1),'exact');
      appdata.bindings(oldBindingIdx,:) = [];  % clear any possible old binding
  catch
      % ignore - possibly empty appdata
      a=1;  % debug point
  end

  % Remove native key-bindings from all editor documents / menu-items
  try
      for docIdx = 1 : jMainPane.getComponentCount
          hEditorPane = getEditorPane(jMainPane.getComponent(docIdx-1));
          inputMap = hEditorPane.getInputMap;
          removeShortcut(inputMap,keystroke);
      end
      appdata.edMenusMap = removeMenuShortcut(appdata.edMenusMap,keystroke);
      appdata.cwMenusMap = removeMenuShortcut(appdata.cwMenusMap,keystroke);
  catch
      % never mind...
  end

  try
      if ~isempty(macro)

          % Normalize the requested macro (if it's a string): '\n', ...
          if ischar(macro)
              macro = sprintf(strrep(macro,'%','%%'));
          end

          % Check & normalize the requested macroType
          if ~ischar(macroType)
              myError('YMA:EditorMacro:badMacroType','bad MACROTYPE input argument - must be a ''string''');
          elseif isempty(macroType) | ~any(lower(macroType(1))=='rt')  %#ok for Matlab6 compatibility
              myError('YMA:EditorMacro:badMacroType','bad MACROTYPE input argument - must be ''text'' or ''run''');
          elseif lower(macroType(1)) == 'r'
              macroType = 'run';
              macroClass = 'user-defined macro';
          else
              macroType = 'text';
              macroClass = 'text';
          end

          % Check if specified macro is a native and/or menu action name
          if ischar(macro) & macroType(1)=='r'  %#ok Matlab 6 compatibility

              % Check for editor native action name
              actionFound = 0;
              hEditorPane = getEditorPane(jMainPane.getComponent(0));  % first document
              actionNames = getNativeActions(hEditorPane);
              if any(strcmpi(macro,actionNames))  %#ok Matlab 6 compatibility
                  % Specified macro appears to be a valid native action name
                  for docIdx = 1 : jMainPane.getComponentCount
                      % Add requested action binding to all editor documents' inputMaps
                      hEditorPane = getEditorPane(jMainPane.getComponent(docIdx-1));
                      inputMap = hEditorPane.getInputMap;
                      %removeShortcut(inputMap,jKeystroke);
                      action = hEditorPane.getActionMap.get(macro);
                      inputMap.put(jKeystroke,action);
                  end
                  [appdata.bindings(end+1,:)] = {keystroke,macro,macroType,'editor native action'};
                  actionFound = 1;
              end

              % Check for CW native action name
              actionNames = getNativeActions(jCmdWin);
              if any(strcmpi(macro,actionNames))  %#ok Matlab 6 compatibility
                  % Specified macro appears to be a valid native action name
                  % Add requested action binding to the CW inputMap
                  inputMap = jCmdWin.getInputMap;
                  %removeShortcut(inputMap,jKeystroke);
                  action = jCmdWin.getActionMap.get(macro);
                  inputMap.put(jKeystroke,action);
                  [appdata.bindings(end+1,:)] = {keystroke,macro,macroType,'cmdwin native action'};
                  actionFound = 1;
              end

              % Check for editor menu action name
              oldBindingIdx = find(strcmpi(macro, appdata.bindings(:,2)) & ...
                                   strcmpi('editor menu action', appdata.bindings(:,4)));
              appdata.bindings(oldBindingIdx,:) = [];  %#ok clear any possible old binding
              menuItemIdx = find(strcmpi(macro,appdata.edMenusMap(:,2)));
              for menuIdx = 1 : length(menuItemIdx)
                  appdata.edMenusMap{menuItemIdx(menuIdx),1} = keystroke;
                  appdata.edMenusMap{menuItemIdx(menuIdx),3}.setAccelerator(jKeystroke);
                  [appdata.bindings(end+1,:)] = {keystroke,macro,macroType,'editor menu action'};
                  actionFound = 1;
              end

              % Check for CW menu action name
              oldBindingIdx = find(strcmpi(macro, appdata.bindings(:,2)) & ...
                                   strcmpi('cmdwin menu action', appdata.bindings(:,4)));
              appdata.bindings(oldBindingIdx,:) = [];  %#ok clear any possible old binding
              menuItemIdx = find(strcmpi(macro,appdata.cwMenusMap(:,2)));
              for menuIdx = 1 : length(menuItemIdx)
                  appdata.cwMenusMap{menuItemIdx(menuIdx),1} = keystroke;
                  appdata.cwMenusMap{menuItemIdx(menuIdx),3}.setAccelerator(jKeystroke);
                  [appdata.bindings(end+1,:)] = {keystroke,macro,macroType,'cmdwin menu action'};
                  actionFound = 1;
              end

              % Bail out if native and/or menu action was handled
              if actionFound
                  return;
              end
          end

          % A non-native macro - Store the new/updated key-binding in the bindings list
          [appdata.bindings(end+1,:)] = {keystroke,macro,macroType,macroClass};
      end
  catch
      myError('YMA:EditorMacro:badMacro','bad MACRO or MACROTYPE input argument - read the help section');
  end

%% Normalize the keystroke string to a standard format
function [keystroke,jKeystroke] = normalizeKeyStroke(keystroke)
  try
      if ~ischar(keystroke)
          myError('YMA:EditorMacro:badKeystroke','bad KEYSTROKE input argument - must be a ''string''');
      end
      keystroke = strrep(keystroke,',',' ');  % ',' => space (extra spaces are allowed)
      keystroke = strrep(keystroke,'-',' ');  % '-' => space (extra spaces are allowed)
      keystroke = strrep(keystroke,'+',' ');  % '+' => space (extra spaces are allowed)
      [flippedKeyChar,flippedMods] = strtok(fliplr(keystroke));
      keyChar   = upper(fliplr(flippedKeyChar));
      modifiers = lower(fliplr(flippedMods));

      keystroke = sprintf('%s %s', modifiers, keyChar);  % PRESSED: the character needs to be UPPERCASE, all modifiers lowercase
      %keystroke = sprintf('%s typed %s',   modifiers, keyChar);  % TYPED: in runtime, the callback is for Typed, not Pressed

      jKeystroke = javax.swing.KeyStroke.getKeyStroke(keystroke);  % normalize & check format validity
      keystroke = char(jKeystroke.toString);  % javax.swing.KeyStroke => Matlab string
      %keystroke = strrep(keystroke, 'pressed', 'released');  % in runtime, the callback is for Typed, not Pressed
      %keystroke = strrep(keystroke, '-P', '-R');  % a different format in Matlab 6 (=Java 1.1.8)...
      keystroke = strrep(keystroke,'keyCode ','');  % Fix for JVM 1.1.8 (Matlab 6)
      if isempty(keystroke)
          myError('YMA:EditorMacro:badKeystroke','bad KEYSTROKE input argument');
      end
  catch
      myError('YMA:EditorMacro:badKeystroke','bad KEYSTROKE input argument - see help section');
  end

%% Main keystroke callback function
function keyPressedCallback(jEditorPane,jEventData,jEditor,appdata,hEditorPane,varargin)
  try
      try
          appdata = getappdata(jEditor,'EditorMacro');
      catch
          % gettappdata() might fail on Matlab 6 so it will fallback to the supplied appdata input arg
      end

      % Normalize keystroke string
      try
          keystroke = javax.swing.KeyStroke.getKeyStrokeForEvent(jEventData);
          %get(jEventData)
      catch
          % Matlab 6 - for some reason, all Fn keys don't work with KeyReleasedCallback, but some of them work ok with KeyPressedCallback...
          jEventData = get(jEditorPane,'KeyPressedCallbackData');
          keystroke = javax.swing.KeyStroke.getKeyStroke(jEventData.keyCode, jEventData.modifiers);
          keystroke = char(keystroke.toString);  % no automatic type-casting in Matlab 6...
          keystroke = strrep(keystroke,'keyCode ','');  % Fix for JVM 1.1.8 (Matlab 6)
          jEditorPane = hEditorPane;  % bypass Matlab 6 quirk...
      end

      % If this keystroke was bound to a macro
      macroIdx = strmatch(keystroke,appdata.bindings(:,1),'exact');
      if ~isempty(macroIdx)

          % Disregard built-in actions - they are dispatched via a separate mechanism
          userTextIdx  = strcmp(appdata.bindings(macroIdx,4),'text');
          userMacroIdx = strcmp(appdata.bindings(macroIdx,4),'user-defined macro');
          if ~any(userTextIdx) & ~any(userMacroIdx)  %#ok Matlab 6 compatibility
              return;
          end

          % Dispatch the defined macro
          macro = appdata.bindings{macroIdx,2};
          macroType = appdata.bindings{macroIdx,3};

          switch lower(macroType(1))

              case 't'  % Text
                  if ischar(macro)
                      % Simple string - insert as-is
                  elseif iscell(macro)
                      % Cell or cell array - feval this cell
                      macro = myFeval(macro{1}, jEditorPane, jEventData, macro{2:end});
                  else  % assume @FunctionHandle
                      % feval this @FunctionHandle
                      macro = myFeval(macro, jEditorPane, jEventData);
                  end

                  % Now insert the resulting string into the jEditorPane caret position or replace selection
                  %caretPosition = jEditorPane.getCaretPosition;
                  try
                      % Matlab 7
                      %jEditorPane.insert(caretPosition, macro);  % better to use replaceSelection() than insert()
                      try
                          % Try to dispatch on EDT
                          awtinvoke(jEditorPane, 'replaceSelection', macro);
                      catch
                          try
                              awtinvoke(java(jEditorPane), 'replaceSelection', macro);
                          catch
                              % no good - try direct invocation
                              jEditorPane.replaceSelection(macro);
                          end
                      end
                  catch
                      % Matlab 6
                      %jEditorPane.insert(macro, caretPosition);  % note the reverse order of input args vs. Matlab 7...
                      try
                          % Try to dispatch on EDT
                          awtinvoke(jEditorPane, 'replaceRange', macro, jEditorPane.getSelStart, jEditorPane.getSelEnd);
                      catch
                          try
                              awtinvoke(java(jEditorPane), 'replaceRange', macro, jEditorPane.getSelStart, jEditorPane.getSelEnd);
                          catch
                              % no good - try direct invocation
                              jEditorPane.replaceRange(macro, jEditorPane.getSelStart, jEditorPane.getSelEnd);
                          end
                      end
                  end
                  
              case 'r'  % Run
                  if ischar(macro)
                      % Simple string - evaluate in the base
                      evalin('base', macro);
                  elseif iscell(macro)
                      % Cell or cell array - feval this cell
                      myFeval(macro{1}, jEditorPane, jEventData, macro{2:end});
                  else  % assume @FunctionHandle
                      % feval this @FunctionHandle
                      myFeval(macro, jEditorPane, jEventData);
                  end
          end
      end
  catch
      % never mind... - ignore error
      %lasterr
      try err = lasterror;  catch, end  %#ok for debugging, will fail on ML6
      dummy=1;          %#ok debugging point
  end

%% Evaluate a function with exception handling to automatically fix too-many-inputs problems
function result = myFeval(func,varargin)
  try
      result = [];
      if nargout
          result = feval(func,varargin{:});
      else
          feval(func,varargin{:});
      end
  catch
      % Try rerunning the function without the two default args
      %v = version;
      %if v(1)<='6'
      %    err.identifier = 'MATLAB:TooManyInputs';  %#ok no lasterror function so assume...
      %else
      %    err = lasterror;  %#ok
      %end
      %if strcmpi(err.identifier,'MATLAB:TooManyInputs')
          if nargout
              result = feval(func,varargin{3:end});
          else
              feval(func,varargin{3:end});
          end
      %end
  end
  

%{ 
% TODO:
% =====
% - Handle Multi-KeyStroke bindings as in Alt-U U (Text / Uppercase)
% - Support native actions in EditorMacro(BINDINGSLIST) bulk mode of operation
% - Fix docking/menu limitations
% - GUI interface (list of actions, list of keybindings
%}