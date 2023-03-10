% Ioriginal = imread('cameraman.tif');
Ioriginal = imread('cup_blur_2.jpg');
imshow(Ioriginal)
title('Original Image')
%% Simulate and Restore Motion Blur Without Noise
PSF = fspecial('motion',7,0);
Idouble = im2double(Ioriginal);
blurred = imfilter(Idouble, PSF,'conv','circular');
subplot(1,2,1);
imshow(Ioriginal)
title('Original Image')
subplot(1,2,2);
imshow(blurred)
title('Blurred Image') 
%% 
% wnr1 = deconvwnr(blurred,PSF);
PSF = fspecial('motion',1.5,0);
wnr1 = deconvwnr(Ioriginal,PSF);
subplot(1,2,1);
imshow(Ioriginal)
title('Original Image')
subplot(1,2,2);
imshow(wnr1)
title('Restored Blurred Image')
%% 
% wnr1 = deconvwnr(blurred,PSF)
for i = 1:0.1:2
    PSF = fspecial('motion',i,0);
    wnr1 = deconvwnr(Ioriginal,PSF);
    subplot(1,2,1);
    imshow(Ioriginal)
    title('Original Image')
    subplot(1,2,2);
    imshow(wnr1)
    title('Restored Blurred Image (i = ' + i + ')')
end
%% Simulate and Restore Motion Blur and Gaussian Noise
blurred = imread('cup_blur_2.jpg');
noise_mean = 0;
noise_var = 0.0001;
blurred_noisy = imnoise(blurred,'gaussian',noise_mean,noise_var);
imshow(blurred_noisy)
title('Blurred and Noisy Image')
%% 
wnr2 = deconvwnr(blurred_noisy,PSF);
imshow(wnr2)
title('Restoration of Blurred Noisy Image (NSR = 0)')
%% 
signal_var = var(Idouble(:));
NSR = noise_var / signal_var;
wnr3 = deconvwnr(blurred_noisy,PSF,NSR);
imshow(wnr3)
title('Restoration of Blurred Noisy Image (Estimated NSR)')
%% Simulate and Restore Motion Blur and 8-Bit Quantization Noise
blurred_quantized = imfilter(Ioriginal,PSF,'conv','circular');
imshow(blurred_quantized)
title('Blurred Quantized Image')
%% 
wnr4 = deconvwnr(blurred_quantized,PSF);
imshow(wnr4)
title('Restoration of Blurred Quantized Image (NSR = 0)');
%% 
uniform_quantization_var = (1/256)^2 / 12;
signal_var = var(Idouble(:));
NSR = uniform_quantization_var / signal_var;
wnr5 = deconvwnr(blurred_quantized,PSF,NSR);
imshow(wnr5)
title('Restoration of Blurred Quantized Image (Estimated NSR)');
