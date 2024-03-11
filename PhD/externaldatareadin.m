clear all
close all
opengl software
addpath(genpath('C:\Program Files\MATLAB\R2016b\toolbox\altmany-export_fig-2763b78'))
addpath(genpath('C:\Program Files\MATLAB\R2016b\toolbox\useradded\append_pdfs'))
addpath(genpath('C:\Program Files\MATLAB\R2016b\toolbox\useradded\export_fig'))
plotting = figure;
set(gcf,'color','w');
set(plotting,'units','normalized','outerposition',[0 0 1 1]);
set(plotting,'PaperUnits','normalized','PaperPosition',[0 0 3 1]);
set(gcf,'renderer','painters')
colormap jet

numcont = 3;
jdtomjd=-2400000.5;

%constants
A_V_NaID_SN2010jl        = 0.03*3.1;
A_V_NaID_SN2011cc        = 0;
A_V_NaID_SN2011ht        = 0;
A_V_NaID_SN2012ab        = 0;
A_V_NaID_PTF11iqb        = 0;
A_V_NaID_SN2009ip        = 0;
A_V_NaID_SN2014ab        = 0.1756;
A_V_NaID_ASASSN14il      = 1.147522311678270;
A_V_NaID_MJ044212        = 0.180033758091385;
A_V_NaID_SN2015da        = 2.976;
A_V_NaID_SN2015bh        = 0.21*3.08;
A_V_NaID_J02331624       = 0;
A_V_NaID_SN2017gas       = 0.958302106473204;
%from Nathan's upcoming paper
A_V_NaID_SN2017hcc       = 0.016 *3.1;
A_V_NaID_SN2018zd        = 0.1021;

%reddening constraint on dataz.ISP from NaID
dataz.ISP_SN2014ab = 0.7498;
dataz.ISP_SN2012ab = 0.71;
%reddening constraint on dataz.ISP from Jon's paper https://ui.adsabs.harvard.edu/abs/2014MNRAS.442.1166M/abstract
dataz.ISP_SN2009ip  = 0.1;
%reddening constraint on dataz.ISP from Roming's paper https://iopscience.iop.org/article/10.1088/0004-637X/751/2/92/pdf
dataz.ISP_SN2011ht = 0.0;
%reddening constraint on dataz.ISP from Tartaglia's paper with multiple constraints https://ui.adsabs.harvard.edu/abs/2020A%26A...635A..39T/abstract
dataz.ISP_SN2015da  = 0.96*9;
%reddening constraint on dataz.ISP from Elias-Rosa's paper https://ui.adsabs.harvard.edu/abs/2016MNRAS.463.3894E/abstract , but the citation to Thone's paper does not show the calculation nor the result actually https://ui.adsabs.harvard.edu/abs/2017A%26A...599A.129T/abstract
dataz.ISP_SN2015bh  = 0.21*9;
%reddening constraint on dataz.ISP from Brajesh's paper https://ui.adsabs.harvard.edu/abs/2019MNRAS.488.3089K/abstract
dataz.ISP_SN2017hcc = A_V_NaID_SN2017hcc*9;
%reddening constraint on dataz.ISP from NaID
dataz.ISP_SN2018zd  = 1.0523;
%reddening constraint on dataz.ISP from Patat's paper https://ui.adsabs.harvard.edu/abs/2011A%26A...527L...6P/abstract
dataz.ISP_SN2010jl  = 0.03*9;

%%use NaID estimate code
%no SN2011cc data
dataz.ISP_SN2011cc = 0.1;
%PTF11iqb data is very late, many years after
dataz.ISP_PTF11iqb  = 0.1; %no reddening from Nathan's paper?
dataz.ISP_ASASSN14il= 3.531396365293645;
%data exists, but need to inspect if keeping first
dataz.ISP_MJ044212  = 3.714059682734566;
dataz.ISP_SN2017gas = 5.915168492941181;
%no J02331624 data?
dataz.ISP_J02331624 = 0.1;



%other published paper results
%SN 1997eg
%ref https://ui.adsabs.harvard.edu/abs/2008ApJ...688.1186H/abstract
%peak date very uncertain because there is no good estimate of the maximum (paper referenced just guesses at an expectation)
%so we use the discovery date as the peak date
%USING ISP CORRECTED VALUES
%externaldata.discoverydatejd
data_ext(1).name = 'SN1997eg';
data_ext(1).discoverydatejd = juliandate(1997,12,4);
data_ext(1).peakmagdatejd = juliandate(1997,12,4);
data_ext(1).contpoldate{1} = data_ext(1).discoverydatejd+16;
data_ext(1).contpolrange{1,1} = [4500 4600]
data_ext(1).contpolP{1,1} = 0.3;
data_ext(1).contpolPerr{1,1} = 0.1;
data_ext(1).contpolT{1,1} = 28;
data_ext(1).contpolTerr{1,1} = 2;
data_ext(1).contpolrange{1,2} = [5200 5500]
data_ext(1).contpolP{1,2} = 0.6;
data_ext(1).contpolPerr{1,2} = 0.1;
data_ext(1).contpolT{1,2} = 37;
data_ext(1).contpolTerr{1,2} = 2;
data_ext(1).contpolrange{1,3} = [6100 6200]
data_ext(1).contpolP{1,3} = 0.3;
data_ext(1).contpolPerr{1,3} = 0.1;
data_ext(1).contpolT{1,3} = 23;
data_ext(1).contpolTerr{1,3} = 2;
data_ext(1).contpolrange{1,4} = [4500 6200]
data_ext(1).contpolP{1,4} = 0.4;
data_ext(1).contpolPerr{1,4} = 0.1;
data_ext(1).contpolT{1,4} = 31;
data_ext(1).contpolTerr{1,4} = 2;
data_ext(1).contpoldate{2} = data_ext(1).discoverydatejd+44;
data_ext(1).contpolrange{2,1} = [4500 4600]
data_ext(1).contpolP{2,1} = 1.0;
data_ext(1).contpolPerr{2,1} = 0.1;
data_ext(1).contpolT{2,1} = 37;
data_ext(1).contpolTerr{2,1} = 2;
data_ext(1).contpolrange{2,2} = [5200 5500]
data_ext(1).contpolP{2,2} = 1.0;
data_ext(1).contpolPerr{2,2} = 0.1;
data_ext(1).contpolT{2,2} = 41;
data_ext(1).contpolTerr{2,2} = 2;
data_ext(1).contpolrange{2,3} = [6100 6200]
data_ext(1).contpolP{2,3} = 0.9;
data_ext(1).contpolPerr{2,3} = 0.1;
data_ext(1).contpolT{2,3} = 35;
data_ext(1).contpolTerr{2,3} = 2;
data_ext(1).contpolrange{2,4} = [4500 6200]
data_ext(1).contpolP{2,4} = 1.0;
data_ext(1).contpolPerr{2,4} = 0.1;
data_ext(1).contpolT{2,4} = 38;
data_ext(1).contpolTerr{2,4} = 2;
data_ext(1).contpoldate{3} = data_ext(1).discoverydatejd+93;
data_ext(1).contpolrange{3,1} = [4500 4600]
data_ext(1).contpolP{3,1} = 1.8;
data_ext(1).contpolPerr{3,1} = 0.1;
data_ext(1).contpolT{3,1} = 34;
data_ext(1).contpolTerr{3,1} = 2;
data_ext(1).contpolrange{3,2} = [5200 5500]
data_ext(1).contpolP{3,2} = 1.9;
data_ext(1).contpolPerr{3,2} = 0.1;
data_ext(1).contpolT{3,2} = 36;
data_ext(1).contpolTerr{3,2} = 2;
data_ext(1).contpolrange{3,3} = [6100 6200]
data_ext(1).contpolP{3,3} = 1.7;
data_ext(1).contpolPerr{3,3} = 0.1;
data_ext(1).contpolT{3,3} = 33;
data_ext(1).contpolTerr{3,3} = 2;
data_ext(1).contpolrange{3,4} = [4500 6200]
data_ext(1).contpolP{3,4} = 1.8;
data_ext(1).contpolPerr{3,4} = 0.1;
data_ext(1).contpolT{3,4} = 35;
data_ext(1).contpolTerr{3,4} = 2;


%SN 1998S
%ref https://ui.adsabs.harvard.edu/abs/2000ApJ...536..239L/abstract
%assuming broad lines unpolarized and narrow lines polarized: case (a)
%peak based on visual magnitude
%limit from 1998-02-23.7 means it was likely discovered soon after shock breakout
%ref for peak, see  Granslo et al. 1998 ; Garnavich et al. 1998c
%this accounts for ISP in the data which actually raises the continuum polarization estimate
data_ext(2).name = 'SN1998S';
data_ext(2).discoverydatejd = juliandate(1998,3,2.68)
data_ext(2).peakmagdatejd = juliandate(1998,3,20)
data_ext(2).contpoldate{1} = juliandate(1998,03,07)
data_ext(2).contpolrange{1,1} = [4300 6800]
data_ext(2).contpolP{1,1} = 3;
data_ext(2).contpolPerr{1,1} = NaN;
data_ext(2).contpolT{1,1} = 135;
data_ext(2).contpolTerr{1,1} = NaN;
%Wang ref https://ui.adsabs.harvard.edu/abs/2001ApJ...550.1030W/abstract
%this assumes a correct estimation of the ISP and are very rough polarization values as no specific values are quoted
data_ext(2).contpoldate{2} = juliandate(1998,03,30);
data_ext(2).contpolrange{2,1} = [4500 7500]
data_ext(2).contpolP{2,1} = 1;
data_ext(2).contpolPerr{2,1} = NaN;
data_ext(2).contpolT{2,1} = NaN;
data_ext(2).contpolTerr{2,1} = NaN;
data_ext(2).contpoldate{3} = juliandate(1998,05,01);
data_ext(2).contpolrange{3,1} = [4500 7500]
data_ext(2).contpolP{3,1} = 3; %zzz this number might be wrong
data_ext(2).contpolPerr{3,1} = NaN;
data_ext(2).contpolT{3,1} = NaN;
data_ext(2).contpolTerr{3,1} = NaN;


