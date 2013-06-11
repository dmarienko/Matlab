function jh = jHash(s)
    %JHASH returns Java hash code for string
    %
    jh = double(java.lang.String(s).hashCode());
end

