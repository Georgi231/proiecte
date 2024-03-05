load('lab3_order1_4.mat');

u1=data.InputData;
u1=u1{1};
y1=data.OutputData;
y1=y1{1};
figure;
plot(t,u1)
hold on;
figure;
plot(t,y1)

yss=0.3;
uss=3;
K=yss/uss; %factorul de amplificare
y_max=0.632*yss;
T=2.45;
H=tf(K,[T,1]);
T=2.45;

u1_valid=u1(201:500);
y1_valid=y1(201:500);
t_valid=t(201:500);

y_simulat=lsim(H,u1_valid,t_valid);
figure;
hold on;
plot(t_valid,y1_valid);
plot(t_valid,u1_valid);
plot(t_valid,y_simulat);

MSE=sum((y1_valid-y_simulat).^2)/(length(y1_valid));

fprintf(" MSE ordin 1= %.2f\n",MSE );


%%
load('lab3_order2_4.mat')
u1=data.InputData;
u1=u1{1};
y1=data.OutputData;
y1=y1{1};
figure;
plot(t,u1)
hold on;
figure;
plot(t,y1)
y0=y1(1)

yss=1.2;
uss=0.5;
K=yss/uss;
t0=3.6;
t1=10;
T0=t1-t0;
ymax=1.8;

M=(ymax-yss)/(yss-y0);
tita=(log(1/M))/sqrt(pi^2+log(M)^2);
omega=(2*pi)/(T0*sqrt(1-tita^2));

H=tf(K*omega^2,[1,2*tita*omega,omega^2]);

u1_valid=u1(201:500);
y1_valid=y1(201:500);
t_valid=t(201:500);
y_simulat=lsim(H,u1_valid,t_valid);
figure;
hold on;
plot(t_valid,y1_valid);
plot(t_valid,u1_valid);
plot(t_valid,y_simulat);

MSE=sum((y1_valid-y_simulat).^2)/(length(y1_valid));
fprintf(" MSE ordin 2= %.2f\n",MSE );