%quasi R band discovery is day 0 KAIT for 2006tf day 64 polarization


%SN 2006tf
%ref https://ui.adsabs.harvard.edu/abs/2008ApJ...686..467S/abstract
%explosion date might be long before discovery
%peak is in both V and R (maybe not after changing the date)
%depolarization at Balmer lines and OI 7774, especially in the broad blueshifted components
%ISP not removed
data_ext(3).name = 'SN2006tf';
data_ext(3).discoverydatejd = juliandate(2006,12,12.48);
data_ext(3).peakmagdatejd = juliandate(2006,12,12.48);
data_ext(3).contpoldate{1} = data_ext(3).discoverydatejd + 64;
data_ext(3).contpolrange{1,1} = [5050 5950];
data_ext(3).contpolP{1,1} = 0.91;
data_ext(3).contpolPerr{1,1} = 0.03;
data_ext(3).contpolT{1,1} = 135.4;
data_ext(3).contpolTerr{1,1} = 0.8;

%SN 2010jl
%ref https://ui.adsabs.harvard.edu/abs/2011A%26A...527L...6P/abstract
%https://sne.space/sne/SN2010jl/ V
%depolarization of Halpha (and Hbeta, Hgamma, and He I 5876) primarily in the narrow and intermediate components
%ref for peak, V band peak https://iopscience.iop.org/article/10.1088/0004-637X/730/1/34/pdf
%ISP considered negligible, so not corrected for in the data
data_ext(4).name = 'SN2010jl';
data_ext(4).discoverydatejd = juliandate(2010,11,02.06);
data_ext(4).peakmagdatejd = 5488.12+2450000;
data_ext(4).contpoldate{1} = juliandate(2010,11,18.2);
data_ext(4).contpolrange{1,1} = [3800 4600];
data_ext(4).contpolP{1,1} = 2;
data_ext(4).contpolPerr{1,1} = 0.04;
data_ext(4).contpolT{1,1} = 140.9;
data_ext(4).contpolTerr{1,1} = 0.9;
data_ext(4).contpolrange{1,2} = [5000 5600];
data_ext(4).contpolP{1,2} = 2.02;
data_ext(4).contpolPerr{1,2} = 0.05;
data_ext(4).contpolT{1,2} = 132.1;
data_ext(4).contpolTerr{1,2} = 1.0;
data_ext(4).contpolrange{1,3} = [6900 8400];
data_ext(4).contpolP{1,3} = 1.67;
data_ext(4).contpolPerr{1,3} = 0.03;
data_ext(4).contpolT{1,3} = 136.0;
data_ext(4).contpolTerr{1,3} = 0.9;
%ref https://ui.adsabs.harvard.edu/abs/2019BAAA...61...90Q/abstract
%this is estimated range, but they use many gaps for lines and average the entire continuum across many regions
%not clear if the ISP correction was applied to these continuum estimates.  They say they use the P_ISP to correct the data, but they plot uncorrected data which seems to match the cont P values.
data_ext(4).contpoldate{2} = juliandate(2010,10,1)+44;
data_ext(4).contpolrange{2,1} = [4500 8000];
data_ext(4).contpolP{2,1} = 1.80;
data_ext(4).contpolPerr{2,1} = 0.01;
data_ext(4).contpolT{2,1} = 135.8;
data_ext(4).contpolTerr{2,1} = NaN;
data_ext(4).contpolrange{3,1} = [4500 8000];
data_ext(4).contpoldate{3} = juliandate(2010,10,1)+93;
data_ext(4).contpolPerr{3,1} = 0.01;
data_ext(4).contpolP{3,1} = 1.41;
data_ext(4).contpolT{3,1} = 137.6;
data_ext(4).contpolTerr{3,1} = NaN;
data_ext(4).contpoldate{4} = juliandate(2010,10,1)+542;
data_ext(4).contpolrange{4,1} = [4500 8000];
data_ext(4).contpolP{4,1} = 0.39;
data_ext(4).contpolPerr{4,1} = 0.01;
data_ext(4).contpolT{4,1} = 19.3;
data_ext(4).contpolTerr{4,1} = NaN;


%SN 2009ip
%ref for peak https://sne.space/sne/SN2009ip/ has very good data for all bands, using R preferably though
%ref https://ui.adsabs.harvard.edu/abs/2014MNRAS.442.1166M/abstract for contpol data
%ISP is considered to be negligible 
data_ext(5).name = 'SN2009ip';
data_ext(5).discoverydatejd = juliandate(2012,07,24.0);
data_ext(5).peakmagdatejd = 56207.22-jdtomjd;
data_ext(5).contpoldate{1} = 2456207.72-3;
data_ext(5).contpolrange{1,1} = [5200 5500];
data_ext(5).contpolP{1,1} = 0.81;
data_ext(5).contpolPerr{1,1} = 0.07;
data_ext(5).contpolT{1,1} = NaN;
data_ext(5).contpolTerr{1,1} = NaN;
data_ext(5).contpolrange{1,2} = [6100 6200];
data_ext(5).contpolP{1,2} = 1.03;
data_ext(5).contpolPerr{1,2} = 0.10;
data_ext(5).contpolT{1,2} = NaN;
data_ext(5).contpolTerr{1,2} = NaN;
data_ext(5).contpolrange{1,3} = [5050 5950];
data_ext(5).contpolP{1,3} = 0.84;
data_ext(5).contpolPerr{1,3} = 0.12;
data_ext(5).contpolT{1,3} = 81;
data_ext(5).contpolTerr{1,3} = 4;
data_ext(5).contpoldate{2} = 2456207.72+7;
data_ext(5).contpolrange{2,1} = [5200 5500];
data_ext(5).contpolP{2,1} = 1.75;
data_ext(5).contpolPerr{2,1} = 0.05;
data_ext(5).contpolT{2,1} = NaN;
data_ext(5).contpolTerr{2,1} = NaN;
data_ext(5).contpolrange{2,2} = [6100 6200];
data_ext(5).contpolP{2,2} = 1.65;
data_ext(5).contpolPerr{2,2} = 0.05;
data_ext(5).contpolT{2,2} = NaN;
data_ext(5).contpolTerr{2,2} = NaN;
data_ext(5).contpolrange{2,3} = [5050 5950];
data_ext(5).contpolP{2,3} = 1.73;
data_ext(5).contpolPerr{2,3} = 0.05;
data_ext(5).contpolT{2,3} = 72;
data_ext(5).contpolTerr{2,3} = 1;
data_ext(5).contpoldate{3} = 2456207.72+30;
data_ext(5).contpolrange{3,1} = [5200 5500];
data_ext(5).contpolP{3,1} = 0.76;
data_ext(5).contpolPerr{3,1} = 0.04;
data_ext(5).contpolT{3,1} = NaN;
data_ext(5).contpolTerr{3,1} = NaN;
data_ext(5).contpolrange{3,2} = [6100 6200];
data_ext(5).contpolP{3,2} = 0.71;
data_ext(5).contpolPerr{3,2} = 0.07;
data_ext(5).contpolT{3,2} = NaN;
data_ext(5).contpolTerr{3,2} = NaN;
data_ext(5).contpolrange{3,3} = [5050 5950];
data_ext(5).contpolP{3,3} = 0.72;
data_ext(5).contpolPerr{3,3} = 0.06;
data_ext(5).contpolT{3,3} = 49;
data_ext(5).contpolTerr{3,3} = 3;
data_ext(5).contpoldate{4} = 2456207.72+31;
data_ext(5).contpolrange{4,1} = [5200 5500];
data_ext(5).contpolP{4,1} = 0.67;
data_ext(5).contpolPerr{4,1} = 0.04;
data_ext(5).contpolT{4,1} = NaN;
data_ext(5).contpolTerr{4,1} = NaN;
data_ext(5).contpolrange{4,2} = [6100 6200];
data_ext(5).contpolP{4,2} = 0.70;
data_ext(5).contpolPerr{4,2} = 0.05;
data_ext(5).contpolT{4,2} = NaN;
data_ext(5).contpolTerr{4,2} = NaN;
data_ext(5).contpolrange{4,3} = [5050 5950];
data_ext(5).contpolP{4,3} = 0.69;
data_ext(5).contpolPerr{4,3} = 0.03;
data_ext(5).contpolT{4,3} = 47;
data_ext(5).contpolTerr{4,3} = 2;
data_ext(5).contpoldate{5} = 2456207.72+38;
data_ext(5).contpolrange{5,1} = [5200 5500];
data_ext(5).contpolP{5,1} = 0.52;
data_ext(5).contpolPerr{5,1} = 0.13;
data_ext(5).contpolT{5,1} = NaN;
data_ext(5).contpolTerr{5,1} = NaN;
data_ext(5).contpolrange{5,2} = [6100 6200];
data_ext(5).contpolP{5,2} = NaN;
data_ext(5).contpolPerr{5,2} = NaN;
data_ext(5).contpolT{5,2} = NaN;
data_ext(5).contpolTerr{5,2} = NaN;
data_ext(5).contpolrange{5,3} = [5050 5950];
data_ext(5).contpolP{5,3} = 0.64;
data_ext(5).contpolPerr{5,3} = 0.09;
data_ext(5).contpolT{5,3} = 66;
data_ext(5).contpolTerr{5,3} = 6;
data_ext(5).contpoldate{6} = 2456207.72+60;
data_ext(5).contpolrange{6,1} = [5200 5500];
data_ext(5).contpolP{6,1} = 0.16;
data_ext(5).contpolPerr{6,1} = 0.04;
data_ext(5).contpolT{6,1} = NaN;
data_ext(5).contpolTerr{6,1} = NaN;
data_ext(5).contpolrange{6,2} = [6100 6200];
data_ext(5).contpolP{6,2} = 0.60;
data_ext(5).contpolPerr{6,2} = 0.05;
data_ext(5).contpolT{6,2} = NaN;
data_ext(5).contpolTerr{6,2} = NaN;
data_ext(5).contpolrange{6,3} = [5050 5950];
data_ext(5).contpolP{6,3} = 0.41;
data_ext(5).contpolPerr{6,3} = 0.04;
data_ext(5).contpolT{6,3} = 122;
data_ext(5).contpolTerr{6,3} = 2;
data_ext(5).contpoldate{7} = 2456207.72+64;
data_ext(5).contpolrange{7,1} = [5200 5500];
data_ext(5).contpolP{7,1} = NaN;
data_ext(5).contpolPerr{7,1} = NaN;
data_ext(5).contpolT{7,1} = NaN;
data_ext(5).contpolTerr{7,1} = NaN;
data_ext(5).contpolrange{7,2} = [6100 6200];
data_ext(5).contpolP{7,2} = 0.56;
data_ext(5).contpolPerr{7,2} = 0.06;
data_ext(5).contpolT{7,2} = 132;
data_ext(5).contpolTerr{7,2} = 3;
data_ext(5).contpolrange{7,3} = [5050 5950];
data_ext(5).contpolP{7,3} = NaN;
data_ext(5).contpolPerr{7,3} = NaN;
data_ext(5).contpolT{7,3} = NaN;
data_ext(5).contpolTerr{7,3} = NaN;


