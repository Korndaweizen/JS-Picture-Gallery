%%
clear all


%% Setup variables
%Uni
plot_path='E:\git\gallery\Evaluation\log';
%Home
%plot_path='E:\Git\gallery\log';

screen_sizes = [320 640 1024 2048 4096];

algorithms= {'\tptOTF' '\tptBackground' '\ownSrcSet' '\allgemein' '\ownSrcSetvalidate'};

algorithm=algorithms{5};

plotArray{1}=[];
plotArray{2}=[];
plotArray{3}=[];
plotArray{4}=[];
plotArray{5}=[];

supertemp=0

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
            tptKBs{j}        = C{6}.*8;
            picNo{j}         = C{7};
            serverAddress{j} = C{8};


            for g=1:size(quality{j})
                check=quality{j}{g};
                if(strcmp(check,'small'))
                    qualityArray{j}(g)=supertemp=1
                end
                if(strcmp(check,'medium'))
                    qualityArray{j}(g)=supertemp=2;
                end
                if(strcmp(check,'large'))
                   qualityArray{j}(g)=supertemp=3;
                end
                if(strcmp(check,'xlarge'))
                    qualityArray{j}(g)=supertemp=4;
                end
                if(strcmp(check,'uncompressed'))
                    qualityArray{j}(g)=supertemp=5;
                    if(strcmp(algorithm,'\allgemein'))
                        qualityArray{j}(g)=6;
                    end
                end 

                if(strcmp(algorithm,'\ownSrcSet'))
                    screensize{j}(g)=str2double(filename);
                end

                if(strcmp(algorithm,'\ownSrcSetvalidate'))
                    plotArray{supertemp}=[plotArray{supertemp} picNo{j}(g)]
                end 

                if(strcmp(algorithm,'\tptBackground') || strcmp(algorithm,'\tptOTF'))
                    maxDLink{j}(g)=str2double(filename);
                end                                                    
            end

            plotArray
            supertemp

            if(strcmp(algorithm,'\tptOTF'))
                for g=1:(size(tptKBs{j})-1)
                    tptKBsShift{j}(g)=tptKBs{j}(g);
                    qualityArrayShift{j}(g)=qualityArray{j}(g+1);
                end
            end

            set (gcf, "papersize", [6.4, 4.8]); 
            set (gcf, "paperposition", [0, 0, 6.4, 4.8]);

            if(strcmp(algorithm,'\ownSrcSet'))
                %Quality Modes vs Picture Size in KB
                figure(2); hold all; box on; 
                Y=[1 2 3 4 5];
                X=[320 640 1024 2064 4096];
                scatter (screensize{j}, qualityArray{j}, 'r');
                set(gca,'XTick',X);
                set(gca,'YTick',[1 2 3 4 5]);
                set(gca,'xscale','log')
                set(gca,'YTickLabel',{'Small' 'Medium' 'Large' 'X-Large' 'Original'}); ;
                set(gca,'XTickLabel',X);
                xlim([250 5000]);
                ylim([0.5 5.5]);
                xlabel('Screen Width');
                ylabel('Selected Qualities');           
                %title ('Screen Resolution vs Selected Qualities');
                %handle = figure(2);
                %save2Files2([0 1 1], [plot_path '\\'], 'Allgemein', handle, 2);
            end

            if(strcmp(algorithm,'\ownSrcSetvalidate'))
                %Quality Modes vs Picture Size in KB
                figure(2); hold all; box on; 
                X=[320 640 1024 2064];
                %scatter(picNo{j}, qualityArray{j}, 'r', 'x');

                Y(1:length(plotArray{1}))=1
                scatter(plotArray{1}, Y, 'r', 'x', 'LineWidth',2);

                Y(1:length(plotArray{2}))=2
                scatter(plotArray{2}, Y, 'b', 'x', 'LineWidth',2);

                Y(1:length(plotArray{3}))=3
                scatter(plotArray{3}, Y, 'g', 'x', 'LineWidth',2);

                Y(1:length(plotArray{4}))=4
                scatter(plotArray{4}, Y, 'c', 'x', 'LineWidth',2);

                %Y(1:length(plotArray{5}))=5
                %scatter(plotArray{5}, Y, 'm', 'x', 'LineWidth',2);

                set(gca,'XTick',X);
                set(gca,'YTick',[1 2 3 4]);
                %set(gca,'xscale','log')
                set(gca,'YTickLabel',{'Small' 'Medium' 'Large' 'X-Large'}); ;
                set(gca,'XTickLabel',X);
                xlim([40 2500]);
                ylim([0.5 4.5]);
                xlabel('Viewport Width in pixels');
                ylabel('Image Size'); 

                allfonts=[findall(2,'type','text');findall(2,'type','axes')];
                set(allfonts,'FontSize',16);
      
                h = legend ('Small', 'Medium', 'Large', 'X-Large');
                rect =  [0.69,0.15,0.2,0.4];
                set(h, 'Position', rect)
                allMarkers = findobj(2,'type','patch'); % Find objects of type 'patch'
                set(allMarkers,'LineWidth', 2);
      
                %title ('Screen Width vs Selected Quality');

                handle = figure(2);
                save2Files2([0 1 1], [plot_path '\\'], 'ownSrcSetvalidate', handle, 2);
            end


            if(strcmp(algorithm,'\tptOTF'))
            
                %Validate

                figure(3); hold all; box on; 
                Y=[1 2 3 4 5];
                X=[1.1 2.6 4 6 8 9.8 12];
                scatter(tptKBsShift{j}./1000, qualityArrayShift{j}, 'r', 'x');
                set(gca,'XTick',X);
                set(gca,'YTick',Y);
                %set(gca,'xscale','log')
                set(gca,'YTickLabel',{'Small' 'Medium' 'Large' 'X-Large' 'Original'}); ;
                %set(gca,'XTickLabel',X);
                xlim([0 13]);
                ylim([0.5 5.5]);
                plot([1.12 1.12], [0.5 5.5], 'LineWidth',2,'Color','black','LineStyle',':' );
                plot([2.64 2.64], [0.5 5.5], 'LineWidth',2,'Color','black','LineStyle',':' );
                plot([9.84 9.84], [0.5 5.5], 'LineWidth',2,'Color','black','LineStyle',':' );
                xlabel('Dl Speed of prev. Img in Mbps');
                ylabel('Selected Quality');           
                %title ('Download Speed vs Selected Quality');
            end

            if(strcmp(algorithm,'\allgemein'))
                %Quality Modes vs Picture Size in KB
                figure(2); clf; hold all; box on; 
                X=[1 2 3 4];
                Y=[50 150 250 500 750 1000 1500 2000];
                scatter (qualityArray{1}, imgSizeByte{1}./1000, 'r');
                set(gca,'XTick',X);
                set(gca,'YTick',Y);
                set(gca,'XTickLabel',{'Small' 'Medium' 'Large' 'X-Large'}); 
                ylim([0 2100]);
                xlim([0.5 4.5]);
                ylabel('Picture Size in KB');
                xlabel('Quality Modes');           
                %title ('Quality Modes vs Picture Size in KB');
                print('-djpeg','Allgemein.jpg'); 
                handle = figure(2);
                save2Files2([0 1 1], [plot_path '\\'], 'content', handle, 2);
            end


    end
end

%if(~(strcmp(algorithm,'\allgemein')))
%    handle = figure(2);
%    save2Files2([0 1 1], [plot_path '\\'], strrep(algorithm, '\\', ''), handle, 2);
%end

if(strcmp(algorithm,'\tptOTF'))
    handle = figure(3);
    allMarkers = findobj(3,'type','patch');
    set(allMarkers,'LineWidth', 2);
    save2Files2([0 1 1], [plot_path '\\'], [strrep(algorithm, '\\', '') '_valid'], handle, 2);
end
