function printdormsolution(vec)
% Print the dorm assignment solution. 

    % Get variables from the base workspace
    dorms=evalin('base','dorms');
    people=evalin('base','people');

    % slots represents the available spaces in the dorms.
    slots=[];
    for i=1:size(dorms,2)
        slots=[slots i,i]; % create two slots for each room
    end

    % print the sample solution by looping over each student assignment
    for i=1:size(vec,2)
        x=vec(i); % get index of slots from the solution
        dorm=dorms{slots(x)}; % which room does that slot map to?
        % print student name and assigned room
        disp(sprintf('%7s -> %7s',people{i},dorm))
        slots(x)=[]; % remove the slot taken by that student
    end