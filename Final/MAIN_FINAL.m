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
Q0 = [pi/4, pi/4, pi/4, pi/4, pi/4, pi/4];
% Q0 = [0,-.5, 0, 1, 1, .75];
w = 1;     % Frequency

% INVERSE DYNAMICS
clear Q Qd

paramNameValStruct.StopTime = '4*pi';
paramNameValStruct.SrcWorkspace = 'current';

Lambda  = 5*eye(3);
% K       = 10*eye(3);
K       = diag([10 30 10]);
eps     = .1;
rho     = 10;
TH0     = TH;
Gamma   = 5*eye(27); 

% simOut = sim('sim_WAM_InverseDynamics', paramNameValStruct);
% simOut = sim('sim_WAM_PBRCDynamics', paramNameValStruct);
% simOut = sim('sim_WAM_PBACDynamics', paramNameValStruct);
simOut = sim('sim_WAM_PBMCDynamics', paramNameValStruct);

handles.pax(1) = subplot(231); hold on; box on;
handles.pax(2) = subplot(232); hold on; box on;
handles.pax(3) = subplot(233); hold on; box on;
handles.pax(4) = subplot(234); hold on; box on;
handles.pax(5) = subplot(235); hold on; box on;
handles.pax(6) = subplot(236); hold on; box on;
% handles.pax(7) = subplot(237); hold on; box on;
% handles.pax(8) = subplot(238); hold on; box on;
% handles.pax(9) = subplot(239); hold on; box on;

plotStates(simOut.t,simOut.Qd, handles.pax);
plotStates(simOut.t,simOut.Q, handles.pax);

