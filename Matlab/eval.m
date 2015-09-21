%%
clear all


%% Setup variables
%Uni
plot_path='E:\Git\gallery\log';
%Home
plot_path='E:\Git\gallery\log';

runs=[1]
for j=runs
    current_folder = fullfile([plot_path '\run ' num2str(j)],'*.csv');
    dirListing = dir(current_folder);
    number_of_files = length(dirListing);

    
    
    for i=1:number_of_files
            current_file = fullfile([plot_path '\run ' num2str(j)],dirListing(i).name)
            fileID = fopen(current_file)
            %Client
            C = textscan(fileID,'%*d %*s %*s %*s %s %*s %s %*s %d %*s %d %*s %f %*s %d %*s %s %*s %*s %*s','HeaderLines',1);
            fclose(fileID);
            %celldisp(C);

            quality{j} = C{1};
            qualityMode{j} = C{2};
            loadTimeMS{j} = C{3};
            imgSizeByte{j} = C{4};
            tptKBs{j} = C{5};
            picNo{j} = C{6};
            serverAddress{j} = C{7};
            
            figure(1); clf; hold all; box on; 
            X=[1 2 3 4 5 6 7 8 9 10] 
            scatter (picNo{1}, tptKBs{1}, 'r');
            set(gca,'XTick',X);
            ylim([0 260]);
            xlim([0 11]);
            ylabel('Average Throughput in KB/s');
            xlabel('Picture');           
            title ('Picture Number vs Throughput');
            print ("test1.pdf"); 
            set (gcf, "papersize", [6.4, 4.8]); 
            set (gcf, "paperposition", [0, 0, 6.4, 4.8]); 
            print ("test111.pdf")

            figure(2); clf; hold all; box on; 
            X=[1 2 3 4 5 6 7 8 9 10] 
            scatter (picNo{1}, imgSizeByte{1}./1000, 'r');
            set(gca,'XTick',X);
            %ylim([0 260]);
            xlim([0 11]);
            ylabel('imgSizeByte');
            xlabel('Picture');           
            title ('Picture Number vs imgSizeByte');
            print ("test22.jpg");
            print('-djpeg','CDF Throughput.jpg'); 
            handle = figure(2);
            save2Files2([0 0 1], [plot_path '\\'], 'CDFState', handle, 2);
    end
end