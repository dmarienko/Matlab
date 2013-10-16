function z = join2matrix(x,y)
    %JOIN2MATRIX Join 2 matrix using 1sts rows as a key
    %   
    % x = [1 2 3 4 6; 11 12 13 14 16; ];
    % y = [3 6 7;     23 26 27;       ];
    % z = join2matrix(x, y)
    % z =
    %
    %      1     2     3     4     6     7
    %     11    12    13    14    16    16
    %    NaN   NaN    23    23    26    27
    z(1,:) = union(x(1,:), y(1,:));
    z(2:3,:) = nan(2, size(z,2));
    
    [~, ~, ib] = intersect(x(1,:), z(1,:));
    z(2, ib) = x(2,:);

    [~, ~, ib] = intersect(y(1,:), z(1,:));
    z(3, ib) = y(2,:);
    
    z(2,:) = propagateNans(z(2,:));
    z(3,:) = propagateNans(z(3,:));
end

function v = propagateNans(vi)
    vo = vi;
    in = find(isnan(vi));
    for i = in,
        if i > 1, vo(i) = vo(i-1); end
    end
    v = vo;
end

