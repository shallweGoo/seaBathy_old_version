%画图专用测试，专治各种画图

figure;
s1 = double(row_timestack(300,:))/max(double(row_timestack(300,:)));
plot(s1(100:1000),'b');
hold on;
s2 = afterFilt(300,:)/max(afterFilt(300,:));
plot(s2(100:1000),'r');
% hold on;
% cmp = [zeros(1,99),part(300,:)];
% plot(cmp,'black');  