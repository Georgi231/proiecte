% Încarcarea datelor
load("iddata-18.mat");

% Grafice initiale
figure;
plot(id)
title("Identificarea initiala")

figure;
plot(val)
title("Validarea initiala")

%na-ordinul polinomului ARX pentru ieșirea y
%nb-ordinul polinomului ARX pentru intrarea u
na = 3;
nb = 3;

% Date initiale
u_id = id.u;
y_id = id.y;
u_val = val.u;
y_val = val.y;
N = length(u_id);

% Gradul polinomului neliniar
n = 4;
% Construirea matricei de regresie
d = [];
for i = 1:N
 % Prima coloană întotdeauna 1
 d(i,1) = 1;
 % Se calculeaza termenii liniari ARX
  for j=2:na+1
   if i-j>0
    d(i,j)=-y_id(i-j);
     else
     d(i,j)=0;
     end
   end
% Se calculeaza partea 2 a matricii cu termeni ARX
   for j=na+2:na+nb+1
    if i-(j-na)>0
     d(i,j)=u_id(i-(j-na));
      else
     d(i,j)=0;
    end
   end

% Termeni polinomiali neliniari pentru datele de identificare
index=na+nb+2;
for m=2:n % m putere
 for w=0:m % w putere
  if i-w>0&&i-(j-na)>0
   parte_liniara = d(i,j);
   parte_neliniara = d(i-w,j-na);
   d(i, index) = -parte_neliniara^(m - w) * parte_liniara^w;
    % Se trece la urmatoarea coloană
    index=index+1;
    else
    d(i,index)=0;
    index=index+1;
    end
   end
  end
end
%predictia se face la fel pt validare
Nval=length(u_val);
d_val=[];
for i=1:Nval
 % Prima coloană întotdeauna 1
 d_val(i,1)=1;
 % Se calculeaza termenii liniari ARX
  for j=2:na+1
    if i-j>0
    d_val(i,j)=-y_val(i-j);
    else
    d_val(i,j) = 0;
    end
  end
  % Se calculeaza partea 2 a matricii cu termeni ARX
for j =na+2:na+nb+1
 if i-(j-na)>0
  d_val(i, j)=u_val(i-(j-na));
  else
  d_val(i,j)=0;
   end
 end
 % Termeni polinomiali neliniari pentru datele de validare
index = na + nb + 2;
for m = 2:n % m putere
 for w = 0:m % w putere
  if i-w>0 && i-(j-na) > 0
   parte_liniara = d_val(i,j);
   parte_neliniara = d_val(i-w,j-na);
   d_val(i,index) = -parte_neliniara^(m-w)*parte_liniara^w;
   % Se trece la urmatoarea coloană
   index = index+1;
   else
   d_val(i,index)=0;
   index = index+1;
   end
  end
 end
end

% Calculul parametrilor theta
theta=d\y_id;

% Calculul iesirii modelului identificat
y_id1=d*theta;
y_hat=d_val*theta;

% Validare prin simulare
ysim=zeros(Nval,1);
for i=2:Nval
    y1=0; % Suma pentru toate y-urile 
    y2=0; % Suma pentru toate u-urile
    y3=0; % Suma pentru toate y-urile si u-urile neliniare
% Termeni liniari ARX pentru y
 for j=1:na
  if i-j>0
   y1=y1-theta(j)*ysim(i-j);
   end
 end
% Termeni liniari ARX pentru u
 for j=1:nb
  if i-j>0
   y2=y2+theta(na+j)*u_val(i-j);
  end
end
% Termeni neliniari ARX
index=na+nb+2;
 for m =2:n % m putere
  for w=0:m % w putere
   if i-w>0 && i-(na+1) > 0
    parte_liniara = d_val(i,j);
    parte_neliniara = d_val(i-w, na+1);
    y3 = y3-theta(index)*parte_neliniara^(m - w)*parte_liniara^w;
    index = index + 1;
    end
   end
 end
%ysim(i) = y1 + y2 + y3;
ysim(i)=y3;
end

% Identificare prin simulare
ysimid=zeros(N, 1);
for i = 2:N
y1 = 0; % Suma pentru toate y-urile 
y2 = 0; % Suma pentru toate u-urile
y3 = 0; % Suma pentru toate y-urile si u-urile neliniare
% Termeni liniari ARX pentru y
for j = 1:na
 if i-j > 0
 y1=y1-theta(j)*ysimid(i-j);
 end
end
% Termeni liniari ARX pentru u
 for j=1:nb
  if i-j>0
   y2=y2+theta(na + j)*u_id(i - j);
  end
 end
% Termeni neliniari ARX
 index=na+nb+2;
 for m = 2:n % m putere
 for w = 0:m % w putere
   if i-w > 0 && i-(na+1) > 0
   parte_liniara = d(i,j);
   parte_neliniara=d(i-w,na+1);
   y3 = y3 - theta(index) * parte_neliniara^(m - w) * parte_liniara^w;
   index = index + 1;
   end
  end
 end
%ysim(i) = y1 + y2 + y3;
ysimid(i)=y3;
end

% Eroare identificare
e1=y_id-y_id1;
MSE1 = 1/N*sum(e1.^2);

% Eroare validare prezicere
e2=y_val-y_hat;
MSE2 = 1/Nval*sum(e2.^2);

% Eroare validare simulare
e3=y_val-ysim;
MSE3=1/Nval*sum(e3.^2);

% Eroare identificare simulare
e4=y_val-ysimid;
MSE4=1/N*sum(e4.^2);

% Afisarea graficelor cu MSE
figure;
plot(y_id);
hold on;
plot(y_id1);
title(['Identificare model ARX neliniar - MSE: ', num2str(MSE1)]);

figure;
plot(y_val);
hold on;
plot(y_hat);
title(['Validare model ARX neliniar - MSE: ', num2str(MSE2)]); 

figure;
plot(y_val);
hold on;
plot(ysim,'r');
title(['Validare model ARX neliniar simulare - MSE: ', num2str(MSE3)]);

figure;
plot(y_id);
hold on;
plot(ysimid,'r');
title(['Identificare model ARX neliniar simulare - MSE: ', num2str(MSE4)]);