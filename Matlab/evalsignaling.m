
tmp= [0.80
0.80
0.81
0.81
0.80
0.80
0.80
0.80
0.80
0.80]

[M,C]=nanmeanconfint(tmp/3, 0.95, 1)

plot_path='E:\Git\gallery\Matlab';

figure(2); clf; hold all; box on; 

errorbar(1 ,M, C);

M-C

%title ('Quality Modes vs Picture Size in KB');
print('-djpeg','Allgemein.jpg'); 
handle = figure(2);
save2Files2([0 1 1], [plot_path '\\'], 'contentasdasd', handle, 2);