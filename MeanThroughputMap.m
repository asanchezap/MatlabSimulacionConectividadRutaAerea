function f = MeanThroughputMap(scenario, sat, elevacion, throughput)
    lat = 0:10:90;
    NGS = length(lat);
    elevations = elevacion*ones(1,NGS);
    long = zeros(1, NGS);

    uniques = 0:1:ceil(length(sat)/2);
    
    for l=1:length(lat)
        gs(l)= groundStation(scenario, Latitude=lat(l), Longitude=long(l), MinElevationAngle=elevations(l));
    
        ac = access(sat,gs(l));
        s = accessStatus(ac);
        ss = sum(s,1);

        counts(l,:) = histc(ss, uniques);
    end
        
    %graph detailing the number of satellites in range at all times  
    for i=1:1:max(uniques)+1
        leg{i} = "Nº sats visibles = " + num2str(i-1);
    end
    percentages = counts/sum(counts(1,:));
    meanThroughput = throughput*(percentages*uniques');
    maxThroughput = throughput*max((ceil(percentages).*repmat(uniques,10,1))');

    T = [flip(meanThroughput'), meanThroughput(2:end)'];
    TT = repmat(T',1, 200);

    figure
    axesm eckert4;
    framem
    gridm
    axis off   
    
    R = georefcells([-90 90],[0 360], size(TT));
    geoshow(TT,R,'DisplayType','texturemap');
    %geoshow('landareas.shp','FaceColor','black');
    load coastlines;
    geoshow(coastlat,coastlon,'color',"k");

    cb = colorbar('southoutside');
    cb.Label.String = 'Mean throughput at each location [Mbps]';
end