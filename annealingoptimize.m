function vec=annealingoptimize(domain,costf,T,cool,step)
% Takes domain and cost function and return the minimum solutoin,
% simulating alloy annealing process. Requires Communication Toolbox for 
% 'randint' call.

    % Validate input arguments
    if nargin < 2
        error('Not enough input arguments.');
    elseif nargin <3
        % default Simulated Annealing parameters
        T=10000.0; % initial temperature 
        cool=0.95; % cooling factor
        step=1; % randomizing step - randomize between -step and step
    elseif nargin <4
        cool=0.95;
        step=1;
    elseif nargin <5
        step=1;
    end

    % Generate a random guess.
    vec=zeros(1,size(domain,2));
    for i=1:size(domain,2)
        vec(1,i)=randint(1,1,domain(:,i)');
    end

    while T>0.1
        % Choose one of the indices
        i=ceil(size(domain,2)*rand);

        % Choose a direction of change
        dir=randint(1,1,[-step step]); 

        % Create a filter
        filter=zeros(1,size(domain,2));
        filter(i)=dir;

        % Create a new vector by applying the filter
        % and make sure it is within the range
        vecb=vec+filter;
        if vecb(i)<domain(1,i)
            vecb(i)=domain(1,i);
        elseif vecb(i)>domain(2,i)
            vecb(i)=domain(2,i);
        end

        % Calculate the current cost and new cost
        ea=costf(vec);
        eb=costf(vecb);

        % Calculate probability cutoff
        p=exp(double((-ea-eb)/T));

        % Is it better, or does it make the probability cutoff?
        if eb<ea || rand<p
            vec=vecb;
        end

        % Decrease the temperature
        T=T*cool;
    end