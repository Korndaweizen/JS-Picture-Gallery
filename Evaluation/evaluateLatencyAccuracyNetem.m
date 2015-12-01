%%
clear all
pkg load statistics

%% Setup variables
%Uni
plot_path='E:\git\gallery\Evaluation\log';
%Home
%plot_path='E:\Git\gallery\log';

algorithm='\latency_validation_netem'

current_folder = fullfile([plot_path algorithm],'*.csv');
dirListing = dir(current_folder);
number_of_files = length(dirListing);

selectedLatencyArray=[];
intervalArray=[];
maxLatencyArray=[];

for j=1:number_of_files
        current_file = fullfile([plot_path algorithm],dirListing(j).name);

        filename=strrep(dirListing(j).name, '.csv', '');
        filename=strrep(filename, 'mbit', '');
        filename=strrep(filename, 'ms', '');

        fileID = fopen(current_file);
        %Client
        C = textscan(fileID,'%f %*s %*s %*s %s %*s %s %*s %d %*s %d %d %d %*s','HeaderLines',1);
        fclose(fileID);
        %celldisp(C);

        timestamp{j}       = C{1}.-C{1}(1);
        serverAddress{j}   = C{2}
        mode{j}            = C{3}
        selectedLatency{j} = C{4}

        latencServer1{j}   = C{5}

        for g=1:size(timestamp{j})
            maxLatency{j}(g)=str2double(filename);                                                
        end
        
        [M,C] = nanmeanConfInt(selectedLatency{j}, 0.95, 1);
        intervalArray=[intervalArray C];


        selectedLatencyArray=[selectedLatencyArray M];
        maxLatencyArray=[maxLatencyArray mean(maxLatency{j})];
end

%Measured Latency vs Set Latency

set (gcf, "papersize", [6.4, 4.8]); 
set (gcf, "paperposition", [0, 0, 6.4, 4.8]);

figure(2); hold all; box on; 

plot([0 130], [0 130],':');
%scatter (maxLatencyArray, selectedLatencyArray.-selectedLatencyArray(1), 'r', 'x');
h1=errorbar(maxLatencyArray,selectedLatencyArray.-selectedLatencyArray(1),intervalArray,'r');

XY=[0:10:130];
set(gca,'XTick',XY);
set(gca,'YTick',XY);

xlim([-1 130]);
ylim([-1 130]);

xlabel('Set Latency [ms]');
ylabel('Latency [ms]');           

allfonts=[findall(2,'type','text');findall(2,'type','axes')];
set(allfonts,'FontSize',16);
h = legend ([h1],{'Estimated Latency'});

rect =  [0.5,0.1431,0.405,0.1925];
set(h, 'Position', rect)

allMarkers = findobj(2,'type','patch');
set(allMarkers,'LineWidth', 2);

handle = figure(2);
save2Files2([0 1 1], [plot_path '\\'], 'latency_accuracy_netem', handle, 2);