pkg load statistics 

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

[M,C]=nanmeanConfInt(tmp/3, 0.95, 1)

plot_path='E:\Git\gallery\Matlab';

figure(2); clf; hold all; box on; 

errorbar(1 ,M, C);

M-C
