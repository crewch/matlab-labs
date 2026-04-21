%% 1. Загрузка исходного изображения

f = load('A5_07_1.mat', '-ascii');
f = double(f);
F = fft2(f);

[rows, cols] = size(f);

%% 2 Первый способ: умножение на (-1)^(x+y)

% Генерация матрицы коэффициентов (-1)^(x+y)
[x, y] = meshgrid(0:cols-1, 0:rows-1);
center_mask = (-1).^(x + y);

% Модулированное изображение
f_mod = f .* center_mask;

% Спектр модулированного изображения
F_c1 = fft2(f_mod);

% Амплитудный спектр и логарифмирование
Amp_c1 = abs(F_c1);
AmpL_c1 = log(1 + Amp_c1);

% Отображаем
figure;
imshow(mat2gray(AmpL_c1), []);
title('Центрированный спектр (способ 1: умножение на (-1)^{x+y})');
imwrite(mat2gray(AmpL_c1), 'task5_07_centered_spectrum_method1.jpg');

%% 3 Второй способ: fftshift

% Центрируем спектр непосредственно
F_c2 = fftshift(F);

% Амплитудный спектр второго способа
Amp_c2 = abs(F_c2);
AmpL_c2 = log(1 + Amp_c2);

figure;
imshow(mat2gray(AmpL_c2), []);
title('Центрированный спектр (способ 2: fftshift)');
imwrite(mat2gray(AmpL_c2), 'task5_07_centered_spectrum_method2.jpg');

%% 4 Восстановление изображений из центрированных спектров

% --- Способ 1 ---
% Обратное ДПФ
f_rec1_mod = ifft2(F_c1);

% Снимаем модуляцию, умножая на (-1)^(x+y)
f_rec1 = real(f_rec1_mod .* center_mask);
f_rec1_norm = mat2gray(f_rec1);

figure;
imshow(f_rec1_norm, []);
title('Восстановленное изображение (из центрированного спектра, способ 1)');
imwrite(f_rec1_norm, 'task5_07_reconstructed_method1.jpg');

% --- Способ 2 ---
% Сначала снимаем центрирование: ifftshift
F_unshift = ifftshift(F_c2);

% Теперь обратное ДПФ
f_rec2 = real(ifft2(F_unshift));
f_rec2_norm = mat2gray(f_rec2);

figure;
imshow(f_rec2_norm, []);
title('Восстановленное изображение (из центрированного спектра, способ 2)');
imwrite(f_rec2_norm, 'task5_07_reconstructed_method2.jpg');

%% Выводы:
% 1) Оба способа дают одинаковый центрированный амплитудный спектр.
%
% 2) Восстановленные изображения идентичны исходному (с учётом погрешностей).
%
% 3) Умножение на (-1)^(x+y) и fftshift — эквивалентные операции.
