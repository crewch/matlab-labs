%% 1.1. Моделирование искажения изображений с помощью шумов.
% Проведите моделирование искажения изображения путем добавления следующих шумов: гауссовский шум, шум типа «соль и перец».

imagePath = 'Img3_07_1.jpg';
originalImage = im2double(rgb2gray(imread(imagePath)));

% Параметры шумов
gaussianVar = 0.01;   % Дисперсия гауссовского шума
spDensity = 0.05;     % Плотность шума "соль и перец" (5%)

% Добавление шумов
gaussianImage = imnoise(originalImage, 'gaussian', 0, gaussianVar);
spImage = imnoise(originalImage, 'salt & pepper', spDensity);

figure;
subplot(1,3,1);
imshow(originalImage);
title('Исходное изображение');

subplot(1,3,2);
imshow(gaussianImage);
title(['Гауссовский шум (дисперсия = ', num2str(gaussianVar), ')']);

subplot(1,3,3);
imshow(spImage);
title(['Шум "соль и перец" (плотность = ', num2str(spDensity), ')']);

%% 1.2. Составьте программу, выполняющую подавление шумов с помощью масочных фильтров следующего вида:
% - среднеарифметический;
% - среднегеометрический;
% - среднегармонический;
% - медианный.

% Параметры фильтров
filterSize = [3, 3]; % Размер ядра фильтра (3x3)

% 1. Среднеарифметический фильтр
hMean = fspecial('average', filterSize);
meanGaussianImage = imfilter(gaussianImage, hMean);
meanSpImage = imfilter(spImage, hMean);

% 2. Среднегеометрический фильтр
geometricFilter = @(x) exp(mean(log(x(:) + eps))); % +eps для избежания log(0)
geomGaussianImage = nlfilter(gaussianImage, filterSize, geometricFilter);
geomSpImage = nlfilter(spImage, filterSize, geometricFilter);

% 3. Среднегармонический фильтр
harmonicFilter = @(x) numel(x) / sum(1./(x(:) + eps)); % +eps для избежания деления на 0
harmGaussianImage = nlfilter(gaussianImage, filterSize, harmonicFilter);
harmSpImage = nlfilter(spImage, filterSize, harmonicFilter);

% 4. Медианный фильтр
medGaussianImage = medfilt2(gaussianImage, filterSize);
medSpImage = medfilt2(spImage, filterSize);

% Визуализация результатов для гауссовского шума
figure;
subplot(2, 3, 1);
imshow(gaussianImage);
title('Гауссовский шум');

subplot(2, 3, 2);
imshow(meanGaussianImage);
title('Среднеарифм.');

subplot(2, 3, 3);
imshow(geomGaussianImage);
title('Среднегеометр.');

subplot(2, 3, 4);
imshow(harmGaussianImage);
title('Среднегармон.');

subplot(2, 3, 5);
imshow(medGaussianImage);
title('Медианный');

% Визуализация результатов для шума "соль и перец"
figure;
subplot(2, 3, 1);
imshow(spImage);
title('Шум "соль и перец"');

subplot(2, 3, 2);
imshow(meanSpImage); title('Среднеарифм.');

subplot(2, 3, 3);
imshow(geomSpImage);
title('Среднегеометр.');

subplot(2, 3, 4);
imshow(harmSpImage);
title('Среднегармон.');

subplot(2, 3, 5);
imshow(medSpImage);
title('Медианный');

%% 1.3. Проведите исследование эффективности подавления шумов обоих видов (гауссовского и «соль и перец») при различных уровнях зашумления и при использовании фильтров различного вида.

% Параметры тестирования
gaussianVars = [0.01, 0.05, 0.1];   % Уровни гауссовского шума
spDensities = [0.01, 0.05, 0.1];    % Уровни шума "соль и перец"
psnrResults = zeros(4, 2, 3); % [фильтр, тип шума, уровень]

% Функция для расчёта Peak Signal-to-Noise Ratio
% Чем выше PSNR — тем ближе отфильтрованное изображение к исходному.
calculatePsnr = @(orig, noisy) 10 * log10(1 / mean((orig(:) - noisy(:)).^2));

% Тестирование для гауссовского шума
for i = 1:3
	gaussianImage = imnoise(originalImage, 'gaussian', 0, gaussianVars(i));
	meanImage = imfilter(gaussianImage, hMean);
	geomImage = nlfilter(gaussianImage, filterSize, geometricFilter);
	harmImage = nlfilter(gaussianImage, filterSize, harmonicFilter);
	medImage = medfilt2(gaussianImage, filterSize);
	
	psnrResults(1, 1, i) = calculatePsnr(originalImage, meanImage);
	psnrResults(2, 1, i) = calculatePsnr(originalImage, geomImage);
	psnrResults(3, 1, i) = calculatePsnr(originalImage, harmImage);
	psnrResults(4, 1, i) = calculatePsnr(originalImage, medImage);
end

% Тестирование для шума "соль и перец"
for i = 1:3
	spImage = imnoise(originalImage, 'salt & pepper', spDensities(i));
	meanImage = imfilter(spImage, hMean);
	geomImage = nlfilter(spImage, filterSize, geometricFilter);
	harmImage = nlfilter(spImage, filterSize, harmonicFilter);
	medImage = medfilt2(spImage, filterSize);
	
	psnrResults(1, 2, i) = calculatePsnr(originalImage, meanImage);
	psnrResults(2, 2, i) = calculatePsnr(originalImage, geomImage);
	psnrResults(3, 2, i) = calculatePsnr(originalImage, harmImage);
	psnrResults(4, 2, i) = calculatePsnr(originalImage, medImage);
end

% Вывод таблицы Peak Signal-to-Noise Ratio
disp('Peak Signal-to-Noise Ratio (dB) для разных фильтров и шумов:');
disp('-----------------------------------------------------------');
disp('                      | Гауссовский шум | Шум "соль и перец"');
disp('                      | 0.01 | 0.05 | 0.1 | 0.01 | 0.05 | 0.1 |');
disp('-----------------------------------------------------------');
filters = {'Ср. арифм. ', 'Ср. геом. ', 'Ср. гарм. ', 'Медианный '};
for k = 1:4
	row = [filters{k}, ...
		num2str(psnrResults(k, 1, :)), "|", ...
		num2str(psnrResults(k, 2, :))];
	disp(row);
end


% Выводы:
% 1. Гауссовский шум:
% - Лучше всего работает среднеарифметический фильтр.

% 2. Шум соль и перец:
% - Медианный фильтр демонстрирует наилучшие результаты.

% 3. Зависимость от уровня шума:
% - С ростом уровня шума PSNR всех фильтров снижается.
% - Медианный фильтр сохраняет устойчивость даже при плотности шума 10%.
