function drawnetwork(vec, drawtitle)
% takes a vector and draw a network graph

    % Validate input arguments
    if nargin <2
        drawtitle='Optimized Network Graph';
    end

    % get the variables in the workspace
    people=evalin('base','people');
    links=evalin('base','links');

    % get the position of each node
    pos=zeros(size(vec,2)/2,2);
    offset=1;
    for i=1:size(pos,1)
        pos(i,:)=vec(offset:offset+1);
        offset=offset+2;
    end

    x=pos(:,1);
    y=pos(:,2);
    datalabels = people;

    figure1 = figure('Name','Fig-1');
    axes('Parent',figure1);
    xlim([0 400]);
    ylim([0 400]);
    hold('all');
    title(drawtitle);

    % get the coorindates of the links
    for i=1:size(links,1)
        x1=pos(links(i,1),1);
        y1=pos(links(i,1),2); 
        x2=pos(links(i,2),1);
        y2=pos(links(i,2),2); 
        line([x1,x2],[y1,y2]);
    end

    scatter(x, y, 'DisplayName', 'Critics', 'XDataSource', 'x', 'YDataSource','y'); figure(gcf)
    text(x+7,y,datalabels);