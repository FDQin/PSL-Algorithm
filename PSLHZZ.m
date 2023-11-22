clear all
clc
[file,path] = uigetfile('.dat','Please select a photo');

f = importdata([path,file]);
% % file = strrep(file,'.dat','.tiff');
% imwrite(uint16(f),[path,file]);
% 
% f = imread([path,file]);
% f = 65535 - f;
imshow(f,[0,255])
S = 100;
CL = 65535;
L = 5;
PSLthreshold = 0.25;
PSLpeak = 0;
PSLpho = power(50/100,2) * 4000/S * power(10, L .* (double(f) / CL - 1/2));
C_R = 10; % mm
[x_scr,y_scr] = screenphots(f,C_R);
alpha_sum = 0;
for i = x_scr
    for j = y_scr
        P_max = max([PSLpho(i-1,j-1), PSLpho(i-1,j), PSLpho(i-1,j+1), PSLpho(i,j-1),...
            PSLpho(i,j+1), PSLpho(i+1,j-1), PSLpho(i+1,j), PSLpho(i+1,j+1)]);
        if P_max < PSLpho(i,j)
            PSLpeak = PSLpho(i,j) + PSLpho(i,j-1) + PSLpho(i-1,j) + PSLpho(i+1,j);
            if  PSLpeak >= PSLthreshold
                alpha_sum = alpha_sum + 1;
            end
        end
    end
end
% delete([path,file]) 
% close Figure 1
uiwait(msgbox({['Count file is: ', file], ['The PSL Count is: ', num2str(alpha_sum)]},'Count Reslut'))
close Figure 1
close Figure 2
% surf(PSLpho(x_scr(300:450),y_scr(300:450)))
% shading interp;

function  [x_scr,y_scr] = screenphots(f,C_R)
r = C_R * 508/25.4; 
format short
[y0,x0] = ginput();
x0 = round(x0);
y0 = round(y0);
aplha=0:pi/40:2*pi;
x=x0 + r*cos(aplha);
y=y0 + r*sin(aplha);
hold on
plot(y,x,'r-','linewidth',3);
plot(y0,x0,'r*','linewidth',3)
axis equal
%----------------------???-----------------------
r = C_R * 508/25.4;
x_scr = (x0 - r):(x0 + r);
y_scr = (y0 - r):(y0 + r);
X = 0;
Y = 0;
for i = 1:length(x_scr)
    for j = 1:length(y_scr)
        if power(x_scr(i),2)+power(y_scr(j),2) <= power(r,2)
            X(end +1) = x_scr(i);
            Y(end +1) = y_scr(j);
        end
    end
end
figure(2)
imshow(f(x_scr,y_scr))
end