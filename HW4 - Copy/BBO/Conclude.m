function Conclude(DisplayFlag, OPTIONS, Population, MinCost, AvgCost)
% Output results of population-based optimization algorithm.
if DisplayFlag
    % Count the number of duplicates
    DupFlag = false(1, OPTIONS.popsize);
    for i = 1 : OPTIONS.popsize
        if DupFlag(i), continue, end
        if OPTIONS.OrderDependent
            Chrom1 = Population(i).chrom;
        else
            Chrom1 = sort(Population(i).chrom);
        end
        for j = i+1 : OPTIONS.popsize
            if OPTIONS.OrderDependent
                Chrom2 = Population(j).chrom;
            else
                Chrom2 = sort(Population(j).chrom);
            end
            if isequal(Chrom1, Chrom2)
                DupFlag(i) = true;
                DupFlag(j) = true;
            end
        end
    end  
    disp([num2str(sum(DupFlag)), ' duplicates in final population.']);
    % Display the best solution
    if OPTIONS.OrderDependent
        Chrom = Population(1).chrom;
    else
        Chrom = sort(Population(1).chrom);
    end
    disp(['Best chromosome = ', num2str(Chrom)]); 
    % Plot some results
    close all;
    plot(0:OPTIONS.Maxgen, AvgCost, 'r'); hold;
    plot(0:OPTIONS.Maxgen, MinCost, 'b');
    xlabel('Generation')
    ylabel('Cost')
    legend('Average Cost', 'Minimum Cost')
end