%% Загрузка изображения
imagePath = 'Img2_07_3.jpg';
originalImage = im2double(imread(imagePath));

figure();
imshow(originalImage, []);
title('Исходное изображение');

figure();
histogram(originalImage);
title('Гистограмма исходного изображения');

%% Гамма-коррекция (imadjust)
gammaValue = 0.3; % Значение < 1 для осветления теней
gammaRestoredImage = imadjust(originalImage, [], [], gammaValue);

figure();
imshow(gammaRestoredImage, []);
title(['Гамма-коррекция (gamma=', num2str(gammaValue), ')']);

figure();
histogram(gammaRestoredImage);
title('Гистограмма после гамма-коррекции');

%% Эквализация гистограммы (histeq)
histeqRestoredImage = histeq(originalImage);

figure();
imshow(histeqRestoredImage, []);
title('Эквализация гистограммы (histeq)');

figure();
histogram(histeqRestoredImage);
title('Гистограмма после эквализации');

%% Автоматическое выравнивание яркости темных областей (imlocalbrighten)
localBrightenRestoredImage = imlocalbrighten(originalImage);

figure();
imshow(localBrightenRestoredImage, []);
title('Автоматическое выравнивание яркости темных областей (imlocalbrighten)');

figure();
histogram(localBrightenRestoredImage);
title('Гистограмма после автоматического выравнивания яркости темных областей');

%% Ручная настройка яркости/контраста (imcontrast)
figure();
imshow(originalImage, []);
title('Изображение после ручной настройки (imcontrast)');
imcontrast;

input('Нажмите Enter после настройки в imcontrast...');

if ishandle(gca)
	processedImage = getimage;
	
	figure();
	histogram(processedImage);
	title('Гистограмма после imcontrast');
else
	error('Не удалось получить изображение из fig-окна');
end
