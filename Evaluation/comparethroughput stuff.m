%%
clear all


%% Setup variables
%Uni
plot_path='E:\Git\gallery\log';
%Home
plot_path='E:\Git\gallery\log';

screen_sizes = [320 640 1024 2048 4096];

algorithms= {'\changingthroughput'};

algorithm=algorithms{1};

nameArray=[];
correctIncorrect=[];
trafficArray=[];
timeArray=[];

runs=[1];
for j=runs
    current_folder = fullfile([plot_path algorithm],'*.csv');
    dirListing = dir(current_folder);
    number_of_files = length(dirListing);

    
    
    for i=1:number_of_files
            current_file = fullfile([plot_path algorithm],dirListing(i).name);

            filename=strrep(dirListing(i).name, '.csv', '');
            filename=strrep(filename, 'mbit', '');

            fileID = fopen(current_file);
            %Client
            C = textscan(fileID,'%f %*s %*s %*s %s %*s %s %*s %d %*s %d %*s %f %*s %d %*s %s %*s %*s %*s','HeaderLines',1);
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

            nameArray=[nameArray; filename];

            for g=1:size(quality{j})
                check=quality{j}{g};
                if(strcmp(check,'small'))
                    qualityArray{j}(g)=1;
                    if(tptKBs{j}(g)<=100)
                        correct++;
                    else
                        mistaken++;
                    end
                end
                if(strcmp(check,'medium'))
                    qualityArray{j}(g)=2;
                    if(tptKBs{j}(g)<=300 && tptKBs{j}(g)>100)
                        correct++;
                    else
                        mistaken++;
                    end
                end
                if(strcmp(check,'large'))
                   qualityArray{j}(g)=3;
                    if(tptKBs{j}(g)<=500 && tptKBs{j}(g)>300)
                        correct++;
                    else
                        mistaken++;
                    end
                end
                if(strcmp(check,'xlarge'))
                    qualityArray{j}(g)=4;
                    if(tptKBs{j}(g)<=1500 && tptKBs{j}(g)>500)
                        correct++;
                    else
                        mistaken++;
                    end
                end
                if(strcmp(check,'uncompressed'))
                    qualityArray{j}(g)=5;
                    if(tptKBs{j}(g)>1500)
                        correct++;
                    else
                        mistaken++;
                    end
                end   
            end

            set (gcf, "papersize", [6.4, 4.8]); 
            set (gcf, "paperposition", [0, 0, 6.4, 4.8]);

            correctIncorrect=[correctIncorrect; correct, mistaken];
            trafficArray=[trafficArray; traffic];
            timeArray=[timeArray; time];

    end
end

correctIncorrect
nameArray
timeArray(1)=round(timeArray(1)*100)/100;
timeArray(2)=round(timeArray(2)*100)/100;

celldata1 = cellstr(nameArray)



figure(2); clf; hold all; box on;
set(gca,'YTick',[0:10:100]);
xlim([0.5 2.5])
bar(correctIncorrect./10,'stacked');
h = legend ('Correct', 'Incorrect');
legend (h, 'location', 'northoutside');
legend boxoff
set(gca,'XTickLabel',{' ' celldata1{1} '' celldata1{2} ''});
text (0.875, 50, "78,3%", 'Color', 'white');
text (1.875, 50, " 95%", 'Color', 'white');

handle = figure(2);
save2Files2([0 1 1], [plot_path '\\'], 'correctnessinpercent_idle_otf', handle, 2);


figure(2); clf; hold all; box on;
%set(gca,'YTick',[0:10:100]);
xlim([0.5 2.5])
bar(trafficArray);
%h = legend ('Download volume');
%legend (h, 'location', 'northoutside');
%legend boxoff
set(gca,'XTickLabel',{' ' celldata1{1} '' celldata1{2} ''});
text (0.8, trafficArray(1)+35, [num2str(trafficArray(1)) " MB"]);
text (1.8, trafficArray(2)+35, [num2str(trafficArray(2)) " MB"]);

handle = figure(2);
save2Files2([0 1 1], [plot_path '\\'], 'traffic_idle_otf', handle, 2);

figure(2); clf; hold all; box on;
%set(gca,'YTick',[0:10:100]);
xlim([0.5 2.5])
bar(timeArray);
%h = legend ('Download time');
%legend (h, 'location', 'northoutside');
%legend boxoff
set(gca,'XTickLabel',{' ' celldata1{1} '' celldata1{2} ''});
text (0.8, timeArray(1)+2, [num2str(timeArray(1)) " Min"]);
text (1.8, timeArray(2)+2, [num2str(timeArray(2)) " Min"]);

handle = figure(2);
save2Files2([0 1 1], [plot_path '\\'], 'time_idle_otf', handle, 2);