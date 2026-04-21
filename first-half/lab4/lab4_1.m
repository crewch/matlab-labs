fs  = 5000;             % частота дискретизации (достаточно для 2000 Гц)
T   = 1;                % длительность сигнала
t   = 0:1/fs:T-1/fs;    % вектор времени

f1 = 200;    % 200 Гц
f2 = 500;    % 500 Гц
f3 = 600;    % 600 Гц
f4 = 2000;   % 2000 Гц

% Формируем сигнал
x = sin(2*pi*f1*t) + sin(2*pi*f2*t) + sin(2*pi*f3*t) + sin(2*pi*f4*t);

figure;
plot(t,x);
xlabel('t, c');
ylabel('x(t)');
title('Сигнал (200+500+600+2000 Гц)');
grid on;
xlim([0 0.02]);

%% Спектр сигнала
N  = length(x);
X  = fft(x, N);
f  = (0:N-1)*(fs/N);

figure;
plot(f(1:N/2), abs(X(1:N/2)));
xlabel('f, Гц');
ylabel('|X(f)|');
title('Спектр исходного сигнала');
grid on;
xlim([0 3000]);

%% Создание фильтра для 200 Гц и 600 Гц
% Параметры фильтра
Rp = 0.01;     % пульсации в полосе пропускания
Rs = 0.001;    % подавление в полосе заграждения

% Полосы пропускания для двух частот
passband1 = [150 250]/(fs/2);   % для 200 Гц
passband2 = [550 650]/(fs/2);   % для 600 Гц

% Полосы подавления
stopband1 = [100 300]/(fs/2);   % между 200 и 600 Гц
stopband2 = [700 fs/2]/(fs/2);  % высокие частоты

% Расчёт фильтра через kaiserord для первой полосы
[n1, Wn1, beta1] = kaiserord([100 300], [1 0], [Rp Rs], fs);
n1 = n1 + rem(n1,2);
h1 = fir1(n1, passband1, 'bandpass', kaiser(n1+1, beta1), 'noscale');

% Расчёт фильтра для второй полосы
[n2, Wn2, beta2] = kaiserord([500 700], [1 0], [Rp Rs], fs);
n2 = n2 + rem(n2,2);
h2 = fir1(n2, passband2, 'bandpass', kaiser(n2+1, beta2), 'noscale');

% Объединяем фильтры
h = h1 + h2;

%% Характеристики фильтра
figure;
stem(0:length(h)-1, h, 'filled');
xlabel('n');
ylabel('h[n]');
title('Импульсная характеристика фильтра');
grid on;

[H, w] = freqz(h, 1, 1024, fs);
figure;
plot(w, abs(H));
xlabel('f, Гц');
ylabel('|H(f)|');
title('АЧХ фильтра');
grid on;
xlim([0 3000]);

%% Фильтрация во временной области
y_time = conv(x, h, 'same');

figure;
plot(t, y_time);
xlabel('t, c');
ylabel('y(t)');
title('Сигнал после фильтрации (временная область)');
grid on;
xlim([0 0.02]);

%% Фильтрация в частотной области
h_pad = [h zeros(1, N-length(h))];
Hf = fft(h_pad, N);
Y_freq = X .* Hf;
y_freq = real(ifft(Y_freq));
y_freq = y_freq(1:length(t));

%% Сравнение результатов
figure;
subplot(2,1,1);
plot(t, y_time);
title('Временная область');
grid on;
xlim([0 0.02]);

subplot(2,1,2);
plot(t, y_freq);
title('Частотная область');
grid on;
xlim([0 0.02]);

%% Спектр выходного сигнала
Y = fft(y_time, N);
figure;
plot(f(1:N/2), abs(Y(1:N/2)));
xlabel('f, Гц');
ylabel('|Y(f)|');
title('Спектр после фильтрации');
grid on;
xlim([0 3000]);