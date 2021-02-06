function [signal_norm]=subactionsnorm(signal,nr_sample)
%Per la specifica variabile scrive un file VARIABILE.DAT che contiene in formato testo (cosi' poi importi in excel)
%la variabile per tutti i file .MAT specificati normalizzata nel tempo (li mette tutti a 100 frames)

if(length(signal)==nr_sample)
    signal_norm=signal;
else
    T=1:length(signal);
    TT=0:length(signal)/(nr_sample-1):length(signal);
    signal_norm=reshape(spline(T,signal,TT),nr_sample,1);
end

