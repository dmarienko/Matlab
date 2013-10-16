classdef Position < handle
    %POSITION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        position = 0
        rPnl = 0
        avgPrice = NaN
    end
    
    methods
        function a = calcAveragedPrice(this, dealPrice, posChange)
            if isnan(this.avgPrice)
                this.avgPrice = dealPrice;
            end
    
            div = this.position + posChange;
            if div == 0
                a = this.avgPrice;
            else
                a = (this.avgPrice * this.position + dealPrice * posChange) / div;
            end
        end
        
        function profit = changePosition(this, dealPrice, newPosition)
            changeSize = newPosition - this.position;
            profit = 0;
    
            % need to handle position reversing - position changes signum
            if newPosition ~= 0 && this.position ~= 0 && sign(newPosition) ~= sign(this.position)
                % liquidate old position -> 0
                profit = this.changePosition(dealPrice, 0) ...
                    + this.changePosition(dealPrice, newPosition); % create new position from 0
                return
            end

            % position grows
            if abs(newPosition) > abs(this.position)
                this.avgPrice = this.calcAveragedPrice(dealPrice, changeSize);
            end

            % position decreases
            if abs(newPosition) < abs(this.position)
                profit = sign(this.position) * (dealPrice - this.avgPrice) * abs(changeSize);
                this.rPnl = this.rPnl + profit;
            end

            % set new position
            this.position = newPosition;

            % if postion becames 0 forget average price
            if newPosition == 0
                this.avgPrice = NaN;
            end
        end
    end
   
end