%ref https://ui.adsabs.harvard.edu/abs/2017MNRAS.470.1491R/abstract
%very complicated analysis of many line features, suggesting the lower part of figure 11 with a CSM region inclined out of line
%of sight by 14° from edge-on along with a photosphere that is prolate with respect to the long axis of the CSM.
%the continuum ranges are actually spread all over the spectrum and added together, so its very imprecise a range to compare to
%300V resolution grating comes first when both dates are the same (first two epochs) as the 1200R grating
data_ext(6).name = 'SN2009ip';
data_ext(6).discoverydatejd = juliandate(2012,07,24.0);
data_ext(6).peakmagdatejd = 56207.22-jdtomjd;
data_ext(6).contpoldate{1} = juliandate(2012,10,03)+35;
data_ext(6).contpolrange{1,1} = [5800 7200];
data_ext(6).contpolP{1,1} = 0.76;
data_ext(6).contpolPerr{1,1} = 0.21;
data_ext(6).contpolT{1,1} = 47;
data_ext(6).contpolTerr{1,1} = 8;
data_ext(6).contpoldate{2} = juliandate(2012,10,03)+35;
data_ext(6).contpolrange{2,1} = [5800 7200];
data_ext(6).contpolP{2,1} = 0.69;
data_ext(6).contpolPerr{2,1} = 0.20;
data_ext(6).contpolT{2,1} = 41;
data_ext(6).contpolTerr{2,1} = 8;
data_ext(6).contpoldate{3} = juliandate(2012,10,03)+42;
data_ext(6).contpolrange{3,1} = [5800 7200];
data_ext(6).contpolP{3,1} = 0.37;
data_ext(6).contpolPerr{3,1} = 0.30;
data_ext(6).contpolT{3,1} = 57;
data_ext(6).contpolTerr{3,1} = 21;
data_ext(6).contpoldate{4} = juliandate(2012,10,03)+42;
data_ext(6).contpolrange{4,1} = [5800 7200];
data_ext(6).contpolP{4,1} = 0.33;
data_ext(6).contpolPerr{4,1} = 0.26;
data_ext(6).contpolT{4,1} = 63;
data_ext(6).contpolTerr{4,1} = 20;
data_ext(6).contpoldate{5} = juliandate(2012,10,03)+64;
data_ext(6).contpolrange{5,1} = [5800 7200];
data_ext(6).contpolP{5,1} = 0.29;
data_ext(6).contpolPerr{5,1} = 0.24;
data_ext(6).contpolT{5,1} = 100;
data_ext(6).contpolTerr{5,1} = 15;
data_ext(6).contpoldate{6} = juliandate(2012,10,03)+68;
data_ext(6).contpolrange{6,1} = [5800 7200];
data_ext(6).contpolP{6,1} = 0.48;
data_ext(6).contpolPerr{6,1} = 0.39;
data_ext(6).contpolT{6,1} = 119;
data_ext(6).contpolTerr{6,1} = 22;
data_ext(6).contpoldate{7} = juliandate(2012,10,03)+73;
data_ext(6).contpolrange{7,1} = [5800 7200];
data_ext(6).contpolP{7,1} = 0.66;
data_ext(6).contpolPerr{7,1} = 0.55;
data_ext(6).contpolT{7,1} = 89;
data_ext(6).contpolTerr{7,1} = 21;
data_ext(6).contpoldate{8} = juliandate(2012,10,03)+83;
data_ext(6).contpolrange{8,1} = [5800 7200];
data_ext(6).contpolP{8,1} = 0.78;
data_ext(6).contpolPerr{8,1} = 1.07;
data_ext(6).contpolT{8,1} = 149;
data_ext(6).contpolTerr{8,1} = 39;

%SN 2012ab
%ours

%SN 2014ab
%ours

%SN 2017hcc
%ref https://ui.adsabs.harvard.edu/abs/2019MNRAS.488.3089K/abstract
%and jon's ATEL is included in the above ref, giving the first data point in V band found in:
%ref https://ui.adsabs.harvard.edu/abs/2017ATel10911....1M/abstract
data_ext(7).name = 'SN2017hcc';
data_ext(7).discoverydatejd = juliandate(   2017,10,02.378   );
data_ext(7).peakmagdatejd = 2091.60 +2456000;
data_ext(7).contpoldate{1} = 2458056.5;
data_ext(7).contpolrange{1,1} = [5510-880/2 5510+880/2];
data_ext(7).contpolP{1,1} = 4.84;
data_ext(7).contpolPerr{1,1} = 0.02;
data_ext(7).contpolT{1,1} = 96.5;
data_ext(7).contpolTerr{1,1} = 0.1;
data_ext(7).contpoldate{2} = 2458067.1;
data_ext(7).contpolrange{2,1} = [6580-1380/2 6580+1380/2];
data_ext(7).contpolP{2,1} = 3.22;
data_ext(7).contpolPerr{2,1} = 0.13;
data_ext(7).contpolT{2,1} = 95;
data_ext(7).contpolTerr{2,1} = 1.4;
data_ext(7).contpoldate{3} = 2458110.0;
data_ext(7).contpolrange{3,1} = [6580-1380/2 6580+1380/2];
data_ext(7).contpolP{3,1} = 1.35;
data_ext(7).contpolPerr{3,1} = 0.20;
data_ext(7).contpolT{3,1} = 101.4;
data_ext(7).contpolTerr{3,1} = 4.7;
data_ext(7).contpoldate{4} = 2458113.1;
data_ext(7).contpolrange{4,1} = [5510-880/2 5510+880/2];
data_ext(7).contpolP{4,1} = 1.36;
data_ext(7).contpolPerr{4,1} = 0.10;
data_ext(7).contpolT{4,1} = 100.8;
data_ext(7).contpolTerr{4,1} = 2.2;















%ISP values for SNe

%SN 2017hcc
q_ISP = 0.032;
q_ISP_err = 0.018;
u_ISP = -0.170;
u_ISP_err = 0.019;


















%if 3
[data_contpol.contpol{1} data_contpol.contpolsig{1} data_contpol.conttheta{1} data_contpol.contthetasig{1} data_contpol.contq{1} data_contpol.contqsig{1} data_contpol.contu{1} data_contpol.contusig{1} data_contpol.wave{1} data_contpol.contpol{2} data_contpol.contpolsig{2} data_contpol.conttheta{2} data_contpol.contthetasig{2} data_contpol.contq{2} data_contpol.contqsig{2} data_contpol.contu{2} data_contpol.contusig{2} data_contpol.wave{2} data_contpol.contpol{3} data_contpol.contpolsig{3} data_contpol.conttheta{3} data_contpol.contthetasig{3} data_contpol.contq{3} data_contpol.contqsig{3} data_contpol.contu{3} data_contpol.contusig{3} data_contpol.wave{3} data_contpol.reldate data_contpol.name data_contpol.tel data_contpol.ins data_contpol.date] = textread('..\data\data_contpol_ptqu.txt','%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %s %s %s %s','delimiter',' ');

[data_FW.FW data_FW.Halphafluxtot data_FW.name data_FW.tel data_FW.reldate] = textread('..\data\data_FW.txt','%f %f %s %s %f','delimiter',' ');

[data_FW.FW data_FW.name data_FW.tel data_FW.reldate] = textread('..\data\data_FW.txt','%f %s %s %f','delimiter',' ');


%colors need fixing on lines/errorbars
%QU MIGRATION PLOTS

snnames = unique(data_contpol.name);
colormatrix = distinguishable_colors(size(snnames,1));
markerlist = ['o', '+', '*', '.', 'x', 's', 'd', '^', 'v', '>', '<', 'p', 'h'];

