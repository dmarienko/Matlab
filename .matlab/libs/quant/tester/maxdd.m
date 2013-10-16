function [ ddRel, ddStart, ddEnd ] = maxdd( data )
% Calculates the maximum relative drawdown of time-series data.
%
% [ ddRel, ddStart, ddEnd ] = maxdd( data )
%
% INPUTS:
% data...  time-series vector
%
% OUTPUTS:
% ddRel   ... Maximum drawdown (relative)
% ddStart ... Start index of maximum drawdown phase
% ddEnd   ... End index of maximum drawdown phase
%
% Andreas Bonelli, August 2007
% andreas.bonelli@gmail.com

mymax = -inf;
ddRel = 0;

for j = 1:length(data)
    if data(j) > mymax
        mymax = data(j);
        lastmax = j;
    end
    dd = 1-(data(j)/mymax);
    if dd > ddRel
        ddRel = dd;
        ddStart = lastmax;
        ddEnd = j;
    end
end
