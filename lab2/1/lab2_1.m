%% Загрузка изображения
inputImagePath = 'Img2_07_1.jpg';
originalGrayImage = im2double(rgb2gray(imread(inputImagePath)));
[height, width, ~] = size(originalGrayImage);

%% Генерация неравномерной засветки (градиент по вертикали)
% Создание матрицы засветки, увеличивающейся снизу вверх
baseRowVector = ones(1, width);
shadingMatrix = zeros(height, width);

for currentRow = 1:height
	intensityFactor = (height - currentRow + 1)^2; % Квадратичный градиент
	shadingMatrix(currentRow, :) = intensityFactor * baseRowVector;
end

% Нормализация матрицы засветки
shadingMatrix = shadingMatrix / max(shadingMatrix(:));

% Применение засветки к исходному изображению
shadedImage = originalGrayImage .* shadingMatrix;
% Нормализация затененного изображения
shadedImage = shadedImage / max(shadedImage(:));

%% Восстановление изображения с помощью коррекции неравномерной засветки
% Подбор параметра sigma для функции imflatfield
sigma = 130;
correctedImage = imflatfield(shadedImage, sigma);

%% Сохранение всех изображений
resultsFolder = './results/';

imwrite(originalGrayImage, fullfile(resultsFolder, 'original_image.png'));
imwrite(shadingMatrix, fullfile(resultsFolder, 'shading_matrix.png'));
imwrite(shadedImage, fullfile(resultsFolder, 'shaded_image.png'));
imwrite(correctedImage, fullfile(resultsFolder, 'corrected_image.png'));