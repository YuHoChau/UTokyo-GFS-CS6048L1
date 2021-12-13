I_MS = imread('mul.tif');
I_MS = imresize(I_MS, 4);
I_MS_D = im2double(I_MS);
I_PAN = imread('pan.tif');
I_PAN_D = im2double(I_PAN);
I_GLP_HRI = GLP_Reg_FS(I_MS_D, I_PAN_D, 'none', 4, 0);
img = im2uint16(I_GLP_HRI); %Change into Unit16'
