clc;                                               % Clears the screen
clear all;

t=1; t_end=365;%How long the day is

L=1500;
w=10000;
Alpha=0.25;
Sigma=0.75;
m=0.24;

for L=1300:100:1500 %L cannot be 1200 or lower
Hb = zeros(t_end,1);
Hi = zeros(t_end,1);

Hb(1) = 100;% How many Hb and Hi in the day 1
Hi(1) = 20;
x=[Hb;Hi];

f1=@(x,y) L.*(x)/(w+x)-Alpha.*x+Sigma.*x.*(y./(x+y));
f2=@(x,y) Alpha.*x-Sigma.*x.*(y./(x-y))-m.*y;  
F_xy = @(x,y)[f1(x,y);f2(x,y)];                    

for i=1:(t_end-1)                           % calculation loop
    k_1 = F_xy(Hb(i),Hi(i)); 
    
    k_2 = F_xy(Hb(i)+0.5*t,Hi(i)+0.5*t*k_1);
    k_3 = F_xy((Hb(i)+0.5*t),(Hi(i)+0.5*t*k_2));
    k_4 = F_xy((Hb(i)+t),(Hi(i)+k_3*t));
    
    Hb(i+1) = Hb(i) + (1/6)*(k_1(1)+2*k_2(1)+2*k_3(1)+k_4(1))*t;
    Hi(i+1) = Hi(i) + (1/6)*(k_1(2)+2*k_2(2)+2*k_3(2)+k_4(2))*t;  
end

time=1:1:t_end;%figures are in here
figure(1);%Hb and Hi vs time
plot(time,Hb,'r-');
hold on;
plot(time,Hi,'b--');
title('Hb&Hi vs time');
xlabel('Number of Bees');
ylabel('Time');
legend('Hb','Hi');

figure(2);%Hb vs Hi
plot(Hb,Hi);
title('Hb vs Hi');
xlabel('Number of Hb');
ylabel('Number of Hi');
hold on;

fprintf('point is %8.4e %8.4e and the rate is %8.4e\n',Hb(t_end),Hi(t_end),Hb(t_end)/Hi(t_end) );
end