function [senyal] = AplicarFiltro(tipus,Bw,ganancia, fc,senyal, fFI, fref)
senyal=fft(senyal);
lenght=size(senyal);
gananciaM=[];
i=1;
if (tipus=="RF") % Primero de todo el filtro RF 
    while (i<=lenght(2))
        if (i>(fc-Bw/2)&& i<(fc+Bw/2) || i>(lenght(2)-(fc+Bw/2)) && i<(lenght(2)-(fc-Bw/2)))
            gananciaM(i)=ganancia; % ganancia en lineal
        else
            gananciaM(i)=10e-6; % parte que se atenuará
        end
        i=i+1;
    end
    senyal=senyal.*gananciaM;

elseif(tipus=="FI") % El filtro FI  
    while (i<=lenght(2))
        if (i>(fFI-Bw/2)&& i<(fFI+Bw/2) || i>(lenght(2)-(fFI+Bw/2)) && i<(lenght(2)-(fFI-Bw/2)))
            gananciaM(i)=ganancia; % ganancia en lineal
        else
            gananciaM(i)=10e-6; % parte que se atenuará
        end
        i=i+1;
    end
    senyal=senyal.*gananciaM;

elseif(tipus=="PB") % El filtro Pasa-bajos 
        while (i<=lenght(2))
            if (i<(fref+Bw/2) || i>(lenght(2)-(fref+Bw/2)))
                gananciaM(i)=ganancia; % ganancia en lineal
            else
                gananciaM(i)=10e-6; % parte que se atenuará
            end
            i=i+1;
        end
        senyal=senyal.*gananciaM;
        senyal(1)=senyal(1)*0; % Eliminamos la continua con un condensador

end
end
