clear all
clc
counter = 0;
filename='562';
f = importdata([filename,'.tiff']);
alpha_sum = PSLconter(f)
disp('-------successfully!!!-------')
function alpha_sum = PSLconter(f)
clear alpha_sum
PSLthreshold = 0.2;
alpha_sum = 0;
x_scr = 2:600;
y_scr = 2:600;
S = 1000;
CL = 65535;
L = 5;
PSLpeak = 0;
PSLpho = power(50/100,2) * 4000/S * power(10, L .* (double(f) / CL - 1/2));
for i = x_scr
    for j = y_scr
        P_max = max([PSLpho(i-1,j-1), PSLpho(i-1,j), PSLpho(i-1,j+1), PSLpho(i,j-1),...
            PSLpho(i,j+1), PSLpho(i+1,j-1), PSLpho(i+1,j), PSLpho(i+1,j+1)]);
        if P_max < PSLpho(i,j)
            PSLpeak = PSLpho(i,j) + PSLpho(i,j-1) + PSLpho(i-1,j) + PSLpho(i+1,j);
            if PSLthreshold <= PSLpeak
                alpha_sum = alpha_sum + 1;
            end
        end
    end
end
imshow(f(x_scr,y_scr))
end
