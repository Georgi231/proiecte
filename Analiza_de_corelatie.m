load('lab5_2.mat')

u =id.InputData{1};
y =id.OutputData{1};
figure
plot(detrend(y))

yval=val.OutputData{1};
uval=val.InputData{1};


M=40;
L=length(u);
T=length(y);
ru=zeros(1,L);
ryu=zeros(1,L);
for i=1:T-1
    for j=1:T-i
       ru(i) = ru(i) + u(j+i-1) * u(j);
       ryu(i) = ryu(i) + y(j+i-1) * u(j);
    end
    ru(i) = ru(i) / L;
    ryu(i) = ryu(i) / L;
end

RU=zeros(L,M);
for i=1:L
    for j=1:M
        if i<j
        RU(i,j)=ru(abs(j-i)+1);
        else
            RU(i,j) = ru(abs(i-j)+1);
    end 
end
end

h=RU\ryu';
figure
plot(h)


y_hat=conv(h,u);
y_hat=y_hat(1:length(u));
figure
plot(y)
hold on
plot(y_hat)

y_hat_val=conv(h,uval);
y_hat_val=y_hat_val(1:length(uval));
figure
plot(yval)
hold on
plot(y_hat_val)

error=y-y_hat;
MSE=sum((error).^2)/length(error)

fprintf('MSE este de :%d %f\n',MSE )