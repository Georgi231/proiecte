load('lab2_02.mat');
id.X;
id.Y;
val.X;
val.Y;

n=30;
MSE_id=zeros(1,n);
MSE_val=zeros(1,n);

  
nmax=30;
min_MSE_val=Inf;
for n=1:30
A=zeros(length(id.X),n);
for i=1:length(id.X)
    for j=1:n                    
        A(i,j)=id.X(i).^(j-1);
    end
end
theta_id=A\id.Y';
F=zeros(length(val.X),n);
for i=1:length(val.X)
    for j=1:n
        F(i,j)=val.X(i).^(j-1);
    end
end
y_hat1=A*theta_id;
y_hat2=F*theta_id;
e_id=id.Y-y_hat1';
e_val=val.Y-y_hat2';

MSE_id(n)=sum(e_id.^2)/(length(id.X));
MSE_val(n)=sum(e_val.^2)/(length(val.X));

if MSE_val(n)<min_MSE_val
    min_MSE_val=MSE_val(n);
end
[min_MSE_val,grad_val]=min(MSE_val);
end

figure;
plot(1:n,MSE_id)
figure;
plot(1:n,MSE_val)
figure;
plot(id.X,id.Y,val.X,val.Y)
hold on
figure;
plot(val.X,val.Y,val.X,y_hat2)
fprintf("minimul este: %f \n:grad_val: %d\n" , min(MSE_val),grad_val);