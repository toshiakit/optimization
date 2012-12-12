function bestr=randomoptimize(domain, costf)
% Takes domain and cost function and return the minimum solutoin out of 
% 1000 randomly generated solutions. Requires Communication Toolbox for 
% 'randint' call. 

    % number of random guesses to generate
    guesses=1000; 
    
    % Generate random guesses.
    sol=zeros(guesses,size(domain,2));
    for i=1:size(domain,2)
        sol(:,i)=randint(guesses,1,domain(:,i)');
    end
    
    % Calculate the total cost for each.
    cost=zeros(size(sol,1),1);
    for i=1:size(sol,1)
        cost(i,1)=costf(sol(i,:));
    end

    % Find the minimum cost and get the solution that generates it.
    [v,idx]=min(cost);
    bestr=sol(idx,:); 