for i=1:length(unique(data_contpol.name))
	clf
	hold all
	data.numepochs(i) = size(data_contpol.contq{1}(find(strcmp(data_contpol.name,snnames(i)))),1);
	%in percent
	
	if(data.numepochs(i) > 3)
		colormatrix(i,4) = 1;
	else
		colormatrix(i,4) = 0.25;
	end

	for j=1:numcont
		qval(i,j,[1:data.numepochs(i)]) = 100.*data_contpol.contq{j}(find(strcmp(data_contpol.name,snnames(i))));
		uval(i,j,[1:data.numepochs(i)]) = 100.*data_contpol.contu{j}(find(strcmp(data_contpol.name,snnames(i))));
		qval_err(i,j,[1:data.numepochs(i)]) = 100.*data_contpol.contqsig{j}(find(strcmp(data_contpol.name,snnames(i))));
		uval_err(i,j,[1:data.numepochs(i)]) = 100.*data_contpol.contusig{j}(find(strcmp(data_contpol.name,snnames(i))));
	
	
	
	
	
		plot(100.*data_contpol.contq{j}(find(strcmp(data_contpol.name,snnames(i)))),100.*data_contpol.contu{j}(find(strcmp(data_contpol.name,snnames(i)))),'Color',[colormatrix(j,1) colormatrix(j,2) colormatrix(j,3)])
		for k=1:data.numepochs(i)
			errorbar(qval(i,j,k), uval(i,j,k), uval_err(i,j,k), uval_err(i,j,k), qval_err(i,j,k), qval_err(i,j,k), 'Color',[colormatrix(j,1) colormatrix(j,2) colormatrix(j,3)],'Marker',markerlist(k),'MarkerSize',25)
		end
		
	end

	if (strcmp(snnames(i),'SN2009ip'))
		clear Halphafluxtot
	Halphafluxtot = data_FW.Halphafluxtot(find(strcmp(data_FW.name,snnames(i))));
	qvalpred(i,1) = (((Halphafluxtot(2)+3) * qval(i,3,1)) - (3 * qval(i,2,1)))/Halphafluxtot(2);
	uvalpred(i,1) = (((Halphafluxtot(2)+3) * uval(i,3,1)) - (3 * uval(i,2,1)))/Halphafluxtot(2);
	scatter(qvalpred(i,1),uvalpred(i,1),400,[0 0 0])
	scatter(qvalpred(i,1),uvalpred(i,1),200,[0 0 0])
	qvalpred(i,1)
	uvalpred(i,1)
	%qvalpred(i,[1:data.numepochs(i)]) = (data_FW.Halphafluxtot(find(strcmp(data_FW.name,snnames(i))))+3) .* qval(i,3,[1:data.numepochs(i)])'
	%data_FW.Halphafluxtot(find(strcmp(data_FW.name,snnames(i))))
	else
		clear Halphafluxtot
	Halphafluxtot = data_FW.Halphafluxtot(find(strcmp(data_FW.name,snnames(i))));
	qvalpred(i,1) = (((Halphafluxtot(1)+3) * qval(i,3,1)) - (3 * qval(i,2,1)))/Halphafluxtot(1);
	uvalpred(i,1) = (((Halphafluxtot(1)+3) * uval(i,3,1)) - (3 * uval(i,2,1)))/Halphafluxtot(1);
	scatter(qvalpred(i,1),uvalpred(i,1),400,[0 0 0])
	scatter(qvalpred(i,1),uvalpred(i,1),200,[0 0 0])
	%qvalpred(i,[1:data.numepochs(i)]) = (data_FW.Halphafluxtot(find(strcmp(data_FW.name,snnames(i))))+3) .* qval(i,3,[1:data.numepochs(i)])'
	%data_FW.Halphafluxtot(find(strcmp(data_FW.name,snnames(i))))
	end
	
	box on
	blah1 = line([-10 10],[0 0],'LineStyle','--','Color',[0 0 0]);
	blah2 = line([0 0],[-10 10],'LineStyle','--','Color',[0 0 0]);
	xlabel('Integrated q (\%)','FontSize',28,'interpreter','latex')
	ylabel('Integrated u (\%)','FontSize',28,'interpreter','latex')
		
	text((0.1+max(max(qval(i,:,:)))) - ((0.1+max(max(qval(i,:,:)))) - (-0.1+min(min(qval(i,:,:)))))*0.2,(0.1+max(max(uval(i,:,:)))) - ((0.1+max(max(uval(i,:,:)))) - (-0.1+min(min(uval(i,:,:)))))*0.1,snnames(i),'interpreter','LaTex','FontSize',38,'Color',[0 0 0])
	text((0.1+max(max(qval(i,:,:)))) - ((0.1+max(max(qval(i,:,:)))) - (-0.1+min(min(qval(i,:,:)))))*0.2,(0.1+max(max(uval(i,:,:)))) - ((0.1+max(max(uval(i,:,:)))) - (-0.1+min(min(uval(i,:,:)))))*0.2,'5100-5700 $\rm{\AA}$','interpreter','LaTex','FontSize',38,'Color',[colormatrix(1,1) colormatrix(1,2) colormatrix(1,3)])
	text((0.1+max(max(qval(i,:,:)))) - ((0.1+max(max(qval(i,:,:)))) - (-0.1+min(min(qval(i,:,:)))))*0.2,(0.1+max(max(uval(i,:,:)))) - ((0.1+max(max(uval(i,:,:)))) - (-0.1+min(min(uval(i,:,:)))))*0.3,'6000-6300 $\rm{\AA}$','interpreter','LaTex','FontSize',38,'Color',[colormatrix(2,1) colormatrix(2,2) colormatrix(2,3)])
	text((0.1+max(max(qval(i,:,:)))) - ((0.1+max(max(qval(i,:,:)))) - (-0.1+min(min(qval(i,:,:)))))*0.2,(0.1+max(max(uval(i,:,:)))) - ((0.1+max(max(uval(i,:,:)))) - (-0.1+min(min(uval(i,:,:)))))*0.4,'Narrow H$\alpha$','interpreter','LaTex','FontSize',38,'Color',[colormatrix(3,1) colormatrix(3,2) colormatrix(3,3)])
	ax1 = gca;
	set(ax1,'FontSize',36)
	set(ax1,'XMinorTick','on','YMinorTick','on')
	axis([[-0.1+min(min(qval(i,:,:))) 0.1+max(max(qval(i,:,:)))] [-0.1+min(min(uval(i,:,:))) 0.1+max(max(uval(i,:,:)))]])

	%[~, objh] = legend([s1, s2, s3, s4, s5],{'Epoch 1','Epoch 2','Epoch 3','Epoch 4','Epoch 5'},'FontSize',38)
	%objhl = findobj(objh, 'type', 'patch'); %// objects of legend of type line
	%set(objhl, 'Markersize', 20); %// set marker size as desired

	filename_qumigration(i) = strcat('C:\Users\Cbilinski\Desktop\Figures\newplots_peakdate\qumigration_narrowhalpha',snnames(i),'.pdf');
	export_fig(char(filename_qumigration(i)))
end

%

