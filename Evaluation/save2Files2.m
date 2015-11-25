function [ ] = save2Files2( save_as, path2image, fileName, handle, latexFigureCount )
%SAVE2FILES Summary of this function goes here
%   Detailed explanation goes here

%ti = get(gca,'TightInset')
%set(gca,'Position',[ti(1) ti(2) 1-ti(3)-ti(1) 1-ti(4)-ti(2)]);
%set(gca,'units','centimeters');

if save_as(2) == 1
    %saveas(handle, [path2image 'pics\fig\' fileName '.fig'],'fig');
    saveas(handle, [path2image 'pics\jpg\' fileName '.jpg'],'jpg');
end

if save_as(1) == 1
    disp([path2image 'eps\' fileName '.eps'])
    saveas(handle, [path2image 'pics\eps\' fileName '.eps'],'epsc');
    %print('-depsc','-tiff','-r600',[path2image 'eps\' fileName '.eps'])
end

if save_as(3) == 1
    if latexFigureCount == 1
        save2pdf([path2image 'pics\' fileName], handle, 600, 16, 1);
    elseif latexFigureCount == 2
        save2pdf([path2image 'pics\' fileName], handle, 600, 16, 2);
    elseif latexFigureCount == 3
        save2pdf([path2image 'pics\' fileName], handle, 600, 16, 3);
    elseif latexFigureCount > 3
        save2pdf([path2image 'pics\' fileName], handle, 600, 16, latexFigureCount);        
    end 
end
