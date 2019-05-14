% Erivelton Gualter dos Santos
%
% Homeword 6

% clear all
close all
clc

% Get terms

if ~exist('Mfcn', 'var')
    [M, C, G, F, TH, Y] = getWAMParameters();
    [Mfcn, Cfcn, Gfcn, Ffcn, Yfcn, Yavfcn, TH] = convertSymVarsTOfunctions(M, C, G, F, TH);
end
                                            
% Initial conditions
handles.Q0 = [pi/4, pi/4, pi/4, pi/4, pi/4, pi/4];
% handles.Q0 = [0,-.5, 0, 1, 1, .75];
w = 1;     % Frequency

% INVERSE DYNAMICS
clear Q Qd

paramNameValStruct.StopTime = '4*pi';
paramNameValStruct.SrcWorkspace = 'current';

Lambda  = diag([1 1 1]);
K       = diag([1 1 1]);
eps     = .1;
rho     = 2;
TH0     = TH;
Gamma   = 5*eye(27); 

handles.select = 1;

% simOut = sim('sim_WAM_InverseDynamics', paramNameValStruct);

% handles.LevelPer = .2;
% lvl = 2*handles.LevelPer*rand(27,1) - handles.LevelPer + 1;
%             [Mfcn, Cfcn, Gfcn, Ffcn, Yfcn, Yavfcn, TH] = ...
%                 convertSymVarsTOfunctions(M, C, G, F, TH.*lvl);
        
            
% simOut = sim('sim_WAM_PBRCDynamics', paramNameValStruct);
simOut = sim('sim_WAM_PBACDynamics', paramNameValStruct);
% simOut = sim('sim_WAM_PBMCDynamics', paramNameValStruct);

handles.pax(1) = subplot(331); hold on; box on;
handles.pax(2) = subplot(332); hold on; box on;
handles.pax(3) = subplot(333); hold on; box on;
handles.pax(4) = subplot(334); hold on; box on;
handles.pax(5) = subplot(335); hold on; box on;
handles.pax(6) = subplot(336); hold on; box on;
handles.pax(7) = subplot(337); hold on; box on;
handles.pax(8) = subplot(338); hold on; box on;
handles.pax(9) = subplot(339); hold on; box on;

plotStates(simOut.t,simOut.Qd, handles.pax, simOut.Tau);
plotStates(simOut.t,simOut.Q, handles.pax, simOut.Tau);

