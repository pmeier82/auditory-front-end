clear;
close all
clc


% Load a signal
load AFE_earSignals_16kHz

% Request ratemap    
requests = {'itd'};

cc_wSizeSec = 0.02;
cc_hSizeSec = 0.01;

% Parameters
par = genParStruct('gt_lowFreqHz',80,'gt_highFreqHz',8000,'gt_nChannels',32,'ihc_method','dau','cc_wSizeSec',cc_wSizeSec,'cc_hSizeSec',cc_hSizeSec); 

% Create a data object
dObj = dataObject(earSignals,fsHz);

% Create a manager
mObj = manager(dObj,requests,par);

% Request processing
mObj.processSignal();

sigL = [dObj.time{1}.Data(:)];
sigR = [dObj.time{2}.Data(:)];

timeSec = (1:numel(sigL))/fsHz;

itd = [dObj.itd{1}.Data(:)];
freqHz = dObj.itd{1}.cfHz;

[nFrames,nChannels] = size(itd);

wSizeSamples = 0.5 * round((cc_wSizeSec * fsHz * 2));
wStepSamples = round((cc_hSizeSec * fsHz));

tSec = (wSizeSamples + (0:nFrames-1)*wStepSamples)/fsHz;

figure;
hp = plot(timeSec(1:3:end),[sigR(1:3:end) sigL(1:3:end)]');
set(hp(1),'color',[0 0 0],'linewidth',2);
set(hp(2),'color',[0.5 0.5 0.5],'linewidth',2);
hl = legend({'Right ear' 'Left ear'});
hpos = get(hl,'position');
hpos(1) = hpos(1) * 0.95;
hpos(2) = hpos(2) * 0.975;
set(hl,'position',hpos);

xlabel('Time (sec)')
ylabel('Amplitude')
grid on
ylim([-1.25 1.25])
xlim([timeSec(1) timeSec(end)])
title('Time domain signals')

figure;
imagesc(tSec,1:nChannels,1E3*itd')
axis xy;
colorbar;
title('ITD')
xlabel('Time (s)')
ylabel('Center frequency (Hz)')

nYLabels = 8;
 
% Find the spacing for the y-axis which evenly divides the y-axis
set(gca,'ytick',linspace(1,nChannels,nYLabels));
set(gca,'yticklabel',round(interp1(1:nChannels,freqHz,linspace(1,nChannels,nYLabels))));


% fig2LaTeX(['ITD_01'],1,16);fig2LaTeX(['ITD_02'],2,16)

