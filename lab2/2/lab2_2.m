contrastParameter = 60;

resultsFolder = './results/';

imageData = load('Z2_07_2.mat', '-ASCII');

imwrite(imageData,  fullfile(resultsFolder, 'original_image.png'));

% Определение динамического диапазона яркостей исходного изображения
imageMax = max(imageData(:));
imageMin = min(imageData(:));
fprintf('Динамический диапазон исходного изображения: от %f до %f\n', imageMin, imageMax);

% Применение нелинейного (логарифмического) преобразования
% Формула: log(1 + contrastParameter * I)
% Параметр contrastParameter позволяет управлять "крутизной" нелинейности
logTransformed = log(1 + contrastParameter * imageData);

% Определение динамического диапазона преобразованного изображения
logMin = min(logTransformed(:));
logMax = max(logTransformed(:));
fprintf('Динамический диапазон после лог-преобразования: от %f до %f\n', logMin, logMax);

% Нормализация результата преобразования в диапазон [0, 1]
logTransformed = logTransformed / logMax;

imwrite(logTransformed, fullfile(resultsFolder,'log_transformed_image.png'));