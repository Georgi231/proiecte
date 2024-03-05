close all;clc;clear;
load('georgi_date.mat')
N=200;
m_3=3;
na=27;
nb=27;
a=-0.7;
b=0.7;
m_10=10;

Ts = 0.01;

% Generare semnal de intrare

x = spabG(N, m_3, a, b);
x2=spabG(N, m_10, a, b);
% Izolare subsecvențe
%u=[zeros(1,10),x',zeros(1,30),x2',zeros(1,40),0.4*ones(1,70)];
u=[zeros(1,30),x',zeros(1,100),x2',zeros(1,100),0.4*ones(1,70)];

figure
plot (u)


idu_3=u(29:131);
idy_3=vel(29:131);
idu_10=u(229:331);
idy_10=vel(229:331);
valu=u(430:end);
valy=vel(430:end);

minLength = min(length(valy), length(valu));
valy = valy(1:minLength);
valu = valu(1:minLength);

identif_3=iddata(idy_3',idu_3',t(2)-t(1));
identif_10=iddata(idy_10',idu_10',t(2)-t(1));
validare=iddata(valy',valu',t(2)-t(1));

a1 = arx(identif_3,[na,nb,1]); 
a2 = arx(identif_10,[na,nb,1]);
%a3 = arx(validare,[na,nb,1]);

figure;
compare(identif_3,a1);
figure;
compare(validare,a1);
figure;
compare(identif_10,a2);
figure;
compare(validare,a2);

 v_3 = lsim(a1,valu);
 v_10= lsim(a2,valu);
% v = lsim(a3,valu);
% 
% 
figure;
plot(idy_3);
hold on;
plot(v_3);
plot(v_10);
legend('Date','Simulare N = 3','Simulare N = 10');



function g=spabG(N,m_3,a,b)
aa=zeros(m_3);
if m_3== 3
        aa([1, 3]) = 1;
    elseif m_3 == 4
        aa([1, 4]) = 1;
    elseif m_3 == 5
        aa([2, 5]) = 1;
    elseif m_3 == 6
        aa([1, 6]) = 1;
    elseif m_3 == 7
        aa([1, 6]) = 1;
    elseif m_3 == 8
        aa([1, 2, 7, 8]) = 1;
    elseif m_3 == 9
        aa([4, 9]) = 1;
    elseif m_3 == 10
        aa([3, 10]) = 1;
end

Q= zeros(m_3);
    for q = 1:m_3
        Q(1, q) = aa(q);
    end
    
    for i = 2:m_3
        Q(i, 1:i) = aa(1:i);
    end
    
    h= ones(100, m_3);
    for i = 2:100
        h(i, 1) = mod(Q(1, :) * h(i-1, :)', 2);
        h(i, 2:end) = h(i-1, 1:end-1);
    end
    
    u = h(:, 1);
    g=u;
     g = a + (b - a)* g;
end