clf
for i=1:length(unique(data_contpol.name))
	hold all
	sc(i) = scatter(100*data_contpol.contpol{1}(find(strcmp(data_contpol.name,snnames(i)))), data_FW.FW(find(strcmp(data_FW.name,snnames(i)))),200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled')
	box on
end


xlabel('Continuum Polarization 5100-5700 (\%)','FontSize',28,'interpreter','latex')
ylabel('Full Width at 20\% Max','FontSize',28,'interpreter','latex')
ax1 = gca;
set(ax1,'FontSize',36)
set(ax1,'XMinorTick','on','YMinorTick','on')
[~, objh] = legend(sc,unique(data_contpol.name),'FontSize', 24,'Location','NorthEast');
objhl = findobj(objh, 'type', 'patch'); %// objects of legend of type line
set(objhl, 'Markersize', 20); %// set marker size as desired






clf
for i=1:length(unique(data_contpol.name))
	hold all
	sc(i) = scatter(data_FW.reldate(find(strcmp(data_contpol.name,snnames(i)))), data_FW.FW(find(strcmp(data_FW.name,snnames(i)))),200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled')
	box on
end

xlabel('Days Relative to Peak','FontSize',28,'interpreter','latex')
ylabel('Full Width at 20\% Max','FontSize',28,'interpreter','latex')
ax1 = gca;
set(ax1,'FontSize',36)
set(ax1,'XMinorTick','on','YMinorTick','on')
[~, objh] = legend(sc,unique(data_contpol.name),'FontSize', 24,'Location','NorthEast');
objhl = findobj(objh, 'type', 'patch'); %// objects of legend of type line
set(objhl, 'Markersize', 20); %// set marker size as desired



















%contpolp plots
clf
for i=1:length(unique(datacontpol.name))
	axis([[-100 200] [0 6]])
	%initialize dataz.numpoints
	dataz.numpoints(i) = 0;
	for j=1:size(datacontpol.name,1)
		if(strcmp(datacontpol.name(j),snnames_sorted(i)))
			dataz.numpoints(i) = dataz.numpoints(i) + 1;
		end
	end
	if(dataz.numpoints(i) > 3)
		colormatrix_sorted_sorted(i,4) = 1;
	else
		colormatrix_sorted_sorted(i,4) = 0.25
	end
	%days since peak
	%polarization in %
	if(isempty(datacontpol.reldate_peak(find(strcmp(datacontpol.name,snnames_sorted(i)) & strcmp(datacontpol.tel,'Kuiper')))))
		dataz.Kuiperdates{i} = [NaN];
		dataz.Kuipererr_pol{i} = [NaN];
	else
		dataz.Kuiperdates{i} = datacontpol.reldate_peak(find(strcmp(datacontpol.name,snnames_sorted(i)) & strcmp(datacontpol.tel,'Kuiper')));
		dataz.Kuipererr_pol{i} = 100*datacontpol.p1(find(strcmp(datacontpol.name,snnames_sorted(i)) & strcmp(datacontpol.tel,'Kuiper')));
	end
	
	if(isempty(datacontpol.reldate_peak(find(strcmp(datacontpol.name,snnames_sorted(i)) & strcmp(datacontpol.tel,'Bok')))))
		dataz.Bokdates{i} = [NaN];
		dataz.Bokerr_pol{i} = [NaN];
	else
		dataz.Bokdates{i} = datacontpol.reldate_peak(find(strcmp(datacontpol.name,snnames_sorted(i)) & strcmp(datacontpol.tel,'Bok')));
		dataz.Bokerr_pol{i} = 100*datacontpol.p1(find(strcmp(datacontpol.name,snnames_sorted(i)) & strcmp(datacontpol.tel,'Bok')));
	end
	if(isempty(datacontpol.reldate_peak(find(strcmp(datacontpol.name,snnames_sorted(i)) & strcmp(datacontpol.tel,'MMT')))))
		dataz.MMTdates{i} = [NaN];
		dataz.MMTerr_pol{i} = [NaN];
	else
		dataz.MMTdates{i} = datacontpol.reldate_peak(find(strcmp(datacontpol.name,snnames_sorted(i)) & strcmp(datacontpol.tel,'MMT')));
		dataz.MMTerr_pol{i} = 100*datacontpol.p1(find(strcmp(datacontpol.name,snnames_sorted(i)) & strcmp(datacontpol.tel,'MMT')));
	end

	pl(i) = plot(datacontpol.reldate_peak(find(strcmp(datacontpol.name,snnames_sorted(i)))),100*datacontpol.p1(find(strcmp(datacontpol.name,snnames_sorted(i)))),'-','LineWidth',1,'Color',[colormatrix_sorted(i,1) colormatrix_sorted(i,2) colormatrix_sorted(i,3)]);
	hold all
	sc1(i) = scatter(dataz.Kuiperdates{i},dataz.Kuipererr_pol{i},200,[colormatrix_sorted(i,1) colormatrix_sorted(i,2) colormatrix_sorted(i,3)],'filled','o');
	sc2(i) = scatter(dataz.Bokdates{i}   ,dataz.Bokerr_pol{i}   ,200,[colormatrix_sorted(i,1) colormatrix_sorted(i,2) colormatrix_sorted(i,3)],'filled','s');
	sc3(i) = scatter(dataz.MMTdates{i}   ,dataz.MMTerr_pol{i}   ,200,[colormatrix_sorted(i,1) colormatrix_sorted(i,2) colormatrix_sorted(i,3)],'filled','d');
	
	er1_ISP(i) = errorbar(dataz.Kuiperdates{i},dataz.Kuipererr_pol{i},ones(1,size(dataz.Kuipererr_pol{i},1)).* dataz.(['ISP_' char(datacontpol.name{i})]),'Color','k');
	er1_ISP(i).LineStyle = 'none';
	er2_ISP(i) = errorbar(dataz.Bokdates{i}   ,dataz.Bokerr_pol{i}   ,ones(1,size(dataz.Bokerr_pol{i},1)).* dataz.(['ISP_' char(datacontpol.name{i})]),'Color','k');
	er2_ISP(i).LineStyle = 'none';
	er3_ISP(i) = errorbar(dataz.MMTdates{i}   ,dataz.MMTerr_pol{i}   ,ones(1,size(dataz.MMTerr_pol{i},1)).* dataz.(['ISP_' char(datacontpol.name{i})]),'Color','k');
	er3_ISP(i).LineStyle = 'none';
	
	%er1_stat(i) = errorbar(dataz.Kuiperdates{i},dataz.Kuipererr_pol{i},100*datacontpol.contpolsig{1}(find(strcmp(datacontpol.name,snnames_sorted(i)) & strcmp(datacontpol.tel,'Kuiper'))),'Color',[colormatrix_sorted(i,1) colormatrix_sorted(i,2) colormatrix_sorted(i,3)]);
	%er2_stat(i) = errorbar(dataz.Bokdates{i}   ,dataz.Bokerr_pol{i}   ,100*datacontpol.contpolsig{1}(find(strcmp(datacontpol.name,snnames_sorted(i)) & strcmp(datacontpol.tel,'Bok'))),'Color',[colormatrix_sorted(i,1) colormatrix_sorted(i,2) colormatrix_sorted(i,3) ]);
	%er3_stat(i) = errorbar(dataz.MMTdates{i}   ,dataz.MMTerr_pol{i}   ,100*datacontpol.contpolsig{1}(find(strcmp(datacontpol.name,snnames_sorted(i)) & strcmp(datacontpol.tel,'MMT'))),'Color',[colormatrix_sorted(i,1) colormatrix_sorted(i,2) colormatrix_sorted(i,3)]);
	er1_stat(i).LineStyle = 'none';
	er2_stat(i).LineStyle = 'none';
	er3_stat(i).LineStyle = 'none';
	%pause(3)
end

set(gca,'box','on')
xlabel('Days Relative to Peak','interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
ylabel('Continuum Polarization (\%) at 5400 $\AA$','interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
axis([[-100 200] [0 6]])
set(gca,'FontSize',22)

[h1, lgd1] = legend(pl,unique(datacontpol.name),'FontSize', 24,'Location','NorthEastOutside');
lgd1_find = findobj(lgd1, 'type', 'line');
set(lgd1_find, 'LineWidth',12);
lgd1t = findobj(lgd1, 'type', 'text');
set(lgd1t, 'FontSize', 24,'Interpreter','latex');
for i=1:length(unique(datacontpol.name))
	set(lgd1_find(2*i-1), 'Color',[colormatrix_sorted(i,1) colormatrix_sorted(i,2) colormatrix_sorted(i,3)]);
end	
ax1 = gca;
ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none','visible','off');

[~, objh]=legend(ax2,[sc1(4) sc2(4) sc3(4)],[string('Kuiper'),string('Bok'),string('MMT')],'FontSize', 20,'Location','NorthEast');
objhl = findobj(objh, 'type', 'patch'); %// objects of legend of type line
set(objhl, 'Markersize', 20); %// set marker size as desired

export_fig C:\Users\Cbilinski\Desktop\Figures\contpol{1}new.pdf







clf
for i=1:length(unique(data_contpol.name))
	axis([[-100 200] [0 6]])
	%initialize data.numpoints
	data.numpoints(i) = 0;
	for j=1:size(data_contpol.name,1)
		if(strcmp(data_contpol.name(j),snnames(i)))
			data.numpoints(i) = data.numpoints(i) + 1;
		end
	end

	if(data.numpoints(i) > 3)
		colormatrix(i,4) = 1;
	else
		colormatrix(i,4) = 0.2
	end
	
	%days since peak
	%polarization in %
	if(isempty(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper')))))
		data.Kuiperdates{i} = [NaN];
		data.Kuipererr_pol{i} = [NaN];
	else
		data.Kuiperdates{i} = data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper')));
		data.Kuipererr_pol{i} = 100*data_contpol.contpol2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper')));
	end
	
	if(isempty(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok')))))
		data.Bokdates{i} = [NaN];
		data.Bokerr_pol{i} = [NaN];
	else
		data.Bokdates{i} = data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok')));
		data.Bokerr_pol{i} = 100*data_contpol.contpol2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok')));
	end
	if(isempty(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT')))))
		data.MMTdates{i} = [NaN];
		data.MMTerr_pol{i} = [NaN];
	else
		data.MMTdates{i} = data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT')));
		data.MMTerr_pol{i} = 100*data_contpol.contpol2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT')));
	end

	pl(i) = plot(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)))),100*data_contpol.contpol2(find(strcmp(data_contpol.name,snnames(i)))),'-','LineWidth',1,'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3) colormatrix(i,4)]);
	hold all
	sc1(i) = scatter(data.Kuiperdates{i},data.Kuipererr_pol{i},200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled','o','MarkerFaceAlpha', colormatrix(i,4),'MarkerEdgeAlpha', colormatrix(i,4));
	sc2(i) = scatter(data.Bokdates{i}   ,data.Bokerr_pol{i}   ,200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled','s','MarkerFaceAlpha', colormatrix(i,4),'MarkerEdgeAlpha', colormatrix(i,4));
	sc3(i) = scatter(data.MMTdates{i}   ,data.MMTerr_pol{i}   ,200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled','d','MarkerFaceAlpha', colormatrix(i,4),'MarkerEdgeAlpha', colormatrix(i,4));
	
	er1_ISP(i) = errorbar(data.Kuiperdates{i},data.Kuipererr_pol{i},ones(1,size(data.Kuipererr_pol{i},1)).* dataz.(['ISP_' char(data_contpol.name{i})]),'Color','k');
	er1_ISP(i).LineStyle = 'none';
	er2_ISP(i) = errorbar(data.Bokdates{i}   ,data.Bokerr_pol{i}   ,ones(1,size(data.Bokerr_pol{i},1)).* dataz.(['ISP_' char(data_contpol.name{i})]),'Color','k');
	er2_ISP(i).LineStyle = 'none';
	er3_ISP(i) = errorbar(data.MMTdates{i}   ,data.MMTerr_pol{i}   ,ones(1,size(data.MMTerr_pol{i},1)).* dataz.(['ISP_' char(data_contpol.name{i})]),'Color','k');
	er3_ISP(i).LineStyle = 'none';
	
	er1_stat(i) = errorbar(data.Kuiperdates{i},data.Kuipererr_pol{i},100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))),'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3) colormatrix(i,4)]);
	er2_stat(i) = errorbar(data.Bokdates{i}   ,data.Bokerr_pol{i}   ,100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))),'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3) colormatrix(i,4)]);
	er3_stat(i) = errorbar(data.MMTdates{i}   ,data.MMTerr_pol{i}   ,100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))),'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3) colormatrix(i,4)]);
	er1_stat(i).LineStyle = 'none';
	er2_stat(i).LineStyle = 'none';
	er3_stat(i).LineStyle = 'none';
	pause(3)
end

set(gca,'box','on')
xlabel('Days Relative to Peak','interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
ylabel('Continuum Polarization (\%) at 6150 $\AA$','interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
axis([[-100 200] [0 6]])
set(gca,'FontSize',22)

[h1, lgd1] = legend(pl,unique(data_contpol.name),'FontSize', 24,'Location','NorthEastOutside');
lgd1_find = findobj(lgd1, 'type', 'line');
set(lgd1_find, 'LineWidth',12);
lgd1t = findobj(lgd1, 'type', 'text');
set(lgd1t, 'FontSize', 24,'Interpreter','latex');
for i=1:length(unique(data_contpol.name))
	set(lgd1_find(2*i-1), 'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3) colormatrix(i,4)]);
end	
ax1 = gca;
ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none','visible','off');

[~, objh]=legend(ax2,[sc1(4) sc2(4) sc3(4)],[string('Kuiper'),string('Bok'),string('MMT')],'FontSize', 20,'Location','NorthEast');
objhl = findobj(objh, 'type', 'patch'); %// objects of legend of type line
set(objhl, 'Markersize', 20); %// set marker size as desired

export_fig C:\Users\Cbilinski\Desktop\Figures\Contpol2new.pdf










%Theta plot1
clf
for i=1:length(unique(data_contpol.name))
	axis([[-100 200] [0 180]])
	%days since peak
	%theta in degrees
	if(isempty(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper')))))
		data.Kuiperdates{i} = [NaN];
		data.Kuipererr_pol{i} = [NaN];
		data.Kuipererr_theta{i} = [NaN];
	else
		data.Kuiperdates{i} = data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper')));
		data.Kuipererr_pol{i} = 100*data_contpol.contpol{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper')));
		data.Kuipererr_theta{i} = data_contpol.conttheta1(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper')));
	end
	
	if(isempty(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok')))))
		data.Bokdates{i} = [NaN];
		data.Bokerr_pol{i} = [NaN];
		data.Bokerr_theta{i} = [NaN];
	else
		data.Bokdates{i} = data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok')));
		data.Bokerr_pol{i} = 100*data_contpol.contpol{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok')));
		data.Bokerr_theta{i} = data_contpol.conttheta1(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok')));
	end
	if(isempty(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT')))))
		data.MMTdates{i} = [NaN];
		data.MMTerr_pol{i} = [NaN];
		data.MMTerr_theta{i} = [NaN];
	else
		data.MMTdates{i} = data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT')));
		data.MMTerr_pol{i} = 100*data_contpol.contpol{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT')));
		data.MMTerr_theta{i} = data_contpol.conttheta1(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT')));
	end

	pl(i) = plot(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)))),data_contpol.conttheta1(find(strcmp(data_contpol.name,snnames(i)))),'-','LineWidth',1,'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3) colormatrix(i,4)]);
	hold all
	sc1(i) = scatter(data.Kuiperdates{i},data.Kuipererr_theta{i},200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled','o','MarkerFaceAlpha', colormatrix(i,4),'MarkerEdgeAlpha', colormatrix(i,4));
	sc2(i) = scatter(data.Bokdates{i}   ,data.Bokerr_theta{i}   ,200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled','s','MarkerFaceAlpha', colormatrix(i,4),'MarkerEdgeAlpha', colormatrix(i,4));
	sc3(i) = scatter(data.MMTdates{i}   ,data.MMTerr_theta{i}   ,200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled','d','MarkerFaceAlpha', colormatrix(i,4),'MarkerEdgeAlpha', colormatrix(i,4));
	
	%er1_ISP(i) = errorbar(data.Kuiperdates{i},data.Kuipererr_theta{i},ones(1,size(data.Kuipererr_theta{i},1)).* data.(['ISP_' char(data_contpol.name{i})]),'Color','k');
	%er1_ISP(i).LineStyle = 'none';
	%er2_ISP(i) = errorbar(data.Bokdates{i}   ,data.Bokerr_theta{i}   ,ones(1,size(data.Bokerr_theta{i},1)).* data.(['ISP_' char(data_contpol.name{i})]),'Color','k');
	%er2_ISP(i).LineStyle = 'none';
	%er3_ISP(i) = errorbar(data.MMTdates{i}   ,data.MMTerr_theta{i}   ,ones(1,size(data.MMTerr_theta{i},1)).* data.(['ISP_' char(data_contpol.name{i})]),'Color','k');
	%er3_ISP(i).LineStyle = 'none';
	%
	%er1_stat(i) = errorbar(data.Kuiperdates{i},data.Kuipererr_pol{i},100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))),'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3) colormatrix(i,4)]);
	%er2_stat(i) = errorbar(data.Bokdates{i}   ,data.Bokerr_pol{i}   ,100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))),'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3) colormatrix(i,4)]);
	%er3_stat(i) = errorbar(data.MMTdates{i}   ,data.MMTerr_pol{i}   ,100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))),'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3) colormatrix(i,4)]);
	%er1_stat(i).LineStyle = 'none';
	%er2_stat(i).LineStyle = 'none';
	%er3_stat(i).LineStyle = 'none';
	pause(0.1)
end

set(gca,'box','on')
xlabel('Days Relative to Peak','interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
ylabel(['Continuum Polarization Angle ($^{\circ}$) at 5400 $\AA$'],'interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
axis([[-100 200] [0 180]])
set(gca,'FontSize',22)

[h1, lgd1] = legend(pl,unique(data_contpol.name),'FontSize', 24,'Location','NorthEastOutside');
lgd1_find = findobj(lgd1, 'type', 'line');
set(lgd1_find, 'LineWidth',12);
lgd1t = findobj(lgd1, 'type', 'text');
set(lgd1t, 'FontSize', 24,'Interpreter','latex');
for i=1:length(unique(data_contpol.name))
	set(lgd1_find(2*i-1), 'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3) colormatrix(i,4)]);
end	
ax1 = gca;
ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none','visible','off');

[~, objh]=legend(ax2,[sc1(4) sc2(4) sc3(4)],[string('Kuiper'),string('Bok'),string('MMT')],'FontSize', 20,'Location','NorthEast');
objhl = findobj(objh, 'type', 'patch'); %// objects of legend of type line
set(objhl, 'Markersize', 20); %// set marker size as desired

export_fig C:\Users\Cbilinski\Desktop\Figures\Conttheta1.pdf






%Theta plot2
clf
for i=1:length(unique(data_contpol.name))
	axis([[-100 200] [0 180]])
	
	%days since peak
	%theta in degrees
	if(isempty(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper')))))
		data.Kuiperdates{i} = [NaN];
		data.Kuipererr_pol{i} = [NaN];
		data.Kuipererr_theta{i} = [NaN];
	else
		data.Kuiperdates{i} = data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper')));
		data.Kuipererr_pol{i} = 100*data_contpol.contpol{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper')));
		data.Kuipererr_theta{i} = data_contpol.conttheta2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper')));
	end
	
	if(isempty(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok')))))
		data.Bokdates{i} = [NaN];
		data.Bokerr_pol{i} = [NaN];
		data.Bokerr_theta{i} = [NaN];
	else
		data.Bokdates{i} = data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok')));
		data.Bokerr_pol{i} = 100*data_contpol.contpol{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok')));
		data.Bokerr_theta{i} = data_contpol.conttheta2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok')));
	end
	if(isempty(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT')))))
		data.MMTdates{i} = [NaN];
		data.MMTerr_pol{i} = [NaN];
		data.MMTerr_theta{i} = [NaN];
	else
		data.MMTdates{i} = data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT')));
		data.MMTerr_pol{i} = 100*data_contpol.contpol{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT')));
		data.MMTerr_theta{i} = data_contpol.conttheta2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT')));
	end

	pl(i) = plot(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)))),data_contpol.conttheta2(find(strcmp(data_contpol.name,snnames(i)))),'-','LineWidth',1,'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3) colormatrix(i,4)]);
	hold all
	sc1(i) = scatter(data.Kuiperdates{i},data.Kuipererr_theta{i},200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled','o','MarkerFaceAlpha', colormatrix(i,4),'MarkerEdgeAlpha', colormatrix(i,4));
	sc2(i) = scatter(data.Bokdates{i}   ,data.Bokerr_theta{i}   ,200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled','s','MarkerFaceAlpha', colormatrix(i,4),'MarkerEdgeAlpha', colormatrix(i,4));
	sc3(i) = scatter(data.MMTdates{i}   ,data.MMTerr_theta{i}   ,200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled','d','MarkerFaceAlpha', colormatrix(i,4),'MarkerEdgeAlpha', colormatrix(i,4));
	
	%er1_ISP(i) = errorbar(data.Kuiperdates{i},data.Kuipererr_theta{i},ones(1,size(data.Kuipererr_theta{i},1)).* data.(['ISP_' char(data_contpol.name{i})]),'Color','k');
	%er1_ISP(i).LineStyle = 'none';
	%er2_ISP(i) = errorbar(data.Bokdates{i}   ,data.Bokerr_theta{i}   ,ones(1,size(data.Bokerr_theta{i},1)).* data.(['ISP_' char(data_contpol.name{i})]),'Color','k');
	%er2_ISP(i).LineStyle = 'none';
	%er3_ISP(i) = errorbar(data.MMTdates{i}   ,data.MMTerr_theta{i}   ,ones(1,size(data.MMTerr_theta{i},1)).* data.(['ISP_' char(data_contpol.name{i})]),'Color','k');
	%er3_ISP(i).LineStyle = 'none';
	%
	%er1_stat(i) = errorbar(data.Kuiperdates{i},data.Kuipererr_pol{i},100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))),'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3) colormatrix(i,4)]);
	%er2_stat(i) = errorbar(data.Bokdates{i}   ,data.Bokerr_pol{i}   ,100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))),'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3) colormatrix(i,4)]);
	%er3_stat(i) = errorbar(data.MMTdates{i}   ,data.MMTerr_pol{i}   ,100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))),'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3) colormatrix(i,4)]);
	%er1_stat(i).LineStyle = 'none';
	%er2_stat(i).LineStyle = 'none';
	%er3_stat(i).LineStyle = 'none';
	pause(0.1)
end

set(gca,'box','on')
xlabel('Days Relative to Peak','interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
ylabel(['Continuum Polarization Angle ($^{\circ}$) at 6150 $\AA$'],'interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
axis([[-100 200] [0 180]])
set(gca,'FontSize',22)

[h1, lgd1] = legend(pl,unique(data_contpol.name),'FontSize', 24,'Location','NorthEastOutside');
lgd1_find = findobj(lgd1, 'type', 'line');
set(lgd1_find, 'LineWidth',12);
lgd1t = findobj(lgd1, 'type', 'text');
set(lgd1t, 'FontSize', 24,'Interpreter','latex');
for i=1:length(unique(data_contpol.name))
	set(lgd1_find(2*i-1), 'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3) colormatrix(i,4)]);
end	
ax1 = gca;
ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none','visible','off');

[~, objh]=legend(ax2,[sc1(4) sc2(4) sc3(4)],[string('Kuiper'),string('Bok'),string('MMT')],'FontSize', 20,'Location','NorthEast');
objhl = findobj(objh, 'type', 'patch'); %// objects of legend of type line
set(objhl, 'Markersize', 20); %// set marker size as desired

export_fig C:\Users\Cbilinski\Desktop\Figures\conttheta2.pdf







%cont difference plot
clf
for i=1:length(unique(data_contpol.name))
	axis([[-100 200] [-1 2]])
	
	%days since peak
	%polarization in %
	if(isempty(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper')))))
		data.Kuiperdates{i} = [NaN];
		data.Kuipererr_poldif{i} = [NaN];
	else
		data.Kuiperdates{i} = data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper')));
		data.Kuipererr_poldif{i} = 100*data_contpol.contpol{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))) - 100*data_contpol.contpol2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper')));
	end
	
	if(isempty(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok')))))
		data.Bokdates{i} = [NaN];
		data.Bokerr_poldif{i} = [NaN];
	else
		data.Bokdates{i} = data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok')));
		data.Bokerr_poldif{i} = 100*data_contpol.contpol{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))) - 100*data_contpol.contpol2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok')));
	end
	if(isempty(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT')))))
		data.MMTdates{i} = [NaN];
		data.MMTerr_poldif{i} = [NaN];
	else
		data.MMTdates{i} = data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT')));
		data.MMTerr_poldif{i} = 100*data_contpol.contpol{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))) - 100*data_contpol.contpol2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT')));
	end

	pl(i) = plot(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)))),100*data_contpol.contpol{1}(find(strcmp(data_contpol.name,snnames(i))))-100*data_contpol.contpol2(find(strcmp(data_contpol.name,snnames(i)))),'-','LineWidth',1,'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3) colormatrix(i,4)]);
	hold all
	sc1(i) = scatter(data.Kuiperdates{i},data.Kuipererr_poldif{i},200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled','o','MarkerFaceAlpha', colormatrix(i,4),'MarkerEdgeAlpha', colormatrix(i,4));
	sc2(i) = scatter(data.Bokdates{i}   ,data.Bokerr_poldif{i}   ,200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled','s','MarkerFaceAlpha', colormatrix(i,4),'MarkerEdgeAlpha', colormatrix(i,4));
	sc3(i) = scatter(data.MMTdates{i}   ,data.MMTerr_poldif{i}   ,200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled','d','MarkerFaceAlpha', colormatrix(i,4),'MarkerEdgeAlpha', colormatrix(i,4));
	
	er1_ISP(i) = errorbar(data.Kuiperdates{i},data.Kuipererr_poldif{i},ones(1,size(data.Kuipererr_poldif{i},1)).* data.(['ISP_' char(data_contpol.name{i})]),'Color','k');
	er1_ISP(i).LineStyle = 'none';
	er2_ISP(i) = errorbar(data.Bokdates{i}   ,data.Bokerr_poldif{i}   ,ones(1,size(data.Bokerr_poldif{i},1)).* data.(['ISP_' char(data_contpol.name{i})]),'Color','k');
	er2_ISP(i).LineStyle = 'none';
	er3_ISP(i) = errorbar(data.MMTdates{i}   ,data.MMTerr_poldif{i}   ,ones(1,size(data.MMTerr_poldif{i},1)).* data.(['ISP_' char(data_contpol.name{i})]),'Color','k');
	er3_ISP(i).LineStyle = 'none';
	
	er1_stat(i) = errorbar(data.Kuiperdates{i},data.Kuipererr_poldif{i},100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))),'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3) colormatrix(i,4)]);
	er2_stat(i) = errorbar(data.Bokdates{i}   ,data.Bokerr_poldif{i}   ,100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))),'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3) colormatrix(i,4)]);
	er3_stat(i) = errorbar(data.MMTdates{i}   ,data.MMTerr_poldif{i}   ,100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))),'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3) colormatrix(i,4)]);
	er1_stat(i).LineStyle = 'none';
	er2_stat(i).LineStyle = 'none';
	er3_stat(i).LineStyle = 'none';
	pause(0.1)
end

line([-5000 5000], [0 0],'Color','k','LineStyle','--')

set(gca,'box','on')
xlabel('Days Relative to Peak','interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
ylabel('Difference Between Continuum Polarizations (\%) at 5400 and 6150 $\AA$','interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
axis([[-100 200] [-1 2]])
set(gca,'FontSize',22)

[h1, lgd1] = legend(pl,unique(data_contpol.name),'FontSize', 24,'Location','NorthEastOutside');
lgd1_find = findobj(lgd1, 'type', 'line');
set(lgd1_find, 'LineWidth',12);
lgd1t = findobj(lgd1, 'type', 'text');
set(lgd1t, 'FontSize', 24,'Interpreter','latex');
for i=1:length(unique(data_contpol.name))
	set(lgd1_find(2*i-1), 'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3) colormatrix(i,4)]);
end	
ax1 = gca;
ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none','visible','off');

[~, objh]=legend(ax2,[sc1(4) sc2(4) sc3(4)],[string('Kuiper'),string('Bok'),string('MMT')],'FontSize', 20,'Location','NorthEast');
objhl = findobj(objh, 'type', 'patch'); %// objects of legend of type line
set(objhl, 'Markersize', 20); %// set marker size as desired

export_fig C:\Users\Cbilinski\Desktop\Figures\ContPolDif.pdf































%Theta attempt
clf
for i=1:length(unique(data_contpol.name))
hold all
	pl(i) = plot(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)))),data_contpol.conttheta1(find(strcmp(data_contpol.name,snnames(i)))),'--','LineWidth',1,'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)]);
	sc1(i) = scatter(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))),data_contpol.conttheta1(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))),200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled','o');
	sc2(i) = scatter(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))),data_contpol.conttheta1(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))),200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled','s');
	sc3(i) = scatter(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))),data_contpol.conttheta1(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))),200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled','d');
	%tempname = ['ISP_' char(data_contpol.name(i,:))];
	%Kuipererr = sqrt(data.(tempname).^2 + (100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper')))).^2);
	%Bokerr = sqrt(data.(tempname).^2 + (100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok')))).^2);
	%MMTerr = sqrt(data.(tempname).^2 + (100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT')))).^2);
	
	
	%er1(i) = errorbar(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))),100*data_contpol.contpol{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))),100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))));
	%er2(i) = errorbar(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))),100*data_contpol.contpol{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))),100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))));
	%er3(i) = errorbar(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))),100*data_contpol.contpol{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))),100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))));
	
