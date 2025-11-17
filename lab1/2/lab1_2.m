%% Загрузка изображения
inputImagePath = 'Pic_22_2.jpg';
originalImage = im2double(imread(inputImagePath));
[height, width, ~] = size(originalImage);

%% Полутоновое изображение
grayscaleImage = rgb2gray(originalImage);

%% Негативное изображение
negativeImage = 1 - grayscaleImage; % Инверсия значений пикселей

%% Полутоновое с заданным числом градаций
numGrayLevels = 10; % Заданное количество градаций серого (10 оттенков серого вместо 256)
grayStep = 1 / numGrayLevels; % Шаг между уровнями яркости
thresholds = 0:grayStep:1; % Пороговые значения для квантования
quantizedImage = grayscaleImage; % Создание копии для модификации

% Применение квантования к каждому пикселю
for row = 1:height
	for col = 1:width
		for levelIdx = 2:length(thresholds)
			currentPixel = quantizedImage(row, col);
			lowerBound = thresholds(levelIdx-1);
			upperBound = thresholds(levelIdx);
			
			% Проверка принадлежности пикселя к текущему диапазону
			if currentPixel >= lowerBound && currentPixel < upperBound
				quantizedImage(row, col) = lowerBound;
			end
		end
	end
end

% Нормализация для максимального контраста
maxPixelValue = max(quantizedImage(:));
if maxPixelValue > 0
	quantizedImage = quantizedImage / maxPixelValue;
end

%% Палитровое изображение
% Формирование индексов для цветовой карты (диапазон 1-10)
paletteIndices = round(10 * quantizedImage);
paletteIndices = uint8(max(1, min(10, paletteIndices))); % Гарантирует, что индексы лежат в диапазоне [1, 10]
springColormap = spring(10); % Получение цветовой схемы

%% Сохранение всех результатов в файлы
imwrite(originalImage, './results/original_color.jpg'); % Исходное цветное изображение
imwrite(grayscaleImage, './results/grayscale.jpg'); % Полутоновое изображение
imwrite(negativeImage, './results/negative.jpg'); % Негативное изображение
imwrite(quantizedImage, './results/quantized.jpg'); % Полутоновое с заданным числом градаций
imwrite(ind2rgb(paletteIndices, springColormap), './results/pseudocolored.jpg'); % Результат с цветовой картой