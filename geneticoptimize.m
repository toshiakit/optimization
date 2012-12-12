function bestr=geneticoptimize(domain,costf,popsize,step,mutprob,elite,maxiter,print)
% Takes domain and cost function and return the minimum solutoin,
% simulating alloy annealing process. Requires Communication Toolbox for 
% 'randint' call.

    % Validate input arguments
    if nargin < 2
        error('Not enough input arguments.');
    elseif nargin <3
        % default Genetic Algorithms parameters
        popsize=50; % size of population
        step=1; % the magnitude of change to make in mutation
        mutprob=0.2; % probability of mutation
        elite=0.2; % fraction of population to survive
        maxiter=100; % max number of generations to generate
        print=0; % print the progress to screen?
    elseif nargin <4
        step=1; 
        mutprob=0.2; 
        elite=0.2;
        maxiter=100;
        print=0;
    elseif nargin <5
        mutprob=0.2; 
        elite=0.2;
        maxiter=100;
        print=0;
    elseif nargin <6
        elite=0.2;
        maxiter=100;
        print=0;
    elseif nargin <7
        maxiter=100;
        print=0;
    elseif nargin <8
        print=0;
    end

    if print ~=0
        disp('Starting Genetic Algorithms...')
    end
    
    % Build the initial population
    pop=zeros(popsize,size(domain,2));
    for i=1:size(domain,2)
        pop(:,i)=randint(popsize,1,domain(:,i)');
    end

    % How many winners for each generation?
    topelite=ceil(elite*popsize);

    % Main loop
    for i=1:maxiter
        % Calculate the cost and pick winners
        scores=zeros(size(pop,1),2);
        for j=1:size(pop,1)
            scores(j,1)=costf(pop(j,:));
            scores(j,2)=j;
        end
        sorted=sortrows(scores,1);
        ranked=pop(sorted(:,2),:);
        
        % Start with the pure winners
        pop=ranked(1:topelite,:);

        % Add mutated and bred forms of the winners
        while size(pop,1)<popsize
            if rand<mutprob % mutation
                % Pick a random sample from the winners
                r=ranked(ceil(topelite*rand),:);
                % append the mutated vector to the population.
                pop(end+1,:)=mutate(r,domain,step);
            else % crossover
                % Pick two random samples from the winners
                r1=ranked(ceil(topelite*rand),:);
                r2=ranked(ceil(topelite*rand),:);
                % append the cross bred vector to the population.
                pop(end+1,:)=crossover(r1,r2,domain);
            end
        end

        % Print current best score
        if print ~=0
            disp(sorted(1,1))
        end
    end
    
    % return the best solution
    bestr=pop(sorted(1,2),:);
    
end
    
function vec=mutate(vec,domain,step)
% Takes a vector and mutate an element randomly.
    % Pick a random index to mutate
    idx=ceil(size(domain,2)*rand);
    % 50% of the time pick an earlier flight
    % Make sure the current flight is not the first already
    if (rand<0.5) && (vec(idx)>domain(1,idx))
        vec=[vec(1:idx-1) vec(idx)-step vec(idx+1:end)];
    % Otherwise pick a later flight
    % Make sure the current flight is not the last already
    elseif vec(idx)<domain(2,idx)
        vec=[vec(1:idx-1) vec(idx)+step vec(idx+1:end)];
    end
end

function r=crossover(r1,r2,domain)
% Takes two vectors and cross them over at a random element.
    % Pick a random index to crossover
    idx=randint(1,1,[2,size(domain,2)-1]);
    % Concatenate two vectors at the index
    r=[r1(1:idx) r2(idx+1:end)];
end
    