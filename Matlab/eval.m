%%
clear all


%% Setup variables
%Uni
plot_path='E:\Git\gallery\log';
%Home
plot_path='E:\Git\gallery\log';

screen_sizes = [320 640 1024 2048 4096]

algorithms= {'\tptOTF' '\tptBackground' '\ownSrcSet' '\allgemein' '\ownSrcSetvalidate'}

algorithm=algorithms{1}

runs=[1];
for j=runs
    current_folder = fullfile([plot_path algorithm],'*.csv');
    dirListing = dir(current_folder);
    number_of_files = length(dirListing);

    
    
    for i=1:number_of_files
            current_file = fullfile([plot_path algorithm],dirListing(i).name)

            filename=strrep(dirListing(i).name, '.csv', '')
            filename=strrep(filename, 'mbit', '')

            fileID = fopen(current_file)
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


            for g=1:size(quality{j})
                check=quality{j}{g};
                if(strcmp(check,'small'))
                    qualityArray{j}(g)=1;
                end
                if(strcmp(check,'medium'))
                    qualityArray{j}(g)=2;
                end
                if(strcmp(check,'large'))
                   qualityArray{j}(g)=3;
                end
                if(strcmp(check,'xlarge'))
                    qualityArray{j}(g)=4;
                end
                if(strcmp(check,'uncompressed'))
                    qualityArray{j}(g)=5;
                    if(strcmp(algorithm,'\allgemein'))
                        qualityArray{j}(g)=6;
                    end
                end 

                if(strcmp(algorithm,'\ownSrcSet') || strcmp(algorithm,'\ownSrcSetvalidate'))
                    screensize{j}(g)=str2double(filename);
                end 
                if(strcmp(algorithm,'\tptBackground') || strcmp(algorithm,'\tptOTF'))
                    maxDLink{j}(g)=str2double(filename)
                end                                                    
            end

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
                set(gca,'YTick',Y);
                set(gca,'xscale','log')
                set(gca,'YTickLabel',{'Small' 'Medium' 'Large' 'X-Large' 'Original'}); ;
                set(gca,'XTickLabel',X);
                xlim([250 5000]);
                ylim([0.5 5.5]);
                xlabel('Screen Width');
                ylabel('Selected Qualities');           
                title ('Screen Resolution vs Selected Qualities');
                %handle = figure(2);
                %save2Files2([0 1 1], [plot_path '\\'], 'Allgemein', handle, 2);
            end

            if(strcmp(algorithm,'\ownSrcSetvalidate'))
                %Quality Modes vs Picture Size in KB
                figure(2); hold all; box on; 
                Y=[1 2 3 4 5];
                X=[320 640 1024 2064 4096];
                scatter(picNo{j}, qualityArray{j}, 'r', 'x');
                set(gca,'XTick',X);
                set(gca,'YTick',Y);
                %set(gca,'xscale','log')
                set(gca,'YTickLabel',{'Small' 'Medium' 'Large' 'X-Large' 'Original'}); ;
                set(gca,'XTickLabel',X);
                xlim([40 3500]);
                ylim([0.5 5.5]);
                xlabel('Screen Width');
                ylabel('Selected Quality');           
                title ('Screen Width vs Selected Quality');

                %plot([320 320], [0.5 5.5], 'LineWidth',2,'Color','black','LineStyle',':' );
                %plot([640 640], [0.5 5.5], 'LineWidth',2,'Color','black','LineStyle',':' );
                %plot([1024 1024], [0.5 5.5], 'LineWidth',2,'Color','black','LineStyle',':' );
                %plot([2048 2048], [0.5 5.5], 'LineWidth',2,'Color','black','LineStyle',':' );

                %handle = figure(2);
                %save2Files2([0 1 1], [plot_path '\\'], 'Allgemein', handle, 2);
            end

            if(strcmp(algorithm,'\tptBackground') || strcmp(algorithm,'\tptOTF'))
                %Max downlink speed vs Bildauflösung
                figure(2); hold all; box on; 
                Y=[1 2 3 4 5];
                X=[0.5 2 3 8 12];
                scatter (maxDLink{j}, qualityArray{j}, 'r');
                set(gca,'XTick',X);
                set(gca,'YTick',Y);
                %set(gca,'xscale','log')
                set(gca,'YTickLabel',{'Small' 'Medium' 'Large' 'X-Large' 'Original'}); ;
                set(gca,'XTickLabel',X);
                xlim([0 12.5]);
                ylim([0.5 5.5]);
                xlabel('Max Download Speed in Mbit');
                ylabel('Selected Qualities');           
                title ('Max Download Speed vs Selected Qualities');

            end

            if(strcmp(algorithm,'\tptOTF'))
            
                %Validate

                figure(3); hold all; box on; 
                Y=[1 2 3 4 5];
                %X=[0.5 2 3 8 12];
                scatter(tptKBsShift{j}, qualityArrayShift{j}, 'r', 'x');
                %set(gca,'XTick',X);
                set(gca,'YTick',Y);
                %set(gca,'xscale','log')
                set(gca,'YTickLabel',{'Small' 'Medium' 'Large' 'X-Large' 'Original'}); ;
                %set(gca,'XTickLabel',X);
                %xlim([0 12.5]);
                ylim([0.5 5.5]);
                plot([100 100], [0.5 5.5], 'LineWidth',2,'Color','black','LineStyle',':' );
                plot([300 300], [0.5 5.5], 'LineWidth',2,'Color','black','LineStyle',':' );
                plot([500 500], [0.5 5.5], 'LineWidth',2,'Color','black','LineStyle',':' );
                xlabel('Dl Speed of prev. Img in KB/s');
                ylabel('Selected Quality');           
                title ('Download Speed vs Selected Quality');
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
                title ('Quality Modes vs Picture Size in KB');
                print('-djpeg','Allgemein.jpg'); 
                handle = figure(2);
                save2Files2([0 1 1], [plot_path '\\'], 'Allgemein', handle, 2);
            end


    end
end

if(~(strcmp(algorithm,'\allgemein')))
    handle = figure(2);
    save2Files2([0 1 1], [plot_path '\\'], strrep(algorithm, '\\', ''), handle, 2);
end

if(strcmp(algorithm,'\tptOTF'))
    handle = figure(3);
    save2Files2([0 1 1], [plot_path '\\'], [strrep(algorithm, '\\', '') '_valid'], handle, 2);
    xxx=22
end