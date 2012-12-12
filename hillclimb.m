function sol=hillclimb(domain,costf)
% Takes domain and cost function and return the minimum solutoin in the 
% solution space landscape if it is a nice simple smooth 'hill' with no 
% sudden gaps. Requires Communication Toolbox for 'randint' call. 

    % Generate a random guess.
    sol=zeros(1,size(domain,2));
    for i=1:size(domain,2)
        sol(1,i)=randint(1,1,domain(:,i)');
    end

    while 1 % Run the loop until 'break'

        % Create the filter
        filter=[eye(size(sol,2));eye(size(sol,2)).*-1];

        % Create neighbors with the filters
        neighbors=repmat(sol,size(sol,2)*2,1)+filter;

        % Make sure neighbors are within bounds
        for i=1:size(sol,2)
            neighbors(neighbors(:,i)<domain(1,i),i)=domain(1,i);
            neighbors(neighbors(:,i)>domain(2,i),i)=domain(2,i);
        end

        % Continually update the cost calculations among neighbors
        current=costf(sol);
        best=current;
        for i=1:size(neighbors,1)
            cost=costf(neighbors(i,:));
            if cost<best
                best=cost;
                sol=neighbors(i,:);
            end
        end

        if best==current
            break;
        end

    end