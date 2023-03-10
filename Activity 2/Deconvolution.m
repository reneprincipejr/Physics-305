% blurred = imread('cup_blur_2.jpg');
% PSF = fspecial('motion',4,0);
% noise_mean = 0;
% noise_var = 0.0005;
% blurred_noisy = imnoise(blurred,'gaussian',noise_mean,noise_var);
% 
% figure(1)
% subplot(1,2,1);
% imshow(Ioriginal)
% title('Blurred Image Capture')
% subplot(1,2,2);
% imshow(blurred_noisy)
% title('Blurred and Noisy Image')
%% 

blurred = imread('lp.jpg');
PSF = fspecial('motion',1.5,45);

noise_var = 0.0001;
Idouble = im2double(blurred);
signal_var = var(Idouble(:));
NSR = noise_var / signal_var;
wnr3 = deconvwnr(blurred,PSF,NSR);

figure(2);
subplot(1,2,1);
imshow(blurred)
title('Blurred Image Capture')
subplot(1,2,2);
imshow(wnr3)
title('Restoration of Blurred Noisy Image (Estimated NSR)')
% hold on    
%% 
blurred = imread('license_plate.jpg');
PSF = fspecial('motion',1.4,35);
uniform_quantization_var = (1/256)^2 / 12;
signal_var = var(Idouble(:));
NSR = uniform_quantization_var / signal_var;
wnr5 = deconvwnr(blurred,PSF,NSR);

figure(3);
subplot(1,2,1);
imshow(blurred)
title('Blurred Image Capture')
subplot(1,2,2);
blurred_quantized = imfilter(Ioriginal,PSF,'conv','circular');
imshow(wnr5)
title('Restoration of Blurred Quantized Image (Estimated NSR)');
