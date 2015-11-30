%%
clear all


%% Setup variables
%Uni
plot_path='E:\git\picgallery\Evaluation\log';
%Home
%plot_path='E:\Git\gallery\log';

folder='\evaluateEstimatedLatencyVsRandomSelection'

current_folder = fullfile([plot_path folder],'*.csv');
dirListing = dir(current_folder);
number_of_files = length(dirListing);

for j=1:number_of_files
        current_file = fullfile([plot_path folder],dirListing(j).name);

        filename=strrep(dirListing(j).name, '.csv', '');
        filename=strrep(filename, 'mbit', '');

        fileID = fopen(current_file);
        %Client
        C = textscan(fileID,'%f %*s %*s %*s %s %*s %s %*s %d %*s %d %d %d %*s %*s %*s','HeaderLines',1);
        fclose(fileID);
        %celldisp(C);

        timestamp{j}       = C{1}.-C{1}(1);
        serverAddress{j}   = C{2}
        mode{j}            = C{3}
        selectedLatency{j} = C{4}

        latencServer1{j}   = C{5}
        latencServer2{j}   = C{6}
        latencServer3{j}   = C{7}
end

set (gcf, "papersize", [6.4, 4.8]); 
set (gcf, "paperposition", [0, 0, 6.4, 4.8]);

averageLatencyRandomSelect=round(mean([mean(latencServer1{j}) mean(latencServer2{j}) mean(latencServer3{j})])*10)/10
averagePickedLatency=round(mean(selectedLatency{j})*10)/10




figure(2); clf; hold all; box on;
%set(gca,'YTick',[0:10:100]);
xlim([0.5 2.5])
ylim([0 220])
bar([averageLatencyRandomSelect; averagePickedLatency]);

ylabel('Average latency [ms]');
xlabel('Server selection strategy'); 

set(gca,'XTickLabel',{' ' 'Random Selection' '' 'Lowest Latency' ''});
text (0.75, averageLatencyRandomSelect+15, [num2str(averageLatencyRandomSelect) " ms"]);
text (1.8, averagePickedLatency+15, [num2str(averagePickedLatency) " ms"]);

handle = figure(2);
save2Files2([0 1 1], [plot_path '\\'], 'latency_bars', handle, 2);