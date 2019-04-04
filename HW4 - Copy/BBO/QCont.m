function bbo = QCont(bbo)

    bbo.InitFunction = @initializeQ;
    bbo.CostFunction = @QCost;
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [bbo] = initializeQ(bbo)
% Initialize Population
    % Run parameters
    BBOparameters
    OPTIONS = bbo.OPTIONS;
    
    % Only optimizating alpha for while
    MinParValue = bbo.MinParValue;
    MaxParValue = bbo.MaxParValue;
    
    % Initialize population
    for popindex = 1 : OPTIONS.popsize
        chrom = MinParValue + (MaxParValue - MinParValue) .* rand(1,OPTIONS.numVar);
        bbo.Population(popindex).chrom = chrom;
    end
    bbo.OPTIONS.OrderDependent = true;
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out] = QCost(varargin)
% Compute the cost of each member in Population
   
    bbo = varargin{1};
    switch(length(varargin))
        case 1        
            Population = bbo.Population;   
        case 2
            Population = varargin{2};
    end

    
    p = length(Population(1).chrom);
    for popindex = 1 : length(Population)
        Population(popindex).cost = 0;
%         for i = 1 : p-1
%             X = Population(popindex).chrom(i);
            X(1) = Population(popindex).chrom(1);
            X(2) = Population(popindex).chrom(2);
            X(3) = X(2);
            X(4) = Population(popindex).chrom(3);
            [bbo, out] = cost_function (X, bbo);
            Population(popindex).cost = out;
%         end
    end
    bbo.Population = Population;
    
%     switch(length(varargin))
%         case 1
            out = bbo;
%         case 2
%             out = bbo.Population;
%     end
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [bbo, out] = cost_function (Z,bbo)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    Acl = bbo.OPTIONS.Acl;
    xeq = bbo.OPTIONS.xeq;
    ieq = bbo.OPTIONS.ieq;
    m = bbo.OPTIONS.m;    
    g = bbo.OPTIONS.g;    
    k = bbo.OPTIONS.k;    
    K = bbo.OPTIONS.K;    
    out = Inf;
    Q = reshape(Z, 2,2);
    try 
        P = lyap(Acl',Q);
        eigQ = eig(Q);
        if (find(eigQ<0))
            out = Inf;
            return;
        end
    catch
        out = Inf;
        return
    end

    syms x1 x2
    V = 0.5*[(x1-xeq) x2]*P*[(x1-xeq); x2];
    V_sym = matlabFunction(V, 'vars', [x1,x2]);

    u = ieq - K*[x1-xeq; x2];
    x1d = x2;
    x2d = (m*g-k.*u^2/2/x1^2)/m;

    Vdot = diff(V,x1)*x1d + diff(V,x2)*x2d;
    Vdot_sym = matlabFunction(Vdot, 'vars', [x1,x2]);

    % [x1, x2] = meshgrid(0:1e-4:.014, -.1:1e-2:.1);
    [x1, x2] = meshgrid(0:1e-3:.14, -.1:1e-2:.1);
    V = V_sym(x1, x2);
    Vdot = Vdot_sym(x1, x2);

    P1 = [];
    P2 = [];
    for r = 0:1e-3:.14
        for th = 0:.01:2*pi,
            x1 = r*cos(th)+6e-3;
            x2 = r*sin(th);  %absolute coords
            vdot = Vdot_sym(x1,x2);
            if vdot > 0
                fbreak  = 1;
                break;
            else
                fbreak = 0;
            end
        end
        out = 1/r;
        bbo.out.cost = out;
        if fbreak == 1
            break;
        end
    end    
return
