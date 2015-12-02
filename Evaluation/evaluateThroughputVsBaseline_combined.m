%%
clear all
pkg load statistics

%% Setup variables
%Uni
plot_path='.\log';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%
%%%%%       Load OTF Algo Data
%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

folder='\tptOTF'

current_folder = fullfile([plot_path folder],'*.csv');
dirListing = dir(current_folder);
number_of_files = length(dirListing);

estimThroughputArray=[];
intervalArray=[];
maxThroughputArray=[];
maxTpt=0;

for j=1:number_of_files
            current_file = fullfile([plot_path folder],dirListing(j).name);

            filename=strrep(dirListing(j).name, '.csv', '');
            filename=strrep(filename, 'mbit', '');

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

            for g=1:size(timestamp{j})
                maxThroughput{j}(g)=str2double(filename);                                                
            end

            if(maxTpt<str2double(filename))
                  maxTpt=str2double(filename);
            end

            [M,C] = nanmeanConfInt(tptKBs{j}.*8./1000, 0.95, 1);

            estimThroughputArray=[estimThroughputArray M];
            intervalArray=[intervalArray C];

            maxThroughputArray=[maxThroughputArray mean(maxThroughput{j})];
    end

%Measured tpt vs Set tpt 

set (gcf, "papersize", [6.4, 4.8]); 
set (gcf, "paperposition", [0, 0, 6.4, 4.8]);

figure(2); hold all; box on;

XY=[0:1:maxTpt];
plot([0 maxTpt+0.5], [0 maxTpt+0.5],'k:');
h1=errorbar(maxThroughputArray,estimThroughputArray,intervalArray,'r')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%
%%%%%       Load Background Algo Data
%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



folder='\tptBackground'

current_folder = fullfile([plot_path folder],'*.csv');
dirListing = dir(current_folder);
number_of_files = length(dirListing);

estimThroughputArray=[];
intervalArray=[];
maxThroughputArray=[];
maxTpt=0;

for j=1:number_of_files
            current_file = fullfile([plot_path folder],dirListing(j).name);

            filename=strrep(dirListing(j).name, '.csv', '');
            filename=strrep(filename, 'mbit', '');

            fileID = fopen(current_file);
            %Client
            C = textscan(fileID,'%f %*s %*s %*s %s %*s %s %*s %f %*s %*s %*s %*s %*s','HeaderLines',1);
            %                               1   2   3   4  5   6  7  8   9  10  11  12 13  14 
            fclose(fileID);
            %celldisp(C);

            timestamp{j}     = C{1}.-C{1}(1);
            quality{j}       = C{2};
            qualityMode{j}   = C{3};
            tptKBs{j}        = C{4};

            for g=1:size(timestamp{j})
                maxThroughput{j}(g)=str2double(filename);                                                
            end

            if(maxTpt<str2double(filename))
                  maxTpt=str2double(filename);
            end

            [M,C] = nanmeanConfInt(tptKBs{j}.*8./1000, 0.95, 1);

            estimThroughputArray=[estimThroughputArray M];
            intervalArray=[intervalArray C];
            maxThroughputArray=[maxThroughputArray mean(maxThroughput{j})];

    end

h2=errorbar(maxThroughputArray,estimThroughputArray,intervalArray,'b')



set(gca,'XTick',XY);
set(gca,'YTick',XY);

xlim([0 maxTpt+0.5]);
ylim([0 maxTpt+0.5]);

xlabel('Set Throughput [Mbps]');
ylabel('Throughput [Mbps]');           

allfonts=[findall(2,'type','text');findall(2,'type','axes')];
set(allfonts,'FontSize',16);
h = legend ([h2 h1],{'On Idle', 'On the Fly'});
rect =  [0.645,0.132,0.26,0.2];
set(h, 'Position', rect)

allMarkers = findobj(2,'type','patch');
set(allMarkers,'LineWidth', 2);

handle = figure(2);
save2Files2([0 1 1], [plot_path '\\'], 'tpt_accuracy_netem_combined.pdf', handle, 2);