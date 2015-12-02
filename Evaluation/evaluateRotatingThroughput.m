%%
clear all


%% Setup variables

plot_path='.\log';

algorithms= {'\changingthroughput'};

algorithm=algorithms{1};

nameArray=[];
correctIncorrect=[];
trafficArray=[];
timeArray=[];
timeThresholdPercent=[];

runs=[1];
for i=runs
    current_folder = fullfile([plot_path algorithm],'*.csv');
    dirListing = dir(current_folder);
    number_of_files = length(dirListing);

    
    
    for j=1:number_of_files
            current_file = fullfile([plot_path algorithm],dirListing(j).name);

            filename=strrep(dirListing(j).name, '.csv', '');
            filename=strrep(filename, 'mbit', '');
            filename=filename(2:end);

            fileID = fopen(current_file);
            %Client
            C = textscan(fileID,'%f %*s %*s %*s %s %*s %s %*s %f %*s %f %*s %f %*s %f %*s %s %*s %*s %*s','HeaderLines',1);
            fclose(fileID);
            %celldisp(C);

            timestamp{j}     = C{1}.-C{1}(1);
            quality{j}       = C{2};
            qualityMode{j}   = C{3};
            loadTimeMS{j}    = C{4};
            imgSizeByte{j}   = C{5};
            tptKBs{j}        = C{6};
            picNo{j}         = C{7};
            serverAddress{j} = C{8};

            correct=0;
            mistaken=0;
            traffic=sum(imgSizeByte{j})./1000000
            time=sum(loadTimeMS{j})./60000
            greaterTimeThreshold=0;
            LeQTimeThreshold=0;

            nameArray=[nameArray; filename];

            for g=1:size(quality{j})
                check=quality{j}{g};

                if(loadTimeMS{j}(g)<=1300)
                    LeQTimeThreshold++;
                else
                    greaterTimeThreshold++;
                end

                if(strcmp(check,'small'))
                    qualityArray{j}(g)=1;
                    if(tptKBs{j}(g)<=140)
                        correct++;
                    else
                        mistaken++;
                    end
                end
                if(strcmp(check,'medium'))
                    qualityArray{j}(g)=2;
                    if(tptKBs{j}(g)<=330 && tptKBs{j}(g)>140)
                        correct++;
                    else
                        mistaken++;
                    end
                end
                if(strcmp(check,'large'))
                   qualityArray{j}(g)=3;
                    if(tptKBs{j}(g)<=1230 && tptKBs{j}(g)>330)
                        correct++;
                    else
                        mistaken++;
                    end
                end
                if(strcmp(check,'xlarge'))
                    qualityArray{j}(g)=4;
                    if(tptKBs{j}(g)<=5600 && tptKBs{j}(g)>1230)
                        correct++;
                    else
                        mistaken++;
                    end
                end
                if(strcmp(check,'uncompressed'))
                    qualityArray{j}(g)=5;
                    if(tptKBs{j}(g)>5600)
                        correct++;
                    else
                        mistaken++;
                    end
                end   
            end

            set (gcf, "papersize", [6.4, 4.8]); 
            set (gcf, "paperposition", [0, 0, 6.4, 4.8]);
            if(j>1)
            	correctIncorrect=[correctIncorrect; correct, mistaken];
            end
            trafficArray=[trafficArray; traffic];
            timeArray=[timeArray; time];
            timeThresholdPercent=[timeThresholdPercent; greaterTimeThreshold, LeQTimeThreshold];         

    end
end
timeThresholdPercent=timeThresholdPercent./10
correctIncorrect=round(correctIncorrect.*100)./1000

nameArray
timeArray(1)=round(timeArray(1)*100)/100;
timeArray(2)=round(timeArray(2)*100)/100;
timeArray(3)=round(timeArray(3)*100)/100;
trafficArray(1)=round(trafficArray(1)*100)/100;
trafficArray(2)=round(trafficArray(2)*100)/100;
trafficArray(3)=round(trafficArray(3)*100)/100;

celldata1 = cellstr(nameArray)

figure(2); clf; hold all; box on;
set(gca,'YTick',[0:10:100]);
xlim([0.5 2.5])

correctIncorrect(1)

bar(correctIncorrect,'stacked');
h = legend ('Correct', 'Incorrect');
legend (h, 'location', 'northoutside');
legend boxoff
set(gca,'XTickLabel',{' ' celldata1{2} '' celldata1{3} ''});
text (0.875, 50, [num2str(correctIncorrect(1)) '0%'], 'Color', 'white');
text (1.875, 50, [num2str(correctIncorrect(2)) '0%'], 'Color', 'white');

handle = figure(2);
save2Files2([0 1 1], [plot_path '\\'], 'correctnessinpercent_idle_otf', handle, 2);


figure(2); clf; hold all; box on;
xlim([0.5 3.5])
bar(trafficArray);

ylabel('Overall download volume [MB]')
set(gca,'XTickLabel',{' ' celldata1{1} '' celldata1{2} '' celldata1{3} ''});
text (0.65, trafficArray(1)+100, [num2str(trafficArray(1)) " MB"]);
text (1.65, trafficArray(2)+100, [num2str(trafficArray(2)) " MB"]);
text (2.65, trafficArray(3)+100, [num2str(trafficArray(3)) " MB"]);

handle = figure(2);
save2Files2([0 1 1], [plot_path '\\'], 'traffic_idle_otf.pdf', handle, 2);

figure(2); clf; hold all; box on;

xlim([0.5 3.5])

bar(timeArray);

ylabel('Overall download time [min]')
set(gca,'XTickLabel',{' ' celldata1{1} '' celldata1{2} '' celldata1{3} ''});
text (0.7, timeArray(1)+6, [num2str(timeArray(1)) " Min"]);
text (1.7, timeArray(2)+6, [num2str(timeArray(2)) " Min"]);
text (2.7, timeArray(3)+6, [num2str(timeArray(3)) " Min"]);

handle = figure(2);
save2Files2([0 1 1], [plot_path '\\'], 'time_idle_otf.pdf', handle, 2);



figure(2); clf; hold all; box on; 
Y=[1 2 3 4 5];
j
scatter(loadTimeMS{1}./1000, qualityArray{1}.+0.16, 'r', 'x');
scatter(loadTimeMS{2}./1000, qualityArray{2}, 'b', 'o');
scatter(loadTimeMS{3}./1000, qualityArray{3}.-0.16, 'g', 'd');


allfonts=[findall(2,'type','text');findall(2,'type','axes')];
set(allfonts,'FontSize',14);
h = legend ('No Algorithm', 'Idle', 'On the Fly');
rect =  [0.64,0.7325,0.265,0.1925];
set(h, 'Position', rect)

set(gca,'xscale','log')
set(gca,'YTick',Y);
set(gca,'YTickLabel',{'Small' 'Medium' 'Large' 'X-Large' ' '}); ;
ylim([0.5 5.5]);
X=[0.3 0.7 1.3 3 6 12 24 48];
set(gca,'XTick',X);
set(gca,'XTickLabel',X);
plot([1.3 1.3], [0.5 5.5], 'LineWidth',2,'Color','black','LineStyle',':' );
xlabel('Picture load time [s]');
ylabel('Image Size'); 

handle = figure(2);
allMarkers = findobj(2,'type','patch');
set(allMarkers,'LineWidth', 1.3);

save2Files2([0 1 1], [plot_path '\\'], [strrep(algorithm, '\\', '') '_valid.pdf'], handle, 3);