function cost=dormcost(vec)
% The cost function for dorm optimization problem

    % Get variables from the base workspace
    dorms=evalin('base','dorms');
    prefs=evalin('base','prefs');
    
    % initialize the variables
    cost=0;
    slots=[];
    
    for i=1:size(dorms,2)
        slots=[slots i,i]; % create two slots for each room
    end

    % Loop over each student
    for i=1:size(vec,2)
        x=vec(i); % get index of slots from the solution
        if prefs(i,1)==slots(x)
            cost=cost+0; % first choice, so no cost
        elseif prefs(i,2)==slots(x)
            cost=cost+1; % second choice, cost up by 1
        else 
            cost=cost+3; % neigther, so cost up by 3
        end
        slots(x)=[]; % remove the slot taken by that student
    end