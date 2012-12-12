function schedule=createschedule(people,dest,dep,ret,key)
% Access Kayak API to get flight schedules, taking a cell array 'people',
% 3-letter airport codes for destination, departure and return dates in
% mm/dd/yyyy format. Cell array 'people' contains names in the first col
% and their 3-letter airport codes for origin.

    % Validate input arguments
    if nargin <4
        error('Not enough input arguments.');
    elseif nargin <5
        key='YOUR_KAYAK_KEY_HERE';
    end

    sid=getkayaksession(key);
    schedule=cell(size(people,1),2);
    
    % Loop through each people
    for p=1:size(people,1)
        % get 3-letter airport code of origin
        origin=people{p,2};
        
        % Outbound flight
        searchid=flightsearch(sid,origin,dest,dep);
        if isempty(schedule{p,1})
            schedule{p,1}=flightsearchresults(sid,searchid);
        else
            schedule{p,1}(end+1,:)=flightsearchresults(sid,searchid);
        end
        
        % Return flight
        searchid=flightsearch(sid,dest,origin,ret);
        if isempty(schedule{p,2})
            schedule{p,2}=flightsearchresults(sid,searchid);
        else
            schedule{p,2}(end+1,:)=flightsearchresults(sid,searchid);
        end
        
    end
    
end

function sid=getkayaksession(key)
 % Access the Kayak API to obtain an session id from XML response
 
    % Construct the session URL
    % url=sprintf('http://www.kayak.com/k/ident/apisession?token=%s&version=1',key);

    % use a sample XML file instead
    url='getsession.xml';
    % url='accessdenied.xml';

    % Get XML
    try
        doc=xmlread(url);
    catch
        error('Failed to read XML response %s.',url);
    end
    % Session ID is in <sid></sid> tag in the DOM tree 
    try
        sid=char(doc.getElementsByTagName('sid').item(0).getFirstChild.getData);
    catch
        errMsg=char(doc.item(0).item(1).item(0).getData);
        error('API Returned Error: %s', errMsg);
    end
end

function searchid=flightsearch(sid,origin,destination,depart_date)
% Access the Kayak API to obtain an search id from XML reponse

    % Construct search URL:
    % url='http://www.kayak.com/s/apisearch?basicmode=true&oneway=y';
    % url=[url sprintf('&origin=%s',origin)];
    % url=[url sprintf('&destination=%s', destination)];
    % url=[url sprintf('&depart_date=%s', depart_date)];
    % url=[url '&return_date=none&depart_time=a&return_time=a'];
    % url=[url '&travelers=1&cabin=e&action=doFlights&apimode=1'];
    % url=[url sprintf('&_sid_=%s&version=1', sid)];

    % use a sample XML file instead
    url='startflight.xml';
    % url='accessdenied.xml';

    % get XML
    try
        doc=xmlread(url);
    catch
        error('Failed to read XML response %s.',url);
    end

    % Search ID is in <searchid></searchid> tag in the DOM tree
    try
        searchid=char(doc.getElementsByTagName('searchid').item(0).getFirstChild.getData);
    catch
        errMsg=char(doc.item(0).item(1).item(0).getData);
        error('API Returned Error: %s', errMsg);
    end
end

function result=flightsearchresults(sid,searchid)
    while 1

        % wait before you start polling again
        pause(2);

        % Construct polling URL
        % url='http://www.kayak.com/s/apibasic/flight?';
        % url=[url sprintf('searchid=%s', searchid)];
        % url=[url '&c=5&apimode=1'];
        % url=[url sprintf('&_sid_=%s',sid)];
        % url=[url '&version=1'];

        % use a sample XML file instead
        url='flight_nomorepending.xml';
        % url='flight_morepending.xml';
        % url='accessdenied.xml';

        % get XML
        try
            doc=xmlread(url);
        catch
            error('Failed to read XML response %s.',url);
        end

        % Look for morepending tag, and wait until it is no longer true
        try
            morepending=doc.getElementsByTagName('morepending').item(0).getFirstChild;
        catch
            errMsg=char(doc.item(0).item(1).item(0).getData);
            error('API Returned Error: %s', errMsg);
        end
        if isempty(morepending) || strcmp(morepending.getData,'false')
            break; % no more pending data - the full result is available
        end

    end

    % Construct the full result URL
    % url='http://www.kayak.com/s/apibasic/flight?';
    % url=[url sprintf('searchid=%s', searchid)];
    % url=[url '&c=999&apimode=1'];
    % url=[url sprintf('&_sid_=%s',sid)];
    % url=[url '&version=1'];

    % use a sample XML file instead
    url='flight.xml';
    % url='accessdenied.xml';

    % get XML
    try
        doc=xmlread(url);
    catch
        error('Failed to read XML response %s.',url);
    end
    
    % Get 'price', 'depart', and 'arrive' tags from the DOM tree
    % How many items in the object? All three should be the same.
    rowsize=doc.getElementsByTagName('depart').getLength;
    result=cell(rowsize,3);
    for i=1:rowsize
        try
            result{i,1}=DOMtoChar(doc.getElementsByTagName('depart'),i);
            result{i,2}=DOMtoChar(doc.getElementsByTagName('arrive'),i);
            result{i,3}=DOMtoNum(doc.getElementsByTagName('price'),i);
        catch
            errMsg=char(doc.item(0).item(1).item(0).getData);
            error('API Returned Error: %s', errMsg);
        end
    end
    
end

function celldata=DOMtoChar(DOM,i)
% Extract text from DOM object
    % the returned data is in 'date time' format, but we only need time
    % DOM object is zero-indexed
    string=regexp(char(DOM.item(i-1).getFirstChild.getData),' ','split');
    celldata=string{1,2};
end

function celldata=DOMtoNum(DOM,i)
% Extract number from DOM object
    % returned data is just numbers, no symbols to remove
    % DOM object is zero-indexed
    celldata=str2double(char(DOM.item(i-1).getFirstChild.getData));
end