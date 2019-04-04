function [bbo] = Init(DisplayFlag, ProblemFunction, bbo, RandSeed)
% Initialize population-based optimization software.
if ~exist('RandSeed', 'var')
    RandSeed = round(sum(100*clock));
end
rand('state', RandSeed); % initialize random number generator
if DisplayFlag
    disp(['random # seed = ', num2str(RandSeed)]);
end
OPTIONS = bbo.OPTIONS;

% Get the addresses of the initialization, cost, and feasibility functions.
% [InitFunction, CostFunction] = ProblemFunction();
bbo = ProblemFunction();
InitFunction = bbo.InitFunction;
CostFunction = bbo.CostFunction;

% Initialize the population.
% [MaxParValue, MinParValue, Population, OPTIONS] = InitFunction(OPTIONS);
bbo = InitFunction(bbo);
MaxParValue = bbo.MaxParValue;
MinParValue = bbo.MinParValue;
Population = bbo.Population;
OPTIONS = bbo.OPTIONS;

% Compute cost of each individual  
%Population = CostFunction(Population);
bbo = CostFunction(bbo);

% Sort the population from most fit to least fit
% Population = PopSort(Population);
bbo = PopSort(bbo);
Population = bbo.Population;

% Display info to screen
MinCost = zeros(OPTIONS.Maxgen, 1);
AvgCost = zeros(OPTIONS.Maxgen, 1);
MinCost(1) = Population(1).cost;
AvgCost(1) = mean([Population.cost]);
if DisplayFlag
    disp(['The best and mean of Generation # 0 are ', num2str(MinCost(1)), ' and ', num2str(AvgCost(1))]);
end

bbo.MinCost         = MinCost;
bbo.AvgCost         = AvgCost;
bbo.CostFunction    = CostFunction;
bbo.MaxParValue     = MaxParValue;
bbo.MinParValue     = MinParValue;
bbo.Population      = Population;
bbo.OPTIONS         = OPTIONS;
return