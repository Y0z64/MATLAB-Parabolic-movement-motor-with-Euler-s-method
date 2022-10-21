close all
clear variables
clc

%-------------Parametros
%condicionales de la grafica
for i = 1:3
    theta(i) = 30 + rand(1)*40;
    vi(i) = 800 + rand(1)*13;%m/s
    vx(i,1) = vi(i)*cosd(theta(i));
    vy(i,1) = vi(i)*sind(theta(i));
    x_main(i,1) = 0;
    y_main(i,1) = 0;
end
%constantes de grafica
g = -9.8; %m/s^2
m = 1; %kg
b = 0; %kg/s maybe

%--------------------tiempo
ti = 0;
%tf = (((2.*vi(i)) .* sind(theta))/ abs(g))+sqrt((2.*y(i,1))/abs(g)); %tiempo final
tf = 120; %TIEMPO
N = 200;
dt = (tf-ti)/N;
t_alt = ti:dt:tf;

%-----------------Format
title("Motor de movimiento");

%--------------------------
%eje de las x  y
[x,y] = meshgrid(-2000:400:2000);

%hacer Dinamico
%z = sin(sqrt(x.^2+y.^2)) ./ sqrt(x.^2+y.^2);
z = 1200000 ./ sqrt((x).^2+(y).^2);

surf(x,y,(z-3000))

figure(1)
xlabel('x[m]');
ylabel('y[m]');
zlabel('z[m]');
hold on

%----------------------figure data


%velocidades
text_vxi=sprintf("velocidad incial 1= %.2f m/s", vi(1));
w2=text(1000,3000,1000, text_vxi);

text_vxi=sprintf("velocidad inicial 2= %.2f m/s", vi(2));
w3=text(3000,0, 0, text_vxi);

text_vxi=sprintf("velocidad inicial 3= %.2f m/s", vi(3));
w4=text(-3000,0, 1000, text_vxi);


t(1) = ti;

hitGroundTracker = zeros(3);

%main engine
for n = 0:N
    %if all(hitGroundTracker) == true
    %    break
    %end
    t(n+2) = t(n+1) + dt;
    %ground hit tracker
    for i = 1:3
        %if hitGroundTracker(i)
            %continue
        %end
        %----------------main source
        vx(i,n+2) = vx(i,n+1)*(1-b*dt/m);
        vy(i,n+2) = vy(i,n+1)*(1-b*dt/m)+g*dt;
        x_main(i,n+2) = x_main(i,n+1) +vx(i,n+1)*dt;
        y_main(i,n+2) = y_main(i,n+1) +vy(i,n+1)*dt;
        %----------------x,y max
        x_max(i) = (vi(i)^2*sind(2*theta(i))/abs(g)) + x(i,1) + vx(i,1) * abs(sqrt(2*y(i,1))/g);
        y_max(i) = (vi(i)^2*(sind(theta(i)))^2/abs(2*g))+y(i,1);
        %------------MAIN PLOT
        xplot(i) = x_main(i,n+2);
        yplot(i) = y_main(i,n+2);
        %-----------------conditional ground hit tracker
        if y_main(i,n+2) <= 0
            hitGroundTracker(i) = true;
        end
        %------------------print x,y max
    
        
    end
    text_ymax(1)=sprintf("ymax = %dm",y_max(1));
    height(1)=text(x_max(1)/2,0,y_max(1),text_ymax(1));
    text_ymax(2)=sprintf("ymax = %dm",y_max(2));
    height(2)=text(x_max(2)/2,0,y_max(2),text_ymax(2));
    text_ymax(3)=sprintf("ymax = %dm",y_max(3));
    height(3)=text((x_max(3)/2)*-1,0,y_max(3),text_ymax(3));
    pause(0.1)
    
    text_xmax(1)=sprintf("xmax = %dm",x_max(1));
    height(1)=text(x_max(1),0,0,text_ymax(1));
    text_ymax(1)=sprintf("ymax = %dm",y_max(1));
    height(1)=text(x_max(1),0,0,text_ymax(1));
    text_ymax(1)=sprintf("ymax = %dm",y_max(1));
    height(1)=text(x_max(1)*-1,0,0,text_ymax(1));

    %------------PLOT
    plot3(xplot(1)*-1,0,yplot(1),"o");
    plot3(xplot(2),0,yplot(2),"o");
    plot3(xplot(3),0,yplot(3),"o");
end 
view(0,0)


