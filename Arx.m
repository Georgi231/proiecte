load('lab6_2.mat');
u =id.u;
y =id.y;
yval=val.u;
uval=val.y;
figure;
plot(u);
hold on;
figure;
plot(y);
figure 
plot(uval)
hold on
figure
plot(yval)

X_val(k-max(na,nb), :) = [y_reg, u_reg];
 X(k- max(na,nb), :) = [y_reg, u_reg];
na=7;
nb=7;

Phi = zeros(length(y )-max(na,nb) ,na + nb);
idx=1;%contor pt a pastra urm indice de umplere in matrice 

for k = max(na, nb) + 1:length(y)
    y_reg = -y(k - 1:-1:k - na);
    u_reg = u(k - 1:-1:k - nb);
    


   Phi(k ,:) = [y_reg, u_reg];
   idx=idx+1;
end

theta = Phi\y(max(na, nb) + 1:end);

y_hat = zeros(size(y));
for k = max(na, nb) + 1:length(yval)
    y_reg = -y_hat(k - 1:-1:k - na);
    u_reg = uval(k - 1:-1:k - nb);
    
     y_reg = [zeros(1, max(0, na - length(y_reg))), y_reg];
    u_reg = [zeros(1, max(0, nb - length(u_reg))), u_reg];
    
    y_hat(k) = [y_reg, u_reg] * theta;
end
MSE_train = mean((y(na+1:end) - y_hat(na+1:end)).^2);
MSE_val = mean((yval(na+1:end) - y_hat_val(na+1:end)).^2);

fprintf('MSE pentru datele de antrenare: %f\n', MSE_train);
fprintf('MSE pentru datele de validare: %f\n', MSE_val);
figure;
plot(y);
hold on;
plot(y_hat);
figure
plot(yval);
hold on;
plot(y_hat_val);
 


