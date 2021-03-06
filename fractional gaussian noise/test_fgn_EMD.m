close all
clear all
clc

Fs = 2^9;
t = 0:1/Fs:1-1/Fs;


psdx_matrix = [];
sum_psd_all_IMFs = zeros(7,Fs/2);
total = 0;
PSD_IMFs_all_H = [];
PSD_IMFs_Normalized_all_H = [];

for H = 0.1:0.1:0.9
    for i = 1:100
    x = ffgn(1,H,1,size(t,2),0);
    [freq,psdx] = psd_fft(x,Fs);
    psdx_matrix = [psdx_matrix; psdx];
    
    IMF = ceemdan(x,0.02,100,250);
%     IMF = IMF';
    psd_all_IMFs = [];

        if size(IMF,1)>=7
            total = total+1;
            for j=1:7
                [freq_IMF,psd_IMF] = psd_fft(IMF(j,:),Fs);
                psd_all_IMFs = [psd_all_IMFs; psd_IMF];
            end
            sum_psd_all_IMFs = sum_psd_all_IMFs + psd_all_IMFs;
        end
    end
    sum_psd_all_IMFs = sum_psd_all_IMFs/total;
    
    PSD_IMFs_all_H = cat(3,PSD_IMFs_all_H,sum_psd_all_IMFs);
    
    figure,
    for i=1:7
        cstring='rgbcmyk'; % color string
        plot(freq,sum_psd_all_IMFs(i,:),cstring(mod(i,7)+1)); grid on;
        hold on,
        legendInfo{i} = ['IMF_' num2str(i)];
    end
    title(['EMD -- H=',num2str(H)])
    xlabel('frequency')
    ylabel('Power Spectral Density')
    legend(legendInfo)
    
    
% % Normalized filter bank
% freqk = freq;
% Sk = sum_psd_all_IMFs(2,:);
% figure,loglog(freq,Sk,'k+-')
% rho = 2.01+0.2*(H-0.5)+0.12*(H-0.5)^2;
% a = 2*H-1;
% for i=1:6
%     Sk = downsample(Sk,2);
%     freqk = downsample(freqk,2);
%     Skp = rho^(a)*Sk;
%     loglog(freqk,Skp,'k+-')
%     hold on,
% end



% % I another Normalized filter bank
% freqk = freq;
% Sk = sum_psd_all_IMFs(2,:);
% figure,loglog(freqk,10*log(Sk),'k+-')
% rho = 2.01+0.2*(H-0.5)+0.12*(H-0.5)^2;
% a = 2*H-1;
% for i=1:6
%     a = -0.6;
%     Sk = sum_psd_all_IMFs(i+1,:);
%     Skp = rho^(a)*Sk;
%     freqk = rho*freqk;
%     loglog(freqk,10*log(Skp),'k+-')
%     title(['H=',num2str(H)]);
%     hold on,
% end

end
outputFolder = 'C:\Users\ZeinAli\Documents\Dropbox\';
% outputFolder = 'C:\Users\ali.komaty\Documents\MATLAB\11111Resultats th�se\FGN_filter_bank_like_Flandrin(PSD)';
outputFilename = sprintf('%s/PSD_IMFs_CEEMDAN_all_H.mat', outputFolder);
save(outputFilename, 'PSD_IMFs_all_H')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% n = 8;
% 
% sum_psd_all_IMFs = zeros(7,Fs/2);
% total = 0;
% PSD_IMFs_all_H = [];
% PSD_IMFs_Normalized_all_H = [];
% 
% for H = 0.1:0.1:0.9
%     for i = 1:100
%     x = ffgn(1,H,n,size(t,2),0);
%     [freq,psdx] = psd_fft(x,Fs);
%     
%     MIMF = memd(x);
%     sum_psd_all_IMFs1 = [];
%         for dim=1:n;
%             IMF = squeeze(MIMF(dim,:,:));
%             psd_all_IMFs = [];
% 
%                 if size(IMF,1)>=7
%                     total = total+1;
%                     for j=1:7
%                         [freq_IMF,psd_IMF] = psd_fft(IMF(j,:),Fs);
%                         psd_all_IMFs = [psd_all_IMFs; psd_IMF];
%                     end
%                     sum_psd_all_IMFs = sum_psd_all_IMFs + psd_all_IMFs;
%                 end
%         sum_psd_all_IMFs1 = cat(3,sum_psd_all_IMFs1,sum_psd_all_IMFs);
%         end
%         sum_psd_all_IMFs = mean(sum_psd_all_IMFs1,3);
%     sum_psd_all_IMFs1 = sum_psd_all_IMFs1/total;
%     end
%     PSD_IMFs_all_H = cat(4,PSD_IMFs_all_H,sum_psd_all_IMFs1);
%     
%     figure,
%         for i=1:7
%             cstring='rgbcmyk'; % color string
%             plot(freq,sum_psd_all_IMFs(i,:),cstring(mod(i,7)+1)); grid on;
%             hold on,
%             legendInfo{i} = ['IMF_' num2str(i)];
%         end
%     title(['MEMD -- H=',num2str(H)])
%     xlabel('frequency')
%     ylabel('Power Spectral Density')
%     legend(legendInfo)
%     
%     
% % Normalized filter bank
% freqk = freq;
% Sk = sum_psd_all_IMFs(2,:);
% figure,loglog(freq,Sk,'k+-')
% rho = 2.01+0.2*(H-0.5)+0.12*(H-0.5)^2;
% a = 2*H-1;
% for i=1:6
%     Sk = downsample(Sk,2);
%     freqk = downsample(freqk,2);
%     Skp = rho^(a)*Sk;
%     loglog(freqk,Skp,'k+-')
%     hold on,
% end
% 
% 
% 
% % I another Normalized filter bank
% freqk = freq;
% Sk = sum_psd_all_IMFs(2,:);
% figure,loglog(freqk,10*log(Sk),'k+-')
% rho = 2.01+0.2*(H-0.5)+0.12*(H-0.5)^2;
% a = 2*H-1;
% for i=1:6
%     a = -0.6;
%     Sk = sum_psd_all_IMFs(i+1,:);
%     Skp = rho^(a)*Sk;
%     freqk = rho*freqk;
%     loglog(freqk,10*log(Skp),'k+-')
%     title(['H=',num2str(H)]);
%     hold on,
% end
% 
% end
% outputFolder = 'C:\Users\ZeinAli\Documents\Dropbox\';
% %outputFolder = 'C:\Users\ali.komaty\Documents\MATLAB\11111Resultats th�se\FGN_filter_bank_like_Flandrin(PSD)';
% outputFilename = sprintf('%s/PSD_IMFs_MEMD_all_H.mat', outputFolder);
% save(outputFilename, 'PSD_IMFs_all_H')