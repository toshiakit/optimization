function printschedule(r)
% print the solution to screen

    % Access the data vectors/arrays in the base Workspace
    people=evalin('base','people');
    flights=evalin('base','flights');
    dest=evalin('base','dest');

    % Define the output format
    format='%10s%5s %6s-%5s $%3d %6s-%5s $%3d';

    % See below about this variable
    offset=1;

    % 's' will have 12 elements for outbound and return flights, but we
    % have 6 people only. 
    for d=1:size(r,2)/2
        name=people{d,1};
        origin=people{d,2};
        % 'flights' hold 'depart', 'arrive', and 'price' combination per
        % a given origin-desitination pair. 
        % This is the code from the book - I think there is a problem
        % out=flights{i,1}(r(d),:);
        % ret=flights{i,2}(r(d+1),:);

        % This is how it should be.
        out=flights{d,1}(r(offset),:);
        ret=flights{d,2}(r(offset+1),:);
        offset=offset+2;

        disp(sprintf(format,name,origin,out{1},out{2},out{3},ret{1},ret{2},ret{3}))
    end