end

set(gca,'box','on')
xlabel('Days Relative to Discovery Date','interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
ylabel('Polarization Angle (degrees) at 5400 $\AA$','interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
axis([[-25 200] [0 180]])
set(gca,'FontSize',22)

[h, lgd] = legend(pl,unique(data_contpol.name),'FontSize', 24,'Location','NorthEastOutside');
lgdl = findobj(lgd, 'type', 'line');
set(lgdl, 'LineWidth',12);
lgdt = findobj(lgd, 'type', 'text');
set(lgdt, 'FontSize', 24,'Interpreter','latex');
ax1 = gca;
ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none','visible','off');

l = legend(ax2,[sc1(4) sc2(4) sc3(4)],[string('Kuiper'),string('Bok'),string('MMT')],'FontSize', 24,'Location','NorthEast');
set(l,'Interpreter','latex','FontSize',30)
%set(l,'LineWidth',30)





















































clf
hold on
for i=1:length(unique(data_contpol.name))
	pl(i) = plot(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)))),100*data_contpol.contpol2(find(strcmp(data_contpol.name,snnames(i)))),'--','LineWidth',1,'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)]);
	sc1(i) = scatter(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))),100*data_contpol.contpol2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))),200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled','o');
	sc2(i) = scatter(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))),100*data_contpol.contpol2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))),200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled','s');
	sc3(i) = scatter(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))),100*data_contpol.contpol2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))),200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled','d');
	tempname = ['ISP_' char(data_contpol.name(i,:))];
	Kuipererr = sqrt(data.(tempname).^2 + (100*data_contpol.contpolsig2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper')))).^2);
	Bokerr = sqrt(data.(tempname).^2 + (100*data_contpol.contpolsig2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok')))).^2);
	MMTerr = sqrt(data.(tempname).^2 + (100*data_contpol.contpolsig2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT')))).^2);
	
	
	er1(i) = errorbar(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))),100*data_contpol.contpol2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))),Kuipererr);
	er2(i) = errorbar(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))),100*data_contpol.contpol2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))),Bokerr);
	er3(i) = errorbar(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))),100*data_contpol.contpol2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))),MMTerr);
	
	
		
	%er1(i) = errorbar(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))),100*data_contpol.contpol2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))),100*data_contpol.contpolsig2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))));
	%er2(i) = errorbar(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))),100*data_contpol.contpol2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))),100*data_contpol.contpolsig2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))));
	%er3(i) = errorbar(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))),100*data_contpol.contpol2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))),100*data_contpol.contpolsig2(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))));
	
