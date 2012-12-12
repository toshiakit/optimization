function totalcost=schedulecost(sol)
% calcuates the total cost of a given solution

    % Access the data vectors/arrays in the base Workspace
    flights=evalin('base','flights');

    % Initialize variables
    totalprice=0;
    latestarrival=0; % 0:00 of the arrival date
    earliestdep=24*60; % one day later in minutes
    totalwait=0;

    % See below about this variable
    offset=1;

    % 'sol' will have 12 elements for outbound and return flights, 
    % but we have 6 people only. 
    for d=1:size(sol,2)/2
        % Get the outbound and return flights
        % 'flights' hold 'depart', 'arrive', and 'price' combination per
        % a given origin-desitination pair. 
        % This is the code from the book - I think there is a problem
        % outbound=flights{d,1}(s(d),:);
        % returnf=flights{d,2}(s(d+1),:);

        % This is how it should be.
        outbound=flights{d,1}(sol(offset),:);
        returnf=flights{d,2}(sol(offset+1),:);
        offset=offset+2;

        % Total price is the price of all outbound and return flights
        totalprice=totalprice+outbound{3}+returnf{3};

        % Track the latest arrival and earliest departure.
        % If the arrival time is later than the current latest value, then
        % update.
        if latestarrival<getminutes(outbound{2})
            latestarrival=getminutes(outbound{2});
        end
        % If the departure time is earlier than the current earliest value,
        % then update. 
        if earliestdep>getminutes(returnf{1})
            earliestdep=getminutes(returnf{1});
        end
    end

    % Now that the time of the last person to arrive (latestarrival) and
    % the time of the first person to depart (earliestdep), we can
    % calculate the total wait. Everyone has to wait at the airport until 
    % the last person arrives and they must arrive at the airport together
    % with the first person to depart and wait for their own flights.

    % reset the offset
    offset=1;

    for d=1:size(sol,2)/2
        % Get the inbound and outbound flights
        % I hate to run the same set of codes in two separate loops but
        % we need to run the first loop to get latestarrival and
        % earlierstdep values first before you run the second loop.

        outbound=flights{d,1}(sol(offset),:);
        returnf=flights{d,2}(sol(offset+1),:);
        offset=offset+2;

        % The wait time is the gap between the time the last person arrive and
        % your arrival time
        totalwait=totalwait+latestarrival-getminutes(outbound{2});
        % The wait time is the gap between the time you leave and the time the
        % first person departs. 
        totalwait=totalwait+getminutes(returnf{1})-earliestdep;
    end

    % Does this solution requires an exta day of car rental? That'll be 
    % $50 extra (marginal increase)!
    if latestarrival>earliestdep
        totalprice=totalprice+50;
    end

    % Every minute saved is worth $1
    totalcost=totalprice+totalwait*1;