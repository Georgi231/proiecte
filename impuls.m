load('lab4_order1_2.mat')
u1=data.InputData;
u1=u1{1};
y1=data.OutputData;
y1=y1{1};
figure;
plot(t,u1);
hold on;
figure;
plot(t,y1);

yss=3;
uss=2;
ymax=3.95;
y_t1=0.368*(ymax-yss)+yss;
t0=3.84;
t1=5.4;
T=t1-t0;
K=yss/uss;
A=-1/T;
B=K/T;
C=1;
D=0;
H=ss(A,B,C,D);

u1_valid=u1(110:330);
y1_valid=y1(110:330);
t_valid=t(110:330);

y_simulat=lsim(H,u1_valid,t_valid);
figure;
hold on;
plot(t_valid,u1_valid);
plot(t_valid,y1_valid);
plot(t_valid,y_simulat);

MSE=sum((y1_valid-y_simulat).^2)/(length(y1_valid));
fprintf(" MSE impuls de ordin 1: %.2f\n",MSE);

%%
load('lab4_order2_2.mat')
u1=data.InputData;
u1=u1{1};
y1=data.OutputData;
y1=y1{1};
figure;
plot(t,u1);
hold on;
figure;
plot(t,y1);

yss=0.5;
uss=1;
tmax1=3.11;
tmax3=5.33;
T0=tmax3-tmax1;
K=yss/uss;
t1=2.7;
t2=4.3;
t3=5.2;

u1_valid=u1(110:330);
y1_valid=y1(110:330);
t_valid=t(110:330);


Ts=t(2)-t(1);
A_plus=Ts*sum(y1(31:44)-yss);
A_minus=Ts*sum(y1(44:56)-yss);
M=abs(A_minus)/A_plus;

tita=(log(1/M))/sqrt(pi^2+log(M)^2);
omega=(2*pi)/(T0*sqrt(1-tita^2));
H=tf(K*omega^2,[1,2*tita*omega,omega^2]);
y_simulat=lsim(H,u1_valid,t_valid);

figure;
hold on;
plot(t_valid,u1_valid);
plot(t_valid,y1_valid);
plot(t_valid,y_simulat);


MSE=sum((y1_valid-y_simulat).^2)/(length(y1_valid));
fprintf(" MSE impuls de ordin 2: %.2f\n",MSE);



