classdef CEC14Func < handle
    %CEC14 Function
    
    properties (Access = private)
        fh = str2func('cec14_func'); % CEC14 function handler
        fn = 1; % Function number
    end
    
    properties
        lb = -100; % Lower bound
        ub = 100; % Upper bound
        dim = 2; % Dimension [2, 10, 30, 50, 100]
    end
    
    methods
        function obj = CEC14Func(funcNum,lb,ub,dim)
            if nargin == 0
                % Default param
                funcNum = 1;
                lb = -100;
                ub = 100;
                dim = 2;
            end
            obj.fn = funcNum;
            obj.lb = lb;
            obj.ub = ub;
            obj.dim = dim;
        end
        % Cost function evaluation
        function f = eval(obj,pos)
            f = obj.fh(pos',obj.fn)';
        end
        % Get optimum solution and value
        function [optSol, optVal] = getOptimum(obj)
            optSol = load(['input_data/shift_data_', int2str(obj.fn), '.txt']);
            optSol = optSol(1:obj.dim);
            optVal = 100 * obj.fn;
        end
    end
    
end

