classdef PSO < Algorithm
    %PSO Particle Swarm Optimization
    
    properties
        c1 % cognitive component
        c2 % social component
        w % inertia weight
        vMax % maximal velocity
        vMin % minimal velocity
    end
    
    methods
        function obj = PSO(w,c1,c2,vMax,vMin,varargin)
            if nargin == 0
                w = 0.7;
                c1 = 2.0;
                c2 = 2.0;
                vMax = 4;
                vMin = -4;
            end
            
            obj = obj@Algorithm(varargin{:});
            
            obj.w = w;
            obj.c1 = c1;
            obj.c2 = c2;
            obj.vMax = vMax;
            obj.vMin = vMin;
        end
        function [bestSol,bestVal] = run(obj)
            % Initial
            particlePos = obj.initialPopulation();
            particleFit = obj.eval(particlePos);
            [preBestPos,preBestFit] = deal(particlePos,particleFit);
            [gBestFit, iBest] = min(particleFit);
            gBestPos = particlePos(iBest,:);
            velocity = zeros(obj.popSize,obj.costFunc.dim);
            
            % Main loop
            obj.iter = 1;
            obj.convergenceVal(obj.iter) = gBestFit; % Initial cost function value(CFV)
            while obj.iter < obj.maxIter
                obj.iter = obj.iter + 1;
                % Update previous best
                flag4Pre = preBestFit < particleFit;
                preBestFit = flag4Pre.*preBestFit + ~flag4Pre.*particleFit;
                preBestPos = flag4Pre.*preBestPos + ~flag4Pre.*particlePos;
                
                % Update velocity
                velocity = obj.w.*velocity + obj.c1.*rand(obj.popSize,obj.costFunc.dim).*(preBestPos-particlePos) ...
                    + obj.c2.*rand(obj.popSize,obj.costFunc.dim).*(gBestPos-particlePos);
                % Boundary constrains for velocity
                velocity = (velocity>obj.vMax).*obj.vMax + (velocity<=obj.vMax).*velocity;
                velocity = (velocity<obj.vMin).*obj.vMin + (velocity>=obj.vMin).*velocity;
                
                % Update population
                particlePos = particlePos + velocity;
                particlePos = obj.boundaryConstraints(particlePos);
                particleFit = obj.eval(particlePos);
                
                % Update global best
                [bestFit, iBest] = min(particleFit);
                if gBestFit>bestFit
                    [gBestPos,gBestFit] = deal(particlePos(iBest,:),bestFit);
                end
                
                % Save convergence value
                obj.convergenceVal(obj.iter) = gBestFit;
            end
            [bestSol,bestVal] = deal(gBestPos,gBestFit);
        end
    end
    
end

