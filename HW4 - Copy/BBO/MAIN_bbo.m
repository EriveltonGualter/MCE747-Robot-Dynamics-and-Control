% Erivelton Gualter


addpath('BBO');

BBOparameters
    
% Initial PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic;
[MinCost] = BBO(@QCont, bbo);
duration = toc;

% bestAlpha1 = 0.58336;
% bestAlpha2 = 0.60647;

