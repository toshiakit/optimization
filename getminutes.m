function min = getminutes(t)
% accepts a time string in HH:MM format and returns how may minutes into
% the day a give time is.

    x = datevec(t,'HH:MM');
    min=x(4)*60+x(5);
    