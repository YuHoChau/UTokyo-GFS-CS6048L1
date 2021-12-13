%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: 
%           interp23tapGeneral interpolates the image I_Interpolated using a general polynomial interpolator. 
% 
% Interface:
%           I_Interpolated = interp23tapGeneral(I_Interpolated,ratio)
%
% Inputs:
%           I_Interpolated: Image to interpolate;
%           ratio:          Scale ratio between MS and PAN. Pre-condition: Resize factors power of 2;
%
% Outputs:
%           I_Interpolated: Interpolated image.
% 
% Reference:
%       [Loncan15]         L. Loncan, L.B. Almeida, J.M. Bioucas-Dias, X. Briottet, J. Chanussot, N. Dobigeon, S. Fabre, W. Liao, G.A. Licciardi, M. Simoes, J.-Y. Tourneret, M.A. Veganzones, G. Vivone, Q. Wei, and N. Yokoya
%                          "Hyperspectral Pansharpening: A Review"
%                           IEEE Geoscience and Remote Sensing Magazine, vol. 3, no. 3, pp. 27-46, September 2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function I_Interpolated = interp23tapGeneral(I_Interpolated,ratio)

L = 32; % tap (64)

[r,c,b] = size(I_Interpolated);

BaseCoeff = ratio.*fir1(L,1./ratio);

I1LRU = zeros(ratio.*r, ratio.*c, b);    
I1LRU(floor(ratio/2)+1:ratio:end,floor(ratio/2)+1:ratio:end,:) = I_Interpolated;

for ii = 1 : b
    t = I1LRU(:,:,ii); 
    t = imfilter(t',BaseCoeff,'circular'); 
    I1LRU(:,:,ii) = imfilter(t',BaseCoeff,'circular'); 
end

I_Interpolated = I1LRU;

end