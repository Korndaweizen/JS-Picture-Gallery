%%
clear all


%% Setup variables
%Uni
plot_path='E:\git\picgallery\Evaluation\log';
%Home
%plot_path='E:\Git\gallery\log';

folder='\tptOTF'

current_folder = fullfile([plot_path folder],'*.csv');
dirListing = dir(current_folder);
number_of_files = length(dirListing);

estimThroughputArray=[];
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
            tptKBs{j}        = C{6}
            picNo{j}         = C{7};
            serverAddress{j} = C{8};

            for g=1:size(timestamp{j})
                maxThroughput{j}(g)=str2double(filename);                                                
            end

            if(maxTpt<str2double(filename))
                  maxTpt=str2double(filename);
            end

            estimThroughputArray=[estimThroughputArray mean(tptKBs{j}.*8./1000)];
            maxThroughputArray=[maxThroughputArray mean(maxThroughput{j})];
    end

%Measured tpt vs Set tpt 

set (gcf, "papersize", [6.4, 4.8]); 
set (gcf, "paperposition", [0, 0, 6.4, 4.8]);

figure(2); hold all; box on;

plot([0 1000], [0 1000],'k:');
scatter (maxThroughputArray, estimThroughputArray, 'r', 'x');

XY=[0:1:maxTpt];
set(gca,'XTick',XY);
set(gca,'YTick',XY);

xlim([0 maxTpt+0.5]);
ylim([0 maxTpt+0.5]);

xlabel('Set throughput [Mbps]');
ylabel('Estimated avg. throughput [Mbps]');           

allfonts=[findall(2,'type','text');findall(2,'type','axes')];
set(allfonts,'FontSize',16);
h = legend ( 'Baseline','Estimated Throughput');
rect =  [0.445,0.1431,0.46,0.1925];
set(h, 'Position', rect)

allMarkers = findobj(2,'type','patch');
set(allMarkers,'LineWidth', 2);

handle = figure(2);
save2Files2([0 1 1], [plot_path '\\'], 'tpt_accuracy_netem_otf', handle, 2);