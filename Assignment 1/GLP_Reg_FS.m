%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: 
%           GLP_Reg_FS fuses the upsampled MultiSpectral (MS) and PANchromatic (PAN) images by 
%           exploiting the Modulation Transfer Function - Generalized Laplacian Pyramid (MTF-GLP) and a new Full Resolution Regression-based injection model. 
% 
% Interface:
%           I_GLP_HRI = GLP_Reg_FS(I_MS, I_PAN, sensor, ratio, flag8)
%
% Inputs:
%           I_MS:               MS image upsampled at PAN scale;
%           I_PAN:              PAN image;
%           sensor:             String for type of sensor (e.g. 'WV2','IKONOS');
%           ratio:              Scale ratio between MS and PAN. Pre-condition: Integer value;
%           flag8:              Flag8 is 1 when a dataset with R = 8 is considered. Otherwise, for R = 4, it is equal to 0.
%
% Outputs:
%           I_GLP_HRI:          I_GLP_HRI pansharpened image.
% 
% Reference:
%           [Vivone18]          G. Vivone, R. Restaino, and J. Chanussot
%                               "Full Scale Regression-based Injection Coefficients for Panchromatic Sharpening"
%                               IEEE Transactions on Image Processing, vol. 27, no. 7, pp. 3418-3431, July 2018.
% % % % % % % % % % % % %
% 
% Version: 1
% 
% % % % % % % % % % % % % 
% 
% Copyright (C) 2019
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function I_GLP_HRI = GLP_Reg_FS(I_MS, I_PAN, sensor, ratio, flag8)

I_PAN_Filt = MTF(repmat(I_PAN,[1 1 size(I_MS,3)]),sensor,ratio,flag8);

gHRI = zeros(1,size(I_MS,3));

for ii = 1 : size(I_MS,3)
    imPAN = I_PAN; 
    imMSB = I_MS(:,:,ii);
    imPANLRB = I_PAN_Filt(:,:,ii);
        
    CMSPAN = cov(imMSB(:), imPAN(:));    
    CPANPANLR = cov(imPANLRB(:), imPAN(:));
    gHRI(ii) = CMSPAN(1,2)./CPANPANLR(1,2);
end

I_GLP_HRI = Fusion_General(I_PAN,I_MS,gHRI,I_PAN_Filt);

end