end

set(gca,'box','on')
xlabel('Days Relative to Discovery Date','interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
ylabel('Continuum Polarization (\%) at 6150 $\AA$','interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
axis([[-100 600] [0 8.5]])
set(gca,'FontSize',22)

[h, lgd] = legend(pl,unique(data_contpol.name),'FontSize', 24,'Location','NorthEastOutside');
lgdl = findobj(lgd, 'type', 'line');
set(lgdl, 'LineWidth', 12);
lgdt = findobj(lgd, 'type', 'text');
set(lgdt, 'FontSize', 24,'Interpreter','latex');
ax1 = gca;
ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none','visible','off');
l = legend(ax2,[sc1(4) sc2(4) sc3(4)],[string('Kuiper'),string('Bok'),string('MMT')],'FontSize', 24,'Location','NorthEast');
set(l,'Interpreter','latex','FontSize',30)

export_fig C:\Users\Cbilinski\Desktop\Figures\ContPol2.pdf



%Theta attempt
clf
for i=1:length(unique(data_contpol.name))
hold all
	pl(i) = plot(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)))),data_contpol.conttheta1(find(strcmp(data_contpol.name,snnames(i)))),'--','LineWidth',1,'Color',[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)]);
	sc1(i) = scatter(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))),data_contpol.conttheta1(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))),200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled','o');
	sc2(i) = scatter(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))),data_contpol.conttheta1(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))),200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled','s');
	sc3(i) = scatter(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))),data_contpol.conttheta1(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))),200,[colormatrix(i,1) colormatrix(i,2) colormatrix(i,3)],'filled','d');
	%tempname = ['ISP_' char(data_contpol.name(i,:))];
	%Kuipererr = sqrt(data.(tempname).^2 + (100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper')))).^2);
	%Bokerr = sqrt(data.(tempname).^2 + (100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok')))).^2);
	%MMTerr = sqrt(data.(tempname).^2 + (100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT')))).^2);
	
	
	%er1(i) = errorbar(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))),100*data_contpol.contpol{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))),100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))));
	%er2(i) = errorbar(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))),100*data_contpol.contpol{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))),100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))));
	%er3(i) = errorbar(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))),100*data_contpol.contpol{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))),100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))));
	
