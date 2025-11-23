%% 2.1. Использование Лапласиана.
% Используя расфокусировку с помощью гауссовского фильтра
% получите слегка размытое изображение.
% Используя Лапласиан улучшите резкость изображения. Путем
% анализа некоторых деталей изображения (букв, символов, мелких
% деталей) сделайте выводы о степени улучшения изображения в
% результате использования Лапласиана (например, стали ли читаться
% буквы, насколько лучше видны отдельные детали и т.д.).
% Используйте две функции Matlab: imfilter с маской Лапласиана и locallapfilt.
% Сравните результаты улучшения изображения.

grayImage = im2double(rgb2gray(imread('Img3_07_1.jpg')));

% Гауссово размытие
sigma = 1.5;
blurredImage = imgaussfilt(grayImage, sigma);

% Лапласиан через imfilter
laplacianMask = [0 1 0; 1 -4 1; 0 1 0];
laplacianImage = imfilter(blurredImage, laplacianMask, 'replicate', 'same');
sharpenedImfilter = im2uint8(mat2gray(blurredImage - laplacianImage));

% Лапласиан через locallapfilt
alpha = 0.4; % степень сглаживания
beta = 0.8; % степень усиления деталей
sharpenedLocallap = locallapfilt(im2uint8(blurredImage), alpha, beta);

figure;
subplot(1,3,1);
imshow(blurredImage);
title('Размытое изображение');

subplot(1,3,2);
imshow(sharpenedImfilter);
title('Лапласиан (imfilter)');

subplot(1,3,3);
imshow(sharpenedLocallap);
title('Лапласиан (locallapfilt)');

%% 2.2. Использование маски Собела.
% Используя такую же расфокусировку заданного изображения, что и
% в п. 2.1, улучшите резкость с помощью масочного фильтра Собела.

% Маски Собела для обнаружения краёв
sobelGx = [-1 0 1; -2 0 2; -1 0 1];
sobelGy = [-1 -2 -1; 0 0 0; 1 2 1];

% Применение фильтра Собела
sobelX = imfilter(blurredImage, sobelGx, 'replicate', 'same');
sobelY = imfilter(blurredImage, sobelGy, 'replicate', 'same');
sobelMagnitude = mat2gray(sqrt(sobelX.^2 + sobelY.^2));

% Улучшение резкости (добавление краёв к исходному размытому изображению)
k = 0.7; % Коэффициент усиления
sharpenedSobel = im2uint8(mat2gray(blurredImage + k * sobelMagnitude));

figure;
subplot(1,2,1);
imshow(blurredImage);
title('Размытое изображение');

subplot(1,2,2);
imshow(sharpenedSobel);
title('Собел (k=0.7)');

%% 2.3. Сравните эффективность работы двух алгоритмов улучшения резкости изображения: Лапласиана и оператора Собела.

figure;
subplot(1,3,1);
imshow(sharpenedImfilter);
title('Лапласиан (imfilter)');

subplot(1,3,2);
imshow(sharpenedLocallap);
title('Лапласиан (locallapfilt)');

subplot(1,3,3);
imshow(sharpenedSobel);
title('Собел');

figure;
imshowpair(sharpenedImfilter, sharpenedSobel, 'montage');
title('Сравнение Лапласиана imfilter (слева) и Собела (справа)');
