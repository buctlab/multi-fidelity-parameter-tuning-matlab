classdef GWO < Algorithm
    %GWO Grey Wolf Optimizer
    
    properties
    end
    
    methods
        function obj = GWO(varargin)
            obj = obj@Algorithm(varargin{:});
        end
        function [bestSol,bestVal] = run(obj)
            % Initial
            wolfPos = obj.initialPopulation();
            wolfFit = obj.eval(wolfPos);
            % Dominant wolves: alpha, beta, delta
            [sortedWolfFit,iSortedWolfFit] = sort(wolfFit);
            [alphaPos,alphaFit] = deal(wolfPos(iSortedWolfFit(1),:),sortedWolfFit(1));
            [betaPos,betaFit] = deal(wolfPos(iSortedWolfFit(2),:),sortedWolfFit(2));
            [deltaPos,deltaFit] = deal(wolfPos(iSortedWolfFit(3),:),sortedWolfFit(3));
            
            % Main loop
            obj.iter = 1;
            obj.convergenceVal(obj.iter) = alphaFit; % Initial cost function value(CFV)
            while obj.iter < obj.maxIter
                obj.iter = obj.iter + 1;
                % Update population
                a = 2 - obj.iter * (2 / obj.maxIter); % a decreases linearly fron 2 to 0
                
                [r1,r2] = deal(rand(obj.popSize,obj.costFunc.dim), rand(obj.popSize,obj.costFunc.dim));
                a1 = 2 * a .* r1 - a;
                c1 = 2 .* r2;
                dAlpha = abs(c1 .* alphaPos - wolfPos);
                x1 = alphaPos - a1 .* dAlpha;
                
                [r1,r2] = deal(rand(obj.popSize,obj.costFunc.dim), rand(obj.popSize,obj.costFunc.dim));
                a2 = 2 * a .* r1 - a;
                c2 = 2 .* r2;
                dBeta = abs(c2 .* betaPos - wolfPos);
                x2 = betaPos - a2 .* dBeta;
                
                [r1,r2] = deal(rand(obj.popSize,obj.costFunc.dim), rand(obj.popSize,obj.costFunc.dim));
                a3 = 2 * a .* r1 - a;
                c3 = 2 .* r2;
                dDelta = abs(c3 .* deltaPos - wolfPos);
                x3 = deltaPos - a3 .* dDelta;
                
                wolfPos = (x1 + x2 + x3) / 3;
                wolfPos = obj.boundaryConstraints(wolfPos);
                wolfFit = obj.eval(wolfPos);
                
                % Update dominant wolves
                [~,iSortedWolfFit] = sort(wolfFit);
                for i = 1:3
                    idx = iSortedWolfFit(i);
                    if wolfFit(idx) < alphaFit
                        [alphaPos,alphaFit] = deal(wolfPos(idx,:),wolfFit(idx));
                    end
                    if wolfFit(idx) > alphaFit && wolfFit(idx) < betaFit
                        [betaPos,betaFit] = deal(wolfPos(idx,:),wolfFit(idx));
                    end
                    if wolfFit(idx) > betaFit && wolfFit(idx) < deltaFit
                        [deltaPos,deltaFit] = deal(wolfPos(idx,:),wolfFit(idx));
                    end
                end
                
                % Save convergence value
                obj.convergenceVal(obj.iter) = alphaFit;
            end
            
            [bestSol,bestVal] = deal(alphaPos,alphaFit);
        end
    end
    
end

