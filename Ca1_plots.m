% Por: Víctor Peso Keyer
% Con tal de obtener las gráficas de las diferentes señales utilizadas en
% el VOR i la del mismo VOR tenemos que establecer los valores que tendrá
% cada variable. Estas mismas variables las cambiaremos a lo largo del
% proyecto con tal de observar como varian las diferenes gráficas.
%
% Variables:
%   ** Amplitudes:
%      · A --> Amplitud de la señal VOR
%      · Am --> Amplitud de la señal de información
%
%   ** m --> Índice de modulación. Dependiendo del valor que cojamos habrá
% sobremodulación 
%
%   ** B --> Beta, índice de modulación
%
%   ** T_m --> Periodo de mostreo
%
%   ** t --> vector temporal. A través del periodo, creamos un vector que va
% de 0 a 1 s saltando entre intervalos de T_m
%
%   ** Frecuencias:
%      · fport --> Frecuencia portadora
%      · fB --> Frecuencia máxima, también puede ser representada como: fm
%      · fc --> Frecuencia de la señal VOR
%      · fd --> Frecuencia de desviación

% En este caso tenemos estos valores:
A=1; 
Am=1; 
m=0.5;
B=16;
T_m=1e-7; 
t=0:T_m:1; 
fport=9960;
fB=30; 
fc=1e6; 
fd=B*fB/Am; 

% Ahora que ya tenemos todos los parametros escribimos las diferentes
% señales:
% Señal de información:
x=Am*cos(2*pi*fB*t); 
x_int=cumsum(x)*T_m; % aquí calculamos la integral de x con tal que, más 
% adelante, se pueda encontrar la señal FM

% FM:
y_FM=cos(2*pi*fport*t+x_int*fd*2*pi); % esta seria la expresión de la señal
% FM, la cual está formada por un coseno de frecuencia variable
% To:
y_t=cos(2*pi*fB*t); % esta es la expresión de un coseno que más adelante se
% se combertirá en dos deltas situadas en las frecuencias +fB y -fB.

% VOR
x_sum= y_FM + y_t; % para finalmente conseguir la señal VOR, sumamos las dos
% expresiones previas.

s_vor=A*(1+m*x_sum).*cos(2*pi*fc*t); % finalmente obtenemos la señal temporal
% del VOR
s_fft=fft(s_vor); % una vez tenemos la señal temporal del VOR, tenemos que
% hacer su transformada de fourier para más adelante poderla graficar.

% Plots
% Por lo que hace a las diferentes gráficas, plotearemos lo siguiente:
% ** Plots:
%    -- Plot(1): plot temporal de la señal de información
%    -- Plot(2): plot del espectro de la senyal de información
%    -- Plot(3): plot de la densidad espectral de potencia de la señal
%    de información
%    -- Plot(4): plot temporal de la señal FM
%    -- Plot(5): plot del espectro de la señal FM
%    -- Plot(6): plot de la densidad espectral de potencia de la señal FM
%    -- Plot(7): plot temporal de la señal FM + tono
%    -- Plot(8): plot del espectro de la señal FM + tono
%    -- Plot(9): plot de la densidad espectral de potencia de la señal FM
%    + tono
%    -- Plot(10): plot temporal de la señal VOR
%    -- Plot(11): plot del espectro de la señal VOR
%    -- Plot(12): plot de la densidad espectral de potencia de la señal VOR
%    -- Plot(13): plot comparación FM i VOR
%    -- Plot(14): plot FM a diferentes fd
%    -- Plot(15): plot envolvente de la señal VOR m=1
%    -- Plot(16): plot señal de información fB=50 Hz
%    -- Plot(17): plot Tono i FM ampliadas por separado
%    -- Plot(18): plot frecuencia instantánea
%    -- Plot(19): plot FM a fB=150 Hz

%    * Plots del procesado:
%    -- Plot(20): plot después del filtro RF
%    -- Plot(21): plot después del primer oscilador
%    -- Plot(22): plot después del filtro FI
%    -- Plot(23): plot después del oscilador del demodulador AM
%    -- Plot(24): plot después del filtre pasa-bajos del demodulador AM

close all;

figure(1);
plot(t,x);
title('Plot señal información')
xlabel('tiempo [s]')
ylabel('Amplitud')

figure(2);
plot(log10(abs(fft(x))));
title('Plot espectro de la señal información')
xlabel('frecuencia [Hz]')
ylabel('Amplitud')

figure(3);
plot(log10(abs(fft(x)).^2));
title('Plot densidad espectral de potencia señal información')
xlabel('frecuencia [Hz]')
ylabel('Densidad espectral de potencia')

figure(4);
plot(t,y_FM); 
title('Plot señal FM')
xlabel('tiempo [s]')
ylabel('Amplitud')

figure(5);
y_plot=log10(abs(fft(y_FM)));
plot(y_plot);
title('Plot espectro de la señal FM')
xlabel('frecuencia [Hz]')
ylabel('Amplitud')

figure(6);
plot(log10(abs(fft(y_FM)).^2));
title('Plot densidad espectral de potencia señal FM')
xlabel('frecuencia [Hz]')
ylabel('Densidad espectral de potencia')

