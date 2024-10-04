clear;
clc;
num_entries = 100;    
wordLength = 17;      
fractionLength = 12;  
N = 15;

% x_in = randi([-(2^(wordLength-1)) (2^(wordLength-1))-1], num_entries, 1); 
% y_in = randi([-(2^(wordLength-1)) (2^(wordLength-1))-1], num_entries, 1);
% theta_in = randi([-(2^(wordLength-1)) (2^(wordLength-1))-1], num_entries, 1);
for i = 1:num_entries
x_in(i) = rand() * 16;
y_in(i) = rand() * 16;
theta_in(i) = rand() * 1;
end
x_in = fi(x_in, 1, wordLength, fractionLength);
y_in = fi(y_in, 1, wordLength, fractionLength);
theta_in = fi(theta_in, 1, wordLength, fractionLength);

fileIDinx_in = fopen('cordic_inputx_in.hex', 'w');
fileIDiny_in = fopen('cordic_inputy_in.hex', 'w');
fileIDintheta_in = fopen('cordic_inputtheta_in.hex', 'w');
fileIDoutx = fopen('cordic_outputx.hex', 'w');
fileIDouty = fopen('cordic_outputy.hex', 'w');
for i = 1:num_entries
    xi=x_in(i);
    yi=x_in(i);
    ti=theta_in(i);
    
    fprintf(fileIDinx_in,  '%s\n',((xi.hex)));
    fprintf(fileIDiny_in, '%s\n',  ((yi.hex)));
    fprintf(fileIDintheta_in,  '%s\n', ((ti.hex)));
    
    [x_out(i), y_out(i)] = cordic_rotation_fixed(x_in(i), y_in(i), theta_in(i), N,wordLength,fractionLength);
    
    xo=x_out(i);
    yo=y_out(i);
    
    x_out(i) = fi(x_out(i), 1, wordLength, fractionLength);
    y_out(i) = fi(y_out(i), 1, wordLength, fractionLength);
    
    fprintf(fileIDoutx,  '%s\n', ((xo.hex)));
    fprintf(fileIDouty, '%s\n', ((yo.hex)));
end

fclose(fileIDinx_in);
fclose(fileIDiny_in);
fclose(fileIDintheta_in);
fclose(fileIDoutx);
fclose(fileIDouty);
disp('cordic_input.hex has been made successfuly :)');

% clear;
% clc;
% num_entries = 100;    
% wordLength = 17;       % طول الكلمة 16 بت
% fractionLength = 12;   % طول الجزء الكسري 12 بت
% N = 15;                % عدد التكرارات في CORDIC
% 
% % توليد قيم المدخلات عشوائيًا
% for i = 1:num_entries
%     x_in(i) = rand() * 16;  % توليد أرقام عشوائية لـ x
%     y_in(i) = rand() * 16;  % توليد أرقام عشوائية لـ y
%     theta_in(i) = rand() * 16;  % توليد أرقام عشوائية لـ theta
% end
% 
% % تحويل القيم إلى fixed-point باستخدام مكتبة `fi`
% x_in = fi(x_in, 1, wordLength, fractionLength);
% y_in = fi(y_in, 1, wordLength, fractionLength);
% theta_in = fi(theta_in, 1, wordLength, fractionLength);
% 
% % فتح الملفات للكتابة
% fileIDinx_in = fopen('cordic_inputx_in.hex', 'w');
% fileIDiny_in = fopen('cordic_inputy_in.hex', 'w');
% fileIDintheta_in = fopen('cordic_inputtheta_in.hex', 'w');
% fileIDoutx = fopen('cordic_outputx.hex', 'w');
% fileIDouty = fopen('cordic_outputy.hex', 'w');
% 
% % تشغيل الدائرة CORDIC وتوليد المخرجات
% for i = 1:num_entries
%     % كتابة القيم المدخلة في الملفات
%     fprintf(fileIDinx_in,  '%04X\n', bin(x_in(i)));  % تحويل إلى hexadecimal
%     fprintf(fileIDiny_in, '%04X\n',  bin(y_in(i)));
%     fprintf(fileIDintheta_in,  '%04X\n', bin(theta_in(i)));
%     
%     % استدعاء الدائرة CORDIC
%     [x_out(i), y_out(i)] = cordic_rotation_fixed(x_in(i), y_in(i), theta_in(i), N, wordLength, fractionLength);
%     
%     % تحويل المخرجات إلى fixed-point
%     x_out(i) = fi(x_out(i), 1, wordLength, fractionLength);
%     y_out(i) = fi(y_out(i), 1, wordLength, fractionLength);
%     
%     % كتابة المخرجات في الملفات
%     fprintf(fileIDoutx,  '%04X\n', bin(x_out(i)));  % تحويل إلى hexadecimal
%     fprintf(fileIDouty, '%04X\n', bin(y_out(i)));
% end
% 
% % إغلاق الملفات بعد الكتابة
% fclose(fileIDinx_in);
% fclose(fileIDiny_in);
% fclose(fileIDintheta_in);
% fclose(fileIDoutx);
% fclose(fileIDouty);
% 
% disp('تم إنشاء ملفات cordic_input و cordic_output بنجاح!');
