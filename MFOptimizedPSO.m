classdef MFOptimizedPSO < MFOptimizedNIO
    %OPTIMIZEDPSO Optimized optimizer - PSO
    
    properties
    end
    
    methods
        function obj = MFOptimizedPSO(varargin)
            obj = obj@MFOptimizedNIO(varargin{:});
            % Params tuning setup
            obj.lb = [0, 0, 0, 0];
            obj.ub = [1, 10, 10, 20];
            obj.dim = 4;
        end
        function [optSol, optVal] = getOptimum(obj)
            optSol = [0.7, 2.0, 2.0, 4.0];
            [~,optVal] = obj.costFunc.getOptimum();
        end
        function fitness = eval(obj, params)
            n = size(params,1); % population size
            fitness = zeros(1,n); % init fit
            maxIter = obj.fidelity * obj.scale; % scale fidelity as max iterations
            for i = 1:n
                % run pso to optimize cost function with specified params
                pso = PSO(params(i,1),params(i,2),params(i,3),params(i,4),-params(i,4),...
                    obj.costFunc,obj.popSize,maxIter,obj.seed);
                [~,fitness(i)] = pso.run();
                % accumulate evaluation count of cost function
                obj.evalCount = obj.evalCount + pso.evalCount;
            end
        end
    end
    
end

