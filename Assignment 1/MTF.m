%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: 
%           MTF filters the image I_MS using a Gaussin filter matched with the Modulation Transfer Function (MTF) of the MultiSpectral (MS) sensor. 
% 
% Interface:
%           I_Filtered = MTF(I_MS,sensor,ratio,flag)
%
% Inputs:
%           I_MS:           MS image;
%           sensor:         String for type of sensor (e.g. 'WV2', 'IKONOS');
%           ratio:          Scale ratio between MS and PAN.
%           flag:           Flag is 1 when a dataset with R = 8 is considered. Otherwise, for R = 4, it is equal to 0.
%
% Outputs:
%           I_Filtered:     Output filtered MS image.
% 
% References:
%           [Aiazzi02]          B. Aiazzi, L. Alparone, S. Baronti, and A. Garzelli, “Context-driven fusion of high spatial and spectral resolution images based on
%                               oversampled multiresolution analysis,” IEEE Transactions on Geoscience and Remote Sensing, vol. 40, no. 10, pp. 2300–2312, October
%                               2002.
%           [Aiazzi06]          B. Aiazzi, L. Alparone, S. Baronti, A. Garzelli, and M. Selva, “MTF-tailored multiscale fusion of high-resolution MS and Pan imagery,”
%                               Photogrammetric Engineering and Remote Sensing, vol. 72, no. 5, pp. 591–596, May 2006.
%           [Vivone14a]         G. Vivone, R. Restaino, M. Dalla Mura, G. Licciardi, and J. Chanussot, “Contrast and error-based fusion schemes for multispectral
%                               image pansharpening,” IEEE Geoscience and Remote Sensing Letters, vol. 11, no. 5, pp. 930–934, May 2014.
%           [Vivone15]          G. Vivone, L. Alparone, J. Chanussot, M. Dalla Mura, A. Garzelli, G. Licciardi, R. Restaino, and L. Wald, “A Critical Comparison Among Pansharpening Algorithms”, 
%                               IEEE Transactions on Geoscience and Remote Sensing, vol. 53, no. 5, pp. 2565–2586, May 2015.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [I_Filtered,I_MS_LP_LR] = MTF(I_MS,sensor,ratio,flag)

    switch sensor
        case 'QB'
            GNyq = [0.34 0.32 0.30 0.22]; % Band Order: B,G,R,NIR
        case 'IKONOS'
%             GNyq = [0.26,0.28,0.29,0.28]; % Band Order: B,G,R,NIR
            GNyq = 0.3 * ones(1, size(I_MS,3));
        case 'GeoEye1'
            GNyq = [0.23,0.23,0.23,0.23]; % Band Order: B,G,R,NIR
        case 'WV2'
%             GNyq = [0.35 .* ones(1,7), 0.27];
            GNyq = 0.3 * ones(1, size(I_MS,3));
        case {'WV3','WV3_4bands'}
            GNyq = [0.325 0.355 0.360 0.350 0.365 0.360 0.335 0.315];
            if strcmp(sensor,'WV3_4bands')
                GNyq = GNyq([2 3 5 7]);
            end
        case 'none'
            GNyq = 0.29 .* ones(1,size(I_MS,3));
    end

    N = 41;
    I_MS_LP = zeros(size(I_MS));
    nBands = size(I_MS,3);
    fcut = 1/ratio;

    for ii = 1 : nBands
        alpha = sqrt((N*(fcut/2))^2/(-2*log(GNyq(ii))));
        H = fspecial('gaussian', N, alpha);
        Hd = H./max(H(:));
        h = fwind1(Hd,kaiser(N));
        I_MS_Filt = imfilter(I_MS(:,:,ii),real(h),'replicate');
        t = imresize(I_MS_Filt,fcut,'nearest');
        if flag == 0
            I_MS_LP(:,:,ii) = interp23tap(t,ratio);
        else
            I_MS_LP(:,:,ii) = interp23tapGeneral(t,ratio);
        end
        I_MS_LP_LR(:,:,ii) = t;
    end

    I_Filtered = double(I_MS_LP);

end