function FE
    try
        EditorMacro('Escape', @GiveFocusEditor, 'run');
        EditorMacro('Alt v', 'select-word', 'run');
    catch
    end
end