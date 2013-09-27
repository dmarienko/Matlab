disp('Saving workspace ...')
PWD = pwd(); 
try
    save ~/workspace.mat '*' 'PWD';
catch err
end