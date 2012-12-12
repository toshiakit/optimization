function total=crosscount(v)
% Returns the number of lines crossed

    % Get variables from the base workspace
    links=evalin('base','links');
    
    % initialize variable
    total=0;

    % Conver the solution into matrix of people's coorinates
    loc=zeros(size(v,2)/2,2);
    offset=1;
    for i=1:size(loc,1)
        loc(i,:)=v(offset:offset+1);
        offset=offset+2;
    end
    
    % Loop through every pair of links
    for i=1:size(links,1)
        for j=i+1:size(links,1)
            x1=loc(links(i,1),1);
            y1=loc(links(i,1),2);
            x2=loc(links(i,2),1); 
            y2=loc(links(i,2),2); 
            x3=loc(links(j,1),1);
            y3=loc(links(j,1),2);
            x4=loc(links(j,2),1);
            y4=loc(links(j,2),2);

            den=(y4-y3)*(x2-x1)-(x4-x3)*(y2-y1);

            if den==0 % then the lines are parallel
                continue;
            end

            % Otherwise ua and ub are the fraction of the lines where they
            % cross
            ua=((x4-x3)*(y1-y3)-(y4-y3)*(x1-x3))/den;
            ub=((x2-x1)*(y1-y3)-(y2-y1)*(x1-x3))/den;

            % If the fraction is between 0 and 1 for both lines
            % the they cross each other
            if ua>0 && ua<1 && ub>0 && ub<1
                total=total+1;
            end

        end
    end