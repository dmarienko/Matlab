function GiveFocusEditor()
    desktop = com.mathworks.mde.desk.MLDesktop.getInstance;
    eds = desktop.getGroupMembers('Editor');
    for i = 1 : eds.length; eds(i).requestFocus(); end
end

