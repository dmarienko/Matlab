function s3 = joinsignals(s1, s2)
    % s3 = joinsignals(s1, s2) join 2 signals matrices
    %
    % Example:
    % -----------
    % s1 = [1 10 -10; 2 20 -20; 3 30 -30; 6 60 -60;  7 70 -70;]; 
    % s2 = [1 100 -100; 2 200 -200; 5 500 -500; 8 800 -800;];
    % joinsignals(s1,s2)
    %
    % ans =
    %
    %      1    10   -10   100  -100
    %      2    20   -20   200  -200
    %      3    30   -30   NaN   NaN
    %      5   NaN   NaN   500  -500
    %      6    60   -60   NaN   NaN
    %      7    70   -70   NaN   NaN
    %      8   NaN   NaN   800  -800
    if isempty(s1)
        s3 = s2;
    elseif isempty(s2)
        s3 = s1;
    else
        tms = union(s1(:,1), s2(:,1));
        s3 = [tms NaN(size(tms,1), size(s1,2)+size(s2,2)-2)];
        
        for t = tms'
            p1 = s1(s1(:,1)==t, 2:end);
            if isempty(p1), p1 = NaN(1, size(s1,2)-1); end
            p2 = s2(s2(:,1)==t, 2:end);
            if isempty(p2), p2 = NaN(1, size(s2,2)-1); end
            s3(s3(:,1)==t, 2:end) = [p1 p2];
        end
    end
end