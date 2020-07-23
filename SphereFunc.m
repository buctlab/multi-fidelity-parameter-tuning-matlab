classdef SphereFunc < handle
    %Sphere Function
    
    properties
        lb = -5.12; % Lower bound
        ub = 5.12; % Upper bound
        dim = 2; % Dimension [2, 10, 30, 50, 100]
    end
    
    methods
        function obj = SphereFunc(lb,ub,dim)
            if nargin == 0
                % Default param
                lb = -5.12;
                ub = 5.12;
                dim = 2;
            end
            obj.lb = lb;
            obj.ub = ub;
            obj.dim = dim;
        end
        % Cost function evaluation
        function f = eval(~,pos)
            f = sum(power(pos,2),2);
        end
        % Get optimum solution and value
        function [optSol, optVal] = getOptimum(obj)
            [optSol, optVal] = deal(zeros(1,obj.dim),0);
        end
    end
    
end

