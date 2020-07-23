classdef (Abstract) Algorithm < handle
    %ALGORITHM BaseClass
    
    properties
        costFunc % CEC14 function object
        
        popSize % Population size
        iter % Current iteration
        maxIter % Max iterations
        seed % Random seed
        
        evalCount % Count of cost function called
        convergenceVal % Convergence values for each iteration
    end
    
    methods
        function obj = Algorithm(costFunc,popSize,maxIter,seed)
            if nargin == 0
                % Default param
                costFunc = CEC14Func(1);
                popSize = 30;
                maxIter = 200;
                seed = 1;
            end
            obj.costFunc = costFunc;
            obj.popSize = popSize;
            obj.iter = 1;
            obj.maxIter = maxIter;
            obj.seed = seed;
            obj.evalCount = 0;
            obj.convergenceVal = zeros(1,obj.maxIter);
            
            % Create a pseudorandom number generator for reproducibility
            s = RandStream('mt19937ar','Seed',obj.seed);
            RandStream.setGlobalStream(s);
        end
    end
    methods (Access = protected)
        % Cost function evaluation
        function fitness = eval(obj, position)
            obj.evalCount = obj.evalCount + size(position,1);
            fitness = obj.costFunc.eval(position);
        end
        % Initial population
        function position = initialPopulation(obj)
            position = obj.costFunc.lb + (obj.costFunc.ub-obj.costFunc.lb) .* rand(obj.popSize,obj.costFunc.dim);
        end
        % Boundary constraints for outlier
        function position = boundaryConstraints(obj,position)
            tempUB = repmat(obj.costFunc.ub,obj.popSize,1);
            tempLB = repmat(obj.costFunc.lb,obj.popSize,1);
            flag4UB = position > tempUB;
            flag4LB = position < tempLB;
            position = (position.*(~(flag4UB+flag4LB))) + tempUB.*flag4UB + tempLB.*flag4LB;
        end
    end
    methods (Abstract)
        % Entrypoint of algorithm
        [bestSol,bestVal] = run(obj)
    end
    
end

