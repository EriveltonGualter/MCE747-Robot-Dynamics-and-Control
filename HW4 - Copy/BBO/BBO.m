function [MinCost] = BBO(ProblemFunction, bbo, DisplayFlag, RandSeed)

% Biogeography-based optimization (BBO) software for minimizing a continuous function
% INPUTS:  ProblemFunction = the handle of the function that returns the handles of the initialization and cost functions.
%          DisplayFlag = true or false, whether or not to display and plot results.
%          RandSeed = random number seed
% OUTPUTS: MinCost = array of best solution, one element for each generation
 
if ~exist('DisplayFlag', 'var')
    DisplayFlag = true;
end
if ~exist('RandSeed', 'var')
    RandSeed = round(sum(100*clock));
end
OPTIONS = bbo.OPTIONS;
PMutate = bbo.OPTIONS.PMutate; % mutation probability
Keep = bbo.OPTIONS.Keep; % elitism parameter: how many of the best habitats to keep from one generation to the next

% Initialization
% [MinCost, AvgCost, CostFunction, MaxParValue, MinParValue, Population, OPTIONS] = Init(DisplayFlag, ProblemFunction, RandSeed, OPTIONS);
bbo = Init(DisplayFlag, ProblemFunction, bbo, RandSeed);
EliteSolution = zeros(Keep, OPTIONS.numVar);
EliteCost = zeros(Keep, 1);
Island = zeros(OPTIONS.popsize, OPTIONS.numVar);
% Compute immigration and emigration rates.
% lambda(i) is the immigration rate for habitat i.
% mu(i) is the emigration rate for habitat i.
% This assumes the population is sorted from most fit to least fit.
mu = (OPTIONS.popsize + 1 - (1:OPTIONS.popsize)) / (OPTIONS.popsize + 1);
lambda = 1 - mu;
% Begin the optimization loop
for GenIndex = 1 : OPTIONS.Maxgen
    % Save the best habitats in a temporary array.
    for j = 1 : Keep
        EliteSolution(j,:) = bbo.Population(j).chrom;
        EliteCost(j) = bbo.Population(j).cost;
    end
    % Use lambda and mu to decide how much information to share between habitats.
    for k = 1 : length(bbo.Population)
        % Probabilistically input new information into habitat i
        for j = 1 : OPTIONS.numVar
            if rand < lambda(k)
                % Pick a habitat from which to obtain a feature (roulette wheel selection)
                RandomNum = rand * sum(mu);
                Select = mu(1);
                SelectIndex = 1;
                while (RandomNum > Select) && (SelectIndex < OPTIONS.popsize)
                    SelectIndex = SelectIndex + 1;
                    Select = Select + mu(SelectIndex);
                end
                Island(k,j) = bbo.Population(SelectIndex).chrom(j);
            else
                Island(k,j) = bbo.Population(k).chrom(j);
            end
        end
    end
    % Mutation
    for k = 1 : length(bbo.Population)
        for parnum = 1 : OPTIONS.numVar
            if PMutate > rand
                Island(k,parnum) = bbo.MinParValue(parnum) + (bbo.MaxParValue(parnum) - bbo.MinParValue(parnum)) * rand;
            end
        end
    end
    % Replace the habitats with their new versions.
    for k = 1 : length(bbo.Population)
        bbo.Population(k).chrom = Island(k,:);
    end
    % Calculate cost
    bbo = bbo.CostFunction(bbo);
    % Sort from best to worst
    bbo = PopSort(bbo);
    % Replace the current generation's worst individuals with the previous generation's elites.
    n = length(bbo.Population);
    for k = 1 : Keep
        bbo.Population(n-k+1).chrom = EliteSolution(k,:);
        bbo.Population(n-k+1).cost = EliteCost(k);
    end
    % Make sure the population does not have duplicates. 
    bbo = ClearDups(bbo, bbo.OPTIONS, bbo.MaxParValue, bbo.MinParValue, bbo.CostFunction);
    
    % Sort from best to worst
    bbo = PopSort(bbo);
    % Display info to screen
    MinCost(GenIndex+1) = bbo.Population(1).cost;
    AvgCost(GenIndex+1) = mean([bbo.Population.cost]);
    if DisplayFlag
        disp(['The best and mean of Generation # ', num2str(GenIndex), ' are ',...
            num2str(MinCost(GenIndex+1)), ' and ', num2str(AvgCost(GenIndex+1))]);
    end
end
Conclude(DisplayFlag, OPTIONS, bbo.Population, MinCost, AvgCost);
save('bbo_beammeio.mat');
return