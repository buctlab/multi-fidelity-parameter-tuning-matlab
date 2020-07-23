classdef (Abstract) MFOptimizedNIO < handle
    %MFOPTIMIZEDNIO BaseClass
    %   Multi-fidelity optimized NIO
    
    properties
        % Parameters tuning properties
        lb % Lower bound array of params
        ub % Upper bound array of params
        dim % Dimension: count of params
        
        % Basic properties
        costFunc % Optimized problem
        popSize % Population size
        seed % Pseudorandom number generator seed
        
        evalCount % Evaluation counts of cost function
        
        % Multi-fidelity properties
        fidelity % Current fidelity level
        maxFidelity % Max fidelity preset
        scale % Scale for calculate maxIter: maxIter = obj.fidelity * obj.scale
        fcf FidelityControlFunction % Fidelity control function (FCF)
        fidelityUpdate % Fidelity update handler using specified fidelity control function (FCF)
    end
    
    methods
        function obj = MFOptimizedNIO(costFunc,popSize,seed,...
                maxFidelity,scale,fcf)
            % Basic params initial
            obj.costFunc = costFunc;
            obj.popSize = popSize;
            obj.seed = seed;
            obj.evalCount = 0;
            
            % MF params initial
            obj.fidelity = maxFidelity; % init to max fidelity level
            obj.maxFidelity = maxFidelity;
            obj.scale = scale;
            obj.fcf = fcf;
            obj.fidelityUpdate = str2func(['fidelity',char(obj.fcf)]);
        end
    end
    methods (Access = protected)
        % Fidelity control function (FCF)
        % Fixed (for Non-MF test)
        function fidelityFixed(obj,varargin)
            obj.fidelity = obj.maxFidelity;
        end
        % FCF - Linear
        function fidelityLinear(obj,iter,maxIter)
            x = iter / maxIter;
            obj.fidelity = ceil(x * obj.maxFidelity);
        end
        % FCF - Sigmoid
        function fidelitySigmoid(obj,iter,maxIter)
            x = 10 * iter / maxIter - 5;
            obj.fidelity = ceil(1 / (1 + exp(-x)) * obj.maxFidelity);
        end
        % FCF - Sin
        function fidelitySin(obj,iter,maxIter)
            x = iter / maxIter * pi / 2;
            obj.fidelity = ceil(sin(x) * obj.maxFidelity);
        end
        % FCF - Power
        function fidelityPower(obj,iter,maxIter)
            x = iter / maxIter;
            obj.fidelity = ceil(sin(x) * obj.maxFidelity);
        end
    end
    methods (Abstract)
        % Get default params of Optimized-NIO and optimum value of Optimized-problem
        [optSol, optVal] = getOptimum(obj)
        % Use meta optimized params to run Optimized-NIO and get best value of Optimized-problem
        fitness = eval(obj,params)
    end
    
end