end

set(gca,'box','on')
xlabel('Days Relative to Discovery Date','interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
ylabel('Polarization Angle (degrees) at 5400 $\AA$','interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
axis([[-25 200] [0 180]])
set(gca,'FontSize',22)

[h, lgd] = legend(pl,unique(data_contpol.name),'FontSize', 24,'Location','NorthEastOutside');
lgdl = findobj(lgd, 'type', 'line');
set(lgdl, 'LineWidth',12);
lgdt = findobj(lgd, 'type', 'text');
set(lgdt, 'FontSize', 24,'Interpreter','latex');
ax1 = gca;
ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none','visible','off');

l = legend(ax2,[sc1(4) sc2(4) sc3(4)],[string('Kuiper'),string('Bok'),string('MMT')],'FontSize', 24,'Location','NorthEast');
set(l,'Interpreter','latex','FontSize',30)
%set(l,'LineWidth',30)
















%%%garbage

SN2011cc_majorplotdate(1,1) = juliandate(2011,09,16);
SN2011cc_majorplotpolval(1,1) = 1.8;
SN2011cc_majorplotreldate = SN2011cc_majorplotdate - discoverydatejd_SN2011cc;

SN2011ht_majorplotdate(1,1) = juliandate(2012,01,25);
SN2011ht_majorplotpolval(1,1) = 0.3;
SN2011ht_majorplotdate(1,2) = juliandate(2012,02,12);
SN2011ht_majorplotpolval(1,2) = 7;
SN2011ht_majorplotreldate = SN2011ht_majorplotdate - discoverydatejd_SN2011ht;

SN2012ab_majorplotdate(1,1) = juliandate(2012,03,23);
SN2012ab_majorplotpolval(1,1) = 1.5;
SN2012ab_majorplotdate(1,2) = juliandate(2012,04,16);
SN2012ab_majorplotpolval(1,2) = 3;
SN2012ab_majorplotreldate = SN2012ab_majorplotdate - discoverydatejd_SN2012ab;


SN2014ab_majorplotdate(1,1) = juliandate(2014,03,29);
SN2014ab_majorplotpolval(1,1) = 0.5;
SN2014ab_majorplotdate(1,2) = juliandate(2014,04,20);
SN2014ab_majorplotpolval(1,2) = 0.3;
SN2014ab_majorplotdate(1,3) = juliandate(2014,04,26);
SN2014ab_majorplotpolval(1,3) = 0.6;
SN2014ab_majorplotdate(1,4) = juliandate(2014,05,23);
SN2014ab_majorplotpolval(1,4) = 0.5;
SN2014ab_majorplotdate(1,4) = juliandate(2014,06,23);
SN2014ab_majorplotpolval(1,4) = 0.9;
SN2014ab_majorplotreldate = SN2014ab_majorplotdate - discoverydatejd_SN2014ab;


SN2017gas_majorplotdate(1,1) = juliandate(2017,08,30);
SN2017gas_majorplotpolval(1,1) = 3;
SN2017gas_majorplotdate(1,2) = juliandate(2017,09,19);
SN2017gas_majorplotpolval(1,2) = 2.4;
SN2017gas_majorplotdate(1,3) = juliandate(2017,10,17);
SN2017gas_majorplotpolval(1,3) = 1.9;
SN2017gas_majorplotdate(1,4) = juliandate(2017,12,22);
SN2017gas_majorplotpolval(1,4) = 1.6;
SN2017gas_majorplotreldate = SN2017gas_majorplotdate - discoverydatejd_SN2017gas;

hold all
scatter(SN2017gas_majorplotreldate,SN2017gas_majorplotpolval,'filled')
scatter(SN2014ab_majorplotreldate,SN2014ab_majorplotpolval,'filled')
scatter(SN2012ab_majorplotreldate,SN2012ab_majorplotpolval,'filled')
scatter(SN2011cc_majorplotreldate,SN2011cc_majorplotpolval,'filled')
scatter(SN2011ht_majorplotreldate,SN2011ht_majorplotpolval,'filled')

plot(SN2017gas_majorplotreldate,SN2017gas_majorplotpolval,'--')
plot(SN2014ab_majorplotreldate,SN2014ab_majorplotpolval,'--')
plot(SN2012ab_majorplotreldate,SN2012ab_majorplotpolval,'--')
plot(SN2011cc_majorplotreldate,SN2011cc_majorplotpolval,'--')
plot(SN2011ht_majorplotreldate,SN2011ht_majorplotpolval,'--')


lgd2 = legend(sc,unique(data_contpol.name));
lgd2.FontSize = 44;
icons = findobj(lgd,'Type','patch');
set(icons,'MarkerSize',25);

[h,lgd] = legend(sc,unique(data_contpol.name),'FontSize',32);
icons = findobj(lgd,'Type','patch');
set(icons,'MarkerSize',15);

lgd2 = legend(sc,unique(data_contpol.name),'FontSize',32);


set(lgd, 'FontSize', 42)


%tempname = ['ISP_' char(data_contpol.name(i,:))];
%Kuipererr = sqrt(data.(tempname).^2 + (100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper')))).^2);
%Bokerr = sqrt(data.(tempname).^2 + (100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok')))).^2);
%MMTerr = sqrt(data.(tempname).^2 + (100*data_contpol.contpolsig{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT')))).^2);
%
%
%er1(i) = errorbar(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))),100*data_contpol.contpol{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Kuiper'))),Kuipererr);
%er2(i) = errorbar(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))),100*data_contpol.contpol{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'Bok'))),Bokerr);
%er3(i) = errorbar(data_contpol.reldate(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))),100*data_contpol.contpol{1}(find(strcmp(data_contpol.name,snnames(i)) & strcmp(data_contpol.tel,'MMT'))),MMTerr);
	
	
	
	
	
	
	
	
	
	
	
%lgd2 = findobj(lgd2,'Type','line');
%% Find lines that use a marker
%lgd2 = findobj(lgd2,'Marker','none','-xor');
%% Resize the marker in the legend
%set(lgd2,'MarkerSize',70);



%l = legend(ax2,[sc1(4) sc2(4) sc3(4)],[string('Kuiper'),string('Bok'),string('MMT')],'FontSize', 40,'Location','NorthEast');
%set(l,'Interpreter','latex','FontSize',40)
%%set(l,'LineWidth',30)






%[h, lgd] = legend(ax2,[sc1(1) sc2(1) sc3(1)],[string('Kuiper'),string('Bok'),string('MMT')],'FontSize', 24,'Location','NorthEast');
%lgd2 = findobj(lgd, 'type','-property', 'Marker', '-and', '-not', 'Marker', 'none');
%set(lgd2, 'MarkerSize', 34);
%lgdt2 = findobj(lgd, 'type', 'text');
%set(lgdt2, 'FontSize', 24);


