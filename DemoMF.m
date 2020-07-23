% Use Meta-GWO to optimize Optimized-PSO with Optimized-problem(CEC14 F1):
% Non-MF vs Sigmoid-MF
%% Clean Workspace
clear;
clc;
%% Parameter Tuning
% costFunc = CEC14Func(1,-100,100,20); % CEC14 F1, lower=-100, upper=100, dimension=20
costFunc = SphereFunc(-5.12,5.12,50); % Sphere Func, lower=-5.12, upper=5.12, dimension=50

optdPopSize = 30; % Population size (Optimized NIO)
optdSeed = 0; % Random seed (Optimized NIO)
optdMaxFidelity = 10; % Max fidelity level preset (Optimized NIO)
optdScale = 10; % Scale for max iteration (Optimized NIO)

metaPopSize = 30; % Population size (Meta NIO)
metaMaxIter = 100; % Max iteration (Meta NIO)
metaSeed = 0; % Random seed (Meta NIO)

% #Example 1: Non-MF
disp('----- Meta-GWO Non-MF BEGIN -----');
tic;
optdFCF = 'Fixed'; % Fidelity control function (Optimized NIO)
nonMFOptimizedPSO = MFOptimizedPSO(costFunc,optdPopSize,optdSeed,...
    optdMaxFidelity,optdScale,optdFCF); % Create Non-MF Optimized-PSO obj
nonMFMetaGWO = MFMetaGWO(nonMFOptimizedPSO,metaPopSize,metaMaxIter,metaSeed); % Create Non-MF Meta-GWO obj
[nonMFBestSol,nonMFBestVal]= nonMFMetaGWO.run(); % Run Non-MF meta optimization
nonMFEvalCount = nonMFMetaGWO.costFunc.evalCount; % Total evaluation count of cost function(CEC14 F1)
nonMFCvgCurve = nonMFMetaGWO.convergenceVal; % Convergence of cost function value(CFV)
nonMFElapsedTime = toc;
disp(['Elapsed time is ' num2str(nonMFElapsedTime) ' seconds.']);
% Plot convergence curve
figure(1);
plot(nonMFCvgCurve);
title('Meta-GWO Optimize Optimized-PSO(Non-MF)');
xlabel('Generation');
% Disp result
disp(['Eval Count: ' num2str(nonMFEvalCount)]);
disp('Meta-GWO Optimized:');
disp(['Best Parameters: ' mat2str(nonMFBestSol)]);
disp(['Best Value(CFV): ' num2str(nonMFBestVal)]);
disp('----- Meta-GWO Non-MF END -----');
disp(' ');

% #Example 2: Sigmoid-MF
disp('----- Meta-GWO Sigmoid-MF BEGIN -----');
tic;
optdFCF = 'Sigmoid'; % Fidelity control function (Optimized NIO)
sigMFOptimizedPSO = MFOptimizedPSO(costFunc,optdPopSize,optdSeed,...
    optdMaxFidelity,optdScale,optdFCF);
sigMFMetaGWO = MFMetaGWO(sigMFOptimizedPSO,metaPopSize,metaMaxIter,metaSeed);
[sigMFBestSol,sigMFBestVal]= sigMFMetaGWO.run();
sigMFEvalCount = sigMFMetaGWO.costFunc.evalCount;
sigMFCvgCurve = sigMFMetaGWO.convergenceVal;
sigMFElapsedTime = toc;
disp(['Elapsed time is ' num2str(sigMFElapsedTime) ' seconds.']);
% Plot convergence curve
figure(2);
plot(sigMFCvgCurve);
title('Meta-GWO Optimize Optimized-PSO(Sigmoid-MF)');
xlabel('Generation');
% Disp result
disp(['Eval Count: ' num2str(sigMFEvalCount)]);
disp('Meta-GWO Optimized:');
disp(['Best Parameters: ' mat2str(sigMFBestSol)]);
disp(['Best Value(CFV): ' num2str(sigMFBestVal)]);
disp('----- Meta-GWO Sigmoid-MF END -----');
disp(' ');

