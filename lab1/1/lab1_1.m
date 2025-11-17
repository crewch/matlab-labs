%% 1. Загрузка изображения
inputImagePath = 'Pic_22_1.bmp';
originalImage = im2double(imread(inputImagePath));
[height, width, ~] = size(originalImage);
processedImage = originalImage;

%% 1.1 Добавление прямоугольной сетки
gridSpacing = 200; % Расстояние между линиями (пиксели)
gridLineWidth = 3; % Толщина линий (пиксели)
gridColor = [1, 1, 0]; % Цвет сетки [R, G, B]

% Горизонтальные линии
for row = 1:gridSpacing:height
	endRow = min(row + gridLineWidth - 1, height);
	processedImage(row:endRow, :, 1) = gridColor(1); % Красный канал
	processedImage(row:endRow, :, 2) = gridColor(2); % Зелёный канал
	processedImage(row:endRow, :, 3) = gridColor(3); % Синий канал
end

% Вертикальные линии
for col = 1:gridSpacing:width
	endCol = min(col + gridLineWidth - 1, width);
	processedImage(:, col:endCol, 1) = gridColor(1);
	processedImage(:, col:endCol, 2) = gridColor(2);
	processedImage(:, col:endCol, 3) = gridColor(3);
end

%% 1.2 Добавление круглой области
circleCenterY = 400; % Y-координата центра (строки)
circleCenterX = 1000; % X-координата центра (столбцы)
circleRadius = 150; % Радиус в пикселях

% Проверка границ центра круга
circleCenterY = max(1, min(circleCenterY, height));
circleCenterX = max(1, min(circleCenterX, width));

circleRadiusSq = circleRadius^2;

for row = 1:height
	% Вычисляем расстояние только для текущей строки
	rowDistSq = (row - circleCenterY).^2 + ( (1:width) - circleCenterX ).^2;
	inCircle = (rowDistSq <= circleRadiusSq);
	
	% Применяем изменения только в пределах изображения
	validCols = inCircle & (1:width <= width);
	
	% Цвет
	% processedImage(row, validCols, 1) = 0; % Красный канал
	processedImage(row, validCols, 2) = 0; % Зелёный канал
	processedImage(row, validCols, 3) = 0; % Синий канал
end

%% 1.3 Добавление прямоугольной области
rectTop = 100; % Верхняя граница
rectBottom = 500; % Нижняя граница
rectLeft = 100; % Левая граница
rectRight = 500; % Правая граница

% Цвет
processedImage(rectTop:rectBottom, rectLeft:rectRight, 1) = 0; % Красный
processedImage(rectTop:rectBottom, rectLeft:rectRight, 2) = 0; % Зелёный
% processedImage(rectTop:rectBottom, rectLeft:rectRight, 3) = 0; % Синий

%% 1.4 Сохранение результата
outputImagePath = './results/Processed_Pic_22_1.bmp';
imwrite(processedImage, outputImagePath, 'bmp');