figure(7);
plot(t,x_sum); 
title('Plot señal FM + tono')
xlabel('tiempo [s]')
ylabel('Amplitud')

figure(8);
plot(log10(abs(fft(x_sum))));
title('Plot espectro de la señal FM + tono')
xlabel('frecuencia [Hz]')
ylabel('Amplitud')

figure(9);
plot(log10(abs(fft(x_sum)).^2));
title('Plot densidad espectral de potencia señal FM + tono')
xlabel('frecuencia [Hz]')
ylabel('Densidad espectral de potencia')

figure(10);
plot(t,s_vor); 
title('Plot señal VOR')
xlabel('tiempo [s]')
ylabel('Amplitud ')

figure(11);
plot(log10(abs(s_fft))); % Hacemos el plot del logatirmo del módulo de la
% transformada de Fourier de la señal VOR ya que la transformada nos darà
% números complejos complicados de interpretar en una gráfica
title('Plot espectro de la señal VOR')
xlabel('frecuencia [Hz]')
ylabel('Amplitud')

figure(12);
plot(log10(abs(s_fft).^2));
title('Plot densidad espectral de potencia señal VOR')
xlabel('frecuencia [Hz]')
ylabel('Densidad espectral de potencia')

figure(13);
subplot(2,1,1);
plot(t,y_FM);
title('Plot FM')
ylabel('Amplitud')
subplot(2,1,2); 
plot(t,s_vor);
title('Plot VOR')
xlabel('Tiempo [s]')
ylabel('Amplitud')

figure(14);
subplot(2,1,1);
plot(t,y_FM);
title('Plot FM')
ylabel('Amplitud')
fd=7500;
y_FM=cos(2*pi*fport*t+x_int*fd*2*pi);
subplot(2,1,2); 
plot(t,y_FM);
xlabel('Tiempo [s]')
ylabel('Amplitud')

m=0.5;
s_vor=A*(1+m*x_sum).*cos(2*pi*fc*t);
figure(15);
[upper,lower]=envelope(s_vor);
q=[upper;lower]';
plot(q);
legend('upper','lower');
title('Plot envolvente de la señal VOR (m=0.5)')
xlabel('Puntos')
ylabel('Amplitud')

fB=50; 
x=Am*cos(2*pi*fB*t); 
figure(16);
plot(log10(abs(fft(x))));
title('Plot espectro de la señal información')
xlabel('frecuencia [Hz]')
ylabel('Amplitud')

figure(17);
subplot(1,2,1);
x_plot=log10(abs(fft(x_sum)));
plot(x_plot(1:1000));
xlabel('frecuencia [Hz]')
ylabel('Amplitud')
title('Tono')
subplot(1,2,2);
plot(x_plot(9000:11000));
title('FM')
xlabel('frecuencia [Hz]')
ylabel('Amplitud')

figure(18);
fi=fport+fd*x;
plot(t,fi);
title('Frecuencia instantanea')
xlabel('Tiempo [s]')
ylabel('Frecuencia [Hz]')

figure(19);
fB=150;
fd=75;
x=Am*cos(2*pi*fB*t); 
x_int=cumsum(x)*T_m;
y_FM=cos(2*pi*fport*t+x_int*fd*2*pi);
y_plot=log10(abs(fft(y_FM)));
plot(y_plot);
title('Plot espectro de la señal FM fB=150 Hz')
xlabel('Frecuencia [Hz]')
ylabel('Amplitud')


%% Procesado de la señal:
% Al pasar por el filtro RF:
senyal_mod=AplicarFiltro("RF",20940,100,fc,s_vor,0,0);
% senyal_mod=AplicarFiltro("RF",15000,100,fc,s_vor,0,0);
figure(20);
plot(log10(abs(senyal_mod)));
title('Plot después del filtro RF')
xlabel('frecuencia [Hz]')
ylabel('Amplitud')

% Al pasar por el oscilador:
fFI=30000;
fOL=fc-fFI;
senyal=ifft(senyal_mod);
senyal_osc=senyal.*cos(2*pi*fOL*t);
figure(21);
plot(log10(abs(fft(senyal_osc))));
title('Plot después del oscilador')
xlabel('frecuencia [Hz]')
ylabel('Amplitud')

% Al pasar por el filtro FI:
senyal_modFI=AplicarFiltro("FI", 20940, 10, 0, senyal_osc, fFI, 0);
figure(22);
plot(log10(abs(senyal_modFI)));
title('Plot después del filtro FI')
xlabel('frecuencia [Hz]')
ylabel('Amplitud')

% Al pasar por el demodulador:
% Primero per su oscilador
senyal=ifft(senyal_modFI);
senyal_osc2=senyal.*cos(2*pi*fFI*t);
figure(23);
plot(log10(abs(fft(senyal_osc2))));
title('Plot después del oscilador del demodulador')
xlabel('frecuencia [Hz]')
ylabel('Amplitud')

% Al pasar por el filtro PB
senyal_modPB=AplicarFiltro("PB", 20940, 1, 0, senyal_osc2, 0, fport); 
figure(24);
plot(log10(abs(senyal_modPB)));
title('Plot después del filtro PB')
xlabel('frecuencia [Hz]')
ylabel('Amplitud')