%% Evaluation Count of Cost Function
disp('----- Experimental statistics: Evaluation Count -----');
disp(['Non-MF:     ' num2str(nonMFEvalCount)]);
disp(['Sigmoid-MF: ' num2str(sigMFEvalCount)]);
disp(' ');

%% Time Cost
disp('----- Experimental statistics: Time Cost (second) -----');
disp(['Non-MF:     ' num2str(nonMFElapsedTime)]);
disp(['Sigmoid-MF: ' num2str(sigMFElapsedTime)]);
disp(' ');

%% Parameter Evaluation
% #Evaluate Parameters: Convergence Curve
disp('----- Evaluate Parameters: Convergence Curve -----');
maxIter = 100; % optdMaxFidelity * optdScale
% ##Recommended params(Default params)
recParams = {0.7,2.0,2.0,4,-4};
recParamPSO = PSO(recParams{:},costFunc,optdPopSize,maxIter,optdSeed);
recParamPSO.run();
recParamPSOCvgCurve = recParamPSO.convergenceVal;
% ##Clerc params
clercParams = {0.7298,1.49618,1.49618,100,-100};
clercParamPSO = PSO(clercParams{:},costFunc,optdPopSize,maxIter,optdSeed);
clercParamPSO.run();
clercParamPSOCvgCurve = clercParamPSO.convergenceVal;
% ##Non-MF
nonMFParams = num2cell(nonMFBestSol);
nonMFParams{5} = -nonMFParams{4};
nonMFParamPSO = PSO(nonMFParams{:},costFunc,optdPopSize,maxIter,optdSeed);
nonMFParamPSO.run();
nonMFParamPSOCvgCurve = nonMFParamPSO.convergenceVal;
% ##Sigmoid-MF
sigMFParams = num2cell(sigMFBestSol);
sigMFParams{5} = -sigMFParams{4};
sigMFParamPSO = PSO(sigMFParams{:},costFunc,optdPopSize,maxIter,optdSeed);
sigMFParamPSO.run();
sigMFParamPSOCvgCurve = sigMFParamPSO.convergenceVal;

figure(3);
x = 1:maxIter;
plot(x,recParamPSOCvgCurve,x,clercParamPSOCvgCurve,x,nonMFParamPSOCvgCurve,x,sigMFParamPSOCvgCurve);
title('Convergence Curve');
xlabel('Generation');
ylabel('CFV');
legend('Recommended','Clerc','Non-MF','Sigmoid-MF');
disp(' ');

% #Evaluate Parameters: Multiple Runs
disp('----- Evaluate Parameters: Multiple Runs -----');
runs = 30;

varNames = {'Recommended','Clerc','Non_MF','Sigmoid_MF'};
pso30RunsCFV = table(zeros(runs,1),zeros(runs,1),zeros(runs,1),zeros(runs,1),...
    'VariableNames',varNames,'RowNames',cellstr(string(1:runs))); % Save best CFV of every run and every 
for i = 1:runs
    % Calculate
    seed = i;
    recParamPSO = PSO(recParams{:},costFunc,optdPopSize,maxIter,seed); % Recommended params
    [~,pso30RunsCFV.Recommended(i)] = recParamPSO.run();
    clercParamPSO = PSO(clercParams{:},costFunc,optdPopSize,maxIter,seed); % Clerc params
    [~,pso30RunsCFV.Clerc(i)] = clercParamPSO.run();
    nonMFParamPSO = PSO(nonMFParams{:},costFunc,optdPopSize,maxIter,seed); % Meta-GWO(Non-MF) optimized params
    [~,pso30RunsCFV.Non_MF(i)] = nonMFParamPSO.run();
    sigMFParamPSO = PSO(sigMFParams{:},costFunc,optdPopSize,maxIter,seed); % Meta-GWO(Sigmoid-MF) optimized params
    [~,pso30RunsCFV.Sigmoid_MF(i)] = sigMFParamPSO.run();
end

figure(4);
boxplot([pso30RunsCFV.Recommended, pso30RunsCFV.Clerc, pso30RunsCFV.Non_MF, pso30RunsCFV.Sigmoid_MF], 'Labels', {'Recommended','Clerc','Non-MF','Sigmoid-MF'});
title('Multiple Runs');
xlabel('FCF');
ylabel('CFV');
disp(' ');
