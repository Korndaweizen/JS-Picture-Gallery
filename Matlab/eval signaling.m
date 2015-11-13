
tmp= [291.16
292.48
292.41
292.23
289.64
281.20
292.53
290.22
292.95
292.64]

[M,C]=nanmeanconfint(tmp, 0.93, 1)

plot_path='E:\Git\gallery\Matlab';

figure(2); clf; hold all; box on; 

errorbar(1 ,M, C);

%title ('Quality Modes vs Picture Size in KB');
print('-djpeg','Allgemein.jpg'); 
handle = figure(2);
save2Files2([0 1 1], [plot_path '\\'], 'contentasdasd', handle, 2);