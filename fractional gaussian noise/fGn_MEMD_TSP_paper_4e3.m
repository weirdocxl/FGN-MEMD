close all
clear all
clc

Fs = 4e3;
t = 0:1/Fs:1-1/Fs;
pspec = [];
ZC_H = [];
rho = [];

for H = [0.1:0.1:0.1]
    H
    ZC1 = [];
    spec1 = [];
    all_imfs =[];
    ffgnparam = [1,H,8,size(t,2),0];
    TE = [];
    
    for i = 1:2000
        close all
        x = ffgn(1,H,8,size(t,2),0);
        imf   = memd(x);
        spec   = filt_bank(imf);
        spec1   =  cat(4, spec1  , spec(1:8,1:500,1:9));
        [ZC]   = zero_crossing(imf);
        ZC1    = [ZC1 ZC(1:8,:)];
        all_imfs = cat(4,all_imfs, imf(1:8,1:9,:));
        
        TE = cat(3,TE,logElogT(imf));
    end
    close all
%     ZC_H = [ZC_H mean(ZC1,2)];
    outputFolder = '/home/ENGEP/ali.komaty/Bureau/Res_FGN_4e3'; % save data in this folder
    outputFilename = sprintf('%s/ZC1_MEMD=%d.mat', outputFolder, H*10);
    save(outputFilename, 'ZC1')
    outputFilename = sprintf('%s/pspec_4D_MEMD=%d.mat', outputFolder, H*10);
    save(outputFilename, 'spec1')
%     outputFilename = sprintf('%s/IMFs_FGN_4D_1000_MEMD=%d.mat', outputFolder, H*10);
%     save(outputFilename, 'all_imfs')
    pspec = mean(spec1,4);
    outputFilename = sprintf('%s/pspec_MEMD=%d.mat', outputFolder, H*10);
    save(outputFilename, 'pspec')
    plotSpect(pspec,'FGN',H)
    
    outputFilename = sprintf('%s/TE_H=%d.mat', outputFolder, H*10);
    save(outputFilename, 'TE')
    % estimation of rho
    all_dr = [];
    for i=1:size(ZC1,2)
        r = ZC1(:,i);
        dr = circshift(r,1)./r;% decrease rate
        all_dr = [all_dr dr(2:6)];
    end
    rho_H = mean(mean(all_dr),2);
    rho = [rho rho_H];
    
end
    outputFilename = sprintf('%s/rho.mat', outputFolder);
    save(outputFilename, 'rho')
% plotSpect(pspec,'FGN',ffgnparam)
% set(gcf, 'PaperPosition', [0 0 70 50]); %Position plot at left hand corner with width 5 and height 5.
% set(gcf, 'PaperSize', [70 50]); %Set the paper to have width 5 and height 5.
% print(gcf, '-dpdf', '-r300', 'filename.pdf')

%%
%%% Plot of ZC line %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(101)
% for i=0:size(ZC1,2)-1
%     plot(log2(ZC1(:,i+1)),'color',0.8*[1 1 1])
%     hold on,
% end
% %%
% m = log2(mean(ZC1,2));
% % a = [1 1;length(m) 1];
% % b = [m(1) m(8)]';
% % slope = inv(a)*b;
% a = [2:6];
% b = m(2:6)';
% slope = polyfit(a,b,1);
% ZC1 = log2(ZC1);
% hp = plot(1:length(m),m,'--k>',1:length(m),prctile(ZC1',95),...
%     '--go',1:length(m),prctile(ZC1',5),'--rs','LineWidth',2,'MarkerSize',8);
% legend(hp,'mean','95^{th} percentile','5^{th} percentile')
% % data8 = [m prctile(ZC1',95)' prctile(ZC1',5)'];
% % dlmwrite('ZCdata19.dat',data81);
% legend(hp,['slope=' num2str(slope(1))]);
% hx = xlabel('# IMF');
% hy = ylabel('Estimated \alpha');
% axis tight; grid off
% set(hx, 'FontSize', 14) 
% set(hx,'FontWeight','bold')
% set(hy, 'FontSize', 14) 
% set(hy,'FontWeight','bold')
% set(gca,'fontsize',14),hold on


%% Results of decrease rate in function of H
% H = [0.1:0.1:0.9];
% rho = [1.7446 1.7533 1.7583 1.7663 1.7713 1.7784 1.7828 1.7878 1.7938];
% p = polyfit(H,rho,2)
% f = polyval(p,H);
% plot(H,rho,':o',H,f,'-')
% hold on
% syms H
% factor(p(1)*H^2+p(2)*H+p(3))

% % % % plot of the fit function of Flandrin
% fct = @(H) 2.01+0.2*(H-0.5)+0.12*(H-0.5).^2;
% figure,
% fplot(fct,[0.1 0.9])

% % % % plot of the fit function of MEMD
% fct = @(H) 1.772+0.06*(H-0.5)-0.02*(H-0.5).^2;
% % fct = @(H) 1.762+0.065*(H-(1/3))-0.025*(H-(1/3)).^2+0.015*(H-(1/3)).^3;
% fplot(fct,[0.1 0.9])