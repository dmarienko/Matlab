function Matlab_Coloring(obj, event, string_arg)
    % Adjust command Command Window
    try
        cw = com.mathworks.mde.desk.MLDesktop.getInstance.getClient('Command Window');
        xCmdWndView = cw.getComponent(0).getViewport.getComponent(0);
        xCmdWndView.setForeground(java.awt.Color(0.2,0.6,0.2))
        f0 = xCmdWndView.getFont; xCmdWndView.setFont(java.awt.Font(f0.getName,java.awt.Font.BOLD, f0.getSize));

        % Adjust workspace
        cw = com.mathworks.mde.desk.MLDesktop.getInstance.getClient('Workspace');
        xCmdWndView = cw.getComponent(0).getViewport.getComponent(0);
        f0 = xCmdWndView.getFont; xCmdWndView.setFont(java.awt.Font(f0.getName,java.awt.Font.BOLD, f0.getSize));
        xCmdWndView.setForeground(java.awt.Color(0.8,0.5,0.1));
        
        % Adjust command history
        cw = com.mathworks.mde.desk.MLDesktop.getInstance.getClient('Command History');
        if ~isempty(cw)
            xCmdWndView = cw.getComponent(0).getViewport.getComponent(0);
            f0 = xCmdWndView.getFont; xCmdWndView.setFont(java.awt.Font(f0.getName,java.awt.Font.BOLD, f0.getSize));
        end
    
        % Adjust current folder
        cw = com.mathworks.mde.desk.MLDesktop.getInstance.getClient('Current Folder');
        %if isempty(cw) 
        %    com.mathworks.mde.explorer.Explorer.invoke();
        %    cw = com.mathworks.mde.explorer.Explorer.getInstance(); 
        %end
        if ~isempty(cw) 
            xCmdWndView = cw.getComponent(1).getComponent(1).getComponent(0).getComponent(0);
            f0 = xCmdWndView.getFont; xCmdWndView.setFont(java.awt.Font(f0.getName,java.awt.Font.BOLD, f0.getSize));
            xCmdWndView.setForeground(java.awt.Color(0.1,0.5,0.8));
        end
    catch e
        warning(getReport(e))
    end

    Matlab_extendEditorFunctionality(true);

    try
        EditorMacro('Escape', @GiveFocusEditor, 'run');
        EditorMacro('Alt v', 'select-word', 'run');
    catch
    end
    
    FE;
end
