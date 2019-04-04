function [bbo] = ClearDups(bbo, OPTIONS, MaxParValue, MinParValue, CostFunction)
% Make sure there are no duplicate individuals in the population.
% This logic does not make 100% sure that no duplicates exist, but any duplicates that are found are
% randomly mutated, so there should be a good chance that there are no duplicates after this procedure.
% OPTIONS.OrderDependent says if the order of the features is important or not in the solution.
Population = bbo.Population;
for i = 1 : length(Population)
    if OPTIONS.OrderDependent
        Chrom1 = Population(i).chrom;
    else
        Chrom1 = sort(Population(i).chrom);
    end
    for j = i+1 : length(Population)
        if OPTIONS.OrderDependent
            Chrom2 = Population(j).chrom;
        else
            Chrom2 = sort(Population(j).chrom);
        end
        if isequal(Chrom1, Chrom2)           
            parnum = ceil(length(Population(j).chrom) * rand);
            Population(j).chrom(parnum) = MinParValue(parnum) + (MaxParValue(parnum) - MinParValue(parnum)) .* rand;
            % Recalculate the cost of the replaced individual
            bbo = CostFunction(bbo, Population(j));
            Population(j) = bbo.Population;
%             Population(j) = CostFunction(bbo, Population(j));
        end
    end
end
bbo.Population = Population;