%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: 
%           Fusion_General fuses the upsampled MultiSpectral (MS) and PANchromatic (PAN) images by 
%           combining them with a classical additive scheme. 
% 
% Interface:
%           I_Fus = Fusion_General(I_PAN,I_MS,g,PAN_LP)
%
% Inputs:
%           I_PAN:              PAN image;
%           I_MS:               MS image upsampled at PAN scale;
%           g:                  Injection coefficients to be used;
%           PAN_LP:             Low spatial resolution PAN image.
%
% Outputs:
%           I_Fus:              Pansharpened image.
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
function I_Fus = Fusion_General(I_PAN,I_MS,g,PAN_LP)
    coeff(1,1,:) = g;
    I_Fus = I_MS + repmat(coeff,[size(I_PAN,1) size(I_PAN,2) 1]) .* (repmat(I_PAN,[1 1 size(I_MS,3)]) - PAN_LP);
end